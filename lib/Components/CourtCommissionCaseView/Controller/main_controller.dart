import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../CourtCommissionCaseView/Controller/personal_info_controller.dart';
import '../../CourtCommissionCaseView/Controller/step_three_controller.dart';
import '../../CourtCommissionCaseView/Controller/survey_cts.dart';
import 'court_fifth_controller.dart';
import 'court_fourth_controller.dart';
import 'court_seventh_controller.dart';
import 'court_sixth_controller.dart';

// Import all step controllers

class CourtCommissionCaseController extends GetxController {
  // Navigation State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Step Controllers - Initialize them here
  late final PersonalInfoController personalInfoController;
  late final SurveyCTSController surveyCTSController;
  late final CalculationController calculationController; // Add this line
  late final CourtFourthController courtFourthController; // Add this line
  late final CourtFifthController courtFifthController; // Add this line
  late final CourtSixthController courtSixthController; // Add this line
  late final CourtSeventhController courtSeventhController; // Add this line

  // Add more controllers as needed

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: [
      'court_commission_details',
    ], // Personal Info step
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
    4: ['plaintiff_defendant', ], // Applicant Information
    5: ['next_of_kin', ], // Co-owner Information
    6: ['documents', ], // Information about Adjacent Holders
    7: ['documents', 'status'], // Document Upload
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
    personalInfoController = Get.put(PersonalInfoController(), tag: 'personal_info');
    surveyCTSController = Get.put(SurveyCTSController(), tag: 'survey_cts');
    calculationController = Get.put(CalculationController(), tag: 'calculation'); // Add this line
    courtFourthController = Get.put(CourtFourthController(), tag: 'step_four'); // Add this line
    courtFifthController = Get.put(CourtFifthController(), tag: 'court_fifth'); // Add this line
    courtSixthController = Get.put(CourtSixthController(), tag: 'survey_sixth'); // Add this line
    courtSeventhController = Get.put(CourtSeventhController(), tag: 'survey_seventh'); // Add this line
    // Initialize more controllers as needed
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
        return courtFourthController;
      case 4: // Add this case for calculation step
        return courtFifthController;
      case 5: // Add this case for calculation step
        return courtSixthController;
        case 6: // Add this case for calculation step
        return courtSeventhController;
      // Add more cases as you create more controllers
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
        stepController = courtFourthController;
        break;
      case 4: // Add this case
        stepController = courtFifthController;
        break;
      case 5: // Add this case
        stepController = courtSixthController;
        break;
      case 6: // Add this case
        stepController = courtSeventhController;
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
    debugPrintPersonalInfo();
    // print('Current Survey Data: ${surveyData.value}');

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
  Map<String, dynamic> getCourtCommissionData() {
    try {
      if (personalInfoController is StepDataMixin) {
        return personalInfoController.getStepData();
      }
      return {
        'court_commission': {
          'court_name': personalInfoController.courtNameController.text.trim(),
          'court_address': personalInfoController.courtAddressController.text.trim(),
          'commission_order_no': personalInfoController.commissionOrderNoController.text.trim(),
          'commission_date': personalInfoController.commissionDateController.text.trim(),
          'selected_commission_date': personalInfoController.selectedCommissionDate.value?.toIso8601String(),
          'civil_claim': personalInfoController.civilClaimController.text.trim(),
          'issuing_office': personalInfoController.issuingOfficeController.text.trim(),
          'commission_order_files': personalInfoController.commissionOrderFiles.toList(),
        }
      };
    } catch (e) {
      print('Error getting PersonalInfo data: $e');
      return {
        'personal_info': {},
        'court_commission': {}
      };
    }
  }


  /// Collect data from SurveyCTSController
  Map<String, dynamic> getSurveyCTSData() {
    try {
      if (surveyCTSController is StepDataMixin) {
        return surveyCTSController.getStepData();
      }
      return {
        'survey_cts': {
          'survey_number': surveyCTSController.surveyNumberController.text.trim(),
          'department': surveyCTSController.selectedDepartment.value,
          'district': surveyCTSController.selectedDistrict.value,
          'taluka': surveyCTSController.selectedTaluka.value,
          'village': surveyCTSController.selectedVillage.value,
          'office': surveyCTSController.selectedOffice.value,
        }
      };
    } catch (e) {
      print('Error getting SurveyCTS data: $e');
      return {'survey_cts': {}};
    }
  }

  /// Collect data from CalculationController
  Map<String, dynamic> getCalculationData() {
    try {
      if (calculationController is StepDataMixin) {
        return calculationController.getStepData();
      }
      return {
        'calculation': {
          'survey_entries': calculationController.surveyEntries.map((entry) => {
            'id': entry['id'],
            'survey_no': entry['surveyNo'],
            'share': entry['share'],
            'area': entry['area'],
            'selected_village': entry['selectedVillage'],
          }).toList(),
          'total_area': calculationController.totalArea,
          'total_share': calculationController.totalShare,
          'village_options': calculationController.villageOptions,
          'is_loading': calculationController.isLoading.value,
          'calculation_summary': calculationController.getCalculationSummary(),
          'selected_villages': calculationController.getSelectedVillages(),
          'completion_percentage': calculationController.getCompletionPercentage(),
          'all_entries_complete': calculationController.areAllEntriesComplete(),
        }
      };
    } catch (e) {
      print('Error getting Calculation data: $e');
      return {
        'calculation': {}
      };
    }
  }

  /// Collect data from CourtFourthController
  Map<String, dynamic> getCourtFourthData() {
    try {
      if (courtFourthController is StepDataMixin) {
        return courtFourthController.getStepData();
      }
      return {
        'court_fourth': {
          'calculation_type': courtFourthController.selectedCalculationType.value,
          'duration': courtFourthController.selectedDuration.value,
          'holder_type': courtFourthController.selectedHolderType.value,
          'location_category': courtFourthController.selectedLocationCategory.value,
          'calculation_fee': courtFourthController.calculationFeeController.text.trim(),
          'calculation_fee_numeric': courtFourthController.extractNumericFee(),
          'calculation_type_options': courtFourthController.calculationTypeOptions.toList(),
          'duration_options': courtFourthController.durationOptions.toList(),
          'holder_type_options': courtFourthController.holderTypeOptions.toList(),
          'location_category_options': courtFourthController.locationCategoryOptions.toList(),
          'fee_calculation_map': courtFourthController.feeCalculationMap,
        }
      };
    } catch (e) {
      print('Error getting CourtFourth data: $e');
      return {
        'court_fourth': {}
      };
    }
  }


  /// Collect data from CourtFifthController
  Map<String, dynamic> getCourtFifthData() {
    try {
      if (courtFifthController is StepDataMixin) {
        return courtFifthController.getStepData();
      }
      return {
        'court_fifth': {
          'plaintiff_defendant_entries': courtFifthController.plaintiffDefendantEntries.map((entry) => {
            'name': entry['nameController']?.text ?? '',
            'address': entry['addressController']?.text ?? '',
            'mobile': entry['mobileController']?.text ?? '',
            'survey_number': entry['surveyNumberController']?.text ?? '',
            'type': (entry['selectedType'] as RxString?)?.value ?? '',
            'detailed_address': Map<String, String>.from(entry['detailedAddress'] ?? {}),
          }).toList(),
          'type_options': courtFifthController.typeOptions.toList(),
          'total_entries': courtFifthController.plaintiffDefendantEntries.length,
        }
      };
    } catch (e) {
      print('Error getting CourtFifth data: $e');
      return {
        'court_fifth': {}
      };
    }
  }
  /// Collect data from CourtSixthController
  Map<String, dynamic> getCourtSixthData() {
    try {
      if (courtSixthController is StepDataMixin) {
        return courtSixthController.getStepData();
      }
      return {
        'court_sixth': {
          'next_of_kin_entries': courtSixthController.nextOfKinEntries.map((entry) => {
            'address': entry['address'] ?? '',
            'mobile': entry['mobile'] ?? '',
            'survey_no': entry['surveyNo'] ?? '',
            'direction': entry['direction'] ?? '',
            'natural_resources': entry['naturalResources'] ?? '',
          }).toList(),
          'direction_options': courtSixthController.directionOptions,
          'natural_resources_options': courtSixthController.naturalResourcesOptions,
          'total_entries': courtSixthController.nextOfKinEntries.length,
        }
      };
    } catch (e) {
      print('Error getting CourtSixth data: $e');
      return {
        'court_sixth': {}
      };
    }
  }


  /// Collect data from CourtSeventhController
  Map<String, dynamic> getCourtSeventhData() {
    try {
      if (courtSeventhController is StepDataMixin) {
        return courtSeventhController.getStepData();
      }
      return {
        'court_seventh': {
          'selected_identity_type': courtSeventhController.selectedIdentityType.value,
          'identity_card_files': courtSeventhController.identityCardFiles.toList(),
          'seven_twelve_files': courtSeventhController.sevenTwelveFiles.toList(),
          'note_files': courtSeventhController.noteFiles.toList(),
          'partition_files': courtSeventhController.partitionFiles.toList(),
          'scheme_sheet_files': courtSeventhController.schemeSheetFiles.toList(),
          'old_census_map_files': courtSeventhController.oldCensusMapFiles.toList(),
          'demarcation_certificate_files': courtSeventhController.demarcationCertificateFiles.toList(),
          'identity_card_options': courtSeventhController.identityCardOptions,
          'all_documents_uploaded': courtSeventhController.areAllDocumentsUploaded,
          'upload_progress_text': courtSeventhController.uploadProgressText,
          // 'validation_errors': courtSeventhController.validationErrors.toMap(),
        }
      };
    } catch (e) {
      print('Error getting CourtSeventh data: $e');
      return {
        'court_seventh': {}
      };
    }
  }



///////////////////////////////////
// DEBUG PRINT METHODS
///////////////////////////////////

  void debugPrintPersonalInfo() {
    developer.log('=== COURT COMMISSION DATA DEBUG ===', name: 'DebugInfo');

    // Court commission details
    developer.log('Court name: "${personalInfoController.courtNameController.text.trim()}"', name: 'CourtCommission');
    developer.log('Court address: "${personalInfoController.courtAddressController.text.trim()}"', name: 'CourtCommission');
    developer.log('Commission order number: "${personalInfoController.commissionOrderNoController.text.trim()}"', name: 'CourtCommission');
    developer.log('Commission date (text): "${personalInfoController.commissionDateController.text.trim()}"', name: 'CourtCommission');
    developer.log('Selected commission date: "${personalInfoController.selectedCommissionDate.value}"', name: 'CourtCommission');
    developer.log('Civil claim: "${personalInfoController.civilClaimController.text.trim()}"', name: 'CourtCommission');
    developer.log('Issuing office: "${personalInfoController.issuingOfficeController.text.trim()}"', name: 'CourtCommission');
    developer.log('Commission order files: "${personalInfoController.commissionOrderFiles}"', name: 'CourtCommission');


    developer.log('=== END COURT COMMISSION DATA DEBUG ===', name: 'DebugInfo');



    developer.log('=== SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Survey number: "${surveyCTSController.surveyNumberController.text.trim()}"', name: 'SurveyCTS');
    developer.log('Department: "${surveyCTSController.selectedDepartment.value}"', name: 'SurveyCTS');
    developer.log('District: "${surveyCTSController.selectedDistrict.value}"', name: 'SurveyCTS');
    developer.log('Taluka: "${surveyCTSController.selectedTaluka.value}"', name: 'SurveyCTS');
    developer.log('Village: "${surveyCTSController.selectedVillage.value}"', name: 'SurveyCTS');
    developer.log('Office: "${surveyCTSController.selectedOffice.value}"', name: 'SurveyCTS');

    developer.log('=== END SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    for (int i = 0; i < calculationController.surveyEntries.length; i++) {
      final entry = calculationController.surveyEntries[i];
      developer.log('--- Survey Entry ${i + 1} ---', name: 'SurveyEntry');
      // developer.log('Entry ID: "${entry['id']}"', name: 'SurveyEntry');
      developer.log('Selected Village: "${entry['selectedVillage']}"', name: 'SurveyEntry');
      developer.log('Survey No: "${entry['surveyNo']}"', name: 'SurveyEntry');
      developer.log('Share: "${entry['share']}"', name: 'SurveyEntry');
      developer.log('Area: "${entry['area']}"', name: 'SurveyEntry');
    }

    developer.log('=== END CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT FOURTH DATA DEBUG ===', name: 'DebugInfo');

    // Selection values
    developer.log('Calculation Type: "${courtFourthController.selectedCalculationType.value}"', name: 'CourtFourth');
    developer.log('Duration: "${courtFourthController.selectedDuration.value}"', name: 'CourtFourth');
    developer.log('Holder Type: "${courtFourthController.selectedHolderType.value}"', name: 'CourtFourth');
    developer.log('Location Category: "${courtFourthController.selectedLocationCategory.value}"', name: 'CourtFourth');
    developer.log('Calculation Fee: "${courtFourthController.calculationFeeController.text.trim()}"', name: 'CourtFourth');

    developer.log('=== END COURT FOURTH DATA DEBUG ===', name: 'DebugInfo');


    developer.log('=== COURT FIFTH DATA DEBUG ===', name: 'DebugInfo');

    for (int i = 0; i < courtFifthController.plaintiffDefendantEntries.length; i++) {
      final entry = courtFifthController.plaintiffDefendantEntries[i];
      final selectedType = entry['selectedType'] as RxString?;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>?;

      developer.log('--- Plaintiff/Defendant Entry ${i + 1} ---', name: 'CourtFifth');
      developer.log('Type: "${selectedType?.value ?? ''}"', name: 'CourtFifth');
      developer.log('Name: "${entry['nameController']?.text ?? ''}"', name: 'CourtFifth');
      developer.log('Address: "${entry['addressController']?.text ?? ''}"', name: 'CourtFifth');
      developer.log('Mobile: "${entry['mobileController']?.text ?? ''}"', name: 'CourtFifth');
      developer.log('Survey Number: "${entry['surveyNumberController']?.text ?? ''}"', name: 'CourtFifth');
    }

    developer.log('=== END COURT FIFTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT SIXTH DATA DEBUG ===', name: 'DebugInfo');

    for (int i = 0; i < courtSixthController.nextOfKinEntries.length; i++) {
      final entry = courtSixthController.nextOfKinEntries[i];

      developer.log('--- Next of Kin Entry ${i + 1} ---', name: 'CourtSixth');
      developer.log('Address: "${entry['address'] ?? ''}"', name: 'CourtSixth');
      developer.log('Mobile: "${entry['mobile'] ?? ''}"', name: 'CourtSixth');
      developer.log('Survey No: "${entry['surveyNo'] ?? ''}"', name: 'CourtSixth');
      developer.log('Direction: "${entry['direction'] ?? ''}"', name: 'CourtSixth');
      developer.log('Natural Resources: "${entry['naturalResources'] ?? ''}"', name: 'CourtSixth');
    }

    developer.log('=== END COURT SIXTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT SEVENTH DATA DEBUG ===', name: 'DebugInfo');

    // Identity card info
    developer.log('Selected Identity Type: "${courtSeventhController.selectedIdentityType.value}"', name: 'CourtSeventh');
    developer.log('Identity Card Files: "${courtSeventhController.identityCardFiles}"', name: 'CourtSeventh');

    // Document files
    developer.log('Seven Twelve Files: "${courtSeventhController.sevenTwelveFiles}"', name: 'CourtSeventh');
    developer.log('Note Files: "${courtSeventhController.noteFiles}"', name: 'CourtSeventh');
    developer.log('Partition Files: "${courtSeventhController.partitionFiles}"', name: 'CourtSeventh');
    developer.log('Scheme Sheet Files: "${courtSeventhController.schemeSheetFiles}"', name: 'CourtSeventh');
    developer.log('Old Census Map Files: "${courtSeventhController.oldCensusMapFiles}"', name: 'CourtSeventh');
    developer.log('Demarcation Certificate Files: "${courtSeventhController.demarcationCertificateFiles}"', name: 'CourtSeventh');

    developer.log('=== END COURT SEVENTH DATA DEBUG ===', name: 'DebugInfo');
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
      courtFourthController,
      courtFifthController,
      courtSixthController,
      courtSeventhController,
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
