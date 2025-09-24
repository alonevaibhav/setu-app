import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../GovernmentCensusView/Controller/main_controller.dart';
import '../../Widget/address.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
  // Text Controllers for Government Counting
  final governmentCountingOfficerController = TextEditingController();
  final applicantNameController = TextEditingController();
  final governmentCountingOfficerAddressController = TextEditingController();
  final governmentCountingOrderNumberController = TextEditingController();
  final governmentCountingOrderDateController = TextEditingController();
  final countingApplicantNameController = TextEditingController();
  final countingApplicantAddressController = TextEditingController(); // Keep for backward compatibility
  final governmentCountingDetailsController = TextEditingController();

  // Date storage
  final governmentCountingOrderDate = Rxn<DateTime>();

  // File storage
  final governmentCountingOrderFiles = <String>[].obs;

  // Validation states
  final formKey = GlobalKey<FormState>();

  //------------------------Applicant Address Validation Implementation ------------------------//

  // Applicant address data storage
  final applicantAddressData = <String, String>{
    'plotNo': '',
    'address': '',
    'mobileNumber': '',
    'email': '',
    'pincode': '',
    'district': '',
    'village': '',
    'postOffice': '',
  }.obs;

  // Applicant address validation errors
  final applicantAddressValidationErrors = <String, String>{}.obs;

  // Applicant address controllers for the popup
  final applicantAddressControllers = <String, TextEditingController>{
    'plotNoController': TextEditingController(),
    'addressController': TextEditingController(),
    'mobileNumberController': TextEditingController(),
    'emailController': TextEditingController(),
    'pincodeController': TextEditingController(),
    'districtController': TextEditingController(),
    'villageController': TextEditingController(),
    'postOfficeController': TextEditingController(),
  };

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

    // Dispose address controllers
    applicantAddressControllers.values
        .forEach((controller) => controller.dispose());

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

  //------------------------Applicant Address Methods ------------------------//

  // Applicant address formatting method
  String getFormattedApplicantAddress() {
    final parts = <String>[];

    if (applicantAddressData['plotNo']?.isNotEmpty == true) {
      parts.add(applicantAddressData['plotNo']!);
    }
    if (applicantAddressData['address']?.isNotEmpty == true) {
      parts.add(applicantAddressData['address']!);
    }
    if (applicantAddressData['village']?.isNotEmpty == true) {
      parts.add(applicantAddressData['village']!);
    }
    if (applicantAddressData['postOffice']?.isNotEmpty == true) {
      parts.add(applicantAddressData['postOffice']!);
    }
    if (applicantAddressData['pincode']?.isNotEmpty == true) {
      parts.add(applicantAddressData['pincode']!);
    }

    return parts.isEmpty ? 'Click to add applicant address' : parts.join(', ');
  }

  // Check if detailed applicant address is available
  bool hasDetailedApplicantAddress() {
    return applicantAddressData.isNotEmpty &&
        (applicantAddressData['address']?.isNotEmpty == true ||
            applicantAddressData['village']?.isNotEmpty == true);
  }

  // Show applicant address popup
  void showApplicantAddressPopup(BuildContext context) {
    // Populate controllers with current data
    applicantAddressControllers['plotNoController']!.text =
        applicantAddressData['plotNo'] ?? '';
    applicantAddressControllers['addressController']!.text =
        applicantAddressData['address'] ?? '';
    applicantAddressControllers['mobileNumberController']!.text =
        applicantAddressData['mobileNumber'] ?? '';
    applicantAddressControllers['emailController']!.text =
        applicantAddressData['email'] ?? '';
    applicantAddressControllers['pincodeController']!.text =
        applicantAddressData['pincode'] ?? '';
    applicantAddressControllers['districtController']!.text =
        applicantAddressData['district'] ?? '';
    applicantAddressControllers['villageController']!.text =
        applicantAddressData['village'] ?? '';
    applicantAddressControllers['postOfficeController']!.text =
        applicantAddressData['postOffice'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AddressPopup(
        entryIndex: 0,
        controllers: applicantAddressControllers,
        onSave: () => _saveApplicantAddressFromPopup(),
      ),
    );
  }

  // Save applicant address from popup
  void _saveApplicantAddressFromPopup() {
    final newAddressData = {
      'plotNo': applicantAddressControllers['plotNoController']!.text,
      'address': applicantAddressControllers['addressController']!.text,
      'mobileNumber':
          applicantAddressControllers['mobileNumberController']!.text,
      'email': applicantAddressControllers['emailController']!.text,
      'pincode': applicantAddressControllers['pincodeController']!.text,
      'district': applicantAddressControllers['districtController']!.text,
      'village': applicantAddressControllers['villageController']!.text,
      'postOffice': applicantAddressControllers['postOfficeController']!.text,
    };

    updateApplicantAddress(newAddressData);
    Get.back(); // Close the popup
  }

  // Update applicant address with validation
  void updateApplicantAddress(Map<String, String> newAddressData) {
    applicantAddressData.assignAll(newAddressData);

    // Update the old controller for backward compatibility
    countingApplicantAddressController.text = getFormattedApplicantAddress();

    // Clear validation errors
    applicantAddressValidationErrors.clear();

    // Validate address fields
    _validateApplicantAddressFields(newAddressData);

    update(); // Trigger UI update
  }

  // Validate applicant address fields
  void _validateApplicantAddressFields(Map<String, String> addressData) {
    if (addressData['address']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['address'] =
          'Applicant address is required';
    }
    if (addressData['pincode']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['pincode'] = 'Pincode is required';
    }
    if (addressData['village']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['village'] = 'Village is required';
    }
    if (addressData['postOffice']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['postOffice'] =
          'Post Office is required';
    }
  }

  // Clear applicant address fields
  void clearApplicantAddressFields() {
    applicantAddressData.clear();
    applicantAddressValidationErrors.clear();
    applicantAddressControllers.values
        .forEach((controller) => controller.clear());
    countingApplicantAddressController.clear();
  }

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
  //     case 'government_counting_details':
  //       return _validateGovernmentCountingDetails();
  //     default:
  //       return true;
  //   }
  // }

  bool _validateGovernmentCountingDetails() {
    // Validate required fields
    if (governmentCountingOfficerController.text.trim().isEmpty) return false;
    if (governmentCountingOfficerAddressController.text.trim().isEmpty)
      return false;
    if (governmentCountingOrderNumberController.text.trim().isEmpty)
      return false;
    if (governmentCountingOrderDateController.text.trim().isEmpty) return false;
    if (governmentCountingDetailsController.text.trim().isEmpty) return false;
    if (governmentCountingOrderFiles.isEmpty) return false;

    // Additional validation
    if (governmentCountingOfficerController.text.trim().length < 2)
      return false;
    if (governmentCountingOfficerAddressController.text.trim().length < 5)
      return false;
    if (governmentCountingOrderNumberController.text.trim().length < 3)
      return false;
    if (governmentCountingDetailsController.text.trim().length < 10)
      return false;

    // Validate applicant address
    _validateApplicantAddressFields(applicantAddressData);
    if (applicantAddressValidationErrors.isNotEmpty) return false;

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
    if (applicantAddressValidationErrors.isNotEmpty) {
      return 'Please complete the applicant address details';
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
      'government_counting_officer':
          governmentCountingOfficerController.text.trim(),
      'government_counting_officer_address':
          governmentCountingOfficerAddressController.text.trim(),
      'government_counting_order_number':
          governmentCountingOrderNumberController.text.trim(),
      'government_counting_order_date':
          governmentCountingOrderDateController.text.trim(),
      'government_counting_order_date_object':
          governmentCountingOrderDate.value?.toIso8601String(),
      'counting_applicant_name': countingApplicantNameController.text.trim(),
      'counting_applicant_address': getFormattedApplicantAddress(),
      'counting_applicant_address_details':
          Map<String, String>.from(applicantAddressData),
      'government_counting_details':
          governmentCountingDetailsController.text.trim(),
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
    clearApplicantAddressFields(); // Use new address clearing method
    governmentCountingDetailsController.clear();
    governmentCountingOrderDate.value = null;
    governmentCountingOrderFiles.clear();
  }

  void loadData(Map<String, dynamic> data) {
    governmentCountingOfficerController.text =
        data['government_counting_officer'] ?? '';
    governmentCountingOfficerAddressController.text =
        data['government_counting_officer_address'] ?? '';
    governmentCountingOrderNumberController.text =
        data['government_counting_order_number'] ?? '';
    governmentCountingOrderDateController.text =
        data['government_counting_order_date'] ?? '';
    countingApplicantNameController.text =
        data['counting_applicant_name'] ?? '';
    governmentCountingDetailsController.text =
        data['government_counting_details'] ?? '';

    // Load applicant address data
    if (data['counting_applicant_address_details'] != null) {
      final addressDetails =
          Map<String, String>.from(data['counting_applicant_address_details']);
      updateApplicantAddress(addressDetails);
    } else if (data['counting_applicant_address'] != null) {
      countingApplicantAddressController.text =
          data['counting_applicant_address'];
    }

    // Load date object if exists
    if (data['government_counting_order_date_object'] != null) {
      try {
        governmentCountingOrderDate.value =
            DateTime.parse(data['government_counting_order_date_object']);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    // Load files if exists
    if (data['government_counting_order_files'] != null) {
      governmentCountingOrderFiles.assignAll(
          List<String>.from(data['government_counting_order_files']));
    }
  }
}
