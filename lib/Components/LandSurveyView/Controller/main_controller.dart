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
    7: ['documents', ], // Document Upload
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



  /// Collect data from PersonalInfoController
  Map<String, dynamic> getPersonalInfoData() {
    try {
      if (personalInfoController is StepDataMixin) {
        return personalInfoController.getStepData();
      }
      return {
        'personal_info': {
          'is_holder_themselves': personalInfoController.isHolderThemselves.value,
          'has_authority_on_behalf': personalInfoController.hasAuthorityOnBehalf.value,
          'has_been_counted_before': personalInfoController.hasBeenCountedBefore.value,
          'poa_registration_number': personalInfoController.poaRegistrationNumberController.text.trim(),
          'poa_registration_date': personalInfoController.poaRegistrationDateController.text.trim(),
          'poa_issuer_name': personalInfoController.poaIssuerNameController.text.trim(),
          'poa_holder_name': personalInfoController.poaHolderNameController.text.trim(),
          'poa_holder_address': personalInfoController.poaHolderAddressController.text.trim(),
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
          'survey_number': surveyCTSController.surveyNumberController.text.trim(),
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
        return calculationController.getStepData();
      }

      // Fallback: manually collect data from CalculationController
      return {
        'calculations': {
          'calculationType': calculationController.selectedCalculationType.value,
          'isCalculationComplete': calculationController.isCalculationComplete.value,
          'notes': calculationController.notesController.text.trim(),
          'date': calculationController.datecontroller.text.trim(),

          // Common fields for Non-agricultural and Knots counting
          'orderNumber': calculationController.orderNumberController.text.trim(),
          'orderDate': calculationController.orderDateController.text.trim(),
          'schemeOrderNumber': calculationController.schemeOrderNumberController.text.trim(),
          'appointmentDate': calculationController.appointmentDateController.text.trim(),

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
          'mergerOrderNumber': calculationController.mergerOrderNumberController.text.trim(),
          'mergerOrderDate': calculationController.mergerOrderDateController.text.trim(),
          'oldMergerNumber': calculationController.oldMergerNumberController.text.trim(),
          'incorporationOrderFiles': calculationController.incorporationOrderFiles.toList(),

          // Survey number and area from common controllers
          'surveyNumber': calculationController.surveyNumberController.text.trim(),
          'area': calculationController.areaController.text.trim(),
          'subdivision': calculationController.subdivisionController.text.trim(),

          // Entries data
          'hddkayamEntriesCount': calculationController.hddkayamEntries.length,
          'stomachEntriesCount': calculationController.stomachEntries.length,
          'nonAgriculturalEntriesCount': calculationController.nonAgriculturalEntries.length,
          'knotsCountingEntriesCount': calculationController.knotsCountingEntries.length,
          'integrationCalculationEntriesCount': calculationController.integrationCalculationEntries.length,
        }
      };
    } catch (e) {
      print('Error getting Calculation data: $e');
      return {'calculations': {}};
    }
  }
  /// Collect data from StepFourController
  Map<String, dynamic> getStepFourData() {
    try {
      if (stepFourController is StepDataMixin) {
        return stepFourController.getStepData();
      }
      return {'step_four': {}};
    } catch (e) {
      print('Error getting StepFour data: $e');
      return {'step_four': {}};
    }
  }

  /// Collect data from SurveyFifthController (Applicant)
  Map<String, dynamic> getApplicantData() {
    try {
      if (surveyFifthController is StepDataMixin) {
        return surveyFifthController.getStepData();
      }
      return {'applicant': {}};
    } catch (e) {
      print('Error getting Applicant data: $e');
      return {'applicant': {}};
    }
  }

  /// Collect data from SurveySixthController (Co-owner)
  Map<String, dynamic> getCoOwnerData() {
    try {
      if (surveySixthController is StepDataMixin) {
        return surveySixthController.getStepData();
      }
      return {'co_owner': {}};
    } catch (e) {
      print('Error getting CoOwner data: $e');
      return {'co_owner': {}};
    }
  }

  /// Collect data from SurveySeventhController (Next of Kin)
  Map<String, dynamic> getNextOfKinData() {
    try {
      if (surveySeventhController is StepDataMixin) {
        return surveySeventhController.getStepData();
      }
      return {'next_of_kin': {}};
    } catch (e) {
      print('Error getting NextOfKin data: $e');
      return {'next_of_kin': {}};
    }
  }

  /// Collect data from SurveyEightController (Documents)
  Map<String, dynamic> getDocumentsData() {
    try {
      if (surveyEightController is StepDataMixin) {
        return surveyEightController.getStepData();
      }
      return {'documents': {}};
    } catch (e) {
      print('Error getting Documents data: $e');
      return {'documents': {}};
    }
  }


  void debugPrintInfo() {
    print('=== PERSONAL INFO DEBUG ===');

    print('Is holder themselves: ${personalInfoController.isHolderThemselves.value}');
    print('Has authority on behalf: ${personalInfoController.hasAuthorityOnBehalf.value}');
    print('Has been counted before: ${personalInfoController.hasBeenCountedBefore.value}');
    print('POA registration number: "${personalInfoController.poaRegistrationNumberController.text.trim()}"');
    print('POA registration date: "${personalInfoController.poaRegistrationDateController.text.trim()}"');
    print('POA issuer name: "${personalInfoController.poaIssuerNameController.text.trim()}"');
    print('POA holder name: "${personalInfoController.poaHolderNameController.text.trim()}"');
    print('POA holder address: "${personalInfoController.poaHolderAddressController.text.trim()}"');

    print('=== SURVEY INFO DATA DEBUG ===');

    // Get survey data using the existing method
    final surveyData = getSurveyInfoData();
    final surveyInfo = surveyData['survey_cts'] as Map<String, dynamic>?;

    if (surveyInfo != null) {
      print('Survey Number: "${surveyInfo['survey_number']}"');
      print('Department: "${surveyInfo['department']}"');
      print('District: "${surveyInfo['district']}"');
      print('Taluka: "${surveyInfo['taluka']}"');
      print('Village: "${surveyInfo['village']}"');
      print('Office: "${surveyInfo['office']}"');
    } else {
      print('Survey info data is null');
    }

    print('=== CALCULATION DATA DEBUG ===');

    // Get calculation data using the existing method
    final calculationData = getCalculationData();
    final calculations = calculationData['calculations'] as Map<String, dynamic>?;

    if (calculations != null) {
      print('Calculation Type: "${calculations['calculationType']}"');
      print('Is Calculation Complete: ${calculations['isCalculationComplete']}');
      print('Notes: "${calculations['notes']}"');
      print('Date: "${calculations['date']}"');

      // Print common fields if they exist
      if (calculations['orderNumber']?.toString().isNotEmpty ?? false) {
        print('Order Number: "${calculations['orderNumber']}"');
      }
      if (calculations['orderDate']?.toString().isNotEmpty ?? false) {
        print('Order Date: "${calculations['orderDate']}"');
      }
      if (calculations['schemeOrderNumber']?.toString().isNotEmpty ?? false) {
        print('Scheme Order Number: "${calculations['schemeOrderNumber']}"');
      }
      if (calculations['appointmentDate']?.toString().isNotEmpty ?? false) {
        print('Appointment Date: "${calculations['appointmentDate']}"');
      }

      // Print type-specific fields based on calculation type
      String calcType = calculations['calculationType']?.toString() ?? '';

      switch (calcType) {
        case 'Hddkayam':
          print('Survey Number: "${calculations['surveyNumber']}"');
          print('Area: "${calculations['area']}"');
          print('Subdivision: "${calculations['subdivision']}"');
          print('Hddkayam Entries Count: ${calculations['hddkayamEntriesCount']}');

          // Print detailed entries
          for (int i = 0; i < calculationController.hddkayamEntries.length; i++) {
            final entry = calculationController.hddkayamEntries[i];
            print('  Entry ${i + 1}:');
            print('    CT Survey Number: "${entry['ctSurveyNumber'] ?? ''}"');
            print('    Selected CT Survey: "${entry['selectedCTSurvey'] ?? ''}"');
            print('    Area: "${entry['area'] ?? ''}"');
            print('    Area Sqm: "${entry['areaSqm'] ?? ''}"');
            print('    Is Correct: ${entry['isCorrect'] ?? false}');
          }
          break;

        case 'Stomach':
          print('Stomach Entries Count: ${calculations['stomachEntriesCount']}');

          // Print detailed entries
          for (int i = 0; i < calculationController.stomachEntries.length; i++) {
            final entry = calculationController.stomachEntries[i];
            print('  Entry ${i + 1}:');
            print('    Survey Number: "${entry['surveyNumber'] ?? ''}"');
            print('    Measurement Type: "${entry['selectedMeasurementType'] ?? ''}"');
            print('    Total Area: "${entry['totalArea'] ?? ''}"');
            print('    Calculated Area: "${entry['calculatedArea'] ?? ''}"');
            print('    Is Correct: ${entry['isCorrect'] ?? false}');
          }
          break;

        case 'Non-agricultural':
          print('Land Type: "${calculations['landType']}"');
          print('Plot Number: "${calculations['plotNumber']}"');
          print('Built Up Area: "${calculations['builtUpArea']}"');
          print('Non-Agricultural Entries Count: ${calculations['nonAgriculturalEntriesCount']}');

          // Print detailed entries
          for (int i = 0; i < calculationController.nonAgriculturalEntries.length; i++) {
            final entry = calculationController.nonAgriculturalEntries[i];
            print('  Entry ${i + 1}:');
            print('    Survey Number: "${entry['surveyNumber'] ?? ''}"');
            print('    Survey Type: "${entry['selectedSurveyType'] ?? ''}"');
            print('    Area: "${entry['area'] ?? ''}"');
            print('    Area Hectares: "${entry['areaHectares'] ?? ''}"');
            print('    Is Correct: ${entry['isCorrect'] ?? false}');
          }
          break;

        case 'Counting by number of knots':
          print('Knots Count: "${calculations['knotsCount']}"');
          print('Knot Spacing: "${calculations['knotSpacing']}"');
          print('Calculation Method: "${calculations['calculationMethod']}"');
          print('Knots Counting Entries Count: ${calculations['knotsCountingEntriesCount']}');

          // Print detailed entries
          for (int i = 0; i < calculationController.knotsCountingEntries.length; i++) {
            final entry = calculationController.knotsCountingEntries[i];
            print('  Entry ${i + 1}:');
            print('    Survey Number: "${entry['surveyNumber'] ?? ''}"');
            print('    Survey Type: "${entry['selectedSurveyType'] ?? ''}"');
            print('    Area: "${entry['area'] ?? ''}"');
            print('    Area Hectares: "${entry['areaHectares'] ?? ''}"');
            print('    Is Correct: ${entry['isCorrect'] ?? false}');
          }
          break;

        case 'Integration calculation':
          print('Integration Type: "${calculations['integrationType']}"');
          print('Base Line: "${calculations['baseLine']}"');
          print('Ordinates: "${calculations['ordinates']}"');
          print('Merger Order Number: "${calculations['mergerOrderNumber']}"');
          print('Merger Order Date: "${calculations['mergerOrderDate']}"');
          print('Old Merger Number: "${calculations['oldMergerNumber']}"');
          print('Incorporation Order Files Count: ${calculations['incorporationOrderFiles']?.length ?? 0}');
          print('Integration Calculation Entries Count: ${calculations['integrationCalculationEntriesCount']}');

          // Print detailed entries
          for (int i = 0; i < calculationController.integrationCalculationEntries.length; i++) {
            final entry = calculationController.integrationCalculationEntries[i];
            print('  Entry ${i + 1}:');
            print('    CT Survey Number: "${entry['ctSurveyNumber'] ?? ''}"');
            print('    Selected CT Survey: "${entry['selectedCTSurvey'] ?? ''}"');
            print('    Area: "${entry['area'] ?? ''}"');
            print('    Area Sqm: "${entry['areaSqm'] ?? ''}"');
            print('    Is Correct: ${entry['isCorrect'] ?? false}');
          }
          break;
      }
    } else {
      print('Calculation data is null');
    }

    print('=== END DEBUG INFO ===');
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
