// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../../CourtCommissionCaseView/Controller/main_controller.dart';
//
// class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Text Controllers
//   final courtNameController = TextEditingController();
//   final courtAddressController = TextEditingController();
//   final commissionOrderNoController = TextEditingController();
//   final commissionDateController = TextEditingController();
//   final civilClaimController = TextEditingController();
//   final issuingOfficeController = TextEditingController();
//   final applicantNameController = TextEditingController();
//   final applicantAddressController = TextEditingController();
//
//   // Date selection
//   final selectedCommissionDate = Rxn<DateTime>();
//
//   // File upload
//   final commissionOrderFiles = <String>[].obs;
//
//   // Validation states
//   final validationErrors = <String, String>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeValidation();
//   }
//
//   @override
//   void onClose() {
//     courtNameController.dispose();
//     courtAddressController.dispose();
//     commissionOrderNoController.dispose();
//     commissionDateController.dispose();
//     civilClaimController.dispose();
//     issuingOfficeController.dispose();
//     super.onClose();
//   }
//
//   void _initializeValidation() {
//     // Initialize validation states
//     validationErrors.clear();
//   }
//
//   // Update commission date
//   void updateCommissionDate(DateTime date) {
//     selectedCommissionDate.value = date;
//     commissionDateController.text = _formatDate(date);
//     _clearFieldError('commission_date');
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
//   }
//
//   void _clearFieldError(String field) {
//     validationErrors.remove(field);
//   }
//
//   // Validation Methods
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'government_survey':
//         return true; // Temporarily return true to bypass validation
//       default:
//         return true;
//     }
//   }
//   // bool validateCurrentSubStep(String field) {
//   //   switch (field) {
//   //     case 'court_commission_details':
//   //       return _validateCourtCommissionDetails();
//   //     default:
//   //       return true;
//   //   }
//   // }
//
//   bool _validateCourtCommissionDetails() {
//     validationErrors.clear();
//     bool isValid = true;
//
//     // Validate court name
//     if (courtNameController.text.trim().isEmpty) {
//       validationErrors['court_name'] = 'Court name is required';
//       isValid = false;
//     } else if (courtNameController.text.trim().length < 3) {
//       validationErrors['court_name'] = 'Court name must be at least 3 characters';
//       isValid = false;
//     }
//
//     // Validate court address
//     if (courtAddressController.text.trim().isEmpty) {
//       validationErrors['court_address'] = 'Court address is required';
//       isValid = false;
//     } else if (courtAddressController.text.trim().length < 10) {
//       validationErrors['court_address'] = 'Address must be at least 10 characters';
//       isValid = false;
//     }
//
//     // Validate commission order number
//     if (commissionOrderNoController.text.trim().isEmpty) {
//       validationErrors['commission_order_no'] = 'Commission order number is required';
//       isValid = false;
//     } else if (commissionOrderNoController.text.trim().length < 3) {
//       validationErrors['commission_order_no'] = 'Order number must be at least 3 characters';
//       isValid = false;
//     }
//
//     // Validate commission date
//     if (selectedCommissionDate.value == null) {
//       validationErrors['commission_date'] = 'Commission date is required';
//       isValid = false;
//     }
//
//     // Validate civil claim
//     if (civilClaimController.text.trim().isEmpty) {
//       validationErrors['civil_claim'] = 'Civil claim details are required';
//       isValid = false;
//     } else if (civilClaimController.text.trim().length < 5) {
//       validationErrors['civil_claim'] = 'Civil claim must be at least 5 characters';
//       isValid = false;
//     }
//
//     // Validate issuing office
//     if (issuingOfficeController.text.trim().isEmpty) {
//       validationErrors['issuing_office'] = 'Issuing office details are required';
//       isValid = false;
//     } else if (issuingOfficeController.text.trim().length < 5) {
//       validationErrors['issuing_office'] = 'Office details must be at least 5 characters';
//       isValid = false;
//     }
//
//     // Validate file upload
//     if (commissionOrderFiles.isEmpty) {
//       validationErrors['commission_order_file'] = 'Commission order document is required';
//       isValid = false;
//     }
//
//     return isValid;
//   }
//
//   @override
//   bool isStepCompleted(List<String> fields) {
//     for (String field in fields) {
//       if (!validateCurrentSubStep(field)) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   @override
//   String getFieldError(String field) {
//     switch (field) {
//       case 'court_commission_details':
//         if (validationErrors.isNotEmpty) {
//           return validationErrors.values.first;
//         }
//         return 'Please fill all required fields';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   @override
//   Map<String, dynamic> getStepData() {
//     return {
//       'court_name': courtNameController.text.trim(),
//       'court_address': courtAddressController.text.trim(),
//       'commission_order_no': commissionOrderNoController.text.trim(),
//       'commission_date': selectedCommissionDate.value?.toIso8601String(),
//       'civil_claim': civilClaimController.text.trim(),
//       'issuing_office': issuingOfficeController.text.trim(),
//       'commission_order_files': commissionOrderFiles.toList(),
//       'step_completed_at': DateTime.now().toIso8601String(),
//     };
//   }
//
//   // Helper methods for UI
//   String? getFieldValidationError(String field) {
//     return validationErrors[field];
//   }
//
//   bool hasFieldError(String field) {
//     return validationErrors.containsKey(field);
//   }
// }
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../CourtCommissionCaseView/Controller/main_controller.dart';
import '../../Widget/address.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
  // Text Controllers
  final courtNameController = TextEditingController();
  final courtAddressController = TextEditingController();
  final commissionOrderNoController = TextEditingController();
  final commissionDateController = TextEditingController();
  final civilClaimController = TextEditingController();
  final issuingOfficeController = TextEditingController();
  final applicantNameController = TextEditingController();
  final applicantAddressController = TextEditingController(); // Keep for backward compatibility

  // Date selection
  final selectedCommissionDate = Rxn<DateTime>();

  // File upload
  final commissionOrderFiles = <String>[].obs;

  // Validation states
  final validationErrors = <String, String>{}.obs;

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
    applicantNameController.dispose();
    applicantAddressController.dispose();

    // Dispose address controllers
    applicantAddressControllers.values.forEach((controller) => controller.dispose());

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
    applicantAddressControllers['plotNoController']!.text = applicantAddressData['plotNo'] ?? '';
    applicantAddressControllers['addressController']!.text = applicantAddressData['address'] ?? '';
    applicantAddressControllers['mobileNumberController']!.text = applicantAddressData['mobileNumber'] ?? '';
    applicantAddressControllers['emailController']!.text = applicantAddressData['email'] ?? '';
    applicantAddressControllers['pincodeController']!.text = applicantAddressData['pincode'] ?? '';
    applicantAddressControllers['districtController']!.text = applicantAddressData['district'] ?? '';
    applicantAddressControllers['villageController']!.text = applicantAddressData['village'] ?? '';
    applicantAddressControllers['postOfficeController']!.text = applicantAddressData['postOffice'] ?? '';

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
      'mobileNumber': applicantAddressControllers['mobileNumberController']!.text,
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
    applicantAddressController.text = getFormattedApplicantAddress();

    // Clear validation errors
    applicantAddressValidationErrors.clear();

    // Validate address fields
    _validateApplicantAddressFields(newAddressData);

    update(); // Trigger UI update
  }

  // Validate applicant address fields
  void _validateApplicantAddressFields(Map<String, String> addressData) {
    if (addressData['address']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['address'] = 'Applicant address is required';
    }
    if (addressData['pincode']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['pincode'] = 'Pincode is required';
    }
    if (addressData['village']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['village'] = 'Village is required';
    }
    if (addressData['postOffice']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['postOffice'] = 'Post Office is required';
    }
  }

  // Clear applicant address fields
  void clearApplicantAddressFields() {
    applicantAddressData.clear();
    applicantAddressValidationErrors.clear();
    applicantAddressControllers.values.forEach((controller) => controller.clear());
    applicantAddressController.clear();
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

    // Validate applicant name
    if (applicantNameController.text.trim().isEmpty) {
      validationErrors['applicant_name'] = 'Applicant name is required';
      isValid = false;
    } else if (applicantNameController.text.trim().length < 3) {
      validationErrors['applicant_name'] = 'Applicant name must be at least 3 characters';
      isValid = false;
    }

    // Validate applicant address using new validation
    _validateApplicantAddressFields(applicantAddressData);
    if (applicantAddressValidationErrors.isNotEmpty) {
      validationErrors['applicant_address'] = 'Please complete the applicant address details';
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
      'applicant_name': applicantNameController.text.trim(),
      'applicant_address': getFormattedApplicantAddress(),
      'applicant_address_details': Map<String, String>.from(applicantAddressData),
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

  // Utility methods
  void clearAllFields() {
    courtNameController.clear();
    courtAddressController.clear();
    commissionOrderNoController.clear();
    commissionDateController.clear();
    civilClaimController.clear();
    issuingOfficeController.clear();
    applicantNameController.clear();
    clearApplicantAddressFields(); // Use new address clearing method
    commissionOrderFiles.clear();
    selectedCommissionDate.value = null;
    validationErrors.clear();
  }

  void loadStepData(Map<String, dynamic> data) {
    courtNameController.text = data['court_name'] ?? '';
    courtAddressController.text = data['court_address'] ?? '';
    commissionOrderNoController.text = data['commission_order_no'] ?? '';
    civilClaimController.text = data['civil_claim'] ?? '';
    issuingOfficeController.text = data['issuing_office'] ?? '';
    applicantNameController.text = data['applicant_name'] ?? '';

    // Load applicant address data
    if (data['applicant_address_details'] != null) {
      final addressDetails = Map<String, String>.from(data['applicant_address_details']);
      updateApplicantAddress(addressDetails);
    } else if (data['applicant_address'] != null) {
      applicantAddressController.text = data['applicant_address'];
    }

    // Load commission date if exists
    if (data['commission_date'] != null) {
      try {
        selectedCommissionDate.value = DateTime.parse(data['commission_date']);
        commissionDateController.text = _formatDate(selectedCommissionDate.value!);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    // Load files if exists
    if (data['commission_order_files'] != null) {
      commissionOrderFiles.assignAll(List<String>.from(data['commission_order_files']));
    }
  }
}