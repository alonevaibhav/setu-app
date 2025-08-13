import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class CensusFourthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Dropdown options
  final List<String> calculationTypeOptions = [
    'Government census',
  ];

  final List<String> durationOptions = [
    'Regular',
  ];

  final List<String> holderTypeOptions = [
    'Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)',
  ];

  final List<String> calculationFeeRateOptions = [
    'Full calculation fee',
    'Half fee',
    'Free',
  ];

  // Selected values
  final selectedCalculationType = Rxn<String>();
  final selectedDuration = Rxn<String>();
  final selectedHolderType = Rxn<String>();
  final selectedCalculationFeeRate = Rxn<String>();
  final countingFee = 0.obs;

  // Validation states
  final calculationTypeError = ''.obs;
  final durationError = ''.obs;
  final holderTypeError = ''.obs;
  final calculationFeeRateError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set default values
    selectedCalculationType.value = calculationTypeOptions.first;
    selectedDuration.value = durationOptions.first;
    selectedHolderType.value = holderTypeOptions.first;

    // Listen to fee rate changes to calculate counting fee
    ever(selectedCalculationFeeRate, (_) => _calculateCountingFee());
  }

  // Update methods
  void updateCalculationType(String? value) {
    selectedCalculationType.value = value;
    calculationTypeError.value = '';
    _calculateCountingFee();
  }

  void updateDuration(String? value) {
    selectedDuration.value = value;
    durationError.value = '';
  }

  void updateHolderType(String? value) {
    selectedHolderType.value = value;
    holderTypeError.value = '';
    _calculateCountingFee();
  }

  void updateCalculationFeeRate(String? value) {
    selectedCalculationFeeRate.value = value;
    calculationFeeRateError.value = '';
    _calculateCountingFee();
  }

  // Calculate counting fee based on selections
  void _calculateCountingFee() {
    if (selectedCalculationType.value == 'Government census' &&
        selectedHolderType.value == 'Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)') {

      switch (selectedCalculationFeeRate.value) {
        case 'Full calculation fee':
          countingFee.value = 3000;
          break;
        case 'Half fee':
          countingFee.value = 1500;
          break;
        case 'Free':
          countingFee.value = 0;
          break;
        default:
          countingFee.value = 0;
      }
    } else {
      countingFee.value = 0;
    }
  }

  // Validation methods
  bool _validateCalculationType() {
    if (selectedCalculationType.value == null || selectedCalculationType.value!.isEmpty) {
      calculationTypeError.value = 'Calculation type is required';
      return false;
    }
    calculationTypeError.value = '';
    return true;
  }

  bool _validateDuration() {
    if (selectedDuration.value == null || selectedDuration.value!.isEmpty) {
      durationError.value = 'Duration is required';
      return false;
    }
    durationError.value = '';
    return true;
  }

  bool _validateHolderType() {
    if (selectedHolderType.value == null || selectedHolderType.value!.isEmpty) {
      holderTypeError.value = 'Holder type is required';
      return false;
    }
    holderTypeError.value = '';
    return true;
  }

  bool _validateCalculationFeeRate() {
    if (selectedCalculationFeeRate.value == null || selectedCalculationFeeRate.value!.isEmpty) {
      calculationFeeRateError.value = 'Calculation fee rate is required';
      return false;
    }
    calculationFeeRateError.value = '';
    return true;
  }

  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'calculation':
        return _validateCalculationType() &&
            _validateDuration() &&
            _validateHolderType() &&
            _validateCalculationFeeRate();
      case 'status':
        return true; // Status step is always valid for now
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
        if (!_validateCalculationType()) return calculationTypeError.value;
        if (!_validateDuration()) return durationError.value;
        if (!_validateHolderType()) return holderTypeError.value;
        if (!_validateCalculationFeeRate()) return calculationFeeRateError.value;
        return '';
      case 'status':
        return '';
      default:
        return 'This field is required';
    }
  }

  @override
  Map<String, dynamic> getStepData() {
    return {
      'calculationType': selectedCalculationType.value,
      'duration': selectedDuration.value,
      'holderType': selectedHolderType.value,
      'calculationFeeRate': selectedCalculationFeeRate.value,
      'countingFee': countingFee.value,
    };
  }

  // Clear all data
  void clearData() {
    selectedCalculationType.value = null;
    selectedDuration.value = null;
    selectedHolderType.value = null;
    selectedCalculationFeeRate.value = null;
    countingFee.value = 0;
    _clearErrors();
  }

  void _clearErrors() {
    calculationTypeError.value = '';
    durationError.value = '';
    holderTypeError.value = '';
    calculationFeeRateError.value = '';
  }
}