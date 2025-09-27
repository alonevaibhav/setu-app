


import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/preview_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/step_four_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_eight_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_fifth_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_seventh_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_sixth_controller.dart';
import '../../../API Service/api_service.dart';
import '../../../Constants/api_constant.dart';
import '../../../Route Manager/app_routes.dart';
import '../../LandSurveyView/Controller/personal_info_controller.dart';
import '../../LandSurveyView/Controller/step_three_controller.dart';
import '../../LandSurveyView/Controller/survey_cts.dart';
import 'dart:developer' as developer;


class MainSurveyController extends GetxController {
  // Navigation State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;




  // Step Controllers - Initialize them here
  late final PersonalInfoController personalInfoController;
  late final SurveyCTSController surveyCTSController;
  late final CalculationController calculationController;
  late final StepFourController stepFourController;
  late final SurveyFifthController surveyFifthController;
  late final SurveySixthController surveySixthController;
  late final SurveySeventhController surveySeventhController;
  late final SurveyEightController surveyEightController;
  // late final SurveyPreviewController SurveyPreviewController ;

  // Add more controllers as needed

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: ['holder_verification', 'enumeration_check'], // Personal Info step
    1: [
      'survey_number',
      'department',
      'district',
      'taluka',
      'village',
    ],
    2: ['calculation'], // Survey Information
    3: ['calculation'], // Calculation Information
    4: [
      'applicant',
    ], // Applicant Information
    5: [
      'coowner',
    ], // Co-owner Information
    6: [
      'next_of_kin',
    ], // Information about Adjacent Holders
    7: [
      'documents',
    ], // Document Upload
    8: ['preview'], // Preview
    9: ['payment', 'status'], // Payment
  };

  // Validation States
  final isStepValid = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    initializeSurveyData();
    initializeValidationStates();
  }

  void _initializeControllers() {
    personalInfoController =
        Get.put(PersonalInfoController(), tag: 'personal_info');
    surveyCTSController = Get.put(SurveyCTSController(), tag: 'survey_cts');
    calculationController =
        Get.put(CalculationController(), tag: 'calculation'); // Add this line
    stepFourController =
        Get.put(StepFourController(), tag: 'step_four'); // Add this line
    surveyFifthController =
        Get.put(SurveyFifthController(), tag: 'survey_fifth'); // Add this line
    surveySixthController =
        Get.put(SurveySixthController(), tag: 'survey_sixth'); // Add this line
    surveySeventhController = Get.put(SurveySeventhController(),
        tag: 'survey_seventh'); // Add this line
    surveyEightController =
        Get.put(SurveyEightController(), tag: 'survey_eight'); // Add this line
  }

  @override
  void onClose() {
    // Controllers will be disposed automatically by GetX
    super.onClose();
  }

  void initializeSurveyData() {
    surveyData.value = {
      'applicationId': '',
      'status': 'draft',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  void initializeValidationStates() {
    // Initialize all 10 steps (0-9)
    for (int i = 0; i <= 9; i++) {
      isStepValid[i] = false;
    }
  }

  // Get total sub-steps for current main step
  int get totalSubStepsInCurrentStep =>
      stepConfigurations[currentStep.value]?.length ?? 1;

  // Get current sub-step field name
  String get currentSubStepField {
    final fields = stepConfigurations[currentStep.value];
    if (fields != null && currentSubStep.value < fields.length) {
      return fields[currentSubStep.value];
    }
    return '';
  }

  // Get the appropriate step controller for current step
  GetxController get currentStepController {
    switch (currentStep.value) {
      case 0:
        return personalInfoController;
      case 1:
        return surveyCTSController;
      case 2: // Add this case for calculation step
        return calculationController;
      case 3: // Add this case for calculation step
        return stepFourController;
      case 4: // Add this case for calculation step
        return surveyFifthController;
      case 5: // Add this case for calculation step
        return surveySixthController;
      case 6: // Add this case for calculation step
        return surveySeventhController;
      case 7: // Add this case for calculation step
        return surveyEightController;
      case 8: // Add this case for calculation step
        final previewController = Get.put(SurveyPreviewController(), tag: 'survey_preview');
        previewController.refreshData(); // Refresh data when navigating to preview
        return previewController;

      default:
        return this; // Fallback to main controller
    }
  }

  // Check if current sub-step is valid
  bool get isCurrentSubStepValid {
    final stepController = currentStepController;
    if (stepController is StepValidationMixin) {
      return stepController.validateCurrentSubStep(currentSubStepField);
    }
    return true; // Default to true if controller doesn't implement validation
  }

  // Check if entire main step is completed
  bool isMainStepCompleted(int step) {
    final fields = stepConfigurations[step];
    if (fields == null) return false;
    GetxController? stepController;
    switch (step) {
      case 0:
        stepController = personalInfoController;
        break;
      case 1:
        stepController = surveyCTSController;
        break;
      case 2: // Add this case
        stepController = calculationController;
        break;
      case 3: // Add this case
        stepController = stepFourController;
        break;
      case 4: // Add this case
        stepController = surveyFifthController;
        break;
      case 5: // Add this case
        stepController = surveySixthController;
        break;
      case 6: // Add this case
        stepController = surveySeventhController;
        break;
      case 7: // Add this case
        stepController = surveyEightController;
        break;
    // Add more cases
    }
    if (stepController is StepValidationMixin) {
      return stepController.isStepCompleted(fields);
    }
    return false;
  }

  // Navigation Methods
  void nextSubStep() {
    if (!isCurrentSubStepValid) {
      _showValidationError();
      return;
    }
    _saveCurrentSubStepData();

    // Print the current survey data to the console
    // print('Current Survey Data: ${surveyData.value}');
    // debugPrintInfo();
    // submitSurvey();
    debugPrint();
    // Get the current step's total substeps
    final currentStepSubSteps = stepConfigurations[currentStep.value];
    final totalSubSteps = currentStepSubSteps?.length ?? 1;
    if (currentSubStep.value < totalSubSteps - 1) {
      // Move to next sub-step within current main step
      currentSubStep.value++;
    } else {
      // Move to next main step
      if (currentStep.value < 9) {
        currentStep.value++;
        currentSubStep.value = 0;
        _updateStepValidation();
        // If we just moved to preview step (step 8), refresh preview data
        if (currentStep.value == 8) {
          final previewController = Get.find<SurveyPreviewController>(tag: 'survey_preview');
          previewController.refreshData();
        }
      } else {
        // We're at the last step and last substep, submit the survey
        submitSurvey();
      }
    }
  }

  void previousSubStep() {
    if (currentSubStep.value > 0) {
      currentSubStep.value--;
    } else if (currentStep.value > 0) {
      currentStep.value--;
      // Get the previous step's total substeps
      final previousStepSubSteps = stepConfigurations[currentStep.value];
      final totalSubSteps = previousStepSubSteps?.length ?? 1;
      currentSubStep.value = totalSubSteps - 1;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 9) {
      // Check if previous steps are completed
      bool canNavigate = true;
      for (int i = 0; i < step; i++) {
        if (!isMainStepCompleted(i)) {
          canNavigate = false;
          break;
        }
      }
      if (canNavigate || step <= currentStep.value) {
        currentStep.value = step;
        currentSubStep.value = 0;
        // If navigating to preview step (step 8), refresh preview data

        if (step == 8) {
          final previewController = Get.find<SurveyPreviewController>(tag: 'survey_preview');
          previewController.refreshData();
        }
      } else {
        Get.snackbar(
          'Incomplete',
          'Please complete previous steps first',
          backgroundColor: Color(0xFFFFC107),
          colorText: Colors.black,
        );
      }
    }
  }

  void _showValidationError() {
    final stepController = currentStepController;
    String error = 'This field is required';
    if (stepController is StepValidationMixin) {
      error = stepController.getFieldError(currentSubStepField);
    }
    Get.snackbar(
      'Validation Error',
      error,
      backgroundColor: Color(0xFFDC3545),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1200),
    );
  }

  void _saveCurrentSubStepData() {
    final stepController = currentStepController;
    if (stepController is StepDataMixin) {
      final stepData = stepController.getStepData();
      _mergeStepData(stepData);
    }
  }

  void _mergeStepData(Map<String, dynamic> stepData) {
    final currentData = Map<String, dynamic>.from(surveyData.value ?? {});
    currentData.addAll(stepData);
    surveyData.value = currentData;
  }

  void _updateStepValidation() {
    for (int i = 0; i <= 9; i++) {
      isStepValid[i] = isMainStepCompleted(i);
    }
  }

  // Get step indicator color
  Color getStepIndicatorColor(int step) {
    if (isMainStepCompleted(step)) {
      return Color(0xFF52B788); // Green for completed
    } else if (step == currentStep.value) {
      return Color(0xFFFFC107); // Yellow for current
    } else {
      return Colors.white.withOpacity(0.3); // Default
    }
  }

  // Get button text based on current state
  String get nextButtonText {
    if (currentStep.value == 9 &&
        currentSubStep.value == totalSubStepsInCurrentStep - 1) {
      return 'Submit';
    } else if (currentSubStep.value == totalSubStepsInCurrentStep - 1) {
      return 'Next Step';
    } else {
      return 'Save & Next';
    }
  }

  // Update survey data
  void updateSurveyData(String key, dynamic value) {
    final currentData = Map<String, dynamic>.from(surveyData.value ?? {});
    currentData[key] = value;
    surveyData.value = currentData;
  }

  ///////////////////////////////////
  // ALL DATA COLLECTION METHODS
  ///////////////////////////////////

  /// Collect data from PersonalInfoController
  Map<String, dynamic> getPersonalInfoData() {
    try {
      if (personalInfoController is StepDataMixin) {
        return personalInfoController.getStepData();
      }
      return {
        'personal_info': {
          'is_holder_themselves':
          personalInfoController.isHolderThemselves.value,
          'has_authority_on_behalf':
          personalInfoController.hasAuthorityOnBehalf.value,
          'has_been_counted_before':
          personalInfoController.hasBeenCountedBefore.value,
          'poa_registration_number': personalInfoController
              .poaRegistrationNumberController.text
              .trim(),
          'poa_registration_date':
          personalInfoController.poaRegistrationDateController.text.trim(),
          'poa_issuer_name':
          personalInfoController.poaIssuerNameController.text.trim(),
          'poa_holder_name':
          personalInfoController.poaHolderNameController.text.trim(),
          'poa_holder_address':
          personalInfoController.poaHolderAddressController.text.trim(),
        }
      };
    } catch (e) {
      print('Error getting PersonalInfo data: $e');
      return {'personal_info': {}};
    }
  }

  /// Collect data from SurveyCTSController
  Map<String, dynamic> getSurveyInfoData() {
    try {
      if (surveyCTSController is StepDataMixin) {
        return surveyCTSController.getStepData();
      }

      // Fallback: manually collect data from SurveyCTSController
      return {
        'survey_cts': {
          'survey_number':
          surveyCTSController.surveyNumberController.text.trim(),
          'department': surveyCTSController.selectedDepartment.value,
          'district': surveyCTSController.selectedDistrict.value,
          'taluka': surveyCTSController.selectedTaluka.value,
          'village': surveyCTSController.selectedVillage.value,
          'office': surveyCTSController.selectedOffice.value,
          'Number': surveyCTSController.selectedSurveyNo.value,
        }
      };
    } catch (e) {
      print('Error getting SurveyInfo data: $e');
      return {
        'survey_cts': {
          'survey_number': '',
          'department': '',
          'district': '',
          'taluka': '',
          'village': '',
          'office': '',
        }
      };
    }
  }

  Map<String, dynamic> getCalculationData() {
    try {
      if (calculationController is StepDataMixin) {
        // Return data directly from getStepData() without nesting
        return calculationController.getStepData();
      }

      // Fallback: manually collect data from CalculationController
      return {
        'calculationType': calculationController.selectedCalculationType.value,
        'isCalculationComplete':
        calculationController.isCalculationComplete.value,
        'notes': calculationController.notesController.text.trim(),
        'date': calculationController.datecontroller.text.trim(),

        // Common fields for Non-agricultural and Knots counting
        'orderNumber': calculationController.orderNumberController.text.trim(),
        'orderDate': calculationController.orderDateController.text.trim(),
        'schemeOrderNumber':
        calculationController.schemeOrderNumberController.text.trim(),
        'appointmentDate':
        calculationController.appointmentDateController.text.trim(),

        // Type-specific fields
        'landType': calculationController.landType.value,
        'plotNumber': calculationController.plotNumberController.text.trim(),
        'builtUpArea': calculationController.builtUpAreaController.text.trim(),
        'knotsCount': calculationController.knotsCountController.text.trim(),
        'knotSpacing': calculationController.knotSpacingController.text.trim(),
        'calculationMethod': calculationController.calculationMethod.value,
        'integrationType': calculationController.integrationType.value,
        'baseLine': calculationController.baseLineController.text.trim(),
        'ordinates': calculationController.ordinatesController.text.trim(),
        'mergerOrderNumber':
        calculationController.mergerOrderNumberController.text.trim(),
        'mergerOrderDate':
        calculationController.mergerOrderDateController.text.trim(),
        'oldMergerNumber':
        calculationController.oldMergerNumberController.text.trim(),
        'incorporationOrderFiles':
        calculationController.incorporationOrderFiles.toList(),

        // Survey number and area from common controllers
        'surveyNumber':
        calculationController.surveyNumberController.text.trim(),
        'area': calculationController.areaController.text.trim(),
        'subdivision': calculationController.subdivisionController.text.trim(),

        // Entries data
        'hddkayamEntriesCount': calculationController.hddkayamEntries.length,
        'stomachEntriesCount': calculationController.stomachEntries.length,
        'nonAgriculturalEntriesCount':
        calculationController.nonAgriculturalEntries.length,
        'knotsCountingEntriesCount':
        calculationController.knotsCountingEntries.length,
        'integrationCalculationEntriesCount':
        calculationController.integrationCalculationEntries.length,
      };
    } catch (e) {
      print('Error getting Calculation data: $e');
      return {};
    }
  }

  /// Collect data from StepFourController
  Map<String, dynamic> getStepFourData() {
    try {
      if (stepFourController is StepDataMixin) {
        return stepFourController.getStepData();
      }

      return {
        'calculation_type': stepFourController.selectedCalculationType.value,
        'duration': stepFourController.selectedDuration.value,
        'holder_type': stepFourController.selectedHolderType.value,
        'location_category': stepFourController.selectedLocationCategory.value,
        'calculation_fee': stepFourController.calculationFeeController.text,
        'calculation_fee_numeric': stepFourController.extractNumericFee(),
      };
    } catch (e) {
      print('Error getting StepFour data: $e');
      return {
        'calculation_type': null,
        'duration': null,
        'holder_type': null,
        'location_category': null,
        'calculation_fee': '',
        'calculation_fee_numeric': null,
      };
    }
  }

  /// Collect data from SurveyFifthController (Applicant)
  Map<String, dynamic> getFifthController() {
    try {
      if (surveyFifthController is StepDataMixin) {
        // Return data directly from getStepData() without extra nesting
        return surveyFifthController.getStepData();
      }

      // Fallback: manually collect data from SurveyFifthController
      final data = <String, dynamic>{};

      for (int i = 0; i < surveyFifthController.applicantEntries.length; i++) {
        final entry = surveyFifthController.applicantEntries[i];
        final addressData = entry['address'] as RxMap<String, dynamic>;

        data['applicant_$i'] = {
          'agreement':
          (entry['agreementController'] as TextEditingController).text,
          'accountHolderName':
          (entry['accountHolderNameController'] as TextEditingController)
              .text,
          'accountNumber':
          (entry['accountNumberController'] as TextEditingController).text,
          'mobileNumber':
          (entry['mobileNumberController'] as TextEditingController).text,
          'serverNumber':
          (entry['serverNumberController'] as TextEditingController).text,
          'area': (entry['areaController'] as TextEditingController).text,
          'potkaharabaArea':
          (entry['potkaharabaAreaController'] as TextEditingController)
              .text,
          'totalArea':
          (entry['totalAreaController'] as TextEditingController).text,
          'address': Map<String, dynamic>.from(addressData),
        };
      }

      data['applicantCount'] = surveyFifthController.applicantEntries.length;
      return data;
    } catch (e) {
      print('Error getting Applicant data: $e');
      return {
        'applicantCount': 0,
        'error': e.toString(),
      };
    }
  }

  /// Collect data from SurveySixthController (Co-owner)
  Map<String, dynamic> getSixthController() {
    try {
      if (surveySixthController is StepDataMixin) {
        // Return data directly from getStepData() without extra nesting
        return surveySixthController.getStepData();
      }

      // Fallback: manually collect data from SurveySixthController
      final List<Map<String, dynamic>> coownerData = [];

      for (int i = 0; i < surveySixthController.coownerEntries.length; i++) {
        final entry = surveySixthController.coownerEntries[i];
        coownerData.add({
          'name': (entry['nameController'] as TextEditingController).text,
          'mobileNumber':
          (entry['mobileNumberController'] as TextEditingController).text,
          'serverNumber':
          (entry['serverNumberController'] as TextEditingController).text,
          'consent': (entry['consentController'] as TextEditingController).text,
          'address': Map<String, String>.from(entry['address'] as Map? ?? {}),
        });
      }

      return {
        'coowners': coownerData,
        'coownerCount': surveySixthController.coownerEntries.length,
      };
    } catch (e) {
      print('Error getting CoOwner data: $e');
      return {
        'coowners': [],
        'coownerCount': 0,
        'error': e.toString(),
      };
    }
  }

  /// Collect data from SurveySeventhController (Next of Kin)
  Map<String, dynamic> getSeventhController() {
    try {
      if (surveySeventhController is StepDataMixin) {
        // Return data directly from getStepData() - this is the correct approach
        final stepData = surveySeventhController.getStepData();
        print('🔍 Using StepDataMixin - got ${stepData['totalNextOfKinEntries']} entries');
        return stepData;
      }

      // Fallback: manually collect data from SurveySeventhController
      // This fallback now matches the controller's data structure
      final List<Map<String, dynamic>> entriesData = [];

      for (final entry in surveySeventhController.nextOfKinEntries) {
        final naturalResources = entry['naturalResources'] as String? ?? '';
        final direction = entry['direction'] as String? ?? '';

        if (naturalResources == 'Name' || naturalResources == 'Other') {
          // Handle sub-entries for Name/Other types
          final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>?;
          final List<Map<String, dynamic>> subEntriesData = [];

          if (subEntries != null) {
            for (final subEntry in subEntries) {
              subEntriesData.add({
                'name': subEntry['name'] as String? ?? '',
                'address': subEntry['address'] as String? ?? '',
                'mobile': subEntry['mobile'] as String? ?? '',
                'surveyNo': subEntry['surveyNo'] as String? ?? '',
              });
            }
          }

          entriesData.add({
            'naturalResources': naturalResources,
            'direction': direction,
            'subEntries': subEntriesData,
            'totalSubEntries': subEntriesData.length,
          });
        } else {
          // Handle other natural resources types
          entriesData.add({
            'direction': direction,
            'naturalResources': naturalResources,
            // Note: address, mobile, surveyNo are not used for non-Name/Other types in the controller
          });
        }
      }

      final result = {
        'nextOfKinEntries': entriesData,
        'totalNextOfKinEntries': entriesData.length,
      };

      print('🔍 Using fallback method - got ${result['totalNextOfKinEntries']} entries');
      return result;

    } catch (e) {
      print('❌ Error getting NextOfKin data: $e');
      return {
        'nextOfKinEntries': [],
        'totalNextOfKinEntries': 0,
        'error': e.toString(),
      };
    }
  }

  /// Collect data from SurveyEightController (Documents)
  Map<String, dynamic> getDocumentsData() {
    try {
      if (surveyEightController is StepDataMixin) {
        // Return data directly from getStepData() without extra nesting
        return surveyEightController.getStepData();
      }

      // Fallback: manually collect data from SurveyEightController
      return {
        'identityCardType': surveyEightController.selectedIdentityType.value,
        'identityCardFiles': surveyEightController.identityCardFiles.toList(),
        'sevenTwelveFiles': surveyEightController.sevenTwelveFiles.toList(),
        'noteFiles': surveyEightController.noteFiles.toList(),
        'partitionFiles': surveyEightController.partitionFiles.toList(),
        'schemeSheetFiles': surveyEightController.schemeSheetFiles.toList(),
        'oldCensusMapFiles': surveyEightController.oldCensusMapFiles.toList(),
        'demarcationCertificateFiles':
        surveyEightController.demarcationCertificateFiles.toList(),
      };
    } catch (e) {
      print('Error getting Documents data: $e');
      return {
        'identityCardType': '',
        'identityCardFiles': <String>[],
        'sevenTwelveFiles': <String>[],
        'noteFiles': <String>[],
        'partitionFiles': <String>[],
        'schemeSheetFiles': <String>[],
        'oldCensusMapFiles': <String>[],
        'demarcationCertificateFiles': <String>[],
        'error': e.toString(),
      };
    }
  }



  void debugPrintInfo() {
    developer.log('=== POST REQUEST BODY DEBUG ===', name: 'DebugInfo');

    // Get all data
    final surveyData = getSurveyInfoData();
    final surveyInfo = surveyData['survey_cts'] as Map<String, dynamic>?;
    final calculationData = getCalculationData();
    final stepFourData = getStepFourData();
    final applicantData = getFifthController();
    final coOwnerData = getSixthController();
    final nextOfKinData = getSeventhController();

    // === PERSONAL INFO ===
    developer.log('=== PERSONAL INFO DEBUG ===', name: 'DebugInfo');

    developer.log('applicant_name: "${personalInfoController.applicantNameController.text.trim()}"', name: 'PersonalInfo');
    developer.log('applicant_address_details: ${personalInfoController.applicantAddressData}', name: 'PersonalInfo');
    developer.log('is_holder_themselves: ${personalInfoController.isHolderThemselves.value}', name: 'PersonalInfo');
    developer.log('has_authority_on_behalf: ${personalInfoController.hasAuthorityOnBehalf.value}', name: 'PersonalInfo');
    developer.log('should_show_authority_question: ${personalInfoController.shouldShowAuthorityQuestion}', name: 'PersonalInfo');
    developer.log('had_been_counted_before: ${personalInfoController.hasBeenCountedBefore.value.toString()}', name: 'PersonalInfo');
    developer.log('should_show_poa_fields: ${personalInfoController.shouldShowPOAFields}', name: 'PersonalInfo');
    developer.log('poa_registration_number: "${personalInfoController.poaRegistrationNumberController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_registration_date: "${personalInfoController.poaRegistrationDateController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_issuer_name: "${personalInfoController.poaIssuerNameController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_holder_name: "${personalInfoController.poaHolderNameController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_holder_address: "${personalInfoController.poaHolderAddressController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_documents: ${personalInfoController.poaDocument}', name: 'PersonalInfo');



// === SURVEY INFO DEBUG ===
    developer.log('=== SURVEY INFO DEBUG ===', name: 'DebugInfo');

    developer.log('survey_number: "${surveyCTSController.surveyCtsNumber.text.trim()}"', name: 'SurveyInfo');
    developer.log('department: "${surveyCTSController.selectedDepartment.value}"', name: 'SurveyInfo');
    developer.log('district: "${surveyCTSController.selectedDistrict.value}"', name: 'SurveyInfo');
    developer.log('taluka: "${surveyCTSController.selectedTaluka.value}"', name: 'SurveyInfo');
    developer.log('village: "${surveyCTSController.selectedVillage.value}"', name: 'SurveyInfo');


    // === CALCULATION INFO ===
    developer.log('=== CALCULATION INFO ===', name: 'DebugInfo');
    developer.log('calculation_type: "${calculationData['calculationType']?.toString() ?? ""}"', name: 'CalculationInfo');

    // === STEP FOUR INFO ===
    developer.log('=== STEP FOUR INFO ===', name: 'DebugInfo');
    developer.log('selected_calculation_type: "${stepFourController.selectedCalculationType.value}"', name: 'StepFourInfo');
    developer.log('selected_duration: "${stepFourController.selectedDuration.value}"', name: 'StepFourInfo');
    developer.log('selected_holder_type: "${stepFourController.selectedHolderType.value}"', name: 'StepFourInfo');
    developer.log('selected_location_category: "${stepFourController.selectedLocationCategory.value}"', name: 'StepFourInfo');
    developer.log('calculation_fee: "${stepFourController.calculationFeeController.text.trim()}"', name: 'StepFourInfo');
    developer.log('calculation_fee_numeric: "${stepFourData['calculation_fee_numeric']?.toString() ?? ""}"', name: 'StepFourInfo');

    // === CALCULATION ENTRIES ===
    developer.log('=== CALCULATION ENTRIES ===', name: 'DebugInfo');
    String calcType = calculationData['calculationType']?.toString() ?? '';

    switch (calcType) {
      case 'Hddkayam':
        developer.log('Calculation Type: Hddkayam - ${calculationController.hddkayamEntries.length} entries', name: 'CalculationEntries');
        for (int i = 0; i < calculationController.hddkayamEntries.length; i++) {
          final entry = calculationController.hddkayamEntries[i];
          developer.log('Entry ${i + 1}:', name: 'CalculationEntries');
          developer.log('  ct_survey_number: "${entry['ctSurveyNumber']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  selected_ct_survey: "${entry['selectedCTSurvey']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area: "${entry['area']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area_sqm: "${entry['areaSqm']?.toString() ?? ""}"', name: 'CalculationEntries');
        }
        break;

      case 'Stomach':
        developer.log('Calculation Type: Stomach - ${calculationController.stomachEntries.length} entries', name: 'CalculationEntries');
        for (int i = 0; i < calculationController.stomachEntries.length; i++) {
          final entry = calculationController.stomachEntries[i];
          developer.log('Entry ${i + 1}:', name: 'CalculationEntries');
          developer.log('  survey_number: "${entry['surveyNumber']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  measurement_type: "${entry['selectedMeasurementType']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  total_area: "${entry['totalArea']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  calculated_area: "${entry['calculatedArea']?.toString() ?? ""}"', name: 'CalculationEntries');
        }
        break;

      case 'Non-agricultural':
        developer.log('Calculation Type: Non-agricultural - ${calculationController.nonAgriculturalEntries.length} entries', name: 'CalculationEntries');

        // Log common fields (shared with Counting by number of knots)
        developer.log('  order_number: "${calculationController.orderNumberController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  order_date: "${calculationController.orderDateController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  scheme_order_number: "${calculationController.schemeOrderNumberController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  appointment_date: "${calculationController.appointmentDateController.text.trim()}"', name: 'CalculationEntries');

        // Log table entries
        for (int i = 0; i < calculationController.nonAgriculturalEntries.length; i++) {
          final entry = calculationController.nonAgriculturalEntries[i];
          developer.log('Entry ${i + 1}:', name: 'CalculationEntries');
          developer.log('  survey_number: "${entry['surveyNumber']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  survey_type: "${entry['selectedSurveyType']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area: "${entry['area']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area_hectares: "${entry['areaHectares']?.toString() ?? ""}"', name: 'CalculationEntries');
        }
        break;

      case 'Counting by number of knots':
        developer.log('Calculation Type: Counting by number of knots - ${calculationController.knotsCountingEntries.length} entries', name: 'CalculationEntries');

        // Log common fields (shared with Non-agricultural)
        developer.log('  order_number: "${calculationController.orderNumberController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  order_date: "${calculationController.orderDateController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  scheme_order_number: "${calculationController.schemeOrderNumberController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  appointment_date: "${calculationController.appointmentDateController.text.trim()}"', name: 'CalculationEntries');

        // Log table entries
        for (int i = 0; i < calculationController.knotsCountingEntries.length; i++) {
          final entry = calculationController.knotsCountingEntries[i];
          developer.log('Entry ${i + 1}:', name: 'CalculationEntries');
          developer.log('  survey_number: "${entry['surveyNumber']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  survey_type: "${entry['selectedSurveyType']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area: "${entry['area']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area_hectares: "${entry['areaHectares']?.toString() ?? ""}"', name: 'CalculationEntries');
        }
        break;

      case 'Integration calculation':
        developer.log('Calculation Type: Integration calculation - ${calculationController.integrationCalculationEntries.length} entries', name: 'CalculationEntries');

        // === MERGER/ORDER RELATED FIELDS ===
        developer.log('  merger_order_number: "${calculationController.mergerOrderNumberController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  merger_order_date: "${calculationController.mergerOrderDateController.text.trim()}"', name: 'CalculationEntries');
        developer.log('  old_merger_number: "${calculationController.oldMergerNumberController.text.trim()}"', name: 'CalculationEntries');

        // === FILE UPLOADS (incorporation order files) ===
        developer.log('  incorporation_order_files: ${calculationController.incorporationOrderFiles.map((file) => file.toString()).toList()}', name: 'CalculationEntries');

        // === TABLE ENTRIES ===
        for (int i = 0; i < calculationController.integrationCalculationEntries.length; i++) {
          final entry = calculationController.integrationCalculationEntries[i];
          developer.log('Entry ${i + 1}:', name: 'CalculationEntries');
          developer.log('  ct_survey_number: "${entry['ctSurveyNumber']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  selected_ct_survey: "${entry['selectedCTSurvey']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area: "${entry['area']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  area_sqm: "${entry['areaSqm']?.toString() ?? ""}"', name: 'CalculationEntries');
          developer.log('  is_correct: "${entry['isCorrect']?.toString() ?? "false"}"', name: 'CalculationEntries');
        }
        break;

      default:
        developer.log('No calculation type selected or unknown type', name: 'CalculationEntries');
    }

    // === APPLICANTS ===
    developer.log('=== APPLICANTS ===', name: 'DebugInfo');
    final applicantCount = applicantData['applicantCount'] ?? 0;
    developer.log('Total applicants: $applicantCount', name: 'Applicants');

    for (int i = 0; i < applicantCount; i++) {
      final applicantKey = 'applicant_$i';
      final applicantInfo = applicantData[applicantKey] as Map<String, dynamic>?;

      if (applicantInfo != null) {
        final addressInfo = applicantInfo['address'] as Map<String, dynamic>?;

        developer.log('Applicant ${i + 1}:', name: 'Applicants');
        developer.log('  agreement: "${applicantInfo['agreement']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  account_holder_name: "${applicantInfo['accountHolderName']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  account_number: "${applicantInfo['accountNumber']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  mobile_number: "${applicantInfo['mobileNumber']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  server_number: "${applicantInfo['serverNumber']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  area: "${applicantInfo['area']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  potkaharaba_area: "${applicantInfo['potkaharabaArea']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  total_area: "${applicantInfo['totalArea']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  plot_no: "${addressInfo?['plotNo']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  address: "${addressInfo?['address']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  address_mobile_number: "${addressInfo?['mobileNumber']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  email: "${addressInfo?['email']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  pincode: "${addressInfo?['pincode']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  address_district: "${addressInfo?['district']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  address_village: "${addressInfo?['village']?.toString() ?? ""}"', name: 'Applicants');
        developer.log('  post_office: "${addressInfo?['postOffice']?.toString() ?? ""}"', name: 'Applicants');
      }
    }

    // === CO-OWNERS ===
    developer.log('=== CO-OWNERS ===', name: 'DebugInfo');
    final coowners = coOwnerData['coowners'] as List<Map<String, dynamic>>?;
    developer.log('Total co-owners: ${coowners?.length ?? 0}', name: 'CoOwners');

    if (coowners != null) {
      for (int i = 0; i < coowners.length; i++) {
        final coowner = coowners[i];
        final addressInfo = coowner['address'] as Map<String, String>?;

        developer.log('Co-Owner ${i + 1}:', name: 'CoOwners');
        developer.log('  name: "${coowner['name']?.toString() ?? ""}"', name: 'CoOwners');
        developer.log('  mobile_number: "${coowner['mobileNumber']?.toString() ?? ""}"', name: 'CoOwners');
        developer.log('  server_number: "${coowner['serverNumber']?.toString() ?? ""}"', name: 'CoOwners');
        developer.log('  consent: "${coowner['consent']?.toString() ?? ""}"', name: 'CoOwners');
        developer.log('  plot_no: "${addressInfo?['plotNo'] ?? ""}"', name: 'CoOwners');
        developer.log('  address: "${addressInfo?['address'] ?? ""}"', name: 'CoOwners');
        developer.log('  address_mobile_number: "${addressInfo?['mobileNumber'] ?? ""}"', name: 'CoOwners');
        developer.log('  email: "${addressInfo?['email'] ?? ""}"', name: 'CoOwners');
        developer.log('  pincode: "${addressInfo?['pincode'] ?? ""}"', name: 'CoOwners');
        developer.log('  address_district: "${addressInfo?['district'] ?? ""}"', name: 'CoOwners');
        developer.log('  address_village: "${addressInfo?['village'] ?? ""}"', name: 'CoOwners');
        developer.log('  post_office: "${addressInfo?['postOffice'] ?? ""}"', name: 'CoOwners');
      }
    }

// === NEXT OF KIN DEBUG ===
    developer.log('=== NEXT OF KIN ===', name: 'DebugInfo');
    final entries = nextOfKinData['nextOfKinEntries'] as List<Map<String, dynamic>>?;
    developer.log('Total next of kin: ${entries?.length ?? 0}', name: 'NextOfKin');

    if (entries != null) {
      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final naturalResources = entry['naturalResources']?.toString() ?? '';

        developer.log('Next of Kin ${i + 1}:', name: 'NextOfKin');
        developer.log('  direction: "${entry['direction']?.toString() ?? ""}"', name: 'NextOfKin');
        developer.log('  natural_resources: "$naturalResources"', name: 'NextOfKin');

        // Check if this entry has sub-entries (Name/Other types)
        if (entry.containsKey('subEntries')) {
          final subEntries = entry['subEntries'] as List<Map<String, dynamic>>?;
          developer.log('  total_sub_entries: ${entry['totalSubEntries'] ?? 0}', name: 'NextOfKin');

          if (subEntries != null) {
            for (int j = 0; j < subEntries.length; j++) {
              final subEntry = subEntries[j];
              developer.log('    Sub-entry ${j + 1}:', name: 'NextOfKin');
              developer.log('      name: "${subEntry['name']?.toString() ?? ""}"', name: 'NextOfKin');
              developer.log('      address: "${subEntry['address']?.toString() ?? ""}"', name: 'NextOfKin');
              developer.log('      mobile: "${subEntry['mobile']?.toString() ?? ""}"', name: 'NextOfKin');
              developer.log('      survey_no: "${subEntry['surveyNo']?.toString() ?? ""}"', name: 'NextOfKin');
            }
          }
        } else {
          // Legacy format or simple entries without sub-entries
          developer.log('  address: "${entry['address']?.toString() ?? ""}"', name: 'NextOfKin');
          developer.log('  mobile: "${entry['mobile']?.toString() ?? ""}"', name: 'NextOfKin');
          developer.log('  survey_no: "${entry['surveyNo']?.toString() ?? ""}"', name: 'NextOfKin');
        }
      }
    }

    // === DOCUMENTS ===
    developer.log('=== DOCUMENTS ===', name: 'DebugInfo');
    developer.log('identity_card_type: "${surveyEightController.selectedIdentityType.value}"', name: 'Documents');
    developer.log('identity_card_files: ${surveyEightController.identityCardFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');
    developer.log('seven_twelve_files: ${surveyEightController.sevenTwelveFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');
    developer.log('note_files: ${surveyEightController.noteFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');
    developer.log('partition_files: ${surveyEightController.partitionFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');
    developer.log('scheme_sheet_files: ${surveyEightController.schemeSheetFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');
    developer.log('old_census_map_files: ${surveyEightController.oldCensusMapFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');
    developer.log('demarcation_certificate_files: ${surveyEightController.demarcationCertificateFiles?.map((file) => file.toString()).toList() ?? []}', name: 'Documents');

    developer.log('=== END DEBUG ===', name: 'DebugInfo');
  }





  Map<String, dynamic> prepareMultipartData(userId) {
    // Get all data
    final surveyData = getSurveyInfoData();
    final surveyInfo = surveyData['survey_cts'] as Map<String, dynamic>?;
    final calculationData = getCalculationData();
    final stepFourData = getStepFourData();
    final applicantData = getFifthController();
    final coOwnerData = getSixthController();
    final nextOfKinData = getSeventhController();

    // Debug: Print data to check what's being collected
    print('🔍 Survey Info: $surveyInfo');
    print('🔍 Calculation Data: $calculationData');
    print('🔍 Step Four Data: $stepFourData');
    print('🔍 Applicant Data keys: ${applicantData.keys}');
    print('🔍 Co-owner Data keys: ${coOwnerData.keys}');
    print('🔍 Next of Kin Data keys: ${nextOfKinData.keys}');

    // Prepare fields (non-file data)
    Map<String, String> fields = {
      // ID here
      "user_id": userId?.toString() ?? "0",

      // === PERSONAL INFO ===
      "applicant_name": personalInfoController.applicantNameController.text.trim(),
      "applicant_address": personalInfoController.applicantAddressController.text.trim(),
      "is_landholder": personalInfoController.isHolderThemselves.value.toString(),
      "is_power_of_attorney": personalInfoController.hasAuthorityOnBehalf.value?.toString() ?? "false",
      "has_been_counted_before": personalInfoController.hasBeenCountedBefore.value.toString(),
      "poa_registration_number": personalInfoController.poaRegistrationNumberController.text.trim(),
      "poa_registration_date": personalInfoController.poaRegistrationDateController.text.trim(),
      "poa_giver_name": personalInfoController.poaIssuerNameController.text.trim(),
      "poa_holder_name": personalInfoController.poaHolderNameController.text.trim(),
      "poa_holder_address": personalInfoController.poaHolderAddressController.text.trim(),

      // === SURVEY INFO ===
      "survey_type": surveyCTSController.surveyCtsNumber.text,
      "department": surveyCTSController.selectedDepartment.value.toString(),
      "division_id": "1", // Hardcoded as per your example
      "district_id": "26", // Hardcoded as per your example
      "taluka_id": "5", // Hardcoded as per your example
      "village_id": "3", // Hardcoded as per your example

      // === CALCULATION INFO ===
      "operation_type": calculationController.getOperationType(),

      // === STEP FOUR INFO ===
      "selected_calculation_type": stepFourController.selectedCalculationType.value ?? "",
      "selected_duration": stepFourController.selectedDuration.value ?? "",
      "selected_holder_type": stepFourController.selectedHolderType.value ?? "",
      "selected_location_category": stepFourController.selectedLocationCategory.value ?? "",
      "calculation_fee": stepFourController.calculationFeeController.text.trim(),
      "calculation_fee_numeric": stepFourData['calculation_fee_numeric']?.toString() ?? "0",

    };

    // Convert complex data to JSON strings for multipart
    final calculationEntries = _getCalculationEntries(calculationData);
    final adjacentOwners = _getAdjacentOwners(applicantData);
    final coOwners = _getCoOwners(coOwnerData);
    final nextOfKin = _getNextOfKin(nextOfKinData);

    fields["survey_areas"] = jsonEncode(calculationEntries);
    fields["adjacent_owners"] = jsonEncode(adjacentOwners);
    fields["co_owners"] = jsonEncode(coOwners);
    fields["next_of_kin"] = jsonEncode(nextOfKin);



    // Prepare files
    List<MultipartFiles> files = [];

    // Add POA documents
    if (personalInfoController.poaDocument.isNotEmpty) {
      final filePath = personalInfoController.poaDocument.first.toString();
      if (filePath.isNotEmpty) {
        files.add(MultipartFiles(
          field: "poa_document",
          filePath: filePath,
        ));

      }
    }

    // Add document files (single entries, not arrays)
    if (surveyEightController.identityCardFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "identity_proof_path",
        filePath: surveyEightController.identityCardFiles!.first.toString(),
      ));
    }

    if (surveyEightController.sevenTwelveFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "seven_eleven_path",
        filePath: surveyEightController.sevenTwelveFiles!.first.toString(),
      ));
    }

    if (surveyEightController.noteFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "tipan_path",
        filePath: surveyEightController.noteFiles!.first.toString(),
      ));
    }

    if (surveyEightController.partitionFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "fadni_path",
        filePath: surveyEightController.partitionFiles!.first.toString(),
      ));
    }

    if (surveyEightController.schemeSheetFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "yojana_patrak_path",
        filePath: surveyEightController.schemeSheetFiles!.first.toString(),
      ));
    }

    if (surveyEightController.oldCensusMapFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "old_measurement_path",
        filePath: surveyEightController.oldCensusMapFiles!.first.toString(),
      ));
    }

    if (surveyEightController.demarcationCertificateFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "simankan_pramanpatra_path",
        filePath: surveyEightController.demarcationCertificateFiles!.first.toString(),
      ));
    }
    if (surveyEightController.adhikarPatra?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "adhikar_patras_path",
        filePath: surveyEightController.adhikarPatra!.first.toString(),
      ));
    }
    if (surveyEightController.otherDocument?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "other_documents_path",
        filePath: surveyEightController.otherDocument!.first.toString(),
      ));
    }

    // Add calculation-specific files
    if (calculationData['calculationType'] == 'Integration calculation') {
        final filePath = calculationController.incorporationOrderFiles!.first.toString();
        if (filePath.isNotEmpty) {
          files.add(MultipartFiles(
            field: "consolidation_order_map",
            filePath: filePath,
          ));
      }
    }

    // Add non-agricultural specific files
    if (surveyEightController.isNonAgricultural) {
      if (surveyEightController.sakshamPradikaranAdeshFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "saksham_pradikaran_adesh_path",
          filePath: surveyEightController.sakshamPradikaranAdeshFiles!.first.toString(),
        ));
      }
      if (surveyEightController.nakashaFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "nakasha_path",
          filePath: surveyEightController.nakashaFiles!.first.toString(),
        ));
      }
      if (surveyEightController.bhandhakamParvanaFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "bhandhakam_parvana_path",
          filePath: surveyEightController.bhandhakamParvanaFiles!.first.toString(),
        ));
      }
      if (surveyEightController.nonAgriculturalZoneCertificateFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "non_agricultural_zone_certificate_path",
          filePath: surveyEightController.nonAgriculturalZoneCertificateFiles!.first.toString(),
        ));
      }
    }


    // Add stomach specific files
    if (surveyEightController.isStomach) {
      if (surveyEightController.pratisaKarayaycheNakshaFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "pratisa_karayayche_naksha_path",
          filePath: surveyEightController.pratisaKarayaycheNakshaFiles!.first.toString(),
        ));
      }
      if (surveyEightController.bandPhotoFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "band_photo_path",
          filePath: surveyEightController.bandPhotoFiles!.first.toString(),
        ));
      }
      if (surveyEightController.sammatiPatraFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "sammati_patra_path",
          filePath: surveyEightController.sammatiPatraFiles!.first.toString(),
        ));
      }
      if (surveyEightController.stomachZoneCertificateFiles?.isNotEmpty == true) {
        files.add(MultipartFiles(
          field: "stomach_zone_certificate_path",
          filePath: surveyEightController.stomachZoneCertificateFiles!.first.toString(),
        ));
      }
    }

    print('🔍 Total Files: ${files.length}');
    for (var file in files) {
      print('🔍 File: ${file.field} -> ${file.filePath}');
    }

    return {
      'fields': fields,
      'files': files,
    };
  }

// Helper method to get calculation entries
  List<Map<String, dynamic>> _getCalculationEntries(Map<String, dynamic> calculationData) {
    String calcType = calculationData['calculationType']?.toString() ?? '';
    List<Map<String, dynamic>> entries = [];

    print('🔍 Processing calculation type: $calcType');

    switch (calcType) {
      case 'Hddkayam':
        if (calculationController.hddkayamEntries.isNotEmpty) {
          for (int i = 0; i < calculationController.hddkayamEntries.length; i++) {
            final entry = calculationController.hddkayamEntries[i];
            entries.add({
              "survey_number": entry['ctSurveyNumber']?.toString() ?? "",
              "original_area": entry['area']?.toString() ?? "",
              "area": entry['areaSqmController']?.text ?? ""
            });
          }
        }
        break;

      case 'Stomach':
        if (calculationController.stomachEntries.isNotEmpty) {
          for (int i = 0; i < calculationController.stomachEntries.length; i++) {
            final entry = calculationController.stomachEntries[i];
            entries.add({
              "survey_number": entry['surveyNumber']?.toString() ?? "",
              "original_area": entry['totalArea']?.toString() ?? "",
              "total_area":   entry['selectedMeasurementType']?.toString() ?? "",
            });
          }
        }
        break;

      case 'Non-agricultural':
      // Add order details first
        entries.add({
          "survey_number": calculationController.nonAgrisurveyNumberGatNumber.text.trim(),
          "order_approval_number": calculationController.orderNumberController.text.trim(),
          "order_approval_date": calculationController.orderDateController.text.trim(),
          "layout_approval_number": calculationController.schemeOrderNumberController.text.trim(),
          "layout_approval_date": calculationController.appointmentDateController.text.trim(),
        });

        // Then add survey entries
        if (calculationController.nonAgriculturalEntries.isNotEmpty) {
          for (int i = 0; i < calculationController.nonAgriculturalEntries.length; i++) {
            final entry = calculationController.nonAgriculturalEntries[i];
            entries.add({
              "survey_number": entry['surveyNumber']?.toString() ?? "",
              "original_area": entry['area']?.toString() ?? "",
              "area_hector":  entry['areaHectaresController']?.toString() ?? "",
            });
          }
        }
        break;

      case 'Counting by number of knots':
      // Add order details first
        entries.add({
          "survey_number": calculationController.countingKsurveyNumberGatNumber.text.trim(),
          "order_approval_number": calculationController.orderNumberController.text.trim(),
          "order_approval_date": calculationController.orderDateController.text.trim(),
          "layout_approval_number": calculationController.schemeOrderNumberController.text.trim(),
          "layout_approval_date": calculationController.appointmentDateController.text.trim(),
        });

        // Then add survey entries
        if (calculationController.knotsCountingEntries.isNotEmpty) {
          for (int i = 0; i < calculationController.knotsCountingEntries.length; i++) {
            final entry = calculationController.knotsCountingEntries[i];
            entries.add({
              "survey_number": entry['surveyNumber']?.toString() ?? "",
              "original_area": entry['area']?.toString() ?? "",
              "hector_area":entry['areaHectaresController']?.toString() ?? "",
            });
          }
        }
        break;

      case 'Integration calculation':
      // Add consolidation details first
        entries.add({
          "consolidation_order_number": calculationController.mergerOrderNumberController.text.trim(),
          "consolidation_order_date": calculationController.mergerOrderDateController.text.trim(),
          "old_consolidation_mrn": calculationController.oldMergerNumberController.text.trim(),
        });

        // Then add survey entries
        if (calculationController.integrationCalculationEntries.isNotEmpty) {
          for (int i = 0; i < calculationController.integrationCalculationEntries.length; i++) {
            final entry = calculationController.integrationCalculationEntries[i];
            entries.add({
              "ct_survey_number": entry['ctSurveyNumber']?.toString() ?? "",
              "original_area": entry['area']?.toString() ?? "",
            });
          }
        }
        break;

      default:
        print('⚠️ Unknown calculation type: $calcType');
        break;
    }

    print('🔍 Generated ${entries.length} calculation entries');
    return entries;
  }

  List<Map<String, dynamic>> _getAdjacentOwners(Map<String, dynamic> applicantData) {
    List<Map<String, dynamic>> applicantsList = [];
    final applicantCount = applicantData['applicantCount'] ?? 0;
    print('🔍 Processing $applicantCount adjacent owners');
    for (int i = 0; i < applicantCount; i++) {
      final applicantKey = 'applicant_$i';
      final applicantInfo = applicantData[applicantKey] as Map<String, dynamic>?;
      if (applicantInfo != null) {
        final addressInfo = applicantInfo['addressDetails'] as Map<String, dynamic>?;
        applicantsList.add({
          "name": applicantInfo['accountHolderName']?.toString() ?? "",
          // "account_number": applicantInfo['accountNumber']?.toString() ?? "",
          "mobile_number": applicantInfo['mobileNumber']?.toString() ?? "",
          // "server_number": applicantInfo['serverNumber']?.toString() ?? "",
          // "area": applicantInfo['area']?.toString() ?? "",
          // "potkharab_area": applicantInfo['potkaharabaArea']?.toString() ?? "",
          "total_area": applicantInfo['totalArea']?.toString() ?? "",
          "plot_no": addressInfo?['plotNo']?.toString() ?? "",
          "address": addressInfo?['address']?.toString() ?? "",
          "address_mobile_number": addressInfo?['mobileNumber']?.toString() ?? "",
          "email": addressInfo?['email']?.toString() ?? "",
          "pincode": addressInfo?['pincode']?.toString() ?? "",
          "address_district": addressInfo?['district']?.toString() ?? "",
          "address_village": addressInfo?['village']?.toString() ?? "",
          "post_office": addressInfo?['postOffice']?.toString() ?? "",
        });
      }
    }
    print('🔍 Generated ${applicantsList.length} adjacent owners');
    return applicantsList;
  }


// Helper method to get co-owners
  List<Map<String, dynamic>> _getCoOwners(Map<String, dynamic> coOwnerData) {
    List<Map<String, dynamic>> coOwnersList = [];
    final coowners = coOwnerData['coowners'] as List<Map<String, dynamic>>?;

    if (coowners != null) {
      print('🔍 Processing ${coowners.length} co-owners');

      for (int i = 0; i < coowners.length; i++) {
        final coowner = coowners[i];
        final addressInfo = coowner['address'] as Map<String, dynamic>?;

        coOwnersList.add({
          "name": coowner['name']?.toString() ?? "",
          "mobile_number": coowner['mobileNumber']?.toString() ?? "",
          // "server_number": coowner['serverNumber']?.toString() ?? "",
          // "consent": coowner['consent']?.toString() ?? "",
          "plot_no": addressInfo?['plotNo']?.toString() ?? "",
          "address": addressInfo?['address']?.toString() ?? "",
          "address_mobile_number": addressInfo?['mobileNumber']?.toString() ?? "",
          "email": addressInfo?['email']?.toString() ?? "",
          "pincode": addressInfo?['pincode']?.toString() ?? "",
          "address_district": addressInfo?['district']?.toString() ?? "",
          "address_village": addressInfo?['village']?.toString() ?? "",
          "post_office": addressInfo?['postOffice']?.toString() ?? "",
        });
      }
    } else {
      print('🔍 No co-owners found');
    }

    print('🔍 Generated ${coOwnersList.length} co-owners');
    return coOwnersList;
  }

  List<Map<String, dynamic>> _getNextOfKin(Map<String, dynamic> nextOfKinData) {
    List<Map<String, dynamic>> nextOfKinList = [];
    final entries = nextOfKinData['nextOfKinEntries'] as List<Map<String, dynamic>>?;

    if (entries != null) {
      print('🔍 Processing ${entries.length} next of kin entries');

      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final naturalResources = entry['naturalResources']?.toString() ?? '';
        final direction = entry['direction']?.toString() ?? '';

        // Handle entries with sub-entries (Name/Other)
        if (entry.containsKey('subEntries')) {
          final subEntries = entry['subEntries'] as List<Map<String, dynamic>>?;
          if (subEntries != null && subEntries.isNotEmpty) {
            List<Map<String, dynamic>> subEntriesList = [];
            for (int j = 0; j < subEntries.length; j++) {
              final subEntry = subEntries[j];
              subEntriesList.add({
                "name": subEntry['name']?.toString() ?? "",
                "address": subEntry['address']?.toString() ?? "",
                "mobile": subEntry['mobile']?.toString() ?? "",
                "survey_no": subEntry['surveyNo']?.toString() ?? "",
              });
            }
            nextOfKinList.add({
              "direction": direction,
              "natural_resources": naturalResources,
              "sub_entries": subEntriesList,
            });
          }
        }
        // Handle entries without sub-entries (Road, River, etc.)
        else {
          nextOfKinList.add({
            "direction": direction,
            "natural_resources": naturalResources,
            "entry_type": "simple",
            "entry_index": i + 1,
          });
        }
      }
    } else {
      print('🔍 No next of kin entries found');
    }

    print('🔍 Generated ${nextOfKinList.length} next of kin API entries');
    return nextOfKinList;
  }


void debugPrint(){

  String userId = "0";
  print('🆔 User ID: $userId');

  final multipartData = prepareMultipartData(userId);
  final fields = multipartData['fields'] as Map<String, String>;
  final files = multipartData['files'] as List<MultipartFiles>;

  developer.log(jsonEncode(fields), name: 'REQUEST_BODY');


}



  Future<void> submitSurvey() async {

    if (isLoading.value) return;

    // Set loading state
    update(); // Update UI if using GetX controller

    try {
      isLoading.value = true;

      String userId = (await ApiService.getUid()) ?? "0";
      print('🆔 User ID: $userId');

      final multipartData = prepareMultipartData(userId);
      final fields = multipartData['fields'] as Map<String, String>;
      final files = multipartData['files'] as List<MultipartFiles>;

      developer.log(jsonEncode(fields), name: 'REQUEST_BODY');


      final response = await ApiService.multipartPost<Map<String, dynamic>>(
        endpoint: haddakayamPost,
        fields: fields,
        files: files,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {
        print('✅ Survey submitted successfully: ${response.data}');

        Get.snackbar(
          'Success',
          'Survey submitted successfully!',
          backgroundColor: Color(0xFF52B788),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        Get.offAllNamed(AppRoutes.mainDashboard);

        // Show success animation
        update(); // Update UI

        isLoading.value = false;


      } else {
        print('❌ Survey submission failed: ${response.errorMessage ?? 'Unknown error'}');

        Get.snackbar(
          'Error',
          'Failed to submit survey. Please try again.',
          backgroundColor: Color(0xFFDC3545),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        // Show error state
        update();

        isLoading.value = false;


      }
    } catch (e) {
      print('💥 Exception during survey submission: $e');

      // Show error state
      update();
      isLoading.value = false;


    }
  }


  //   Future<void> submitSurvey() async {
  //   try {
  //     String userId = (await ApiService.getUid()) ?? "0";
  //     print('🆔 User ID: $userId');
  //
  //     final multipartData = prepareMultipartData(userId);
  //     final fields = multipartData['fields'] as Map<String, String>;
  //     final files = multipartData['files'] as List<MultipartFiles>;
  //
  //
  //
  //     developer.log(jsonEncode(fields), name: 'REQUEST_BODY',);
  //
  //     final response = await ApiService.multipartPost<Map<String, dynamic>>(
  //       endpoint: haddakayamPost,
  //       fields: fields,
  //       files: files,
  //       fromJson: (json) => json as Map<String, dynamic>,
  //       includeToken: true,
  //     );
  //
  //     if (response.success && response.data != null) {
  //       print('✅ Survey submitted successfully: ${response.data}');
  //     } else {
  //       print('❌ Survey submission failed: ${response.errorMessage ?? 'Unknown error'}');
  //     }
  //   } catch (e) {
  //     print('💥 Exception during survey submission: $e');
  //   }
  // }


  void saveAllStepsData() {
    // Collect data from all step controllers
    final allControllers = [
      personalInfoController,
      surveyCTSController,
      calculationController,
      stepFourController,
      surveyFifthController,
      surveySixthController,
      surveySeventhController,
      surveyEightController,
      // Add more controllers
    ];
    for (final controller in allControllers) {
      if (controller is StepDataMixin) {
        final stepData = controller.getStepData();
        _mergeStepData(stepData);
      }
    }
  }
}

// Mixins for step controllers to implement
mixin StepValidationMixin on GetxController {
  bool validateCurrentSubStep(String field);
  bool isStepCompleted(List<String> fields);
  String getFieldError(String field);
}

mixin StepDataMixin on GetxController {
  Map<String, dynamic> getStepData();
}




