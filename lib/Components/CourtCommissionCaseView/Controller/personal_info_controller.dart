import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../CourtCommissionCaseView/Controller/main_controller.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
  // Text Controllers
  final courtNameController = TextEditingController();
  final courtAddressController = TextEditingController();
  final commissionOrderNoController = TextEditingController();
  final commissionDateController = TextEditingController();
  final civilClaimController = TextEditingController();
  final issuingOfficeController = TextEditingController();
  final applicantNameController = TextEditingController();
  final applicantAddressController = TextEditingController();

  // Date selection
  final selectedCommissionDate = Rxn<DateTime>();

  // File upload
  final commissionOrderFiles = <String>[].obs;

  // Validation states
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeValidation();
  }

  @override
  void onClose() {
    courtNameController.dispose();
    courtAddressController.dispose();
    commissionOrderNoController.dispose();
    commissionDateController.dispose();
    civilClaimController.dispose();
    issuingOfficeController.dispose();
    super.onClose();
  }

  void _initializeValidation() {
    // Initialize validation states
    validationErrors.clear();
  }

  // Update commission date
  void updateCommissionDate(DateTime date) {
    selectedCommissionDate.value = date;
    commissionDateController.text = _formatDate(date);
    _clearFieldError('commission_date');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _clearFieldError(String field) {
    validationErrors.remove(field);
  }

  // Validation Methods
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'government_survey':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }
  // bool validateCurrentSubStep(String field) {
  //   switch (field) {
  //     case 'court_commission_details':
  //       return _validateCourtCommissionDetails();
  //     default:
  //       return true;
  //   }
  // }

  bool _validateCourtCommissionDetails() {
    validationErrors.clear();
    bool isValid = true;

    // Validate court name
    if (courtNameController.text.trim().isEmpty) {
      validationErrors['court_name'] = 'Court name is required';
      isValid = false;
    } else if (courtNameController.text.trim().length < 3) {
      validationErrors['court_name'] = 'Court name must be at least 3 characters';
      isValid = false;
    }

    // Validate court address
    if (courtAddressController.text.trim().isEmpty) {
      validationErrors['court_address'] = 'Court address is required';
      isValid = false;
    } else if (courtAddressController.text.trim().length < 10) {
      validationErrors['court_address'] = 'Address must be at least 10 characters';
      isValid = false;
    }

    // Validate commission order number
    if (commissionOrderNoController.text.trim().isEmpty) {
      validationErrors['commission_order_no'] = 'Commission order number is required';
      isValid = false;
    } else if (commissionOrderNoController.text.trim().length < 3) {
      validationErrors['commission_order_no'] = 'Order number must be at least 3 characters';
      isValid = false;
    }

    // Validate commission date
    if (selectedCommissionDate.value == null) {
      validationErrors['commission_date'] = 'Commission date is required';
      isValid = false;
    }

    // Validate civil claim
    if (civilClaimController.text.trim().isEmpty) {
      validationErrors['civil_claim'] = 'Civil claim details are required';
      isValid = false;
    } else if (civilClaimController.text.trim().length < 5) {
      validationErrors['civil_claim'] = 'Civil claim must be at least 5 characters';
      isValid = false;
    }

    // Validate issuing office
    if (issuingOfficeController.text.trim().isEmpty) {
      validationErrors['issuing_office'] = 'Issuing office details are required';
      isValid = false;
    } else if (issuingOfficeController.text.trim().length < 5) {
      validationErrors['issuing_office'] = 'Office details must be at least 5 characters';
      isValid = false;
    }

    // Validate file upload
    if (commissionOrderFiles.isEmpty) {
      validationErrors['commission_order_file'] = 'Commission order document is required';
      isValid = false;
    }

    return isValid;
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
      case 'court_commission_details':
        if (validationErrors.isNotEmpty) {
          return validationErrors.values.first;
        }
        return 'Please fill all required fields';
      default:
        return 'This field is required';
    }
  }

  @override
  Map<String, dynamic> getStepData() {
    return {
      'court_name': courtNameController.text.trim(),
      'court_address': courtAddressController.text.trim(),
      'commission_order_no': commissionOrderNoController.text.trim(),
      'commission_date': selectedCommissionDate.value?.toIso8601String(),
      'civil_claim': civilClaimController.text.trim(),
      'issuing_office': issuingOfficeController.text.trim(),
      'commission_order_files': commissionOrderFiles.toList(),
      'step_completed_at': DateTime.now().toIso8601String(),
    };
  }

  // Helper methods for UI
  String? getFieldValidationError(String field) {
    return validationErrors[field];
  }

  bool hasFieldError(String field) {
    return validationErrors.containsKey(field);
  }
}