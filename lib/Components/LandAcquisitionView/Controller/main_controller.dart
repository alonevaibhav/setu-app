import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../LandAcquisitionView/Controller/personal_info_controller.dart';
import '../../LandAcquisitionView/Controller/step_three_controller.dart';
import '../../LandAcquisitionView/Controller/survey_cts_controller.dart';
import 'land_fifth_controller.dart';
import 'land_fouth_controller.dart';
import 'land_seventh_controller.dart';
import 'land_sixth_controller.dart';

// Import all step controllers

class MainLandAcquisitionController extends GetxController {
  // Navigation State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Step Controllers - Initialize them here
  late final PersonalInfoController personalInfoController;
  late final LandSecondController surveyCTSController;
  late final CalculationController calculationController; // Add this line
  late final LandFouthController landFouthController; // Add this line
  late final LandFifthController landFifthController; // Add this line
  late final LandSixthController laandSixthController; // Add this line
  late final LandSeventhController landSeventhController; // Add this line

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: [
      'land_acquisition_details',
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
    3: [
      'land_fouth_step',
    ], // Calculation Information
    4: [
      'holder_information',
    ], // Applicant Information
    5: ['next_of_kin'], // Co-owner Information
    6: ['documents' ], // Information about Adjacent Holders
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
    personalInfoController =
        Get.put(PersonalInfoController(), tag: 'personal_info');
    surveyCTSController = Get.put(LandSecondController(), tag: 'survey_cts');
    calculationController =
        Get.put(CalculationController(), tag: 'calculation'); // Add this line
    landFouthController =
        Get.put(LandFouthController(), tag: 'land_fouth'); // Add this line
    landFifthController =
        Get.put(LandFifthController(), tag: 'land_fifth'); // Add this line
    laandSixthController =
        Get.put(LandSixthController(), tag: 'land_sixth'); // Add this line
    landSeventhController =
        Get.put(LandSeventhController(), tag: 'survey_seventh'); // Add this line
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
        return landFouthController;
      case 4: // Add this case for calculation step
        return landFifthController;
      case 5: // Add this case for calculation step
        return laandSixthController;
      case 6: // Add this case for calculation step
        return landSeventhController;
      // Add more cases as you create more controllers
      default:
        return this; // Fallback to main controller
    }
  }

  // Check if current sub-step is valid - FIXED VERSION
  bool get isCurrentSubStepValid {
    final stepController = currentStepController;
    final fieldToValidate = currentSubStepField;

    print('Validating Step: ${currentStep.value}, SubStep: ${currentSubStep.value}, Field: $fieldToValidate');

    if (stepController is StepValidationMixin) {
      final isValid = stepController.validateCurrentSubStep(fieldToValidate);
      print('Validation result: $isValid');

      // For debugging - show validation error
      if (!isValid) {
        final error = stepController.getFieldError(fieldToValidate);
        print('Validation error: $error');
      }

      return isValid;
    }

    print(
        'Controller does not implement StepValidationMixin, defaulting to true');
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
        stepController = landFouthController;
        break;
      case 4: // Add this case
        stepController = landFifthController;
        break;
      case 5: // Add this case
        stepController = laandSixthController;
        break;
      case 6: // Add this case
        stepController = landSeventhController;
        break;
      // Add more cases
    }
    if (stepController is StepValidationMixin) {
      return stepController.isStepCompleted(fields);
    }
    return false;
  }

  // Navigation Methods - FIXED VERSION
  void nextSubStep() {
    print('=== Next SubStep Called ===');
    print('Current Step: ${currentStep.value}, Current SubStep: ${currentSubStep.value}');
    print('Current Field: $currentSubStepField');

    // Force refresh the controller state before validation
    final stepController = currentStepController;
    if (stepController is CalculationController) {
      // Force refresh to ensure latest state
      stepController.surveyEntries.refresh();
    }

    debugPrintPersonalInfo();

    // Check validation
    final isValid = isCurrentSubStepValid;
    print('Is current substep valid: $isValid');

    if (!isValid) {
      _showValidationError();
      return;
    }

    // Save current substep data
    _saveCurrentSubStepData();

    // // Print the current survey data to the console
    // print('Current Survey Data: ${surveyData.value}');

    // Get the current step's total substeps
    final currentStepSubSteps = stepConfigurations[currentStep.value];
    final totalSubSteps = currentStepSubSteps?.length ?? 1;

    if (currentSubStep.value < totalSubSteps - 1) {
      // Move to next substep within current main step
      currentSubStep.value++;
      print('Moved to next substep: ${currentSubStep.value}');
    } else {
      // Move to next main step
      if (currentStep.value < 9) {
        currentStep.value++;
        currentSubStep.value = 0;
        print('Moved to next step: ${currentStep.value}');
        _updateStepValidation();
      } else {
        // We're at the last step and last substep, submit the survey
        print('Submitting survey...');
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

    print('Showing validation error: $error');

    Get.snackbar(
      'Validation Error',
      error,
      backgroundColor: Color(0xFFDC3545),
      colorText: Colors.white,
      duration: Duration(
          milliseconds: 2000), // Increased duration for better visibility
      snackPosition: SnackPosition.BOTTOM,
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
  Map<String, dynamic> getLandAcquisitionData() {
    try {
      if (personalInfoController is StepDataMixin) {
        return personalInfoController.getStepData();
      }
      return {
        'land_acquisition': {
          'land_acquisition_officer': personalInfoController.landAcquisitionOfficerController.text.trim(),
          'land_acquisition_board': personalInfoController.landAcquisitionBoardController.text.trim(),
          'land_acquisition_details': personalInfoController.landAcquisitionDetailsController.text.trim(),
          'land_acquisition_order_number': personalInfoController.landAcquisitionOrderNumberController.text.trim(),
          'land_acquisition_order_date': personalInfoController.landAcquisitionOrderDateController.text.trim(),
          'land_acquisition_office_address': personalInfoController.landAcquisitionOfficeAddressController.text.trim(),
          'land_acquisition_order_files': personalInfoController.landAcquisitionOrderFiles.toList(),
          'land_acquisition_map_files': personalInfoController.landAcquisitionMapFiles.toList(),
          'kml_files': personalInfoController.kmlFiles.toList(),
        }
      };
    } catch (e) {
      print('Error getting PersonalInfo data: $e');
      return {
        'personal_info': {},
        'land_acquisition': {}
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

      List<Map<String, dynamic>> entriesData = [];
      for (int i = 0; i < calculationController.surveyEntries.length; i++) {
        final entry = calculationController.surveyEntries[i];
        entriesData.add({
          'index': i,
          'surveyNo': entry['surveyNo'] ?? '',
          'share': entry['share'] ?? '',
          'area': entry['area'] ?? '',
          'landAcquisitionArea': entry['landAcquisitionArea'] ?? '',
          'abdominalSection': entry['abdominalSection'] ?? '',
          'isComplete': calculationController.isEntryComplete(entry),
        });
      }

      return {
        'calculation': {
          'selectedVillage': calculationController.selectedVillage.value,
          'surveyEntries': entriesData,
          'totalArea': calculationController.totalArea,
          'totalLandAcquisitionArea': calculationController.totalLandAcquisitionArea,
          'completedEntriesCount': calculationController.completedEntriesCount,
          'totalEntriesCount': calculationController.surveyEntries.length,
        }
      };
    } catch (e) {
      print('Error getting Calculation data: $e');
      return {'calculation': {}};
    }
  }

  /// Collect data from LandFouthController
  Map<String, dynamic> getLandFouthData() {
    try {
      if (landFouthController is StepDataMixin) {
        return landFouthController.getStepData();
      }
      return {
        'land_fourth': {
          'calculation_type': landFouthController.selectedCalculationType.value,
          'duration': landFouthController.selectedDuration.value,
          'holder_type': landFouthController.selectedHolderType.value,
          'counting_fee': landFouthController.countingFee.value,
        }
      };
    } catch (e) {
      print('Error getting LandFouth data: $e');
      return {'land_fourth': {}};
    }
  }

  /// Collect data from LandFifthController
  Map<String, dynamic> getLandFifthData() {
    try {
      if (landFifthController is StepDataMixin) {
        return landFifthController.getStepData();
      }

      final List<Map<String, dynamic>> holderData = [];
      for (int i = 0; i < landFifthController.holderEntries.length; i++) {
        final entry = landFifthController.holderEntries[i];
        holderData.add({
          'holderName': entry['holderName'] ?? '',
          'address': entry['address'] ?? '',
          'accountNumber': entry['accountNumber'] ?? '',
          'mobileNumber': entry['mobileNumber'] ?? '',
          'serverNumber': entry['serverNumber'] ?? '',
          'area': entry['area'] ?? '',
          'potKharabaArea': entry['potKharabaArea'] ?? '',
          'totalArea': entry['totalArea'] ?? '',
          'village': entry['village'] ?? '',
          'plotNo': entry['plotNo'] ?? '',
          'email': entry['email'] ?? '',
          'pincode': entry['pincode'] ?? '',
          'district': entry['district'] ?? '',
          'postOffice': entry['postOffice'] ?? '',
        });
      }

      return {
        'land_fifth': {
          'holderInformation': holderData,
          'totalHolderEntries': landFifthController.holderEntries.length,
        }
      };
    } catch (e) {
      print('Error getting LandFifth data: $e');
      return {'land_fifth': {}};
    }
  }

  /// Collect data from LandSixthController
  Map<String, dynamic> getLandSixthData() {
    try {
      if (laandSixthController is StepDataMixin) {
        return laandSixthController.getStepData();
      }

      final List<Map<String, dynamic>> entriesData = [];
      for (final entry in laandSixthController.nextOfKinEntries) {
        entriesData.add({
          'address': entry['address'] as String? ?? '',
          'mobile': entry['mobile'] as String? ?? '',
          'surveyNo': entry['surveyNo'] as String? ?? '',
          'direction': entry['direction'] as String? ?? '',
          'naturalResources': entry['naturalResources'] as String? ?? '',
        });
      }

      return {
        'land_sixth': {
          'nextOfKinEntries': entriesData,
          'totalNextOfKinEntries': entriesData.length,
        }
      };
    } catch (e) {
      print('Error getting LandSixth data: $e');
      return {'land_sixth': {}};
    }
  }

  /// Collect data from SurveyEightController (Documents)
  Map<String, dynamic> getDocumentsData() {
    try {
      if (landSeventhController is StepDataMixin) {
        // Return data directly from getStepData() without extra nesting
        return landSeventhController.getStepData();
      }

      // Fallback: manually collect data from SurveyEightController
      return {
        'identityCardType': landSeventhController.selectedIdentityType.value,
        'identityCardFiles': landSeventhController.identityCardFiles.toList(),
        'sevenTwelveFiles': landSeventhController.sevenTwelveFiles.toList(),
        'noteFiles': landSeventhController.noteFiles.toList(),
        'partitionFiles': landSeventhController.partitionFiles.toList(),
        'schemeSheetFiles': landSeventhController.schemeSheetFiles.toList(),
        'oldCensusMapFiles': landSeventhController.oldCensusMapFiles.toList(),
        'demarcationCertificateFiles': landSeventhController.demarcationCertificateFiles.toList(),
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
// DEBUG PRINT METHODS
///////////////////////////////////

  void debugPrintPersonalInfo() {

    developer.log('=== LAND ACQUISITION DATA DEBUG ===', name: 'DebugInfo');

    // Land acquisition details
    developer.log('Land acquisition officer: "${personalInfoController.landAcquisitionOfficerController.text.trim()}"', name: 'LandAcquisition');
    developer.log('Land acquisition board: "${personalInfoController.landAcquisitionBoardController.text.trim()}"', name: 'LandAcquisition');
    developer.log('Land acquisition details: "${personalInfoController.landAcquisitionDetailsController.text.trim()}"', name: 'LandAcquisition');
    developer.log('Land acquisition order number: "${personalInfoController.landAcquisitionOrderNumberController.text.trim()}"', name: 'LandAcquisition');
    developer.log('Land acquisition order date: "${personalInfoController.landAcquisitionOrderDateController.text.trim()}"', name: 'LandAcquisition');
    developer.log('Land acquisition office address: "${personalInfoController.landAcquisitionOfficeAddressController.text.trim()}"', name: 'LandAcquisition');
    developer.log('Land acquisition order file : "${personalInfoController.landAcquisitionOrderFiles}"', name: 'LandAcquisition');
    developer.log('Land acquisition map file : "${personalInfoController.landAcquisitionMapFiles}"', name: 'LandAcquisition');
    developer.log('KML file : "${personalInfoController.kmlFiles}"', name: 'LandAcquisition');

    developer.log('=== END LAND ACQUISITION DATA DEBUG ===', name: 'DebugInfo');


    developer.log('=== SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Survey number: "${surveyCTSController.surveyNumberController.text.trim()}"', name: 'SurveyCTS');
    developer.log('Department: "${surveyCTSController.selectedDepartment.value}"', name: 'SurveyCTS');
    developer.log('District: "${surveyCTSController.selectedDistrict.value}"', name: 'SurveyCTS');
    developer.log('Taluka: "${surveyCTSController.selectedTaluka.value}"', name: 'SurveyCTS');
    developer.log('Village: "${surveyCTSController.selectedVillage.value}"', name: 'SurveyCTS');
    developer.log('Office: "${surveyCTSController.selectedOffice.value}"', name: 'SurveyCTS');

    developer.log('=== END SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Selected village: "${calculationController.selectedVillage.value}"', name: 'Calculation');
    developer.log('Total entries: ${calculationController.surveyEntries.length}', name: 'Calculation');
    developer.log('Completed entries: ${calculationController.completedEntriesCount}', name: 'Calculation');
    developer.log('Total area: ${calculationController.totalArea}', name: 'Calculation');
    developer.log('Total land acquisition area: ${calculationController.totalLandAcquisitionArea}', name: 'Calculation');

    // Log each survey entry
    for (int i = 0; i < calculationController.surveyEntries.length; i++) {
      final entry = calculationController.surveyEntries[i];
      developer.log('Entry $i - Survey No: "${entry['surveyNo'] ?? ''}"', name: 'Calculation');
      developer.log('Entry $i - Share: "${entry['share'] ?? ''}"', name: 'Calculation');
      developer.log('Entry $i - Area: "${entry['area'] ?? ''}"', name: 'Calculation');
      developer.log('Entry $i - Land Acquisition Area: "${entry['landAcquisitionArea'] ?? ''}"', name: 'Calculation');
      developer.log('Entry $i - Abdominal Section: "${entry['abdominalSection'] ?? ''}"', name: 'Calculation');
      developer.log('Entry $i - Is Complete: ${calculationController.isEntryComplete(entry)}', name: 'Calculation');
    }

    developer.log('=== END CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== LAND FOURTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Calculation type: "${landFouthController.selectedCalculationType.value}"', name: 'LandFourth');
    developer.log('Duration: "${landFouthController.selectedDuration.value}"', name: 'LandFourth');
    developer.log('Holder type: "${landFouthController.selectedHolderType.value}"', name: 'LandFourth');
    developer.log('Counting fee: ${landFouthController.countingFee.value}', name: 'LandFourth');

    developer.log('=== END LAND FOURTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== LAND FIFTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Total holder entries: ${landFifthController.holderEntries.length}', name: 'LandFifth');

    for (int i = 0; i < landFifthController.holderEntries.length; i++) {
      final entry = landFifthController.holderEntries[i];
      developer.log('Entry $i - Holder name: "${entry['holderName'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Address: "${entry['address'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Account number: "${entry['accountNumber'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Mobile number: "${entry['mobileNumber'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Server number: "${entry['serverNumber'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Area: "${entry['area'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Pot Kharaba area: "${entry['potKharabaArea'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Total area: "${entry['totalArea'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Village: "${entry['village'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Plot no: "${entry['plotNo'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Email: "${entry['email'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Pincode: "${entry['pincode'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - District: "${entry['district'] ?? ''}"', name: 'LandFifth');
      developer.log('Entry $i - Post office: "${entry['postOffice'] ?? ''}"', name: 'LandFifth');
    }

    developer.log('=== END LAND FIFTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== LAND SIXTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Total next of kin entries: ${laandSixthController.nextOfKinEntries.length}', name: 'LandSixth');

    for (int i = 0; i < laandSixthController.nextOfKinEntries.length; i++) {
      final entry = laandSixthController.nextOfKinEntries[i];
      developer.log('Entry $i - Address: "${entry['address'] as String? ?? ''}"', name: 'LandSixth');
      developer.log('Entry $i - Mobile: "${entry['mobile'] as String? ?? ''}"', name: 'LandSixth');
      developer.log('Entry $i - Survey No: "${entry['surveyNo'] as String? ?? ''}"', name: 'LandSixth');
      developer.log('Entry $i - Direction: "${entry['direction'] as String? ?? ''}"', name: 'LandSixth');
      developer.log('Entry $i - Natural Resources: "${entry['naturalResources'] as String? ?? ''}"', name: 'LandSixth');
    }

    developer.log('=== END LAND SIXTH DATA DEBUG ===', name: 'DebugInfo');

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
          {'key': 'demarcationCertificateFiles', 'name': 'Demarcation Certificate Documents'},
        ];

        for (final docType in documentTypes) {
          final files = documentsData[docType['key']] as List<String>?;
          developer.log('=== ${docType['name']?.toUpperCase()} ===', name: 'DocumentsData');

          if (files != null && files.isNotEmpty) {
            for (int i = 0; i < files.length; i++) {
              final fileName = files[i].split('/').last;
              developer.log('${docType['name']} Path ${i + 1}: "${files[i]}"', name: 'DocumentsData');
            }
          } else {
            developer.log('No ${docType['name']?.toLowerCase()} uploaded', name: 'DocumentsData', level: 900);
          }
        }
      }
    } catch (e) {
      developer.log('Error in Documents debug: $e', name: 'DocumentsData', level: 1000); // Error level
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
      landFouthController,
      landFifthController,
      laandSixthController,
      landSeventhController,
      // Add more controllers
    ];
    for (final controller in allControllers) {
      if (controller is StepDataMixin) {
        final stepData = controller.getStepData();
        _mergeStepData(stepData);
      }
    }
  }

  // Helper method to manually trigger validation check (for debugging)
  void checkValidation() {
    print('=== Manual Validation Check ===');
    print('Current Step: ${currentStep.value}');
    print('Current SubStep: ${currentSubStep.value}');
    print('Current Field: $currentSubStepField');
    print('Is Valid: $isCurrentSubStepValid');

    if (currentStepController is CalculationController) {
      final calc = currentStepController as CalculationController;
      print('Village selected: "${calc.selectedVillage.value}"');
      print('Survey entries count: ${calc.surveyEntries.length}');
      print('Completed entries: ${calc.completedEntriesCount}');
      print('Validation step result: ${calc.validateCalculationStep()}');
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
