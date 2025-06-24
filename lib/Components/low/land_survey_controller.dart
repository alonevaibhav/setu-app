import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SurveyController extends GetxController {
  // Survey Flow State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final remarksController = TextEditingController();

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

  // Sub-step configurations for each main step
  final Map<int, List<String>> stepConfigurations = {
    0: ['name', 'phone', 'email', 'gender', 'category'],
    1: ['address', 'state', ],
    2: ['remarks', 'status',],
  };

  @override
  void onInit() {
    super.onInit();
    initializeSurveyData();
    initializeValidationStates();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    remarksController.dispose();
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
    for (int i = 0; i <= 2; i++) {
      isStepValid[i] = false;
    }
  }

  // Get total sub-steps for current main step
  int get totalSubStepsInCurrentStep => stepConfigurations[currentStep.value]?.length ?? 1;

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
  // Replace your existing nextSubStep method with this fixed version:

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
      if (currentStep.value < 2) {
        currentStep.value++;
        currentSubStep.value = 0;
        _updateStepValidation();
      } else {
        // We're at the last step and last substep, submit the survey
        submitSurvey();
      }
    }
  }

// Also fix the previousSubStep method:
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
    if (step >= 0 && step <= 2) {
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
      case 'name':
        return nameController.text.trim().length >= 2;
      case 'phone':
        return phoneController.text.trim().length == 10 && RegExp(r'^[0-9]+$').hasMatch(phoneController.text.trim());
      case 'email':
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text.trim());
      case 'gender':
        return selectedGender.value.isNotEmpty;
      case 'category':
        return selectedCategory.value.isNotEmpty;
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
      default:
        return true;
    }
  }

  String getFieldError(String field) {
    switch (field) {
      case 'name':
        return 'Name must be at least 2 characters';
      case 'phone':
        return 'Phone must be exactly 10 digits';
      case 'email':
        return 'Please enter a valid email address';
      case 'gender':
        return 'Please select your gender';
      case 'category':
        return 'Please select your category';
      case 'address':
        return 'Address must be at least 10 characters';
      case 'state':
        return 'Please select your state';
      case 'surveyType':
        return 'Please select survey type';
      case 'remarks':
        return 'Remarks must be at least 5 characters';
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
    );
  }

  void _saveCurrentSubStepData() {
    final field = currentSubStepField;
    final currentData = Map<String, dynamic>.from(surveyData.value ?? {});

    switch (field) {
      case 'name':
        currentData['fullName'] = nameController.text.trim();
        break;
      case 'phone':
        currentData['phone'] = phoneController.text.trim();
        break;
      case 'email':
        currentData['email'] = emailController.text.trim();
        break;
      case 'gender':
        currentData['gender'] = selectedGender.value;
        break;
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
    }

    surveyData.value = currentData;
  }

  void _updateStepValidation() {
    for (int i = 0; i <= 2; i++) {
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
    if (currentStep.value == 2 &&
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

      // Final validation
      if (!isMainStepCompleted(0) || !isMainStepCompleted(1) || !isMainStepCompleted(2)) {
        Get.snackbar(
          'Incomplete Form',
          'Please complete all required fields',
          backgroundColor: Color(0xFFDC3545),
          colorText: Colors.white,
        );
        return;
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
