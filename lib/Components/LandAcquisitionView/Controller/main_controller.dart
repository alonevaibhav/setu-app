// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../LandAcquisitionView/Controller/personal_info_controller.dart';
// import '../../LandAcquisitionView/Controller/step_three_controller.dart';
// import '../../LandAcquisitionView/Controller/survey_cts_controller.dart';
// import 'land_fifth_controller.dart';
// import 'land_fouth_controller.dart';
// import 'land_seventh_controller.dart';
// import 'land_sixth_controller.dart';
//
// // Import all step controllers
//
// class MainLandAcquisitionController extends GetxController {
//   // Navigation State
//   final currentStep = 0.obs;
//   final currentSubStep = 0.obs;
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//
//   // Step Controllers - Initialize them here
//   late final PersonalInfoController personalInfoController;
//   late final SurveyCTSController surveyCTSController;
//   late final CalculationController calculationController; // Add this line
//   late final LandFouthController landFouthController; // Add this line
//   late final LandFifthController landFifthController; // Add this line
//   late final landSixthController laandSixthController; // Add this line
//   late final LandSeventhController landSeventhController; // Add this line
//
//   // Add more controllers as needed
//
//   // Survey Data Storage
//   final surveyData = Rxn<Map<String, dynamic>>();
//
//   // Sub-step configurations for each main step (0-9)
//   final Map<int, List<String>> stepConfigurations = {
//     0: [
//       'land_acquisition_details',
//     ], // Personal Info step
//     1: [
//       'survey_number',
//       'department',
//       'district',
//       'taluka',
//       'village',
//       'office'
//     ],
//     2: ['calculation'], // Survey Information
//     3: ['fouth_step',], // Calculation Information
//     4: ['applicant', 'status'], // Applicant Information
//     5: ['coowner', 'status'], // Co-owner Information
//     6: ['adjacent', 'status'], // Information about Adjacent Holders
//     7: ['documents', 'status'], // Document Upload
//     8: ['preview', 'status'], // Preview
//     9: ['payment', 'status'], // Payment
//   };
//
//   // Validation States
//   final isStepValid = <int, bool>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeControllers();
//     initializeSurveyData();
//     initializeValidationStates();
//   }
//
//   void _initializeControllers() {
//     personalInfoController = Get.put(PersonalInfoController(), tag: 'personal_info');
//     surveyCTSController = Get.put(SurveyCTSController(), tag: 'survey_cts');
//     calculationController = Get.put(CalculationController(), tag: 'calculation'); // Add this line
//     landFouthController = Get.put(LandFouthController(), tag: 'land_fouth'); // Add this line
//     landFifthController = Get.put(LandFifthController(), tag: 'land_fifth'); // Add this line
//     laandSixthController = Get.put(landSixthController(), tag: 'next_of_kin'); // Add this line
//     landSeventhController = Get.put(LandSeventhController(), tag: 'survey_seven'); // Add this line
//   }
//
//   @override
//   void onClose() {
//     // Controllers will be disposed automatically by GetX
//     super.onClose();
//   }
//
//   void initializeSurveyData() {
//     surveyData.value = {
//       'applicationId': '',
//       'status': 'draft',
//       'timestamp': DateTime.now().toIso8601String(),
//     };
//   }
//
//   void initializeValidationStates() {
//     // Initialize all 10 steps (0-9)
//     for (int i = 0; i <= 9; i++) {
//       isStepValid[i] = false;
//     }
//   }
//
//   // Get total sub-steps for current main step
//   int get totalSubStepsInCurrentStep =>
//       stepConfigurations[currentStep.value]?.length ?? 1;
//
//   // Get current sub-step field name
//   String get currentSubStepField {
//     final fields = stepConfigurations[currentStep.value];
//     if (fields != null && currentSubStep.value < fields.length) {
//       return fields[currentSubStep.value];
//     }
//     return '';
//   }
//
//   // Get the appropriate step controller for current step
//   GetxController get currentStepController {
//     switch (currentStep.value) {
//       case 0:
//         return personalInfoController;
//       case 1:
//         return surveyCTSController;
//       case 2: // Add this case for calculation step
//         return calculationController;
//       case 3: // Add this case for calculation step
//         return landFouthController;
//       case 4: // Add this case for calculation step
//         return landFifthController;
//       case 5: // Add this case for calculation step
//         return laandSixthController;
//       case 6: // Add this case for calculation step
//         return landSeventhController;
//       // Add more cases as you create more controllers
//       default:
//         return this; // Fallback to main controller
//     }
//   }
//
//   // Check if current sub-step is valid
//   bool get isCurrentSubStepValid {
//     final stepController = currentStepController;
//     if (stepController is StepValidationMixin) {
//       return stepController.validateCurrentSubStep(currentSubStepField);
//     }
//     return true; // Default to true if controller doesn't implement validation
//   }
//
//   // Check if entire main step is completed
//   bool isMainStepCompleted(int step) {
//     final fields = stepConfigurations[step];
//     if (fields == null) return false;
//     GetxController? stepController;
//     switch (step) {
//       case 0:
//         stepController = personalInfoController;
//         break;
//       case 1:
//         stepController = surveyCTSController;
//         break;
//       case 2: // Add this case
//         stepController = calculationController;
//         break;
//       case 3: // Add this case
//         stepController = landFouthController;
//         break;
//       case 4: // Add this case
//         stepController = landFifthController;
//         break;
//       case 5: // Add this case
//         stepController = laandSixthController;
//         break;
//       case 6: // Add this case
//         stepController = landSeventhController;
//         break;
//       // Add more cases
//     }
//     if (stepController is StepValidationMixin) {
//       return stepController.isStepCompleted(fields);
//     }
//     return false;
//   }
//
//   // Navigation Methods
//   void nextSubStep() {
//     if (!isCurrentSubStepValid) {
//       _showValidationError();
//       return;
//     }
//     _saveCurrentSubStepData();
//
//     // Print the current survey data to the console
//     print('Current Survey Data: ${surveyData.value}');
//
//     // Get the current step's total substeps
//     final currentStepSubSteps = stepConfigurations[currentStep.value];
//     final totalSubSteps = currentStepSubSteps?.length ?? 1;
//     if (currentSubStep.value < totalSubSteps - 1) {
//       // Move to next substep within current main step
//       currentSubStep.value++;
//     } else {
//       // Move to next main step
//       if (currentStep.value < 9) {
//         currentStep.value++;
//         currentSubStep.value = 0;
//         _updateStepValidation();
//       } else {
//         // We're at the last step and last substep, submit the survey
//         submitSurvey();
//       }
//     }
//   }
//
//   void previousSubStep() {
//     if (currentSubStep.value > 0) {
//       currentSubStep.value--;
//     } else if (currentStep.value > 0) {
//       currentStep.value--;
//       // Get the previous step's total substeps
//       final previousStepSubSteps = stepConfigurations[currentStep.value];
//       final totalSubSteps = previousStepSubSteps?.length ?? 1;
//       currentSubStep.value = totalSubSteps - 1;
//     }
//   }
//
//   void goToStep(int step) {
//     if (step >= 0 && step <= 9) {
//       // Check if previous steps are completed
//       bool canNavigate = true;
//       for (int i = 0; i < step; i++) {
//         if (!isMainStepCompleted(i)) {
//           canNavigate = false;
//           break;
//         }
//       }
//       if (canNavigate || step <= currentStep.value) {
//         currentStep.value = step;
//         currentSubStep.value = 0;
//       } else {
//         Get.snackbar(
//           'Incomplete',
//           'Please complete previous steps first',
//           backgroundColor: Color(0xFFFFC107),
//           colorText: Colors.black,
//         );
//       }
//     }
//   }
//
//   void _showValidationError() {
//     final stepController = currentStepController;
//     String error = 'This field is required';
//     if (stepController is StepValidationMixin) {
//       error = stepController.getFieldError(currentSubStepField);
//     }
//     Get.snackbar(
//       'Validation Error',
//       error,
//       backgroundColor: Color(0xFFDC3545),
//       colorText: Colors.white,
//       duration: Duration(milliseconds: 1200),
//     );
//   }
//
//   void _saveCurrentSubStepData() {
//     final stepController = currentStepController;
//     if (stepController is StepDataMixin) {
//       final stepData = stepController.getStepData();
//       _mergeStepData(stepData);
//     }
//   }
//
//   void _mergeStepData(Map<String, dynamic> stepData) {
//     final currentData = Map<String, dynamic>.from(surveyData.value ?? {});
//     currentData.addAll(stepData);
//     surveyData.value = currentData;
//   }
//
//   void _updateStepValidation() {
//     for (int i = 0; i <= 9; i++) {
//       isStepValid[i] = isMainStepCompleted(i);
//     }
//   }
//
//   // Get step indicator color
//   Color getStepIndicatorColor(int step) {
//     if (isMainStepCompleted(step)) {
//       return Color(0xFF52B788); // Green for completed
//     } else if (step == currentStep.value) {
//       return Color(0xFFFFC107); // Yellow for current
//     } else {
//       return Colors.white.withOpacity(0.3); // Default
//     }
//   }
//
//   // Get button text based on current state
//   String get nextButtonText {
//     if (currentStep.value == 9 &&
//         currentSubStep.value == totalSubStepsInCurrentStep - 1) {
//       return 'Submit';
//     } else if (currentSubStep.value == totalSubStepsInCurrentStep - 1) {
//       return 'Next Step';
//     } else {
//       return 'Save & Next';
//     }
//   }
//
//   // Update survey data
//   void updateSurveyData(String key, dynamic value) {
//     final currentData = Map<String, dynamic>.from(surveyData.value ?? {});
//     currentData[key] = value;
//     surveyData.value = currentData;
//   }
//
//   // API Submit Method
//   Future<void> submitSurvey() async {
//     try {
//       isLoading.value = true;
//       // Final validation - check all required steps
//       List<int> requiredSteps = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
//       for (int step in requiredSteps) {
//         if (!isMainStepCompleted(step)) {
//           Get.snackbar(
//             'Incomplete Form',
//             'Please complete all required fields in step ${step + 1}',
//             backgroundColor: Color(0xFFDC3545),
//             colorText: Colors.white,
//           );
//           return;
//         }
//       }
//       // Save final data from all controllers
//       _saveAllStepsData();
//       // Mock API call
//       await Future.delayed(Duration(seconds: 2));
//       final response = {
//         'applicationId': 'SETU${DateTime.now().millisecondsSinceEpoch}',
//         'status': 'submitted',
//         'timestamp': DateTime.now().toIso8601String(),
//         'surveyData': surveyData.value,
//       };
//       surveyData.value = response;
//       Get.snackbar(
//         'Success',
//         'Your survey has been submitted successfully',
//         backgroundColor: Color(0xFF52B788),
//         colorText: Colors.white,
//       );
//       // Navigate to confirmation page
//       Get.toNamed('/confirmation');
//     } catch (e) {
//       errorMessage.value = e.toString();
//       Get.snackbar(
//         'Error',
//         'Something went wrong. Please try again',
//         backgroundColor: Color(0xFFDC3545),
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _saveAllStepsData() {
//     // Collect data from all step controllers
//     final allControllers = [
//       personalInfoController,
//       surveyCTSController,
//       calculationController,
//       landFouthController,
//       landFifthController,
//       laandSixthController,
//       landSeventhController,
//       // Add more controllers
//     ];
//     for (final controller in allControllers) {
//       if (controller is StepDataMixin) {
//         final stepData = controller.getStepData();
//         _mergeStepData(stepData);
//       }
//     }
//   }
// }
//
// // Mixins for step controllers to implement
// mixin StepValidationMixin on GetxController {
//   bool validateCurrentSubStep(String field);
//   bool isStepCompleted(List<String> fields);
//   String getFieldError(String field);
// }
//
// mixin StepDataMixin on GetxController {
//   Map<String, dynamic> getStepData();
// }


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
    3: ['land_fouth_step',], // Calculation Information
    4: ['holder_information', ], // Applicant Information
    5: ['next_of_kin'], // Co-owner Information
    6: ['adjacent', 'status'], // Information about Adjacent Holders
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
    surveyCTSController = Get.put(LandSecondController(), tag: 'survey_cts');
    calculationController = Get.put(CalculationController(), tag: 'calculation'); // Add this line
    landFouthController = Get.put(LandFouthController(), tag: 'land_fouth'); // Add this line
    landFifthController = Get.put(LandFifthController(), tag: 'land_fifth'); // Add this line
    laandSixthController = Get.put(LandSixthController(), tag: 'land_sixth'); // Add this line
    landSeventhController = Get.put(LandSeventhController(), tag: 'survey_seven'); // Add this line
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

    print('Controller does not implement StepValidationMixin, defaulting to true');
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

    // Check validation
    final isValid = isCurrentSubStepValid;
    print('Is current substep valid: $isValid');

    if (!isValid) {
      _showValidationError();
      return;
    }

    // Save current substep data
    _saveCurrentSubStepData();

    // Print the current survey data to the console
    print('Current Survey Data: ${surveyData.value}');

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
      duration: Duration(milliseconds: 2000), // Increased duration for better visibility
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