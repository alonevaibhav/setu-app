import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class LandFouthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Form controllers
  final countingFeeController = TextEditingController();

  // Observable variables
  final selectedCalculationType = 'Land acquisition case'.obs;
  final selectedDuration = ''.obs;
  final selectedHolderType = ''.obs;
  final countingFee = 0.obs;

  // Options for dropdowns
  final calculationTypeOptions = [
    'Land acquisition case',
  ];

  final durationOptions = [
    'Regular',
    'Fast pace',
  ];

  final holderTypeOptions = [
    'Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)',
  ];

  // Validation errors
  final durationError = ''.obs;
  final holderTypeError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes and calculate fee automatically
    ever(selectedDuration, (_) => calculateCountingFee());
    ever(selectedHolderType, (_) => calculateCountingFee());
  }

  @override
  void onClose() {
    countingFeeController.dispose();
    super.onClose();
  }

  // Update methods
  void updateCalculationType(String? value) {
    if (value != null) {
      selectedCalculationType.value = value;
    }
  }

  void updateDuration(String? value) {
    if (value != null) {
      selectedDuration.value = value;
      durationError.value = '';
    }
  }

  void updateHolderType(String? value) {
    if (value != null) {
      selectedHolderType.value = value;
      holderTypeError.value = '';
    }
  }

  // Calculate counting fee based on duration and holder type
  void calculateCountingFee() {
    if (selectedDuration.value.isEmpty || selectedHolderType.value.isEmpty) {
      countingFee.value = 0;
      countingFeeController.text = '0';
      return;
    }

    int fee = 0;

    // Check if holder type contains "Companies/Other Institutions/Various Authorities/Corporations"
    bool isCompanyOrInstitution = selectedHolderType.value.contains('Companies/Other Institutions/Various Authorities/Corporations');

    if (isCompanyOrInstitution) {
      if (selectedDuration.value == 'Regular') {
        fee = 7500;
      } else if (selectedDuration.value == 'Fast pace') {
        fee = 30000;
      }
    } else {
      // Different fee structures for other holder types
      if (selectedDuration.value == 'Regular') {
        fee = 5000; // Example fee for other types
      } else if (selectedDuration.value == 'Fast pace') {
        fee = 15000; // Example fee for other types
      }
    }

    countingFee.value = fee;
    countingFeeController.text = fee.toString();
  }

  // Validation methods
  bool _validateDuration() {
    if (selectedDuration.value.isEmpty) {
      durationError.value = 'Duration is required';
      return false;
    }
    durationError.value = '';
    return true;
  }

  bool _validateHolderType() {
    if (selectedHolderType.value.isEmpty) {
      holderTypeError.value = 'Holder type is required';
      return false;
    }
    holderTypeError.value = '';
    return true;
  }

  // StepValidationMixin implementation
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'calculation':
        return _validateDuration() && _validateHolderType();
      default:
        return true;
    }
  }

  @override
  bool isStepCompleted(List<String> fields) {
    for (String field in fields) {
      if (!validateCurrentSubStep(field)) {
        return false;
      }
    }
    return true;
  }

  @override
  String getFieldError(String field) {
    switch (field) {
      case 'calculation':
        if (selectedDuration.value.isEmpty) {
          return 'Duration is required';
        }
        if (selectedHolderType.value.isEmpty) {
          return 'Holder type is required';
        }
        return '';
      default:
        return 'This field is required';
    }
  }

  // StepDataMixin implementation
  @override
  Map<String, dynamic> getStepData() {
    return {
      'calculation_type': selectedCalculationType.value,
      'duration': selectedDuration.value,
      'holder_type': selectedHolderType.value,
      'counting_fee': countingFee.value,
    };
  }

  // Reset form
  void resetForm() {
    selectedCalculationType.value = 'Land acquisition case';
    selectedDuration.value = '';
    selectedHolderType.value = '';
    countingFee.value = 0;
    countingFeeController.clear();
    durationError.value = '';
    holderTypeError.value = '';
  }

  // Load saved data (if needed)
  void loadSavedData(Map<String, dynamic> data) {
    if (data.containsKey('calculation_type')) {
      selectedCalculationType.value = data['calculation_type'] ?? 'Land acquisition case';
    }
    if (data.containsKey('duration')) {
      selectedDuration.value = data['duration'] ?? '';
    }
    if (data.containsKey('holder_type')) {
      selectedHolderType.value = data['holder_type'] ?? '';
    }
    if (data.containsKey('counting_fee')) {
      countingFee.value = data['counting_fee'] ?? 0;
      countingFeeController.text = countingFee.value.toString();
    }
  }
}