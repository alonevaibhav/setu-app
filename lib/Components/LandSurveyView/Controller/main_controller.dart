import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/step_four.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_eight_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_fifth_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_seventh_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_sixth_controller.dart';
import '../../../API Service/api_service.dart';
import '../../../Constants/api_constant.dart';
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
      'office'
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
    8: ['preview', 'status'], // Preview
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
    debugPrintInfo();

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
        // Return data directly from getStepData() without extra nesting
        return surveySeventhController.getStepData();
      }

      // Fallback: manually collect data from SurveySeventhController
      final List<Map<String, dynamic>> entriesData = [];

      for (final entry in surveySeventhController.nextOfKinEntries) {
        entriesData.add({
          'address': (entry['addressController'] as TextEditingController).text,
          'mobile': (entry['mobileController'] as TextEditingController).text,
          'surveyNo':
              (entry['surveyNoController'] as TextEditingController).text,
          'direction': entry['direction'] as String? ?? '',
          'naturalResources': entry['naturalResources'] as String? ?? '',
        });
      }

      return {
        'nextOfKinEntries': entriesData,
        'totalNextOfKinEntries': entriesData.length,
      };
    } catch (e) {
      print('Error getting NextOfKin data: $e');
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

  ///////////////////////////////////
  // DEBUG PRINT METHOD
  ///////////////////////////////////

  // void debugPrintInfo() {
  //   developer.log('=== PERSONAL INFO DEBUG ===', name: 'DebugInfo');
  //
  //   developer.log(
  //       'Is holder themselves: ${personalInfoController.isHolderThemselves.value}',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'Has authority on behalf: ${personalInfoController.hasAuthorityOnBehalf.value}',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'Has been counted before: ${personalInfoController.hasBeenCountedBefore.value}',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'POA registration number: "${personalInfoController.poaRegistrationNumberController.text.trim()}"',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'POA registration date: "${personalInfoController.poaRegistrationDateController.text.trim()}"',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'POA issuer name: "${personalInfoController.poaIssuerNameController.text.trim()}"',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'POA holder name: "${personalInfoController.poaHolderNameController.text.trim()}"',
  //       name: 'PersonalInfo');
  //   developer.log(
  //       'POA holder address: "${personalInfoController.poaHolderAddressController.text.trim()}"',
  //       name: 'PersonalInfo');
  //
  //   developer.log('=== SURVEY INFO DATA DEBUG ===', name: 'DebugInfo');
  //
  //   final surveyData = getSurveyInfoData();
  //   final surveyInfo = surveyData['survey_cts'] as Map<String, dynamic>?;
  //
  //   if (surveyInfo != null) {
  //     developer.log('Survey Number: "${surveyInfo['survey_number']}"',
  //         name: 'SurveyInfo');
  //     developer.log('Department: "${surveyInfo['department']}"',
  //         name: 'SurveyInfo');
  //     developer.log('District: "${surveyInfo['district']}"',
  //         name: 'SurveyInfo');
  //     developer.log('Taluka: "${surveyInfo['taluka']}"', name: 'SurveyInfo');
  //     developer.log('Village: "${surveyInfo['village']}"', name: 'SurveyInfo');
  //     developer.log('Office: "${surveyInfo['office']}"', name: 'SurveyInfo');
  //   } else {
  //     developer.log('Survey info data is null',
  //         name: 'SurveyInfo', level: 900); // Warning level
  //   }
  //
  //   developer.log('=== CALCULATION DATA DEBUG ===', name: 'DebugInfo');
  //
  //   try {
  //     // Get calculation data using the fixed method
  //     final calculationData = getCalculationData();
  //
  //     if (calculationData.isNotEmpty) {
  //       developer.log(
  //           'Calculation Type: "${calculationData['calculationType']}"',
  //           name: 'CalculationData');
  //
  //
  //       // Print type-specific fields based on calculation type
  //       String calcType = calculationData['calculationType']?.toString() ?? '';
  //
  //       switch (calcType) {
  //         case 'Hddkayam':
  //           developer.log(
  //               'Hddkayam Entries Count: ${calculationData['hddkayamEntriesCount'] ?? 0}',
  //               name: 'Hddkayam');
  //
  //           // Print detailed entries
  //           for (int i = 0;
  //           i < calculationController.hddkayamEntries.length;
  //           i++) {
  //             final entry = calculationController.hddkayamEntries[i];
  //             developer.log('Entry ${i + 1}:', name: 'HddkayamEntry');
  //             developer.log(
  //                 '  CT Survey Number: "${entry['ctSurveyNumber'] ?? ''}"',
  //                 name: 'HddkayamEntry');
  //             developer.log(
  //                 '  Selected CT Survey: "${entry['selectedCTSurvey'] ?? ''}"',
  //                 name: 'HddkayamEntry');
  //             developer.log('  Area: "${entry['area'] ?? ''}"',
  //                 name: 'HddkayamEntry');
  //             developer.log('  Area Sqm: "${entry['areaSqm'] ?? ''}"',
  //                 name: 'HddkayamEntry');
  //             developer.log('  Is Correct: ${entry['isCorrect'] ?? false}',
  //                 name: 'HddkayamEntry');
  //           }
  //           break;
  //
  //         case 'Stomach':
  //           developer.log(
  //               'Stomach Entries Count: ${calculationData['stomachEntriesCount'] ?? 0}',
  //               name: 'Stomach');
  //
  //           // Print detailed entries
  //           for (int i = 0;
  //           i < calculationController.stomachEntries.length;
  //           i++) {
  //             final entry = calculationController.stomachEntries[i];
  //             developer.log('Entry ${i + 1}:', name: 'StomachEntry');
  //             developer.log('  Survey Number: "${entry['surveyNumber'] ?? ''}"',
  //                 name: 'StomachEntry');
  //             developer.log(
  //                 '  Measurement Type: "${entry['selectedMeasurementType'] ?? ''}"',
  //                 name: 'StomachEntry');
  //             developer.log('  Total Area: "${entry['totalArea'] ?? ''}"',
  //                 name: 'StomachEntry');
  //             developer.log(
  //                 '  Calculated Area: "${entry['calculatedArea'] ?? ''}"',
  //                 name: 'StomachEntry');
  //           }
  //           break;
  //
  //         case 'Non-agricultural':
  //           for (int i = 0;
  //           i < calculationController.nonAgriculturalEntries.length;
  //           i++) {
  //             final entry = calculationController.nonAgriculturalEntries[i];
  //             developer.log('Entry ${i + 1}:', name: 'NonAgriculturalEntry');
  //             developer.log('  Survey Number: "${entry['surveyNumber'] ?? ''}"',
  //                 name: 'NonAgriculturalEntry');
  //             developer.log(
  //                 '  Survey Type: "${entry['selectedSurveyType'] ?? ''}"',
  //                 name: 'NonAgriculturalEntry');
  //             developer.log('  Area: "${entry['area'] ?? ''}"',
  //                 name: 'NonAgriculturalEntry');
  //             developer.log('  Area Hectares: "${entry['areaHectares'] ?? ''}"',
  //                 name: 'NonAgriculturalEntry');
  //           }
  //           break;
  //
  //         case 'Counting by number of knots':
  //           for (int i = 0;
  //           i < calculationController.knotsCountingEntries.length;
  //           i++) {
  //             final entry = calculationController.knotsCountingEntries[i];
  //             developer.log('Entry ${i + 1}:', name: 'KnotsCountingEntry');
  //             developer.log('  Survey Number: "${entry['surveyNumber'] ?? ''}"',
  //                 name: 'KnotsCountingEntry');
  //             developer.log(
  //                 '  Survey Type: "${entry['selectedSurveyType'] ?? ''}"',
  //                 name: 'KnotsCountingEntry');
  //             developer.log('  Area: "${entry['area'] ?? ''}"',
  //                 name: 'KnotsCountingEntry');
  //             developer.log('  Area Hectares: "${entry['areaHectares'] ?? ''}"',
  //                 name: 'KnotsCountingEntry');
  //           }
  //           break;
  //
  //         case 'Integration calculation':
  //           developer.log(
  //               'Merger Order Number: "${calculationData['mergerOrderNumber']}"',
  //               name: 'IntegrationCalculation');
  //           developer.log(
  //               'Merger Order Date: "${calculationData['mergerOrderDate']}"',
  //               name: 'IntegrationCalculation');
  //           developer.log(
  //               'Old Merger Number: "${calculationData['oldMergerNumber']}"',
  //               name: 'IntegrationCalculation');
  //           developer.log(
  //               'incorporationOrderFiles raw: ${calculationController.incorporationOrderFiles}',
  //               name: 'IntegrationCalculation');
  //
  //           // Print detailed entries
  //           for (int i = 0;
  //           i < calculationController.integrationCalculationEntries.length;
  //           i++) {
  //             final entry =
  //             calculationController.integrationCalculationEntries[i];
  //             developer.log('Entry ${i + 1}:',
  //                 name: 'IntegrationCalculationEntry');
  //             developer.log(
  //                 '  CT Survey Number: "${entry['ctSurveyNumber'] ?? ''}"',
  //                 name: 'IntegrationCalculationEntry');
  //             developer.log(
  //                 '  Selected CT Survey: "${entry['selectedCTSurvey'] ?? ''}"',
  //                 name: 'IntegrationCalculationEntry');
  //             developer.log('  Area: "${entry['area'] ?? ''}"',
  //                 name: 'IntegrationCalculationEntry');
  //             developer.log('  Area Sqm: "${entry['areaSqm'] ?? ''}"',
  //                 name: 'IntegrationCalculationEntry');
  //           }
  //           break;
  //
  //         default:
  //           developer.log(
  //               'No calculation type selected or unknown type: "$calcType"',
  //               name: 'CalculationData',
  //               level: 900);
  //       }
  //     } else {
  //       developer.log(
  //           'Calculation data is empty - no calculation type selected or no data entered',
  //           name: 'CalculationData',
  //           level: 900);
  //     }
  //   } catch (e) {
  //     developer.log('Error in calculation debug: $e',
  //         name: 'CalculationData', level: 1000); // Error level
  //   }
  //
  //   developer.log('=== STEP FOUR DATA DEBUG ===', name: 'DebugInfo');
  //
  //   try {
  //     // Get step four data using the fixed method
  //     final stepFourData = getStepFourData();
  //
  //     if (stepFourData.isNotEmpty) {
  //       // Additional debugging for controller state
  //       developer.log(
  //           'Controller selectedCalculationType: "${stepFourController.selectedCalculationType.value}"',
  //           name: 'StepFourController');
  //       developer.log(
  //           'Controller selectedDuration: "${stepFourController.selectedDuration.value}"',
  //           name: 'StepFourController');
  //       developer.log(
  //           'Controller selectedHolderType: "${stepFourController.selectedHolderType.value}"',
  //           name: 'StepFourController');
  //       developer.log(
  //           'Controller selectedLocationCategory: "${stepFourController.selectedLocationCategory.value}"',
  //           name: 'StepFourController');
  //       developer.log(
  //           'Controller calculationFeeController text: "${stepFourController.calculationFeeController.text}"',
  //           name: 'StepFourController');
  //       developer.log(
  //           'Calculation Fee Numeric: ${stepFourData['calculation_fee_numeric'] ?? 'null'}',
  //           name: 'StepFourData');
  //     }
  //   } catch (e) {
  //     developer.log('Error in Step Four debug: $e',
  //         name: 'StepFourData', level: 1000); // Error level
  //   }
  //
  //   developer.log('=== FIFTH CONTROLLER DATA DEBUG ===', name: 'DebugInfo');
  //
  //   try {
  //     // Get applicant data using the fixed method
  //     final applicantData = getFifthController();
  //
  //     if (applicantData.isNotEmpty) {
  //       final applicantCount = applicantData['applicantCount'] ?? 0;
  //       developer.log('Total Applicants: $applicantCount',
  //           name: 'ApplicantData');
  //
  //       // Debug each applicant entry
  //       for (int i = 0; i < applicantCount; i++) {
  //         final applicantKey = 'applicant_$i';
  //         final applicantInfo =
  //         applicantData[applicantKey] as Map<String, dynamic>?;
  //
  //         if (applicantInfo != null) {
  //           developer.log('=== APPLICANT ${i + 1} ===', name: 'ApplicantEntry');
  //           developer.log('Agreement: "${applicantInfo['agreement'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log(
  //               'Account Holder Name: "${applicantInfo['accountHolderName'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log(
  //               'Account Number: "${applicantInfo['accountNumber'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log(
  //               'Mobile Number: "${applicantInfo['mobileNumber'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log(
  //               'Server Number: "${applicantInfo['serverNumber'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log('Area: "${applicantInfo['area'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log(
  //               'Potkaharaba Area: "${applicantInfo['potkaharabaArea'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //           developer.log('Total Area: "${applicantInfo['totalArea'] ?? ''}"',
  //               name: 'ApplicantEntry');
  //
  //           // Debug address data
  //           final addressInfo =
  //           applicantInfo['address'] as Map<String, dynamic>?;
  //           if (addressInfo != null && addressInfo.isNotEmpty) {
  //             developer.log('=== ADDRESS ${i + 1} ===',
  //                 name: 'ApplicantAddress');
  //             developer.log('Plot No: "${addressInfo['plotNo'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('Address: "${addressInfo['address'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('Mobile: "${addressInfo['mobileNumber'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('Email: "${addressInfo['email'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('Pincode: "${addressInfo['pincode'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('District: "${addressInfo['district'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('Village: "${addressInfo['village'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //             developer.log('Post Office: "${addressInfo['postOffice'] ?? ''}"',
  //                 name: 'ApplicantAddress');
  //           } else {
  //             developer.log('No address data for applicant ${i + 1}',
  //                 name: 'ApplicantAddress', level: 900);
  //           }
  //         } else {
  //           developer.log('Applicant ${i + 1} data is null',
  //               name: 'ApplicantEntry', level: 900);
  //         }
  //       }
  //     } else {
  //       developer.log('Applicant data is empty - no applicants added',
  //           name: 'ApplicantData', level: 900);
  //     }
  //   } catch (e) {
  //     developer.log('Error in Applicant debug: $e',
  //         name: 'ApplicantData', level: 1000); // Error level
  //   }
  //
  //   developer.log('=== END APPLICANT DEBUG ===', name: 'DebugInfo');
  //
  //   developer.log('=== SIXTH CONTROLLER DATA DEBUG ===', name: 'DebugInfo');
  //
  //   try {
  //     // Get co-owner data using the fixed method
  //     final coOwnerData = getSixthController();
  //     if (coOwnerData.isNotEmpty) {
  //       final coowners = coOwnerData['coowners'] as List<Map<String, dynamic>>?;
  //
  //       if (coowners != null && coowners.isNotEmpty) {
  //         for (int i = 0; i < coowners.length; i++) {
  //           final coowner = coowners[i];
  //
  //           developer.log('=== CO-OWNER ${i + 1} ===', name: 'CoOwnerEntry');
  //           developer.log('Name: "${coowner['name'] ?? ''}"',
  //               name: 'CoOwnerEntry');
  //           developer.log('Mobile Number: "${coowner['mobileNumber'] ?? ''}"',
  //               name: 'CoOwnerEntry');
  //           developer.log('Server Number: "${coowner['serverNumber'] ?? ''}"',
  //               name: 'CoOwnerEntry');
  //           developer.log('Consent: "${coowner['consent'] ?? ''}"',
  //               name: 'CoOwnerEntry');
  //
  //           // Debug address data
  //           final addressInfo = coowner['address'] as Map<String, String>?;
  //           if (addressInfo != null && addressInfo.isNotEmpty) {
  //             developer.log('=== CO-OWNER ${i + 1} ADDRESS ===',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Plot No: "${addressInfo['plotNo'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Address: "${addressInfo['address'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Mobile: "${addressInfo['mobileNumber'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Email: "${addressInfo['email'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Pincode: "${addressInfo['pincode'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('District: "${addressInfo['district'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Village: "${addressInfo['village'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //             developer.log('Post Office: "${addressInfo['postOffice'] ?? ''}"',
  //                 name: 'CoOwnerAddress');
  //           } else {
  //             developer.log('No address data for co-owner ${i + 1}',
  //                 name: 'CoOwnerAddress', level: 900);
  //           }
  //
  //           // Show formatted address
  //           final formattedAddress =
  //           surveySixthController.getFormattedAddress(i);
  //           developer.log(
  //               'Formatted address for co-owner ${i + 1}: "$formattedAddress"',
  //               name: 'CoOwnerFormatted');
  //         }
  //       } else {
  //         developer.log('No co-owners in the list',
  //             name: 'CoOwnerData', level: 900);
  //       }
  //     } else {
  //       developer.log('Co-owner data is empty - no co-owners added',
  //           name: 'CoOwnerData', level: 900);
  //     }
  //   } catch (e) {
  //     developer.log('Error in Co-owner debug: $e',
  //         name: 'CoOwnerData', level: 1000); // Error level
  //   }
  //
  //   developer.log('=== NEXT OF KIN DATA DEBUG ===', name: 'DebugInfo');
  //
  //   try {
  //     // Get next of kin data using the fixed method
  //     final nextOfKinData = getSeventhController();
  //
  //     if (nextOfKinData.isNotEmpty) {
  //       final entries =
  //       nextOfKinData['nextOfKinEntries'] as List<Map<String, dynamic>>?;
  //
  //       if (entries != null && entries.isNotEmpty) {
  //         for (int i = 0; i < entries.length; i++) {
  //           final entry = entries[i];
  //
  //           developer.log('=== NEXT OF KIN ${i + 1} ===',
  //               name: 'NextOfKinEntry');
  //           developer.log('Address: "${entry['address'] ?? ''}"',
  //               name: 'NextOfKinEntry');
  //           developer.log('Mobile: "${entry['mobile'] ?? ''}"',
  //               name: 'NextOfKinEntry');
  //           developer.log('Survey No: "${entry['surveyNo'] ?? ''}"',
  //               name: 'NextOfKinEntry');
  //           developer.log('Direction: "${entry['direction'] ?? ''}"',
  //               name: 'NextOfKinEntry');
  //           developer.log(
  //               'Natural Resources: "${entry['naturalResources'] ?? ''}"',
  //               name: 'NextOfKinEntry');
  //
  //           // Check if required fields are filled
  //           final requiredFields = [
  //             'address',
  //             'mobile',
  //             'surveyNo',
  //             'direction',
  //             'naturalResources'
  //           ];
  //           final missingFields = <String>[];
  //
  //           for (String field in requiredFields) {
  //             if ((entry[field] ?? '').toString().trim().isEmpty) {
  //               missingFields.add(field);
  //             }
  //           }
  //         }
  //       } else {
  //         developer.log('No next of kin entries in the list',
  //             name: 'NextOfKinData', level: 900);
  //       }
  //     } else {
  //       developer.log('Next of kin data is empty - no entries added',
  //           name: 'NextOfKinData', level: 900);
  //     }
  //   } catch (e) {
  //     developer.log('Error in Next of Kin debug: $e',
  //         name: 'NextOfKinData', level: 1000); // Error level
  //   }
  //
  //   developer.log('=== COURT EIGHT DATA DEBUG ===', name: 'DebugInfo');
  //
  //   // Identity card info
  //   developer.log('Selected Identity Type: "${surveyEightController.selectedIdentityType.value}"', name: 'CourtSeventh');
  //   developer.log('Identity Card Files: "${surveyEightController.identityCardFiles}"', name: 'CourtSeventh');
  //
  //   // Document files
  //   developer.log('Seven Twelve Files: "${surveyEightController.sevenTwelveFiles}"', name: 'CourtSeventh');
  //   developer.log('Note Files: "${surveyEightController.noteFiles}"', name: 'CourtSeventh');
  //   developer.log('Partition Files: "${surveyEightController.partitionFiles}"', name: 'CourtSeventh');
  //   developer.log('Scheme Sheet Files: "${surveyEightController.schemeSheetFiles}"', name: 'CourtSeventh');
  //   developer.log('Old Census Map Files: "${surveyEightController.oldCensusMapFiles}"', name: 'CourtSeventh');
  //   developer.log('Demarcation Certificate Files: "${surveyEightController.demarcationCertificateFiles}"', name: 'CourtSeventh');
  //
  //   developer.log('=== END COURT EIGHT DATA DEBUG ===', name: 'DebugInfo');
  //
  //   developer.log('=== END DEBUG ===', name: 'DebugInfo');
  // }


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
    developer.log('=== PERSONAL INFO ===', name: 'DebugInfo');
    developer.log('is_holder_themselves: ${personalInfoController.isHolderThemselves.value.toString()}', name: 'PersonalInfo');
    developer.log('has_authority_on_behalf: ${personalInfoController.hasAuthorityOnBehalf.value.toString()}', name: 'PersonalInfo');
    developer.log('has_been_counted_before: ${personalInfoController.hasBeenCountedBefore.value.toString()}', name: 'PersonalInfo');
    developer.log('poa_registration_number: "${personalInfoController.poaRegistrationNumberController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_registration_date: "${personalInfoController.poaRegistrationDateController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_issuer_name: "${personalInfoController.poaIssuerNameController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_holder_name: "${personalInfoController.poaHolderNameController.text.trim()}"', name: 'PersonalInfo');
    developer.log('poa_holder_address: "${personalInfoController.poaHolderAddressController.text.trim()}"', name: 'PersonalInfo');

    // === SURVEY INFO ===
    developer.log('=== SURVEY INFO ===', name: 'DebugInfo');
    developer.log('survey_number: "${surveyInfo?['survey_number']?.toString() ?? ""}"', name: 'SurveyInfo');
    developer.log('department: "${surveyInfo?['department']?.toString() ?? ""}"', name: 'SurveyInfo');
    developer.log('district: "${surveyInfo?['district']?.toString() ?? ""}"', name: 'SurveyInfo');
    developer.log('taluka: "${surveyInfo?['taluka']?.toString() ?? ""}"', name: 'SurveyInfo');
    developer.log('village: "${surveyInfo?['village']?.toString() ?? ""}"', name: 'SurveyInfo');
    developer.log('office: "${surveyInfo?['office']?.toString() ?? ""}"', name: 'SurveyInfo');

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

    // === NEXT OF KIN ===
    developer.log('=== NEXT OF KIN ===', name: 'DebugInfo');
    final entries = nextOfKinData['nextOfKinEntries'] as List<Map<String, dynamic>>?;
    developer.log('Total next of kin: ${entries?.length ?? 0}', name: 'NextOfKin');

    if (entries != null) {
      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];
        developer.log('Next of Kin ${i + 1}:', name: 'NextOfKin');
        developer.log('  address: "${entry['address']?.toString() ?? ""}"', name: 'NextOfKin');
        developer.log('  mobile: "${entry['mobile']?.toString() ?? ""}"', name: 'NextOfKin');
        developer.log('  survey_no: "${entry['surveyNo']?.toString() ?? ""}"', name: 'NextOfKin');
        developer.log('  direction: "${entry['direction']?.toString() ?? ""}"', name: 'NextOfKin');
        developer.log('  natural_resources: "${entry['naturalResources']?.toString() ?? ""}"', name: 'NextOfKin');
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














  Map<String, dynamic> PostRequestBody() {
    // Get all data
    final surveyData = getSurveyInfoData();
    final surveyInfo = surveyData['survey_cts'] as Map<String, dynamic>?;
    final calculationData = getCalculationData();
    final stepFourData = getStepFourData();
    final applicantData = getFifthController();
    final coOwnerData = getSixthController();
    final nextOfKinData = getSeventhController();

    return {
      // === PERSONAL INFO ===
      "is_landholder": personalInfoController.isHolderThemselves.value.toString(),
      "is_power_of_attorney": personalInfoController.hasAuthorityOnBehalf.value.toString(),
      "has_been_counted_before": personalInfoController.hasBeenCountedBefore.value.toString(),
      "poa_registration_number": personalInfoController.poaRegistrationNumberController.text.trim(),
      "poa_registration_date": personalInfoController.poaRegistrationDateController.text.trim(),
      "poa_giver_name": personalInfoController.poaIssuerNameController.text.trim(),
      "poa_holder_name": personalInfoController.poaHolderNameController.text.trim(),
      "poa_holder_address": personalInfoController.poaHolderAddressController.text.trim(),
      "poa_document_path": personalInfoController.sevenTwelveFiles.toList(), // add validation later

      // === SURVEY INFO ===
      "survey_type": surveyInfo?['survey_number']?.toString() ?? "", // changes to dropdown
      "department": surveyInfo?['department']?.toString() ?? "",
      "division_id": surveyInfo?['division_id']?.toString() ?? "", // added later
      "district_id": surveyInfo?['district']?.toString() ?? "",
      "taluka_id": surveyInfo?['taluka']?.toString() ?? "",
      "village_id": surveyInfo?['village']?.toString() ?? "",
      "office_name": surveyInfo?['office']?.toString() ?? "",

      // === CALCULATION INFO ===
      "operation_type": calculationData['calculationType']?.toString() ?? "",  //changes to ENUM given values

      // === CALCULATION ENTRIES ===
      "calculation_entries": () {
        String calcType = calculationData['calculationType']?.toString() ?? '';
        List<Map<String, dynamic>> entries = [];

        switch (calcType) {
          case 'Hddkayam':
            for (int i = 0; i < calculationController.hddkayamEntries.length; i++) {
              final entry = calculationController.hddkayamEntries[i];
              entries.add({
                "survey_number": entry['ctSurveyNumber']?.toString() ?? "",
                // "survey_number": entry['selectedCTSurvey']?.toString() ?? "",  /// same field are same data manage in UI
                "original_area": entry['area']?.toString() ?? "",
                // "original_area": entry['areaSqm']?.toString() ?? "",
              });
            }
            break;

          case 'Stomach':
            for (int i = 0; i < calculationController.stomachEntries.length; i++) {
              final entry = calculationController.stomachEntries[i];
              entries.add({
                "survey_number": entry['surveyNumber']?.toString() ?? "",
                // "measurement_type": entry['selectedMeasurementType']?.toString() ?? "",
                "original_area": entry['totalArea']?.toString() ?? "",
                // "calculated_area": entry['calculatedArea']?.toString() ?? "",
              });
            }
            break;

          case 'Non-agricultural':
          // Add common fields for Non-agricultural
            entries.add({
              "order_approval_number": calculationController.orderNumberController.text.trim(),
              "order_approval_date": calculationController.orderDateController.text.trim(),
              "layout_approval_number": calculationController.schemeOrderNumberController.text.trim(),
              "layout_approval_date": calculationController.appointmentDateController.text.trim(),
            });

            for (int i = 0; i < calculationController.nonAgriculturalEntries.length; i++) {
              final entry = calculationController.nonAgriculturalEntries[i];
              entries.add({
                "survey_number": entry['surveyNumber']?.toString() ?? "",
                // "survey_type": entry['selectedSurveyType']?.toString() ?? "",
                "original_area": entry['area']?.toString() ?? "",
                // "area_hectares": entry['areaHectares']?.toString() ?? "",
              });
            }
            break;

          case 'Counting by number of knots':
          // Add common fields for Counting by number of knots
            entries.add({
              "order_approval_number": calculationController.orderNumberController.text.trim(),
              "order_approval_date": calculationController.orderDateController.text.trim(),
              "layout_approval_number": calculationController.schemeOrderNumberController.text.trim(),
              "layout_approval_date": calculationController.appointmentDateController.text.trim(),
            });

            for (int i = 0; i < calculationController.knotsCountingEntries.length; i++) {
              final entry = calculationController.knotsCountingEntries[i];
              entries.add({
                "survey_number": entry['surveyNumber']?.toString() ?? "",
                // "survey_type": entry['selectedSurveyType']?.toString() ?? "",
                "original_area": entry['area']?.toString() ?? "",
                // "area_hectares": entry['areaHectares']?.toString() ?? "",
              });
            }
            break;

          case 'Integration calculation':
          // Add specific fields for Integration calculation
            entries.add({
              "consolidation_order_number": calculationController.mergerOrderNumberController.text.trim(),
              "consolidation_order_date": calculationController.mergerOrderDateController.text.trim(),
              "old_consolidation_mrn": calculationController.oldMergerNumberController.text.trim(),
              "consolidationOrderMapPath": calculationController.incorporationOrderFiles?.map((file) => file.toString()).toList() ?? [],
            });

            for (int i = 0; i < calculationController.integrationCalculationEntries.length; i++) {
              final entry = calculationController.integrationCalculationEntries[i];
              entries.add({
                "ct_survey_number": entry['ctSurveyNumber']?.toString() ?? "",
                // "selected_ct_survey": entry['selectedCTSurvey']?.toString() ?? "",
                "original_area": entry['area']?.toString() ?? "",
                // "area_sqm": entry['areaSqm']?.toString() ?? "",
              });
            }
            break;
        }

        return entries;
      }(),

      // === STEP FOUR INFO ===
      "selected_calculation_type": stepFourController.selectedCalculationType.value,
      "selected_duration": stepFourController.selectedDuration.value,
      "selected_holder_type": stepFourController.selectedHolderType.value,
      "selected_location_category": stepFourController.selectedLocationCategory.value,  //is_within_municipal_corporation: 0 or 1
      "calculation_fee": stepFourController.calculationFeeController.text.trim(),
      "calculation_fee_numeric": stepFourData['calculation_fee_numeric']?.toString() ?? "",



      // === APPLICANTS ===
      "adjacent_owners": () {
        List<Map<String, dynamic>> applicantsList = [];
        final applicantCount = applicantData['applicantCount'] ?? 0;

        for (int i = 0; i < applicantCount; i++) {
          final applicantKey = 'applicant_$i';
          final applicantInfo = applicantData[applicantKey] as Map<String, dynamic>?;

          if (applicantInfo != null) {
            final addressInfo = applicantInfo['address'] as Map<String, dynamic>?;

            applicantsList.add({
              // "agreement": applicantInfo['agreement']?.toString() ?? "",
              "name": applicantInfo['accountHolderName']?.toString() ?? "",
              "account_number": applicantInfo['accountNumber']?.toString() ?? "",
              "mobile_number": applicantInfo['mobileNumber']?.toString() ?? "",
              "server_number": applicantInfo['serverNumber']?.toString() ?? "",
              "area": applicantInfo['area']?.toString() ?? "",
              "potkharab_area": applicantInfo['potkaharabaArea']?.toString() ?? "",
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

        return applicantsList;
      }(),

      // === CO-OWNERS ===
      "co_owners": () {
        List<Map<String, dynamic>> coOwnersList = [];
        final coowners = coOwnerData['coowners'] as List<Map<String, dynamic>>?;

        if (coowners != null) {
          for (int i = 0; i < coowners.length; i++) {
            final coowner = coowners[i];
            final addressInfo = coowner['address'] as Map<String, String>?;

            coOwnersList.add({
              "name": coowner['name']?.toString() ?? "",
              "mobile_number": coowner['mobileNumber']?.toString() ?? "",
              "server_number": coowner['serverNumber']?.toString() ?? "",
              "consent": coowner['consent']?.toString() ?? "", // this is checkbox not added yet
              //address fields
              "plot_no": addressInfo?['plotNo'] ?? "",
              "address": addressInfo?['address'] ?? "",
              "address_mobile_number": addressInfo?['mobileNumber'] ?? "", // not added yet
              "email": addressInfo?['email'] ?? "",
              "pincode": addressInfo?['pincode'] ?? "",
              "address_district": addressInfo?['district'] ?? "",
              "address_village": addressInfo?['village'] ?? "",
              "post_office": addressInfo?['postOffice'] ?? "",
            });
          }
        }

        return coOwnersList;
      }(),

      // === NEXT OF KIN ===
      "next_of_kin": () {
        List<Map<String, dynamic>> nextOfKinList = [];
        final entries = nextOfKinData['nextOfKinEntries'] as List<Map<String, dynamic>>?;

        if (entries != null) {
          for (int i = 0; i < entries.length; i++) {
            final entry = entries[i];
            nextOfKinList.add({
              "address": entry['address']?.toString() ?? "",
              "mobile": entry['mobile']?.toString() ?? "",
              "survey_no": entry['surveyNo']?.toString() ?? "",
              "direction": entry['direction']?.toString() ?? "",
              "natural_resources": entry['naturalResources']?.toString() ?? "",
            });
          }
        }

        return nextOfKinList;
      }(),

      // === DOCUMENTS ===
      "identity_proof_path": surveyEightController.selectedIdentityType.value,
      "identity_card_files": surveyEightController.identityCardFiles?.map((file) => file.toString()).toList() ?? [],
      "seven_eleven_path": surveyEightController.sevenTwelveFiles?.map((file) => file.toString()).toList() ?? [],
      "tipan_path": surveyEightController.noteFiles?.map((file) => file.toString()).toList() ?? [],
      "fadni_path": surveyEightController.partitionFiles?.map((file) => file.toString()).toList() ?? [],
      "yojana_patrak_path": surveyEightController.schemeSheetFiles?.map((file) => file.toString()).toList() ?? [],
      "old_measurement_path": surveyEightController.oldCensusMapFiles?.map((file) => file.toString()).toList() ?? [],
      "simankan_pramanpatra_path": surveyEightController.demarcationCertificateFiles?.map((file) => file.toString()).toList() ?? [],
    };
  }






  Future<void> submitSurvey() async {
    try {
      final requestBody = PostRequestBody();

      final response = await ApiService.post<Map<String, dynamic>>(
        endpoint: bhusampadanPost,
        body: requestBody,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {
        print('✅ Success: ${response.data}');
      } else {
        print('❌ Error: ${response.errorMessage ?? 'Unknown error'}');
      }
    } catch (e) {
      print('💥 Exception: $e');
    }
  }


  void _saveAllStepsData() {
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
