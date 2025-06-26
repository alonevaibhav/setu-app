import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SurveyController extends GetxController {
  // Survey Flow State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Form Controllers
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final remarksController = TextEditingController();
  final paymentController = TextEditingController();

  ///------------------Start Controller ------------------///
  final applicantNameController = TextEditingController();
  final applicantPhoneController = TextEditingController();
  final relationshipController = TextEditingController();
  final relationshipWithApplicantController = TextEditingController();
  final poaRegistrationNumberController = TextEditingController();
  final poaRegistrationDateController = TextEditingController();
  final poaIssuerNameController = TextEditingController();
  final poaHolderNameController = TextEditingController();
  final poaHolderAddressController = TextEditingController();

// Observable boolean values for questions
  final isHolderThemselves = Rxn<bool>();
  final hasAuthorityOnBehalf = Rxn<bool>();
  final hasBeenCountedBefore = Rxn<bool>();

  // Dropdown Values
  final selectedGender = ''.obs;
  final selectedCategory = ''.obs;
  final selectedState = ''.obs;
  final selectedSurveyType = ''.obs;

  // Validation States
  final validationErrors = <String, String>{}.obs;
  final isStepValid = <int, bool>{}.obs;

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: ['holder_verification', 'enumeration_check'], // Personal Info step
    1: ['address', 'state'], // Survey/CTS Information
    2: ['remarks', 'status'], // Survey Information
    3: ['calculation', 'status'], // Calculation Information
    4: ['applicant', 'status'], // Applicant Information
    5: ['coowner', 'status'], // Co-owner Information
    6: ['adjacent', 'status'], // Information about Adjacent Holders
    7: ['documents', 'status'], // Document Upload
    8: ['preview', 'status'], // Preview
    9: ['payment', 'status'], // Payment
  };

  @override
  void onInit() {
    super.onInit();
    initializeSurveyData();
    initializeValidationStates();
  }

  @override
  void onClose() {
    emailController.dispose();
    addressController.dispose();
    remarksController.dispose();
    poaRegistrationNumberController.dispose();
    poaRegistrationDateController.dispose();
    poaIssuerNameController.dispose();
    poaHolderNameController.dispose();
    poaHolderAddressController.dispose();
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

  // Check if current sub-step is valid
  bool get isCurrentSubStepValid {
    final field = currentSubStepField;
    return validateField(field);
  }

  // Check if entire main step is completed
  bool isMainStepCompleted(int step) {
    final fields = stepConfigurations[step];
    if (fields == null) return false;

    for (String field in fields) {
      if (!validateField(field)) return false;
    }
    return true;
  }

  // Navigation Methods
  void nextSubStep() {
    if (!isCurrentSubStepValid) {
      _showValidationError();
      return;
    }

    _saveCurrentSubStepData();

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

  // Validation Methods
  bool validateField(String field) {
    switch (field) {
      ///------------------Start Controller ------------------///

      case 'holder_verification':
        // Check if holder themselves is selected
        if (isHolderThemselves.value == null) return false;

        // If not holder themselves, check authority
        if (isHolderThemselves.value == false) {
          if (hasAuthorityOnBehalf.value == null) return false;

          // If has authority, validate POA fields
          if (hasAuthorityOnBehalf.value == true) {
            return poaRegistrationNumberController.text.trim().length >= 3 &&
                poaRegistrationDateController.text.trim().isNotEmpty &&
                poaIssuerNameController.text.trim().length >= 2 &&
                poaHolderNameController.text.trim().length >= 2 &&
                poaHolderAddressController.text.trim().length >= 5;
          }
        }
        return true;

      case 'enumeration_check':
        return hasBeenCountedBefore.value != null;

      case 'address':
        return addressController.text.trim().length >= 10;
      case 'state':
        return selectedState.value.isNotEmpty;
      case 'surveyType':
        return selectedSurveyType.value.isNotEmpty;
      case 'documents':
        return true; // Optional for now
      case 'remarks':
        return remarksController.text.trim().length >= 5;
      case 'status':
        return true; // Always valid
      case 'images':
        return true; // Optional
      case 'summary':
        return true; // Always valid
      case 'calculation':
        return true; // Add your calculation validation logic here
      case 'applicant':
        return true; // Add your applicant validation logic here
      case 'coowner':
        return true; // Add your co-owner validation logic here
      case 'adjacent':
        return true; // Add your adjacent holders validation logic here
      case 'preview':
        return true; // Always valid for preview
      case 'payment':
        return paymentController.text.trim().length >=
            2; // Add your payment validation logic here
      default:
        return true;
    }
  }

  String getFieldError(String field) {
    switch (field) {
      ///------------------Start Controller ------------------///

      case 'holder_verification':
        if (isHolderThemselves.value == null) {
          return 'Please select if you are the holder';
        }
        if (isHolderThemselves.value == false &&
            hasAuthorityOnBehalf.value == null) {
          return 'Please select if you have authority on behalf';
        }
        if (isHolderThemselves.value == false &&
            hasAuthorityOnBehalf.value == true) {
          if (poaRegistrationNumberController.text.trim().length < 3) {
            return 'Registration number must be at least 3 characters';
          }
          if (poaRegistrationDateController.text.trim().isEmpty) {
            return 'Registration date is required';
          }
          if (poaIssuerNameController.text.trim().length < 2) {
            return 'Issuer name must be at least 2 characters';
          }
          if (poaHolderNameController.text.trim().length < 2) {
            return 'Holder name must be at least 2 characters';
          }
          if (poaHolderAddressController.text.trim().length < 5) {
            return 'Address must be at least 5 characters';
          }
        }
        return 'Please complete holder verification';
      case 'enumeration_check':
        return 'Please select if this has been counted before';

      case 'name':
        return 'Name must be at least 2 characters';
      case 'category':
        return 'Please select your category';
      default:
        return 'This field is required';
    }
  }

  void _showValidationError() {
    final field = currentSubStepField;
    final error = getFieldError(field);
    Get.snackbar(
      'Validation Error',
      error,
      backgroundColor: Color(0xFFDC3545),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1200),
    );
  }

  void _saveCurrentSubStepData() {
    final field = currentSubStepField;
    final currentData = Map<String, dynamic>.from(surveyData.value ?? {});

    switch (field) {
      case 'category':
        currentData['category'] = selectedCategory.value;
        break;
      case 'address':
        currentData['address'] = addressController.text.trim();
        break;
      case 'state':
        currentData['state'] = selectedState.value;
        break;
      case 'surveyType':
        currentData['surveyType'] = selectedSurveyType.value;
        break;
      case 'remarks':
        currentData['remarks'] = remarksController.text.trim();
        break;
      case 'calculation':
        currentData['calculation'] = 'completed'; // Add your logic here
        break;
    }

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

  // Update dropdown values
  void updateGender(String? value) {
    selectedGender.value = value ?? '';
  }

  void updateCategory(String? value) {
    selectedCategory.value = value ?? '';
  }

  void updateState(String? value) {
    selectedState.value = value ?? '';
  }

  void updateSurveyType(String? value) {
    selectedSurveyType.value = value ?? '';
  }

  // API Submit Method
  Future<void> submitSurvey() async {
    try {
      isLoading.value = true;

      // Final validation - check all required steps
      List<int> requiredSteps = [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
      ]; // Add more required steps as needed
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

      // Save final data
      _saveCurrentSubStepData();

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
}
