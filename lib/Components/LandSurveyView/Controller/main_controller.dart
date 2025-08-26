import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/step_four.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_eight_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_fifth_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_seventh_controller.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/survey_sixth_controller.dart';
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
      // Move to next substep within current main step
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

  void debugPrintInfo() {
    developer.log('=== PERSONAL INFO DEBUG ===', name: 'DebugInfo');

    developer.log(
        'Is holder themselves: ${personalInfoController.isHolderThemselves.value}',
        name: 'PersonalInfo');
    developer.log(
        'Has authority on behalf: ${personalInfoController.hasAuthorityOnBehalf.value}',
        name: 'PersonalInfo');
    developer.log(
        'Has been counted before: ${personalInfoController.hasBeenCountedBefore.value}',
        name: 'PersonalInfo');
    developer.log(
        'POA registration number: "${personalInfoController.poaRegistrationNumberController.text.trim()}"',
        name: 'PersonalInfo');
    developer.log(
        'POA registration date: "${personalInfoController.poaRegistrationDateController.text.trim()}"',
        name: 'PersonalInfo');
    developer.log(
        'POA issuer name: "${personalInfoController.poaIssuerNameController.text.trim()}"',
        name: 'PersonalInfo');
    developer.log(
        'POA holder name: "${personalInfoController.poaHolderNameController.text.trim()}"',
        name: 'PersonalInfo');
    developer.log(
        'POA holder address: "${personalInfoController.poaHolderAddressController.text.trim()}"',
        name: 'PersonalInfo');

    developer.log('=== SURVEY INFO DATA DEBUG ===', name: 'DebugInfo');

    final surveyData = getSurveyInfoData();
    final surveyInfo = surveyData['survey_cts'] as Map<String, dynamic>?;

    if (surveyInfo != null) {
      developer.log('Survey Number: "${surveyInfo['survey_number']}"',
          name: 'SurveyInfo');
      developer.log('Department: "${surveyInfo['department']}"',
          name: 'SurveyInfo');
      developer.log('District: "${surveyInfo['district']}"',
          name: 'SurveyInfo');
      developer.log('Taluka: "${surveyInfo['taluka']}"', name: 'SurveyInfo');
      developer.log('Village: "${surveyInfo['village']}"', name: 'SurveyInfo');
      developer.log('Office: "${surveyInfo['office']}"', name: 'SurveyInfo');
    } else {
      developer.log('Survey info data is null',
          name: 'SurveyInfo', level: 900); // Warning level
    }

    developer.log('=== CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    try {
      // Get calculation data using the fixed method
      final calculationData = getCalculationData();

      if (calculationData.isNotEmpty) {
        developer.log(
            'Calculation Type: "${calculationData['calculationType']}"',
            name: 'CalculationData');
        if (calculationData['orderNumber']?.toString().isNotEmpty ?? false) {
          developer.log('Order Number: "${calculationData['orderNumber']}"',
              name: 'CalculationData');
        }
        if (calculationData['orderDate']?.toString().isNotEmpty ?? false) {
          developer.log('Order Date: "${calculationData['orderDate']}"',
              name: 'CalculationData');
        }
        if (calculationData['schemeOrderNumber']?.toString().isNotEmpty ??
            false) {
          developer.log(
              'Scheme Order Number: "${calculationData['schemeOrderNumber']}"',
              name: 'CalculationData');
        }
        if (calculationData['appointmentDate']?.toString().isNotEmpty ??
            false) {
          developer.log(
              'Appointment Date: "${calculationData['appointmentDate']}"',
              name: 'CalculationData');
        }

        // Print type-specific fields based on calculation type
        String calcType = calculationData['calculationType']?.toString() ?? '';

        switch (calcType) {
          case 'Hddkayam':
            developer.log(
                'Hddkayam Entries Count: ${calculationData['hddkayamEntriesCount'] ?? 0}',
                name: 'Hddkayam');

            // Print detailed entries
            for (int i = 0;
                i < calculationController.hddkayamEntries.length;
                i++) {
              final entry = calculationController.hddkayamEntries[i];
              developer.log('Entry ${i + 1}:', name: 'HddkayamEntry');
              developer.log(
                  '  CT Survey Number: "${entry['ctSurveyNumber'] ?? ''}"',
                  name: 'HddkayamEntry');
              developer.log(
                  '  Selected CT Survey: "${entry['selectedCTSurvey'] ?? ''}"',
                  name: 'HddkayamEntry');
              developer.log('  Area: "${entry['area'] ?? ''}"',
                  name: 'HddkayamEntry');
              developer.log('  Area Sqm: "${entry['areaSqm'] ?? ''}"',
                  name: 'HddkayamEntry');
              developer.log('  Is Correct: ${entry['isCorrect'] ?? false}',
                  name: 'HddkayamEntry');
            }
            break;

          case 'Stomach':
            developer.log(
                'Stomach Entries Count: ${calculationData['stomachEntriesCount'] ?? 0}',
                name: 'Stomach');

            // Print detailed entries
            for (int i = 0;
                i < calculationController.stomachEntries.length;
                i++) {
              final entry = calculationController.stomachEntries[i];
              developer.log('Entry ${i + 1}:', name: 'StomachEntry');
              developer.log('  Survey Number: "${entry['surveyNumber'] ?? ''}"',
                  name: 'StomachEntry');
              developer.log(
                  '  Measurement Type: "${entry['selectedMeasurementType'] ?? ''}"',
                  name: 'StomachEntry');
              developer.log('  Total Area: "${entry['totalArea'] ?? ''}"',
                  name: 'StomachEntry');
              developer.log(
                  '  Calculated Area: "${entry['calculatedArea'] ?? ''}"',
                  name: 'StomachEntry');
            }
            break;

          case 'Non-agricultural':
            for (int i = 0;
                i < calculationController.nonAgriculturalEntries.length;
                i++) {
              final entry = calculationController.nonAgriculturalEntries[i];
              developer.log('Entry ${i + 1}:', name: 'NonAgriculturalEntry');
              developer.log('  Survey Number: "${entry['surveyNumber'] ?? ''}"',
                  name: 'NonAgriculturalEntry');
              developer.log(
                  '  Survey Type: "${entry['selectedSurveyType'] ?? ''}"',
                  name: 'NonAgriculturalEntry');
              developer.log('  Area: "${entry['area'] ?? ''}"',
                  name: 'NonAgriculturalEntry');
              developer.log('  Area Hectares: "${entry['areaHectares'] ?? ''}"',
                  name: 'NonAgriculturalEntry');
            }
            break;

          case 'Counting by number of knots':
            for (int i = 0;
                i < calculationController.knotsCountingEntries.length;
                i++) {
              final entry = calculationController.knotsCountingEntries[i];
              developer.log('Entry ${i + 1}:', name: 'KnotsCountingEntry');
              developer.log('  Survey Number: "${entry['surveyNumber'] ?? ''}"',
                  name: 'KnotsCountingEntry');
              developer.log(
                  '  Survey Type: "${entry['selectedSurveyType'] ?? ''}"',
                  name: 'KnotsCountingEntry');
              developer.log('  Area: "${entry['area'] ?? ''}"',
                  name: 'KnotsCountingEntry');
              developer.log('  Area Hectares: "${entry['areaHectares'] ?? ''}"',
                  name: 'KnotsCountingEntry');
            }
            break;

          case 'Integration calculation':
            developer.log(
                'Merger Order Number: "${calculationData['mergerOrderNumber']}"',
                name: 'IntegrationCalculation');
            developer.log(
                'Merger Order Date: "${calculationData['mergerOrderDate']}"',
                name: 'IntegrationCalculation');
            developer.log(
                'Old Merger Number: "${calculationData['oldMergerNumber']}"',
                name: 'IntegrationCalculation');
            developer.log(
                'incorporationOrderFiles raw: ${calculationController.incorporationOrderFiles}',
                name: 'IntegrationCalculation');

            // Print detailed entries
            for (int i = 0;
                i < calculationController.integrationCalculationEntries.length;
                i++) {
              final entry =
                  calculationController.integrationCalculationEntries[i];
              developer.log('Entry ${i + 1}:',
                  name: 'IntegrationCalculationEntry');
              developer.log(
                  '  CT Survey Number: "${entry['ctSurveyNumber'] ?? ''}"',
                  name: 'IntegrationCalculationEntry');
              developer.log(
                  '  Selected CT Survey: "${entry['selectedCTSurvey'] ?? ''}"',
                  name: 'IntegrationCalculationEntry');
              developer.log('  Area: "${entry['area'] ?? ''}"',
                  name: 'IntegrationCalculationEntry');
              developer.log('  Area Sqm: "${entry['areaSqm'] ?? ''}"',
                  name: 'IntegrationCalculationEntry');
            }
            break;

          default:
            developer.log(
                'No calculation type selected or unknown type: "$calcType"',
                name: 'CalculationData',
                level: 900);
        }
      } else {
        developer.log(
            'Calculation data is empty - no calculation type selected or no data entered',
            name: 'CalculationData',
            level: 900);
      }
    } catch (e) {
      developer.log('Error in calculation debug: $e',
          name: 'CalculationData', level: 1000); // Error level
    }

    developer.log('=== STEP FOUR DATA DEBUG ===', name: 'DebugInfo');

    try {
      // Get step four data using the fixed method
      final stepFourData = getStepFourData();

      if (stepFourData.isNotEmpty) {
        // Additional debugging for controller state
        developer.log(
            'Controller selectedCalculationType: "${stepFourController.selectedCalculationType.value}"',
            name: 'StepFourController');
        developer.log(
            'Controller selectedDuration: "${stepFourController.selectedDuration.value}"',
            name: 'StepFourController');
        developer.log(
            'Controller selectedHolderType: "${stepFourController.selectedHolderType.value}"',
            name: 'StepFourController');
        developer.log(
            'Controller selectedLocationCategory: "${stepFourController.selectedLocationCategory.value}"',
            name: 'StepFourController');
        developer.log(
            'Controller calculationFeeController text: "${stepFourController.calculationFeeController.text}"',
            name: 'StepFourController');
        developer.log(
            'Calculation Fee Numeric: ${stepFourData['calculation_fee_numeric'] ?? 'null'}',
            name: 'StepFourData');
      }
    } catch (e) {
      developer.log('Error in Step Four debug: $e',
          name: 'StepFourData', level: 1000); // Error level
    }

    developer.log('=== FIFTH CONTROLLER DATA DEBUG ===', name: 'DebugInfo');

    try {
      // Get applicant data using the fixed method
      final applicantData = getFifthController();

      if (applicantData.isNotEmpty) {
        final applicantCount = applicantData['applicantCount'] ?? 0;
        developer.log('Total Applicants: $applicantCount',
            name: 'ApplicantData');

        // Debug each applicant entry
        for (int i = 0; i < applicantCount; i++) {
          final applicantKey = 'applicant_$i';
          final applicantInfo =
              applicantData[applicantKey] as Map<String, dynamic>?;

          if (applicantInfo != null) {
            developer.log('=== APPLICANT ${i + 1} ===', name: 'ApplicantEntry');
            developer.log('Agreement: "${applicantInfo['agreement'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log(
                'Account Holder Name: "${applicantInfo['accountHolderName'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log(
                'Account Number: "${applicantInfo['accountNumber'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log(
                'Mobile Number: "${applicantInfo['mobileNumber'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log(
                'Server Number: "${applicantInfo['serverNumber'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log('Area: "${applicantInfo['area'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log(
                'Potkaharaba Area: "${applicantInfo['potkaharabaArea'] ?? ''}"',
                name: 'ApplicantEntry');
            developer.log('Total Area: "${applicantInfo['totalArea'] ?? ''}"',
                name: 'ApplicantEntry');

            // Debug address data
            final addressInfo =
                applicantInfo['address'] as Map<String, dynamic>?;
            if (addressInfo != null && addressInfo.isNotEmpty) {
              developer.log('=== ADDRESS ${i + 1} ===',
                  name: 'ApplicantAddress');
              developer.log('Plot No: "${addressInfo['plotNo'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('Address: "${addressInfo['address'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('Mobile: "${addressInfo['mobileNumber'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('Email: "${addressInfo['email'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('Pincode: "${addressInfo['pincode'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('District: "${addressInfo['district'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('Village: "${addressInfo['village'] ?? ''}"',
                  name: 'ApplicantAddress');
              developer.log('Post Office: "${addressInfo['postOffice'] ?? ''}"',
                  name: 'ApplicantAddress');
            } else {
              developer.log('No address data for applicant ${i + 1}',
                  name: 'ApplicantAddress', level: 900);
            }
          } else {
            developer.log('Applicant ${i + 1} data is null',
                name: 'ApplicantEntry', level: 900);
          }
        }
      } else {
        developer.log('Applicant data is empty - no applicants added',
            name: 'ApplicantData', level: 900);
      }
    } catch (e) {
      developer.log('Error in Applicant debug: $e',
          name: 'ApplicantData', level: 1000); // Error level
    }

    developer.log('=== END APPLICANT DEBUG ===', name: 'DebugInfo');

    developer.log('=== SIXTH CONTROLLER DATA DEBUG ===', name: 'DebugInfo');

    try {
      // Get co-owner data using the fixed method
      final coOwnerData = getSixthController();
      if (coOwnerData.isNotEmpty) {
        final coowners = coOwnerData['coowners'] as List<Map<String, dynamic>>?;

        if (coowners != null && coowners.isNotEmpty) {
          for (int i = 0; i < coowners.length; i++) {
            final coowner = coowners[i];

            developer.log('=== CO-OWNER ${i + 1} ===', name: 'CoOwnerEntry');
            developer.log('Name: "${coowner['name'] ?? ''}"',
                name: 'CoOwnerEntry');
            developer.log('Mobile Number: "${coowner['mobileNumber'] ?? ''}"',
                name: 'CoOwnerEntry');
            developer.log('Server Number: "${coowner['serverNumber'] ?? ''}"',
                name: 'CoOwnerEntry');
            developer.log('Consent: "${coowner['consent'] ?? ''}"',
                name: 'CoOwnerEntry');

            // Debug address data
            final addressInfo = coowner['address'] as Map<String, String>?;
            if (addressInfo != null && addressInfo.isNotEmpty) {
              developer.log('=== CO-OWNER ${i + 1} ADDRESS ===',
                  name: 'CoOwnerAddress');
              developer.log('Plot No: "${addressInfo['plotNo'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('Address: "${addressInfo['address'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('Mobile: "${addressInfo['mobileNumber'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('Email: "${addressInfo['email'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('Pincode: "${addressInfo['pincode'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('District: "${addressInfo['district'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('Village: "${addressInfo['village'] ?? ''}"',
                  name: 'CoOwnerAddress');
              developer.log('Post Office: "${addressInfo['postOffice'] ?? ''}"',
                  name: 'CoOwnerAddress');
            } else {
              developer.log('No address data for co-owner ${i + 1}',
                  name: 'CoOwnerAddress', level: 900);
            }

            // Show formatted address
            final formattedAddress =
                surveySixthController.getFormattedAddress(i);
            developer.log(
                'Formatted address for co-owner ${i + 1}: "$formattedAddress"',
                name: 'CoOwnerFormatted');
          }
        } else {
          developer.log('No co-owners in the list',
              name: 'CoOwnerData', level: 900);
        }
      } else {
        developer.log('Co-owner data is empty - no co-owners added',
            name: 'CoOwnerData', level: 900);
      }
    } catch (e) {
      developer.log('Error in Co-owner debug: $e',
          name: 'CoOwnerData', level: 1000); // Error level
    }

    developer.log('=== NEXT OF KIN DATA DEBUG ===', name: 'DebugInfo');

    try {
      // Get next of kin data using the fixed method
      final nextOfKinData = getSeventhController();

      if (nextOfKinData.isNotEmpty) {
        final entries =
            nextOfKinData['nextOfKinEntries'] as List<Map<String, dynamic>>?;

        if (entries != null && entries.isNotEmpty) {
          for (int i = 0; i < entries.length; i++) {
            final entry = entries[i];

            developer.log('=== NEXT OF KIN ${i + 1} ===',
                name: 'NextOfKinEntry');
            developer.log('Address: "${entry['address'] ?? ''}"',
                name: 'NextOfKinEntry');
            developer.log('Mobile: "${entry['mobile'] ?? ''}"',
                name: 'NextOfKinEntry');
            developer.log('Survey No: "${entry['surveyNo'] ?? ''}"',
                name: 'NextOfKinEntry');
            developer.log('Direction: "${entry['direction'] ?? ''}"',
                name: 'NextOfKinEntry');
            developer.log(
                'Natural Resources: "${entry['naturalResources'] ?? ''}"',
                name: 'NextOfKinEntry');

            // Check if required fields are filled
            final requiredFields = [
              'address',
              'mobile',
              'surveyNo',
              'direction',
              'naturalResources'
            ];
            final missingFields = <String>[];

            for (String field in requiredFields) {
              if ((entry[field] ?? '').toString().trim().isEmpty) {
                missingFields.add(field);
              }
            }
          }
        } else {
          developer.log('No next of kin entries in the list',
              name: 'NextOfKinData', level: 900);
        }
      } else {
        developer.log('Next of kin data is empty - no entries added',
            name: 'NextOfKinData', level: 900);
      }
    } catch (e) {
      developer.log('Error in Next of Kin debug: $e',
          name: 'NextOfKinData', level: 1000); // Error level
    }

    // developer.log('=== END NEXT OF KIN DEBUG ===', name: 'DebugInfo');

    developer.log('=== DOCUMENTS DATA DEBUG ===', name: 'DebugInfo');

    try {
      // Get documents data using the fixed method
      final documentsData = getDocumentsData();

      if (documentsData.isNotEmpty) {
        // Identity Card Information
        developer.log('=== IDENTITY CARD ===', name: 'DocumentsData');
        developer.log(
            'Identity Card Type: "${documentsData['identityCardType'] ?? ''}"',
            name: 'DocumentsData');

        final identityFiles =
            documentsData['identityCardFiles'] as List<String>?;
        if (identityFiles != null && identityFiles.isNotEmpty) {
          developer.log('Identity Card Path : "$identityFiles"',
              name: 'DocumentsData');
          // }
        } else {
          developer.log('No identity card files uploaded',
              name: 'DocumentsData', level: 900);
        }

        // Document Files Information
        final documentTypes = [
          {'key': 'sevenTwelveFiles', 'name': '7/12 Documents'},
          {'key': 'noteFiles', 'name': 'Note Documents'},
          {'key': 'partitionFiles', 'name': 'Partition Documents'},
          {'key': 'schemeSheetFiles', 'name': 'Scheme Sheet Documents'},
          {'key': 'oldCensusMapFiles', 'name': 'Old Census Map Documents'},
          {
            'key': 'demarcationCertificateFiles',
            'name': 'Demarcation Certificate Documents'
          },
        ];

        for (final docType in documentTypes) {
          final files = documentsData[docType['key']] as List<String>?;
          developer.log('=== ${docType['name']?.toUpperCase()} ===',
              name: 'DocumentsData');

          if (files != null && files.isNotEmpty) {
            for (int i = 0; i < files.length; i++) {
              final fileName = files[i].split('/').last;
              developer.log('${docType['name']} Path ${i + 1}: "${files[i]}"',
                  name: 'DocumentsData');
            }
          } else {
            developer.log('No ${docType['name']?.toLowerCase()} uploaded',
                name: 'DocumentsData', level: 900);
          }
        }
      }
    } catch (e) {
      developer.log('Error in Documents debug: $e',
          name: 'DocumentsData', level: 1000); // Error level
    }

    developer.log('=== END DOCUMENTS DEBUG ===', name: 'DebugInfo');

    developer.log('=== END DEBUG ===', name: 'DebugInfo');
  }

  // API Submit Method
  Future<void> submitSurvey() async {
    try {
      isLoading.value = true;
      // Final validation - check all required steps
      List<int> requiredSteps = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
      for (int step in requiredSteps) {
        if (!isMainStepCompleted(step)) {
          Get.snackbar(
            'Incomplete Form',
            'Please complete all required fields in step ${step + 1}',
            backgroundColor: Color(0xFFDC3545),
            colorText: Colors.white,
          );
          return;
        }
      }
      // Save final data from all controllers
      _saveAllStepsData();
      // Mock API call
      await Future.delayed(Duration(seconds: 2));
      final response = {
        'applicationId': 'SETU${DateTime.now().millisecondsSinceEpoch}',
        'status': 'submitted',
        'timestamp': DateTime.now().toIso8601String(),
        'surveyData': surveyData.value,
      };
      surveyData.value = response;
      Get.snackbar(
        'Success',
        'Your survey has been submitted successfully',
        backgroundColor: Color(0xFF52B788),
        colorText: Colors.white,
      );
      // Navigate to confirmation page
      Get.toNamed('/confirmation');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again',
        backgroundColor: Color(0xFFDC3545),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
