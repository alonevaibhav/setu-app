import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../CourtAllocationCaseView/Controller/main_controller.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {

  // Text Controllers for Government Counting
  final governmentCountingOfficerController = TextEditingController();
  final governmentCountingOfficerAddressController = TextEditingController();
  final governmentCountingOrderNumberController = TextEditingController();
  final governmentCountingOrderDateController = TextEditingController();
  final countingApplicantNameController = TextEditingController();
  final countingApplicantAddressController = TextEditingController();
  final governmentCountingDetailsController = TextEditingController();


  // Date storage
  final governmentCountingOrderDate = Rxn<DateTime>();

  // File storage
  final governmentCountingOrderFiles = <String>[].obs;

  // Validation states
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeListeners();
  }

  @override
  void onClose() {
    // Dispose controllers
    governmentCountingOfficerController.dispose();
    governmentCountingOfficerAddressController.dispose();
    governmentCountingOrderNumberController.dispose();
    governmentCountingOrderDateController.dispose();
    countingApplicantNameController.dispose();
    countingApplicantAddressController.dispose();
    governmentCountingDetailsController.dispose();
    super.onClose();
  }

  void _initializeListeners() {
    // Add listeners if needed for real-time validation
  }

  // Date update methods
  void updateGovernmentCountingOrderDate(DateTime date) {
    governmentCountingOrderDate.value = date;
    governmentCountingOrderDateController.text =
    '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  // Validation Methods (StepValidationMixin implementation)
  @override
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'government_counting_details':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }
  // bool validateCurrentSubStep(String field) {
  //   switch (field) {
  //     case 'government_counting_details':
  //       return _validateGovernmentCountingDetails();
  //     default:
  //       return true;
  //   }
  // }

  bool _validateGovernmentCountingDetails() {
    // Validate required fields
    if (governmentCountingOfficerController.text.trim().isEmpty) return false;
    if (governmentCountingOfficerAddressController.text.trim().isEmpty) return false;
    if (governmentCountingOrderNumberController.text.trim().isEmpty) return false;
    if (governmentCountingOrderDateController.text.trim().isEmpty) return false;
    if (governmentCountingDetailsController.text.trim().isEmpty) return false;
    if (governmentCountingOrderFiles.isEmpty) return false;

    // Additional validation
    if (governmentCountingOfficerController.text.trim().length < 2) return false;
    if (governmentCountingOfficerAddressController.text.trim().length < 5) return false;
    if (governmentCountingOrderNumberController.text.trim().length < 3) return false;
    if (governmentCountingDetailsController.text.trim().length < 10) return false;

    return true;
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
      case 'government_counting_details':
        return _getGovernmentCountingDetailsError();
      default:
        return 'This field is required';
    }
  }

  String _getGovernmentCountingDetailsError() {
    if (governmentCountingOfficerController.text.trim().isEmpty) {
      return 'Officer name is required';
    }
    if (governmentCountingOfficerController.text.trim().length < 2) {
      return 'Officer name must be at least 2 characters';
    }
    if (governmentCountingOfficerAddressController.text.trim().isEmpty) {
      return 'Officer address is required';
    }
    if (governmentCountingOfficerAddressController.text.trim().length < 5) {
      return 'Officer address must be at least 5 characters';
    }
    if (governmentCountingOrderNumberController.text.trim().isEmpty) {
      return 'Order number is required';
    }
    if (governmentCountingOrderNumberController.text.trim().length < 3) {
      return 'Order number must be at least 3 characters';
    }
    if (governmentCountingOrderDateController.text.trim().isEmpty) {
      return 'Order date is required';
    }
    if (governmentCountingDetailsController.text.trim().isEmpty) {
      return 'Government counting details are required';
    }
    if (governmentCountingDetailsController.text.trim().length < 10) {
      return 'Details must be at least 10 characters';
    }
    if (governmentCountingOrderFiles.isEmpty) {
      return 'Government counting order document is required';
    }
    return 'Please complete all required fields';
  }

  // Data Methods (StepDataMixin implementation)
  @override
  Map<String, dynamic> getStepData() {
    return {
      'government_counting_officer': governmentCountingOfficerController.text.trim(),
      'government_counting_officer_address': governmentCountingOfficerAddressController.text.trim(),
      'government_counting_order_number': governmentCountingOrderNumberController.text.trim(),
      'government_counting_order_date': governmentCountingOrderDateController.text.trim(),
      'government_counting_order_date_object': governmentCountingOrderDate.value?.toIso8601String(),
      'counting_applicant_name': countingApplicantNameController.text.trim(),
      'counting_applicant_address': countingApplicantAddressController.text.trim(),
      'government_counting_details': governmentCountingDetailsController.text.trim(),
      'government_counting_order_files': governmentCountingOrderFiles.toList(),
    };
  }

  // Utility Methods
  void clearForm() {
    governmentCountingOfficerController.clear();
    governmentCountingOfficerAddressController.clear();
    governmentCountingOrderNumberController.clear();
    governmentCountingOrderDateController.clear();
    countingApplicantNameController.clear();
    countingApplicantAddressController.clear();
    governmentCountingDetailsController.clear();
    governmentCountingOrderDate.value = null;
    governmentCountingOrderFiles.clear();
  }

  void loadData(Map<String, dynamic> data) {
    governmentCountingOfficerController.text = data['government_counting_officer'] ?? '';
    governmentCountingOfficerAddressController.text = data['government_counting_officer_address'] ?? '';
    governmentCountingOrderNumberController.text = data['government_counting_order_number'] ?? '';
    governmentCountingOrderDateController.text = data['government_counting_order_date'] ?? '';
    countingApplicantNameController.text = data['counting_applicant_name'] ?? '';
    countingApplicantAddressController.text = data['counting_applicant_address'] ?? '';
    governmentCountingDetailsController.text = data['government_counting_details'] ?? '';

    // Load date object if exists
    if (data['government_counting_order_date_object'] != null) {
      try {
        governmentCountingOrderDate.value = DateTime.parse(data['government_counting_order_date_object']);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    // Load files if exists
    if (data['government_counting_order_files'] != null) {
      governmentCountingOrderFiles.assignAll(
          List<String>.from(data['government_counting_order_files'])
      );
    }
  }
}