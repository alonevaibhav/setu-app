import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../API Service/api_service.dart';
import '../../../Constants/api_constant.dart';
import '../../GovernmentCensusView/Controller/personal_info_controller.dart';
import '../../GovernmentCensusView/Controller/step_three_controller.dart';
import '../../GovernmentCensusView/Controller/survey_cts.dart';
import 'census_eighth_controller.dart';
import 'census_fifth_controller.dart';
import 'census_fourth_controller.dart';
import 'census_seventh_controller.dart';
import 'census_sixth_controller.dart';
// Import all step controllers

class GovernmentCensusController extends GetxController {
  // Navigation State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Step Controllers - Initialize them here
  late final PersonalInfoController personalInfoController;
  late final SurveyCTSController surveyCTSController;
  late final CalculationController calculationController; // Add this line
  late final CensusFourthController censusFourthController; // Add this line
  late final CensusFifthController censusFifthController; // Add this line
  late final CensusSixthController censusSixthController; // Add this line
  late final CensusSeventhController censusSeventhController; // Add this line
  late final CensusEighthController censusEighthController; // Add this line

  // Add more controllers as needed

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: [
      'government_counting_details',
    ], // Personal Info step
    1: [
      'survey_number',
      'department',
      'district',
      'taluka',
      'village',
      'office'
    ],
    2: ['government_survey'], // Survey Information
    3: ['calculation', 'status'], // Calculation Information
    4: [
      'applicant',
    ], // Applicant Information
    5: ['coowner', ], // Co-owner Information
    6: ['next_of_kin', ], // Information about Adjacent Holders
    7: ['documents',], // Document Upload
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
    censusFourthController = Get.put(CensusFourthController(), tag: 'census_fourth'); // Add this line
    censusFifthController = Get.put(CensusFifthController(), tag: 'census_fifth'); // Add this line
    censusSixthController = Get.put(CensusSixthController(), tag: 'census_sixth'); // Add this line
    censusSeventhController = Get.put(CensusSeventhController(), tag: 'census_seventh'); // Add this line
    censusEighthController = Get.put(CensusEighthController(), tag: 'census_eighth'); // Add this line
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
        return censusFourthController;
      case 4: // Add this case for calculation step
        return censusFifthController;
      case 5: // Add this case for calculation step
        return censusSixthController;
      case 6: // Add this case for calculation step
        return censusEighthController;
      case 7: // Add this case for calculation step
        return censusFourthController;
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
        stepController = censusFourthController;
        break;
      case 4: // Add this case
        stepController = censusFifthController;
        break;
      case 5: // Add this case
        stepController = censusSixthController;
        break;
      case 6: // Add this case
        stepController = censusSeventhController;
        break;
      case 7: // Add this case
        stepController = censusEighthController;
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
    submitSurvey();

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
// DATA COLLECTION METHODS
///////////////////////////////////

  /// Collect data from PersonalInfoController
  Map<String, dynamic> getGovernmentCountingData() {
    try {
      if (personalInfoController is StepDataMixin) {
        return personalInfoController.getStepData();
      }
      return {
        'government_counting': {
          'government_counting_officer': personalInfoController.governmentCountingOfficerController.text.trim(),
          'government_counting_officer_address': personalInfoController.governmentCountingOfficerAddressController.text.trim(),
          'government_counting_order_number': personalInfoController.governmentCountingOrderNumberController.text.trim(),
          'government_counting_order_date': personalInfoController.governmentCountingOrderDateController.text.trim(),
          'selected_government_counting_order_date': personalInfoController.governmentCountingOrderDate.value?.toIso8601String(),
          'counting_applicant_name': personalInfoController.countingApplicantNameController.text.trim(),
          'counting_applicant_address': personalInfoController.countingApplicantAddressController.text.trim(),
          'government_counting_details': personalInfoController.governmentCountingDetailsController.text.trim(),
          'government_counting_order_files': personalInfoController.governmentCountingOrderFiles.toList(),
        }
      };
    } catch (e) {
      print('Error getting PersonalInfo government counting data: $e');
      return {
        'government_counting': {}
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
  Map<String, dynamic> getGovernmentSurveyData() {
    try {
      if (calculationController is StepDataMixin) {
        return calculationController.getStepData();
      }
      return {
        'government_survey': {
          'entries': calculationController.entriesSummary,
          'total_area': calculationController.totalArea,
          'entry_count': calculationController.surveyEntries.length,
          'is_form_valid': calculationController.isFormValid.value,
          // 'validation_errors': calculationController.validationErrors.toMap(),
          'timestamp': DateTime.now().toIso8601String(),
        }
      };
    } catch (e) {
      print('Error getting CalculationController government survey data: $e');
      return {
        'government_survey': {}
      };
    }
  }

  /// Collect data from CensusFourthController
  Map<String, dynamic> getCensusFourthData() {
    try {
      if (censusFourthController is StepDataMixin) {
        return censusFourthController.getStepData();
      }
      return {
        'census_fourth': {
          'calculationType': censusFourthController.selectedCalculationType.value,
          'duration': censusFourthController.selectedDuration.value,
          'holderType': censusFourthController.selectedHolderType.value,
          'calculationFeeRate': censusFourthController.selectedCalculationFeeRate.value,
          'countingFee': censusFourthController.countingFee.value,
        }
      };
    } catch (e) {
      print('Error getting CensusFourthController data: $e');
      return {
        'census_fourth': {}
      };
    }
  }

  /// Collect data from CensusFifthController
  Map<String, dynamic> getCensusFifthData() {
    try {
      if (censusFifthController is StepDataMixin) {
        return censusFifthController.getStepData();
      }

      final data = <String, dynamic>{};
      for (int i = 0; i < censusFifthController.applicantEntries.length; i++) {
        final entry = censusFifthController.applicantEntries[i];
        final addressData = entry['address'] as RxMap<String, dynamic>?;

        data['applicant_$i'] = {
          'agreement': (entry['agreementController'] as TextEditingController?)?.text ?? '',
          'accountHolderName': (entry['accountHolderNameController'] as TextEditingController?)?.text ?? '',
          'accountNumber': (entry['accountNumberController'] as TextEditingController?)?.text ?? '',
          'mobileNumber': (entry['mobileNumberController'] as TextEditingController?)?.text ?? '',
          'serverNumber': (entry['serverNumberController'] as TextEditingController?)?.text ?? '',
          'area': (entry['areaController'] as TextEditingController?)?.text ?? '',
          'potkaharabaArea': (entry['potkaharabaAreaController'] as TextEditingController?)?.text ?? '',
          'totalArea': (entry['totalAreaController'] as TextEditingController?)?.text ?? '',
          'address': addressData != null ? Map<String, dynamic>.from(addressData) : <String, dynamic>{},
        };
      }
      data['applicantCount'] = censusFifthController.applicantEntries.length;

      return {
        'census_fifth': data
      };
    } catch (e) {
      print('Error getting CensusFifthController data: $e');
      return {
        'census_fifth': {}
      };
    }
  }

  /// Collect data from CensusSixthController
  Map<String, dynamic> getCensusSixthData() {
    try {
      if (censusSixthController is StepDataMixin) {
        return censusSixthController.getStepData();
      }

      final List<Map<String, dynamic>> coownerData = [];
      for (int i = 0; i < censusSixthController.coownerEntries.length; i++) {
        final entry = censusSixthController.coownerEntries[i];
        final addressEntry = entry['address'];

        coownerData.add({
          'name': entry['name'] ?? '',
          'mobileNumber': entry['mobileNumber'] ?? '',
          'serverNumber': entry['serverNumber'] ?? '',
          'consent': entry['consent'] ?? '',
          'address': addressEntry != null
              ? Map<String, String>.from(addressEntry as Map)
              : <String, String>{},
        });
      }

      return {
        'census_sixth': {
          'coowners': coownerData,
          'coownerCount': censusSixthController.coownerEntries.length,
        }
      };
    } catch (e) {
      print('Error getting CensusSixthController data: $e');
      return {
        'census_sixth': {}
      };
    }
  }

  /// Collect data from CensusSeventhController
  Map<String, dynamic> getCensusSeventhData() {
    try {
      if (censusSeventhController is StepDataMixin) {
        return censusSeventhController.getStepData();
      }

      final List<Map<String, dynamic>> entriesData = [];
      for (final entry in censusSeventhController.nextOfKinEntries) {
        entriesData.add({
          'name': entry['name'] as String? ?? '',
          'address': entry['address'] as String? ?? '',
          'mobile': entry['mobile'] as String? ?? '',
          'surveyNo': entry['surveyNo'] as String? ?? '',
          'direction': entry['direction'] as String? ?? '',
          'naturalResources': entry['naturalResources'] as String? ?? '',
        });
      }

      return {
        'census_seventh': {
          'nextOfKinEntries': entriesData,
          'totalNextOfKinEntries': entriesData.length,
        }
      };
    } catch (e) {
      print('Error getting CensusSeventhController data: $e');
      return {
        'census_seventh': {}
      };
    }
  }

  /// Collect data from censusEighthController
  Map<String, dynamic> getCourtEightData() {
    try {
      if (censusEighthController is StepDataMixin) {
        return censusEighthController.getStepData();
      }
      return {
        'court_seventh': {
          'selected_identity_type': censusEighthController.selectedIdentityType.value,
          'identity_card_files': censusEighthController.identityCardFiles.toList(),
          'seven_twelve_files': censusEighthController.sevenTwelveFiles.toList(),
          'note_files': censusEighthController.noteFiles.toList(),
          'partition_files': censusEighthController.partitionFiles.toList(),
          'scheme_sheet_files': censusEighthController.schemeSheetFiles.toList(),
          'old_census_map_files': censusEighthController.oldCensusMapFiles.toList(),
          'demarcation_certificate_files': censusEighthController.demarcationCertificateFiles.toList(),
          'identity_card_options': censusEighthController.identityCardOptions,
          'all_documents_uploaded': censusEighthController.areAllDocumentsUploaded,
          'upload_progress_text': censusEighthController.uploadProgressText,
          // 'validation_errors': censusEighthController.validationErrors.toMap(),
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

  void debugPrintInfo() {
    developer.log('=== GOVERNMENT COUNTING DATA DEBUG ===', name: 'DebugInfo');

    // Government counting details
    developer.log('Government counting officer: "${personalInfoController.governmentCountingOfficerController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Government counting officer address: "${personalInfoController.governmentCountingOfficerAddressController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Government counting order number: "${personalInfoController.governmentCountingOrderNumberController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Government counting order date (text): "${personalInfoController.governmentCountingOrderDateController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Selected government counting order date: "${personalInfoController.governmentCountingOrderDate.value}"', name: 'GovernmentCounting');
    developer.log('Counting applicant name: "${personalInfoController.countingApplicantNameController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Counting applicant address: "${personalInfoController.countingApplicantAddressController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Government counting details: "${personalInfoController.governmentCountingDetailsController.text.trim()}"', name: 'GovernmentCounting');
    developer.log('Government counting order files: "${personalInfoController.governmentCountingOrderFiles}"', name: 'GovernmentCounting');
    developer.log('=== END GOVERNMENT COUNTING DEBUG ===', name: 'DebugInfo');




    developer.log('=== SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Survey number: "${surveyCTSController.surveyNumberController.text.trim()}"', name: 'SurveyCTS');
    developer.log('Department: "${surveyCTSController.selectedDepartment.value}"', name: 'SurveyCTS');
    developer.log('District: "${surveyCTSController.selectedDistrict.value}"', name: 'SurveyCTS');
    developer.log('Taluka: "${surveyCTSController.selectedTaluka.value}"', name: 'SurveyCTS');
    developer.log('Village: "${surveyCTSController.selectedVillage.value}"', name: 'SurveyCTS');
    developer.log('Office: "${surveyCTSController.selectedOffice.value}"', name: 'SurveyCTS');

    developer.log('=== END SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');


    developer.log('=== GOVERNMENT SURVEY DATA DEBUG ===', name: 'DebugInfo');

    // Individual survey entries
    for (int i = 0; i < calculationController.surveyEntries.length; i++) {
      final entry = calculationController.surveyEntries[i];
      developer.log('=== SURVEY ENTRY ${i + 1} ===', name: 'GovernmentSurvey');
      developer.log('Survey No./Group No.: "${entry['surveyNo'] ?? ''}"', name: 'GovernmentSurvey');
      developer.log('Part No.: "${entry['partNo'] ?? ''}"', name: 'GovernmentSurvey');
      developer.log('Area: "${entry['area'] ?? ''}"', name: 'GovernmentSurvey');

    }

    developer.log('=== END GOVERNMENT SURVEY DEBUG ===', name: 'DebugInfo');

    developer.log('=== CENSUS FOURTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Calculation Type: "${censusFourthController.selectedCalculationType.value ?? ''}"', name: 'CensusFourth');
    developer.log('Duration: "${censusFourthController.selectedDuration.value ?? ''}"', name: 'CensusFourth');
    developer.log('Holder Type: "${censusFourthController.selectedHolderType.value ?? ''}"', name: 'CensusFourth');
    developer.log('Calculation Fee Rate: "${censusFourthController.selectedCalculationFeeRate.value ?? ''}"', name: 'CensusFourth');
    developer.log('Counting Fee: "${censusFourthController.countingFee.value}"', name: 'CensusFourth');

    developer.log('=== END CENSUS FOURTH DEBUG ===', name: 'DebugInfo');


    developer.log('=== CENSUS FIFTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Total applicant entries: "${censusFifthController.applicantEntries.length}"', name: 'CensusFifth');

    // Individual applicant entries
    for (int i = 0; i < censusFifthController.applicantEntries.length; i++) {
      final entry = censusFifthController.applicantEntries[i];
      final addressData = entry['address'] as RxMap<String, dynamic>?;

      developer.log('=== APPLICANT ENTRY ${i + 1} ===', name: 'CensusFifth');
      developer.log('Agreement: "${(entry['agreementController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Account Holder Name: "${(entry['accountHolderNameController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Account Number: "${(entry['accountNumberController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Mobile Number: "${(entry['mobileNumberController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Server Number: "${(entry['serverNumberController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Area: "${(entry['areaController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Potkaharaba Area: "${(entry['potkaharabaAreaController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');
      developer.log('Total Area: "${(entry['totalAreaController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusFifth');

      if (addressData != null) {
        developer.log('Plot No: "${addressData['plotNo'] ?? ''}"', name: 'CensusFifth');
        developer.log('Address: "${addressData['address'] ?? ''}"', name: 'CensusFifth');
        developer.log('Address Mobile: "${addressData['mobileNumber'] ?? ''}"', name: 'CensusFifth');
        developer.log('Email: "${addressData['email'] ?? ''}"', name: 'CensusFifth');
        developer.log('Pincode: "${addressData['pincode'] ?? ''}"', name: 'CensusFifth');
        developer.log('District: "${addressData['district'] ?? ''}"', name: 'CensusFifth');
        developer.log('Village: "${addressData['village'] ?? ''}"', name: 'CensusFifth');
        developer.log('Post Office: "${addressData['postOffice'] ?? ''}"', name: 'CensusFifth');
      }
    }

    developer.log('=== END CENSUS FIFTH DEBUG ===', name: 'DebugInfo');


    developer.log('=== CENSUS SIXTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Total coowner entries: "${censusSixthController.coownerEntries.length}"', name: 'CensusSixth');

    // Individual coowner entries
    for (int i = 0; i < censusSixthController.coownerEntries.length; i++) {
      final entry = censusSixthController.coownerEntries[i];
      final addressEntry = entry['address'];
      final address = addressEntry != null ? addressEntry as Map<String, String> : <String, String>{};

      developer.log('=== COOWNER ENTRY ${i + 1} ===', name: 'CensusSixth');
      developer.log('Name: "${(entry['nameController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSixth');
      developer.log('Mobile Number: "${(entry['mobileNumberController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSixth');
      developer.log('Server Number: "${(entry['serverNumberController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSixth');
      developer.log('Consent: "${(entry['consentController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSixth');
      developer.log('Plot No: "${address['plotNo'] ?? ''}"', name: 'CensusSixth');
      developer.log('Address: "${address['address'] ?? ''}"', name: 'CensusSixth');
      developer.log('Address Mobile: "${address['mobileNumber'] ?? ''}"', name: 'CensusSixth');
      developer.log('Email: "${address['email'] ?? ''}"', name: 'CensusSixth');
      developer.log('Pincode: "${address['pincode'] ?? ''}"', name: 'CensusSixth');
      developer.log('District: "${address['district'] ?? ''}"', name: 'CensusSixth');
      developer.log('Village: "${address['village'] ?? ''}"', name: 'CensusSixth');
      developer.log('Post Office: "${address['postOffice'] ?? ''}"', name: 'CensusSixth');
    }

    developer.log('=== END CENSUS SIXTH DEBUG ===', name: 'DebugInfo');


    developer.log('=== CENSUS SEVENTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Total next of kin entries: "${censusSeventhController.nextOfKinEntries.length}"', name: 'CensusSeventh');

    // Individual next of kin entries
    for (int i = 0; i < censusSeventhController.nextOfKinEntries.length; i++) {
      final entry = censusSeventhController.nextOfKinEntries[i];

      developer.log('=== NEXT OF KIN ENTRY ${i + 1} ===', name: 'CensusSeventh');
      developer.log('Name: "${(entry['nameController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSeventh');
      developer.log('Address: "${(entry['addressController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSeventh');
      developer.log('Mobile: "${(entry['mobileController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSeventh');
      developer.log('Survey No: "${(entry['surveyNoController'] as TextEditingController?)?.text ?? ''}"', name: 'CensusSeventh');
      developer.log('Direction: "${entry['direction'] ?? ''}"', name: 'CensusSeventh');
      developer.log('Natural Resources: "${entry['naturalResources'] ?? ''}"', name: 'CensusSeventh');
    }

    developer.log('=== END CENSUS SEVENTH DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT EIGHT DATA DEBUG ===', name: 'DebugInfo');

    // Identity card info
    developer.log('Selected Identity Type: "${censusEighthController.selectedIdentityType.value}"', name: 'CourtSeventh');
    developer.log('Identity Card Files: "${censusEighthController.identityCardFiles}"', name: 'CourtSeventh');

    // Document files
    developer.log('Seven Twelve Files: "${censusEighthController.sevenTwelveFiles}"', name: 'CourtSeventh');
    developer.log('Note Files: "${censusEighthController.noteFiles}"', name: 'CourtSeventh');
    developer.log('Partition Files: "${censusEighthController.partitionFiles}"', name: 'CourtSeventh');
    developer.log('Scheme Sheet Files: "${censusEighthController.schemeSheetFiles}"', name: 'CourtSeventh');
    developer.log('Old Census Map Files: "${censusEighthController.oldCensusMapFiles}"', name: 'CourtSeventh');
    developer.log('Demarcation Certificate Files: "${censusEighthController.demarcationCertificateFiles}"', name: 'CourtSeventh');

    developer.log('=== END COURT EIGHT DATA DEBUG ===', name: 'DebugInfo');

  }
















  Map<String, dynamic> prepareMultipartData(userId) {
    // Get all data
    final governmentCountingData = getGovernmentCountingData();
    final governmentCounting = governmentCountingData['government_counting'] as Map<String, dynamic>?;
    final surveyCTSData = getSurveyCTSData();
    final surveyCTS = surveyCTSData['survey_cts'] as Map<String, dynamic>?;
    final governmentSurveyData = getGovernmentSurveyData();
    final censusFourthData = getCensusFourthData();
    final censusFifthData = getCensusFifthData();
    final censusSixthData = getCensusSixthData();
    final censusSeventhData = getCensusSeventhData();
    final courtEightData = getCourtEightData();


    // Prepare fields (non-file data)
    Map<String, String> fields = {
      // User ID
      "user_id": userId?.toString() ?? "0",

      // === GOVERNMENT COUNTING INFO ===
      "government_counting_officer": personalInfoController.governmentCountingOfficerController.text.trim(),
      "government_counting_officer_address": personalInfoController.governmentCountingOfficerAddressController.text.trim(),
      "government_counting_order_number": personalInfoController.governmentCountingOrderNumberController.text.trim(),
      "government_counting_order_date": personalInfoController.governmentCountingOrderDateController.text.trim(),
      "counting_applicant_name": personalInfoController.countingApplicantNameController.text.trim(),
      "counting_applicant_address": personalInfoController.countingApplicantAddressController.text.trim(),
      "government_counting_details": personalInfoController.governmentCountingDetailsController.text.trim(),

      // === SURVEY CTS INFO ===
      "survey_number": surveyCTSController.surveyNumberController.text.trim(),
      "department": surveyCTSController.selectedDepartment.value ?? "",
      "district": surveyCTSController.selectedDistrict.value ?? "",
      "taluka": surveyCTSController.selectedTaluka.value ?? "",
      "village": surveyCTSController.selectedVillage.value ?? "",
      "office": surveyCTSController.selectedOffice.value ?? "",

      // === CENSUS FOURTH INFO ===
      "calculation_type": censusFourthController.selectedCalculationType.value ?? "",
      "duration": censusFourthController.selectedDuration.value ?? "",
      "holder_type": censusFourthController.selectedHolderType.value ?? "",
      "calculation_fee_rate": censusFourthController.selectedCalculationFeeRate.value ?? "",
      "counting_fee": censusFourthController.countingFee.value?.toString() ?? "",
    };

    // Convert complex data to JSON strings for multipart
    final surveyEntries = _getSurveyEntries(governmentSurveyData);
    final applicantEntries = _getApplicantEntries(censusFifthData);
    final coOwners = _getCoOwners(censusSixthData);
    final nextOfKin = _getNextOfKin(censusSeventhData);

    // Debug: Print the arrays before encoding
    print('🔍 Survey Entries: $surveyEntries');
    print('🔍 Applicant Entries: $applicantEntries');
    print('🔍 Co-owners: $coOwners');
    print('🔍 Next of Kin: $nextOfKin');

    fields["survey_entries"] = jsonEncode(surveyEntries);
    fields["applicant_entries"] = jsonEncode(applicantEntries);
    fields["co_owners"] = jsonEncode(coOwners);
    fields["next_of_kin"] = jsonEncode(nextOfKin);

    // Prepare files
    List<MultipartFiles> files = [];

    // Add government counting order files
    if (personalInfoController.governmentCountingOrderFiles.isNotEmpty) {
        final filePath = personalInfoController.governmentCountingOrderFiles.toString();
        if (filePath.isNotEmpty) {
          files.add(MultipartFiles(
            field: "government_counting_order_file",
            filePath: filePath,
          ));

      }
    }

    // Add document files from census eighth controller
    if (censusEighthController.identityCardFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "identity_proof_path",
        filePath: censusEighthController.identityCardFiles!.first.toString(),
      ));
    }

    if (censusEighthController.sevenTwelveFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "seven_twelve_path",
        filePath: censusEighthController.sevenTwelveFiles!.first.toString(),
      ));
    }

    if (censusEighthController.noteFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "note_path",
        filePath: censusEighthController.noteFiles!.first.toString(),
      ));
    }

    if (censusEighthController.partitionFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "partition_path",
        filePath: censusEighthController.partitionFiles!.first.toString(),
      ));
    }

    if (censusEighthController.schemeSheetFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "scheme_sheet_path",
        filePath: censusEighthController.schemeSheetFiles!.first.toString(),
      ));
    }

    if (censusEighthController.oldCensusMapFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "old_census_map_path",
        filePath: censusEighthController.oldCensusMapFiles!.first.toString(),
      ));
    }

    if (censusEighthController.demarcationCertificateFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "demarcation_certificate_path",
        filePath: censusEighthController.demarcationCertificateFiles!.first.toString(),
      ));
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

// Helper method to get survey entries
  List<Map<String, dynamic>> _getSurveyEntries(Map<String, dynamic> governmentSurveyData) {
    List<Map<String, dynamic>> entries = [];

    print('🔍 Processing government survey entries: ${calculationController.surveyEntries.length}');

    if (calculationController.surveyEntries.isNotEmpty) {
      for (int i = 0; i < calculationController.surveyEntries.length; i++) {
        final entry = calculationController.surveyEntries[i];
        entries.add({
          "survey_no": entry['surveyNo']?.toString() ?? "",
          "part_no": entry['partNo']?.toString() ?? "",
          "area": entry['area']?.toString() ?? "",
        });
      }
    }

    print('🔍 Generated ${entries.length} survey entries');
    return entries;
  }

// Helper method to get applicant entries
  List<Map<String, dynamic>> _getApplicantEntries(Map<String, dynamic> censusFifthData) {
    List<Map<String, dynamic>> applicantsList = [];

    print('🔍 Processing applicant entries: ${censusFifthController.applicantEntries.length}');

    if (censusFifthController.applicantEntries.isNotEmpty) {
      for (int i = 0; i < censusFifthController.applicantEntries.length; i++) {
        final entry = censusFifthController.applicantEntries[i];
        final addressData = entry['address'] as RxMap<String, dynamic>?;

        applicantsList.add({
          "agreement": (entry['agreementController'] as TextEditingController?)?.text?.trim() ?? "",
          "account_holder_name": (entry['accountHolderNameController'] as TextEditingController?)?.text?.trim() ?? "",
          "account_number": (entry['accountNumberController'] as TextEditingController?)?.text?.trim() ?? "",
          "mobile_number": (entry['mobileNumberController'] as TextEditingController?)?.text?.trim() ?? "",
          "server_number": (entry['serverNumberController'] as TextEditingController?)?.text?.trim() ?? "",
          "area": (entry['areaController'] as TextEditingController?)?.text?.trim() ?? "",
          "potkaharaba_area": (entry['potkaharabaAreaController'] as TextEditingController?)?.text?.trim() ?? "",
          "total_area": (entry['totalAreaController'] as TextEditingController?)?.text?.trim() ?? "",
          "plot_no": addressData?['plotNo']?.toString() ?? "",
          "address": addressData?['address']?.toString() ?? "",
          "address_mobile_number": addressData?['mobileNumber']?.toString() ?? "",
          "email": addressData?['email']?.toString() ?? "",
          "pincode": addressData?['pincode']?.toString() ?? "",
          "address_district": addressData?['district']?.toString() ?? "",
          "address_village": addressData?['village']?.toString() ?? "",
          "post_office": addressData?['postOffice']?.toString() ?? "",
        });
      }
    }

    print('🔍 Generated ${applicantsList.length} applicant entries');
    return applicantsList;
  }

// Helper method to get co-owners
  List<Map<String, dynamic>> _getCoOwners(Map<String, dynamic> censusSixthData) {
    List<Map<String, dynamic>> coOwnersList = [];

    print('🔍 Processing co-owners: ${censusSixthController.coownerEntries.length}');

    if (censusSixthController.coownerEntries.isNotEmpty) {
      for (int i = 0; i < censusSixthController.coownerEntries.length; i++) {
        final entry = censusSixthController.coownerEntries[i];
        final addressEntry = entry['address'];
        final address = addressEntry != null ? addressEntry as Map<String, String> : <String, String>{};

        coOwnersList.add({
          "name": (entry['nameController'] as TextEditingController?)?.text?.trim() ?? "",
          "mobile_number": (entry['mobileNumberController'] as TextEditingController?)?.text?.trim() ?? "",
          "server_number": (entry['serverNumberController'] as TextEditingController?)?.text?.trim() ?? "",
          "consent": (entry['consentController'] as TextEditingController?)?.text?.trim() ?? "",
          "plot_no": address['plotNo'] ?? "",
          "address": address['address'] ?? "",
          "address_mobile_number": address['mobileNumber'] ?? "",
          "email": address['email'] ?? "",
          "pincode": address['pincode'] ?? "",
          "address_district": address['district'] ?? "",
          "address_village": address['village'] ?? "",
          "post_office": address['postOffice'] ?? "",
        });
      }
    }

    print('🔍 Generated ${coOwnersList.length} co-owners');
    return coOwnersList;
  }

// Helper method to get next of kin
  List<Map<String, dynamic>> _getNextOfKin(Map<String, dynamic> censusSeventhData) {
    List<Map<String, dynamic>> nextOfKinList = [];

    print('🔍 Processing next of kin: ${censusSeventhController.nextOfKinEntries.length}');

    if (censusSeventhController.nextOfKinEntries.isNotEmpty) {
      for (int i = 0; i < censusSeventhController.nextOfKinEntries.length; i++) {
        final entry = censusSeventhController.nextOfKinEntries[i];

        nextOfKinList.add({
          "name": (entry['nameController'] as TextEditingController?)?.text?.trim() ?? "",
          "address": (entry['addressController'] as TextEditingController?)?.text?.trim() ?? "",
          "mobile": (entry['mobileController'] as TextEditingController?)?.text?.trim() ?? "",
          "survey_no": (entry['surveyNoController'] as TextEditingController?)?.text?.trim() ?? "",
          "direction": entry['direction']?.toString() ?? "",
          "natural_resources": entry['naturalResources']?.toString() ?? "",
        });
      }
    }

    print('🔍 Generated ${nextOfKinList.length} next of kin entries');
    return nextOfKinList;
  }
  Future<void> submitSurvey() async {
    try {
      String userId = (await ApiService.getUid()) ?? "0";
      print('🆔 User ID: $userId');

      final multipartData = prepareMultipartData(userId);
      final fields = multipartData['fields'] as Map<String, String>;
      final files = multipartData['files'] as List<MultipartFiles>;

      developer.log(jsonEncode(fields), name: 'REQUEST_BODY');

      final response = await ApiService.multipartPost<Map<String, dynamic>>(
        endpoint: landAcquisitionPost, // Update this endpoint name as needed
        fields: fields,
        files: files,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {
        print('✅ Government counting survey submitted successfully: ${response.data}');
      } else {
        print('❌ Government counting survey submission failed: ${response.errorMessage ?? 'Unknown error'}');
      }
    } catch (e) {
      print('💥 Exception during government counting survey submission: $e');
    }
  }

  void _saveAllStepsData() {
    // Collect data from all step controllers
    final allControllers = [
      personalInfoController,
      surveyCTSController,
      calculationController,
      censusFourthController,
      censusFifthController,
      censusSixthController,
      censusSeventhController,
      censusEighthController,
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
