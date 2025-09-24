// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../Controller/main_controller.dart';
//
// class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
//
//   // Text Controllers
//   final applicantNameController = TextEditingController();
//   final applicantAddressController = TextEditingController();
//   final courtNameController = TextEditingController();
//   final courtAddressController = TextEditingController();
//   final courtOrderNumberController = TextEditingController();
//   final courtAllotmentDateController = TextEditingController();
//   final claimNumberYearController = TextEditingController();
//   final specialOrderCommentsController = TextEditingController();
//
//   // File Upload Lists
//   final courtOrderFiles = <String>[].obs;
//
//   // Date Selection
//   final courtAllotmentDate = Rxn<DateTime>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeControllers();
//   }
//
//   void _initializeControllers() {
//     // Initialize any default values if needed
//   }
//
//   @override
//   void onClose() {
//     // Dispose text controllers
//     courtNameController.dispose();
//     courtAddressController.dispose();
//     courtOrderNumberController.dispose();
//     courtAllotmentDateController.dispose();
//     claimNumberYearController.dispose();
//     specialOrderCommentsController.dispose();
//     super.onClose();
//   }
//
//   // Date Update Methods
//   void updateCourtAllotmentDate(DateTime selectedDate) {
//     courtAllotmentDate.value = selectedDate;
//     courtAllotmentDateController.text =
//     "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
//   }
//
//   // Field Validation Methods
//   bool _validateCourtName() {
//     return courtNameController.text.trim().isNotEmpty &&
//         courtNameController.text.trim().length >= 3;
//   }
//
//   bool _validateCourtAddress() {
//     return courtAddressController.text.trim().isNotEmpty &&
//         courtAddressController.text.trim().length >= 10;
//   }
//
//   bool _validateCourtOrderNumber() {
//     return courtOrderNumberController.text.trim().isNotEmpty &&
//         courtOrderNumberController.text.trim().length >= 3;
//   }
//
//   bool _validateCourtAllotmentDate() {
//     return courtAllotmentDateController.text.trim().isNotEmpty &&
//         courtAllotmentDate.value != null;
//   }
//
//   bool _validateClaimNumberYear() {
//     return claimNumberYearController.text.trim().isNotEmpty &&
//         claimNumberYearController.text.trim().length >= 4;
//   }
//
//   bool _validateCourtOrderFiles() {
//     return courtOrderFiles.isNotEmpty;
//   }
//
//   bool _validateSpecialOrderComments() {
//     return specialOrderCommentsController.text.trim().isNotEmpty &&
//         specialOrderCommentsController.text.trim().length >= 10;
//   }
//
//   // Step Validation Mixin Implementation
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'calculation':
//         return true; // Temporarily return true to bypass validation
//       default:
//         return true;
//     }
//   }
//   // bool validateCurrentSubStep(String field) {
//   //   switch (field) {
//   //     case 'calculation':
//   //       return _validateCourtName() &&
//   //           _validateCourtAddress() &&
//   //           _validateCourtOrderNumber() &&
//   //           _validateCourtAllotmentDate() &&
//   //           _validateClaimNumberYear() &&
//   //           _validateCourtOrderFiles() &&
//   //           _validateSpecialOrderComments();
//   //     default:
//   //       return true;
//   //   }
//   // }
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
//       case 'calculation':
//         if (!_validateCourtName()) {
//           return 'Court name is required (minimum 3 characters)';
//         }
//         if (!_validateCourtAddress()) {
//           return 'Court address is required (minimum 10 characters)';
//         }
//         if (!_validateCourtOrderNumber()) {
//           return 'Court order number is required (minimum 3 characters)';
//         }
//         if (!_validateCourtAllotmentDate()) {
//           return 'Court allotment date is required';
//         }
//         if (!_validateClaimNumberYear()) {
//           return 'Claim number and year is required (minimum 4 characters)';
//         }
//         if (!_validateCourtOrderFiles()) {
//           return 'Court allocation order document is required';
//         }
//         if (!_validateSpecialOrderComments()) {
//           return 'Special order or comments are required (minimum 10 characters)';
//         }
//         return 'Please fill all required fields';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   // Step Data Mixin Implementation
//   @override
//   Map<String, dynamic> getStepData() {
//     return {
//       'courtName': courtNameController.text.trim(),
//       'courtAddress': courtAddressController.text.trim(),
//       'courtOrderNumber': courtOrderNumberController.text.trim(),
//       'courtAllotmentDate': courtAllotmentDateController.text.trim(),
//       'courtAllotmentDateValue': courtAllotmentDate.value?.toIso8601String(),
//       'claimNumberYear': claimNumberYearController.text.trim(),
//       'courtOrderFiles': courtOrderFiles.toList(),
//       'specialOrderComments': specialOrderCommentsController.text.trim(),
//       'stepCompleted': isStepCompleted(['calculation']),
//       'timestamp': DateTime.now().toIso8601String(),
//     };
//   }
//
//   // Helper Methods
//   void clearAllFields() {
//     courtNameController.clear();
//     courtAddressController.clear();
//     courtOrderNumberController.clear();
//     courtAllotmentDateController.clear();
//     claimNumberYearController.clear();
//     specialOrderCommentsController.clear();
//     courtOrderFiles.clear();
//     courtAllotmentDate.value = null;
//   }
//
//   // Load data from saved state
//   void loadStepData(Map<String, dynamic> data) {
//     courtNameController.text = data['courtName'] ?? '';
//     courtAddressController.text = data['courtAddress'] ?? '';
//     courtOrderNumberController.text = data['courtOrderNumber'] ?? '';
//     courtAllotmentDateController.text = data['courtAllotmentDate'] ?? '';
//     claimNumberYearController.text = data['claimNumberYear'] ?? '';
//     specialOrderCommentsController.text = data['specialOrderComments'] ?? '';
//
//     if (data['courtOrderFiles'] != null) {
//       courtOrderFiles.assignAll(List<String>.from(data['courtOrderFiles']));
//     }
//
//     if (data['courtAllotmentDateValue'] != null) {
//       courtAllotmentDate.value = DateTime.parse(data['courtAllotmentDateValue']);
//     }
//   }
//
// }


import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';
import '../../Widget/address.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {

  // Text Controllers
  final applicantNameController = TextEditingController();
  final applicantAddressController = TextEditingController(); // Keep for backward compatibility
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
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize any default values if needed
  }

  @override
  void onClose() {
    // Dispose text controllers
    applicantNameController.dispose();
    applicantAddressController.dispose();
    courtNameController.dispose();
    courtAddressController.dispose();
    courtOrderNumberController.dispose();
    courtAllotmentDateController.dispose();
    claimNumberYearController.dispose();
    specialOrderCommentsController.dispose();

    // Dispose address controllers
    applicantAddressControllers.values.forEach((controller) => controller.dispose());

    super.onClose();
  }

  // Date Update Methods
  void updateCourtAllotmentDate(DateTime selectedDate) {
    courtAllotmentDate.value = selectedDate;
    courtAllotmentDateController.text =
    "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
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

  // Field Validation Methods
  bool _validateApplicantName() {
    return applicantNameController.text.trim().isNotEmpty &&
        applicantNameController.text.trim().length >= 3;
  }

  bool _validateApplicantAddress() {
    // Validate address fields first
    _validateApplicantAddressFields(applicantAddressData);
    return applicantAddressValidationErrors.isEmpty;
  }

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
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'calculation':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }
  // bool validateCurrentSubStep(String field) {
  //   switch (field) {
  //     case 'calculation':
  //       return _validateApplicantName() &&
  //           _validateApplicantAddress() &&
  //           _validateCourtName() &&
  //           _validateCourtAddress() &&
  //           _validateCourtOrderNumber() &&
  //           _validateCourtAllotmentDate() &&
  //           _validateClaimNumberYear() &&
  //           _validateCourtOrderFiles() &&
  //           _validateSpecialOrderComments();
  //     default:
  //       return true;
  //   }
  // }

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
        if (!_validateApplicantName()) {
          return 'Applicant name is required (minimum 3 characters)';
        }
        if (!_validateApplicantAddress()) {
          return 'Please complete the applicant address details';
        }
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
      'applicantName': applicantNameController.text.trim(),
      'applicantAddress': getFormattedApplicantAddress(),
      'applicantAddressDetails': Map<String, String>.from(applicantAddressData),
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
    applicantNameController.clear();
    clearApplicantAddressFields(); // Clear address fields
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
    applicantNameController.text = data['applicantName'] ?? '';
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

    // Load applicant address data
    if (data['applicantAddressDetails'] != null) {
      final addressDetails = Map<String, String>.from(data['applicantAddressDetails']);
      updateApplicantAddress(addressDetails);
    } else if (data['applicantAddress'] != null) {
      applicantAddressController.text = data['applicantAddress'];
    }
  }
}