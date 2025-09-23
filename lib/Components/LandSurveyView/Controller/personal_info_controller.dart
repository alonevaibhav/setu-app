// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'main_controller.dart';
//
// class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Form Controllers
//   final applicantNameController = TextEditingController();
//   final applicantAddressController = TextEditingController();
//   final applicantPhoneController = TextEditingController();
//   final relationshipController = TextEditingController();
//   final relationshipWithApplicantController = TextEditingController();
//   final poaRegistrationNumberController = TextEditingController();
//   final poaRegistrationDateController = TextEditingController();
//   final poaIssuerNameController = TextEditingController();
//   final poaHolderNameController = TextEditingController();
//   final poaHolderAddressController = TextEditingController();
//   final poaDocument = <String>[].obs;
//
//
//   // Observable boolean values for questions
//   final isHolderThemselves = Rxn<bool>();
//   final hasAuthorityOnBehalf = Rxn<bool>();
//   final hasBeenCountedBefore = Rxn<bool>();
//
//   @override
//   void onClose() {
//     // Dispose all controllers
//     applicantNameController.dispose();
//     applicantPhoneController.dispose();
//     relationshipController.dispose();
//     relationshipWithApplicantController.dispose();
//     poaRegistrationNumberController.dispose();
//     poaRegistrationDateController.dispose();
//     poaIssuerNameController.dispose();
//     poaHolderNameController.dispose();
//     poaHolderAddressController.dispose();
//     super.onClose();
//   }
//
//   // Reset methods for dependent fields
//   void resetAuthorityFields() {
//     hasAuthorityOnBehalf.value = null;
//     applicantPhoneController.clear();
//     relationshipController.clear();
//     relationshipWithApplicantController.clear();
//     clearPOAFields();
//   }
//
//   void clearPOAFields() {
//     poaRegistrationNumberController.clear();
//     poaRegistrationDateController.clear();
//     poaIssuerNameController.clear();
//     poaHolderNameController.clear();
//     poaHolderAddressController.clear();
//   }
//
//   // Handle holder themselves selection
//   void updateHolderThemselves(bool? value) {
//     isHolderThemselves.value = value;
//     if (value == true) {
//       resetAuthorityFields();
//     }
//   }
//
//   // Handle authority on behalf selection
//   void updateAuthorityOnBehalf(bool? value) {
//     hasAuthorityOnBehalf.value = value;
//     if (value != true) {
//       clearPOAFields();
//     }
//   }
//
//   // Handle enumeration check
//   void updateEnumerationCheck(bool? value) {
//     hasBeenCountedBefore.value = value;
//   }
//
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
//   //     case 'holder_verification':
//   //     // Check if holder themselves is selected
//   //       if (isHolderThemselves.value == null) return false;
//   //
//   //       // If not holder themselves, check authority
//   //       if (isHolderThemselves.value == false) {
//   //         if (hasAuthorityOnBehalf.value == null) return false;
//   //
//   //         // If has authority, validate POA fields
//   //         if (hasAuthorityOnBehalf.value == true) {
//   //           return _validatePOAFields();
//   //         }
//   //       }
//   //       return true;
//   //
//   //     case 'enumeration_check':
//   //       return hasBeenCountedBefore.value != null;
//   //
//   //     default:
//   //       return true;
//   //   }
//   // }
//
//   bool _validatePOAFields() {
//     return poaRegistrationNumberController.text.trim().length >= 3 &&
//         poaRegistrationDateController.text.trim().isNotEmpty &&
//         poaIssuerNameController.text.trim().length >= 2 &&
//         poaHolderNameController.text.trim().length >= 2 &&
//         poaHolderAddressController.text.trim().length >= 5;
//   }
//
//   @override
//   bool isStepCompleted(List<String> fields) {
//     for (String field in fields) {
//       if (!validateCurrentSubStep(field)) return false;
//     }
//     return true;
//   }
//
//   @override
//   String getFieldError(String field) {
//     switch (field) {
//       case 'holder_verification':
//         if (isHolderThemselves.value == null) {
//           return 'Please select if you are the holder';
//         }
//         if (isHolderThemselves.value == false &&
//             hasAuthorityOnBehalf.value == null) {
//           return 'Please select if you have authority on behalf';
//         }
//         if (isHolderThemselves.value == false &&
//             hasAuthorityOnBehalf.value == true) {
//           return _getPOAValidationError();
//         }
//         return 'Please complete holder verification';
//
//       case 'enumeration_check':
//         return 'Please select if this has been counted before';
//
//       default:
//         return 'This field is required';
//     }
//   }
//
//   String _getPOAValidationError() {
//     if (poaRegistrationNumberController.text.trim().length < 3) {
//       return 'Registration number must be at least 3 characters';
//     }
//     if (poaRegistrationDateController.text.trim().isEmpty) {
//       return 'Registration date is required';
//     }
//     if (poaIssuerNameController.text.trim().length < 2) {
//       return 'Issuer name must be at least 2 characters';
//     }
//     if (poaHolderNameController.text.trim().length < 2) {
//       return 'Holder name must be at least 2 characters';
//     }
//     if (poaHolderAddressController.text.trim().length < 5) {
//       return 'Address must be at least 5 characters';
//     }
//     return 'Please complete all Power of Attorney fields';
//   }
//
//   @override
//   Map<String, dynamic> getStepData() {
//     return {
//       'personal_info': {
//         'is_holder_themselves': isHolderThemselves.value,
//         'has_authority_on_behalf': hasAuthorityOnBehalf.value,
//         'has_been_counted_before': hasBeenCountedBefore.value,
//         'applicant_name': applicantNameController.text.trim(),
//         'applicant_phone': applicantPhoneController.text.trim(),
//         'relationship': relationshipController.text.trim(),
//         'relationship_with_applicant': relationshipWithApplicantController.text.trim(),
//         'poa_registration_number': poaRegistrationNumberController.text.trim(),
//         'poa_registration_date': poaRegistrationDateController.text.trim(),
//         'poa_issuer_name': poaIssuerNameController.text.trim(),
//         'poa_holder_name': poaHolderNameController.text.trim(),
//         'poa_holder_address': poaHolderAddressController.text.trim(),
//       }
//     };
//   }
//
//   // Utility method to check if POA fields should be shown
//   bool get shouldShowPOAFields {
//     return isHolderThemselves.value == false &&
//         hasAuthorityOnBehalf.value == true;
//   }
//
//   // Utility method to check if authority question should be shown
//   bool get shouldShowAuthorityQuestion {
//     return isHolderThemselves.value == false;
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';
import '../../Widget/address.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
  // Form Controllers
  final applicantNameController = TextEditingController();
  final applicantAddressController = TextEditingController(); // Keep for backward compatibility
  final applicantPhoneController = TextEditingController();
  final relationshipController = TextEditingController();
  final relationshipWithApplicantController = TextEditingController();
  final poaRegistrationNumberController = TextEditingController();
  final poaRegistrationDateController = TextEditingController();
  final poaIssuerNameController = TextEditingController();
  final poaHolderNameController = TextEditingController();
  final poaHolderAddressController = TextEditingController();
  final poaDocument = <String>[].obs;





  // Observable boolean values for questions
  final isHolderThemselves = Rxn<bool>();
  final hasAuthorityOnBehalf = Rxn<bool>();
  final hasBeenCountedBefore = Rxn<bool>();

  @override
  void onClose() {
    // Dispose all controllers
    applicantNameController.dispose();
    applicantAddressController.dispose();
    applicantPhoneController.dispose();
    relationshipController.dispose();
    relationshipWithApplicantController.dispose();
    poaRegistrationNumberController.dispose();
    poaRegistrationDateController.dispose();
    poaIssuerNameController.dispose();
    poaHolderNameController.dispose();
    poaHolderAddressController.dispose();

    // Dispose address controllers
    applicantAddressControllers.values.forEach((controller) => controller.dispose());

    super.onClose();
  }

  // Reset methods for dependent fields
  void resetAuthorityFields() {
    hasAuthorityOnBehalf.value = null;
    applicantPhoneController.clear();
    relationshipController.clear();
    relationshipWithApplicantController.clear();
    clearPOAFields();
  }

  void clearPOAFields() {
    poaRegistrationNumberController.clear();
    poaRegistrationDateController.clear();
    poaIssuerNameController.clear();
    poaHolderNameController.clear();
    poaHolderAddressController.clear();
  }

  // Handle holder themselves selection
  void updateHolderThemselves(bool? value) {
    isHolderThemselves.value = value;
    if (value == true) {
      resetAuthorityFields();
    }
  }

  // Handle authority on behalf selection
  void updateAuthorityOnBehalf(bool? value) {
    hasAuthorityOnBehalf.value = value;
    if (value != true) {
      clearPOAFields();
    }
  }

  // Handle enumeration check
  void updateEnumerationCheck(bool? value) {
    hasBeenCountedBefore.value = value;
  }


  //------------------------Address  ------------------------//

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

  // Address validation errors
  final applicantAddressValidationErrors = <String, String>{}.obs;

  // Address controllers for the popup
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

  // Address popup functionality
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

    return parts.isEmpty ? 'Click to add address' : parts.join(', ');
  }

  // Check if detailed address is available
  bool hasDetailedApplicantAddress() {
    return applicantAddressData.isNotEmpty &&
        (applicantAddressData['address']?.isNotEmpty == true ||
            applicantAddressData['village']?.isNotEmpty == true);
  }

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
        entryIndex: 0, // Use 0 as a placeholder since we're not dealing with multiple entries
        controllers: applicantAddressControllers,
        onSave: () => _saveApplicantAddressFromPopup(),
      ),
    );
  }

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

  void _validateApplicantAddressFields(Map<String, String> addressData) {
    if (addressData['address']?.trim().isEmpty ?? true) {
      applicantAddressValidationErrors['address'] = 'Address is required';
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
  //     case 'holder_verification':
  //       // Validate applicant name
  //       if (applicantNameController.text.trim().length < 3) return false;
  //
  //       // Validate applicant address
  //       _validateApplicantAddressFields(applicantAddressData);
  //       if (applicantAddressValidationErrors.isNotEmpty) return false;
  //
  //       // Check if holder themselves is selected
  //       if (isHolderThemselves.value == null) return false;
  //
  //       // If not holder themselves, check authority
  //       if (isHolderThemselves.value == false) {
  //         if (hasAuthorityOnBehalf.value == null) return false;
  //
  //         // If has authority, validate POA fields
  //         if (hasAuthorityOnBehalf.value == true) {
  //           return _validatePOAFields();
  //         }
  //       }
  //       return true;
  //
  //     case 'enumeration_check':
  //       return hasBeenCountedBefore.value != null;
  //
  //     default:
  //       return true;
  //   }
  // }

  bool _validatePOAFields() {
    return poaRegistrationNumberController.text.trim().length >= 3 &&
        poaRegistrationDateController.text.trim().isNotEmpty &&
        poaIssuerNameController.text.trim().length >= 2 &&
        poaHolderNameController.text.trim().length >= 2 &&
        poaHolderAddressController.text.trim().length >= 5;
  }

  @override
  bool isStepCompleted(List<String> fields) {
    for (String field in fields) {
      if (!validateCurrentSubStep(field)) return false;
    }
    return true;
  }

  @override
  String getFieldError(String field) {
    switch (field) {
      case 'holder_verification':
        if (applicantNameController.text.trim().length < 3) {
          return 'Please enter a valid applicant name';
        }
        if (applicantAddressValidationErrors.isNotEmpty) {
          return 'Please complete the applicant address';
        }
        if (isHolderThemselves.value == null) {
          return 'Please select if you are the holder';
        }
        if (isHolderThemselves.value == false &&
            hasAuthorityOnBehalf.value == null) {
          return 'Please select if you have authority on behalf';
        }
        if (isHolderThemselves.value == false &&
            hasAuthorityOnBehalf.value == true) {
          return _getPOAValidationError();
        }
        return 'Please complete holder verification';

      case 'enumeration_check':
        return 'Please select if this has been counted before';

      default:
        return 'This field is required';
    }
  }

  String _getPOAValidationError() {
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
    return 'Please complete all Power of Attorney fields';
  }

  @override
  Map<String, dynamic> getStepData() {
    return {
      'personal_info': {
        'is_holder_themselves': isHolderThemselves.value,
        'has_authority_on_behalf': hasAuthorityOnBehalf.value,
        'has_been_counted_before': hasBeenCountedBefore.value,
        'applicant_name': applicantNameController.text.trim(),
        'applicant_address': getFormattedApplicantAddress(),
        'applicant_address_details': Map<String, String>.from(applicantAddressData),
        'applicant_phone': applicantPhoneController.text.trim(),
        'relationship': relationshipController.text.trim(),
        'relationship_with_applicant': relationshipWithApplicantController.text.trim(),
        'poa_registration_number': poaRegistrationNumberController.text.trim(),
        'poa_registration_date': poaRegistrationDateController.text.trim(),
        'poa_issuer_name': poaIssuerNameController.text.trim(),
        'poa_holder_name': poaHolderNameController.text.trim(),
        'poa_holder_address': poaHolderAddressController.text.trim(),
      }
    };
  }

  // Utility method to check if POA fields should be shown
  bool get shouldShowPOAFields {
    return isHolderThemselves.value == false &&
        hasAuthorityOnBehalf.value == true;
  }

  // Utility method to check if authority question should be shown
  bool get shouldShowAuthorityQuestion {
    return isHolderThemselves.value == false;
  }
}