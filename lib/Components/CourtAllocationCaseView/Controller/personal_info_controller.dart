import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {

  // Text Controllers
  final courtNameController = TextEditingController();
  final courtAddressController = TextEditingController();
  final courtOrderNumberController = TextEditingController();
  final courtAllotmentDateController = TextEditingController();
  final claimNumberYearController = TextEditingController();
  final specialOrderCommentsController = TextEditingController();

  // File Upload Lists
  final courtOrderFiles = <String>[].obs;

  // Date Selection
  final courtAllotmentDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize any default values if needed
  }

  @override
  void onClose() {
    // Dispose text controllers
    courtNameController.dispose();
    courtAddressController.dispose();
    courtOrderNumberController.dispose();
    courtAllotmentDateController.dispose();
    claimNumberYearController.dispose();
    specialOrderCommentsController.dispose();
    super.onClose();
  }

  // Date Update Methods
  void updateCourtAllotmentDate(DateTime selectedDate) {
    courtAllotmentDate.value = selectedDate;
    courtAllotmentDateController.text =
    "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
  }

  // Field Validation Methods
  bool _validateCourtName() {
    return courtNameController.text.trim().isNotEmpty &&
        courtNameController.text.trim().length >= 3;
  }

  bool _validateCourtAddress() {
    return courtAddressController.text.trim().isNotEmpty &&
        courtAddressController.text.trim().length >= 10;
  }

  bool _validateCourtOrderNumber() {
    return courtOrderNumberController.text.trim().isNotEmpty &&
        courtOrderNumberController.text.trim().length >= 3;
  }

  bool _validateCourtAllotmentDate() {
    return courtAllotmentDateController.text.trim().isNotEmpty &&
        courtAllotmentDate.value != null;
  }

  bool _validateClaimNumberYear() {
    return claimNumberYearController.text.trim().isNotEmpty &&
        claimNumberYearController.text.trim().length >= 4;
  }

  bool _validateCourtOrderFiles() {
    return courtOrderFiles.isNotEmpty;
  }

  bool _validateSpecialOrderComments() {
    return specialOrderCommentsController.text.trim().isNotEmpty &&
        specialOrderCommentsController.text.trim().length >= 10;
  }

  // Step Validation Mixin Implementation
  @override
  // bool validateCurrentSubStep(String field) {
  //   switch (field) {
  //     case 'calculation':
  //       return true; // Temporarily return true to bypass validation
  //     default:
  //       return true;
  //   }
  // }
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'calculation':
        return _validateCourtName() &&
            _validateCourtAddress() &&
            _validateCourtOrderNumber() &&
            _validateCourtAllotmentDate() &&
            _validateClaimNumberYear() &&
            _validateCourtOrderFiles() &&
            _validateSpecialOrderComments();
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
        if (!_validateCourtName()) {
          return 'Court name is required (minimum 3 characters)';
        }
        if (!_validateCourtAddress()) {
          return 'Court address is required (minimum 10 characters)';
        }
        if (!_validateCourtOrderNumber()) {
          return 'Court order number is required (minimum 3 characters)';
        }
        if (!_validateCourtAllotmentDate()) {
          return 'Court allotment date is required';
        }
        if (!_validateClaimNumberYear()) {
          return 'Claim number and year is required (minimum 4 characters)';
        }
        if (!_validateCourtOrderFiles()) {
          return 'Court allocation order document is required';
        }
        if (!_validateSpecialOrderComments()) {
          return 'Special order or comments are required (minimum 10 characters)';
        }
        return 'Please fill all required fields';
      default:
        return 'This field is required';
    }
  }

  // Step Data Mixin Implementation
  @override
  Map<String, dynamic> getStepData() {
    return {
      'courtName': courtNameController.text.trim(),
      'courtAddress': courtAddressController.text.trim(),
      'courtOrderNumber': courtOrderNumberController.text.trim(),
      'courtAllotmentDate': courtAllotmentDateController.text.trim(),
      'courtAllotmentDateValue': courtAllotmentDate.value?.toIso8601String(),
      'claimNumberYear': claimNumberYearController.text.trim(),
      'courtOrderFiles': courtOrderFiles.toList(),
      'specialOrderComments': specialOrderCommentsController.text.trim(),
      'stepCompleted': isStepCompleted(['calculation']),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Helper Methods
  void clearAllFields() {
    courtNameController.clear();
    courtAddressController.clear();
    courtOrderNumberController.clear();
    courtAllotmentDateController.clear();
    claimNumberYearController.clear();
    specialOrderCommentsController.clear();
    courtOrderFiles.clear();
    courtAllotmentDate.value = null;
  }

  // Load data from saved state
  void loadStepData(Map<String, dynamic> data) {
    courtNameController.text = data['courtName'] ?? '';
    courtAddressController.text = data['courtAddress'] ?? '';
    courtOrderNumberController.text = data['courtOrderNumber'] ?? '';
    courtAllotmentDateController.text = data['courtAllotmentDate'] ?? '';
    claimNumberYearController.text = data['claimNumberYear'] ?? '';
    specialOrderCommentsController.text = data['specialOrderComments'] ?? '';

    if (data['courtOrderFiles'] != null) {
      courtOrderFiles.assignAll(List<String>.from(data['courtOrderFiles']));
    }

    if (data['courtAllotmentDateValue'] != null) {
      courtAllotmentDate.value = DateTime.parse(data['courtAllotmentDateValue']);
    }
  }

  // Print current data for debugging
  void printCurrentData() {
    print('=== Court Allocation Data ===');
    print('Court Name: ${courtNameController.text}');
    print('Court Address: ${courtAddressController.text}');
    print('Court Order Number: ${courtOrderNumberController.text}');
    print('Court Allotment Date: ${courtAllotmentDateController.text}');
    print('Claim Number & Year: ${claimNumberYearController.text}');
    print('Special Order/Comments: ${specialOrderCommentsController.text}');
    print('Court Order Files: ${courtOrderFiles.length} files');
    print('Step Completed: ${isStepCompleted(['calculation'])}');
    print('=============================');
  }
}