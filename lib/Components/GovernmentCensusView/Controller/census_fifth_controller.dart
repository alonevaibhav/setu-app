// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../Widget/address.dart';
// import '../Controller/main_controller.dart';
//
// class CensusFifthController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Observable list of applicant entries
//   final applicantEntries = <Map<String, dynamic>>[].obs;
//
//   // Loading states
//   final isLoading = false.obs;
//
//   // Validation errors
//   final validationErrors = <String, String>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with one entry
//     addApplicantEntry();
//   }
//
//   // Add new applicant entry
//   void addApplicantEntry() {
//     final newEntry = {
//       'id': DateTime.now().millisecondsSinceEpoch.toString(),
//       'agreementController': TextEditingController(),
//       'accountHolderNameController': TextEditingController(),
//       'accountNumberController': TextEditingController(),
//       'mobileNumberController': TextEditingController(),
//       'serverNumberController': TextEditingController(),
//       'areaController': TextEditingController(),
//       'potkaharabaAreaController': TextEditingController(),
//       'totalAreaController': TextEditingController(),
//       // Address fields
//       'address': <String, dynamic>{
//         'plotNo': '',
//         'address': '',
//         'mobileNumber': '',
//         'email': '',
//         'pincode': '',
//         'district': '',
//         'village': '',
//         'postOffice': '',
//       }.obs,
//       // Controllers for address popup
//       'addressControllers': {
//         'plotNoController': TextEditingController(),
//         'addressController': TextEditingController(),
//         'mobileNumberController': TextEditingController(),
//         'emailController': TextEditingController(),
//         'pincodeController': TextEditingController(),
//         'districtController': TextEditingController(),
//         'villageController': TextEditingController(),
//         'postOfficeController': TextEditingController(),
//       },
//     };
//     applicantEntries.add(newEntry);
//   }
//
//   // Remove applicant entry
//   void removeApplicantEntry(int index) {
//     if (applicantEntries.length > 1) {
//       // Dispose controllers
//       final entry = applicantEntries[index];
//       entry['agreementController']?.dispose();
//       entry['accountHolderNameController']?.dispose();
//       entry['accountNumberController']?.dispose();
//       entry['mobileNumberController']?.dispose();
//       entry['serverNumberController']?.dispose();
//       entry['areaController']?.dispose();
//       entry['potkaharabaAreaController']?.dispose();
//       entry['totalAreaController']?.dispose();
//
//       // Dispose address controllers
//       final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>;
//       addressControllers.values.forEach((controller) => controller.dispose());
//
//       applicantEntries.removeAt(index);
//     }
//   }
//
//   // Update applicant entry field
//   void updateApplicantEntry(int index, String field, String value) {
//     if (index < applicantEntries.length) {
//       // Clear validation error for this field
//       validationErrors.remove('${index}_$field');
//     }
//   }
//
//   // Show address popup
//   Future<void> showAddressPopup(BuildContext context, int entryIndex) async {
//     final entry = applicantEntries[entryIndex];
//     final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>;
//     final addressData = entry['address'] as RxMap<String, dynamic>;
//
//     // Pre-fill controllers with existing data
//     addressControllers['plotNoController']!.text = addressData['plotNo'] ?? '';
//     addressControllers['addressController']!.text = addressData['address'] ?? '';
//     addressControllers['mobileNumberController']!.text = addressData['mobileNumber'] ?? '';
//     addressControllers['emailController']!.text = addressData['email'] ?? '';
//     addressControllers['pincodeController']!.text = addressData['pincode'] ?? '';
//     addressControllers['districtController']!.text = addressData['district'] ?? '';
//     addressControllers['villageController']!.text = addressData['village'] ?? '';
//     addressControllers['postOfficeController']!.text = addressData['postOffice'] ?? '';
//
//     final result = await Get.dialog<bool>(
//       AddressPopup(
//         entryIndex: entryIndex,
//         controllers: addressControllers,
//         onSave: () {
//           _saveAddressData(entryIndex, addressControllers);
//           Get.back(result: true);
//         },
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//   // Save address data
//   void _saveAddressData(int entryIndex, Map<String, TextEditingController> controllers) {
//     final entry = applicantEntries[entryIndex];
//     final addressData = entry['address'] as RxMap<String, dynamic>;
//
//     addressData.addAll({
//       'plotNo': controllers['plotNoController']!.text,
//       'address': controllers['addressController']!.text,
//       'mobileNumber': controllers['mobileNumberController']!.text,
//       'email': controllers['emailController']!.text,
//       'pincode': controllers['pincodeController']!.text,
//       'district': controllers['districtController']!.text,
//       'village': controllers['villageController']!.text,
//       'postOffice': controllers['postOfficeController']!.text,
//     });
//   }
//
//   // Get formatted address string
//   String getFormattedAddress(int entryIndex) {
//     if (entryIndex >= applicantEntries.length) return 'Click to add address';
//
//     final addressData = applicantEntries[entryIndex]['address'] as RxMap<String, dynamic>;
//     final plotNo = addressData['plotNo'] ?? '';
//     final address = addressData['address'] ?? '';
//     final village = addressData['village'] ?? '';
//
//     if (plotNo.isEmpty && address.isEmpty && village.isEmpty) {
//       return 'Click to add address';
//     }
//
//     return [plotNo, address, village].where((s) => s.isNotEmpty).join(', ');
//   }
//
//   // Validation methods
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
//   //   validationErrors.clear();
//   //   bool isValid = true;
//   //
//   //   for (int i = 0; i < applicantEntries.length; i++) {
//   //     final entry = applicantEntries[i];
//   //
//   //     // Check required fields
//   //     if ((entry['agreementController'] as TextEditingController).text.isEmpty) {
//   //       validationErrors['${i}_agreement'] = 'Agreement is required';
//   //       isValid = false;
//   //     }
//   //
//   //     if ((entry['accountHolderNameController'] as TextEditingController).text.isEmpty) {
//   //       validationErrors['${i}_accountHolderName'] = 'Account holder name is required';
//   //       isValid = false;
//   //     }
//   //
//   //     if ((entry['accountNumberController'] as TextEditingController).text.isEmpty) {
//   //       validationErrors['${i}_accountNumber'] = 'Account number is required';
//   //       isValid = false;
//   //     }
//   //
//   //     if ((entry['mobileNumberController'] as TextEditingController).text.isEmpty) {
//   //       validationErrors['${i}_mobileNumber'] = 'Mobile number is required';
//   //       isValid = false;
//   //     }
//   //
//   //     // Validate address data
//   //     final addressData = entry['address'] as RxMap<String, dynamic>;
//   //     if ((addressData['address'] ?? '').isEmpty) {
//   //       validationErrors['${i}_address'] = 'Address is required';
//   //       isValid = false;
//   //     }
//   //
//   //     if ((addressData['pincode'] ?? '').isEmpty) {
//   //       validationErrors['${i}_pincode'] = 'Pincode is required';
//   //       isValid = false;
//   //     }
//   //
//   //     if ((addressData['village'] ?? '').isEmpty) {
//   //       validationErrors['${i}_village'] = 'Village is required';
//   //       isValid = false;
//   //     }
//   //
//   //     if ((addressData['postOffice'] ?? '').isEmpty) {
//   //       validationErrors['${i}_postOffice'] = 'Post Office is required';
//   //       isValid = false;
//   //     }
//   //   }
//   //
//   //   return isValid;
//   // }
//
//   @override
//   bool isStepCompleted(List<String> fields) {
//     return validateCurrentSubStep('');
//   }
//
//   @override
//   String getFieldError(String field) {
//     return validationErrors[field] ?? 'This field is required';
//   }
//
//   @override
//   Map<String, dynamic> getStepData() {
//     final data = <String, dynamic>{};
//
//     for (int i = 0; i < applicantEntries.length; i++) {
//       final entry = applicantEntries[i];
//       final addressData = entry['address'] as RxMap<String, dynamic>;
//
//       data['applicant_$i'] = {
//         'agreement': (entry['agreementController'] as TextEditingController).text,
//         'accountHolderName': (entry['accountHolderNameController'] as TextEditingController).text,
//         'accountNumber': (entry['accountNumberController'] as TextEditingController).text,
//         'mobileNumber': (entry['mobileNumberController'] as TextEditingController).text,
//         'serverNumber': (entry['serverNumberController'] as TextEditingController).text,
//         'area': (entry['areaController'] as TextEditingController).text,
//         'potkaharabaArea': (entry['potkaharabaAreaController'] as TextEditingController).text,
//         'totalArea': (entry['totalAreaController'] as TextEditingController).text,
//         'address': Map<String, dynamic>.from(addressData),
//       };
//     }
//
//     data['applicantCount'] = applicantEntries.length;
//     return data;
//   }
//
//   @override
//   void onClose() {
//     // Dispose all controllers
//     for (final entry in applicantEntries) {
//       entry['agreementController']?.dispose();
//       entry['accountHolderNameController']?.dispose();
//       entry['accountNumberController']?.dispose();
//       entry['mobileNumberController']?.dispose();
//       entry['serverNumberController']?.dispose();
//       entry['areaController']?.dispose();
//       entry['potkaharabaAreaController']?.dispose();
//       entry['totalAreaController']?.dispose();
//
//       final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>;
//       addressControllers.values.forEach((controller) => controller.dispose());
//     }
//     super.onClose();
//   }
// }


import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../Widget/address.dart';
import '../Controller/main_controller.dart';

class CensusFifthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable list of applicant entries
  final applicantEntries = <Map<String, dynamic>>[].obs;

  // Loading states
  final isLoading = false.obs;

  // Validation errors
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one entry
    addApplicantEntry();
  }

  // Add new applicant entry
  void addApplicantEntry() {
    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'agreementController': TextEditingController(),
      'accountHolderNameController': TextEditingController(),
      'accountNumberController': TextEditingController(),
      'mobileNumberController': TextEditingController(),
      'serverNumberController': TextEditingController(),
      'areaController': TextEditingController(),
      'potkaharabaAreaController': TextEditingController(),
      'totalAreaController': TextEditingController(),
      // Address fields
      'address': <String, dynamic>{
        'plotNo': '',
        'address': '',
        'mobileNumber': '',
        'email': '',
        'pincode': '',
        'district': '',
        'village': '',
        'postOffice': '',
      }.obs,
      // Controllers for address popup
      'addressControllers': <String, TextEditingController>{
        'plotNoController': TextEditingController(),
        'addressController': TextEditingController(),
        'mobileNumberController': TextEditingController(),
        'emailController': TextEditingController(),
        'pincodeController': TextEditingController(),
        'districtController': TextEditingController(),
        'villageController': TextEditingController(),
        'postOfficeController': TextEditingController(),
      },
    };
    applicantEntries.add(newEntry);
  }

  // Remove applicant entry
  void removeApplicantEntry(int index) {
    if (applicantEntries.length > 1 && index < applicantEntries.length) {
      // Dispose controllers safely
      final entry = applicantEntries[index];

      // Dispose main controllers
      (entry['agreementController'] as TextEditingController?)?.dispose();
      (entry['accountHolderNameController'] as TextEditingController?)?.dispose();
      (entry['accountNumberController'] as TextEditingController?)?.dispose();
      (entry['mobileNumberController'] as TextEditingController?)?.dispose();
      (entry['serverNumberController'] as TextEditingController?)?.dispose();
      (entry['areaController'] as TextEditingController?)?.dispose();
      (entry['potkaharabaAreaController'] as TextEditingController?)?.dispose();
      (entry['totalAreaController'] as TextEditingController?)?.dispose();

      // Dispose address controllers safely
      final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>?;
      addressControllers?.values.forEach((controller) => controller.dispose());

      applicantEntries.removeAt(index);
    }
  }

  // Update applicant entry field
  void updateApplicantEntry(int index, String field, String value) {
    if (index < applicantEntries.length) {
      // Clear validation error for this field
      validationErrors.remove('${index}_$field');
    }
  }

  // Show address popup
  Future<void> showAddressPopup(BuildContext context, int entryIndex) async {
    if (entryIndex >= applicantEntries.length) return;

    final entry = applicantEntries[entryIndex];
    final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>?;
    final addressData = entry['address'] as RxMap<String, dynamic>?;

    if (addressControllers == null || addressData == null) return;

    // Pre-fill controllers with existing data safely
    addressControllers['plotNoController']?.text = addressData['plotNo']?.toString() ?? '';
    addressControllers['addressController']?.text = addressData['address']?.toString() ?? '';
    addressControllers['mobileNumberController']?.text = addressData['mobileNumber']?.toString() ?? '';
    addressControllers['emailController']?.text = addressData['email']?.toString() ?? '';
    addressControllers['pincodeController']?.text = addressData['pincode']?.toString() ?? '';
    addressControllers['districtController']?.text = addressData['district']?.toString() ?? '';
    addressControllers['villageController']?.text = addressData['village']?.toString() ?? '';
    addressControllers['postOfficeController']?.text = addressData['postOffice']?.toString() ?? '';

    final result = await Get.dialog<bool>(
      AddressPopup(
        entryIndex: entryIndex,
        controllers: addressControllers,
        onSave: () {
          _saveAddressData(entryIndex, addressControllers);
          Get.back(result: true);
        },
      ),
      barrierDismissible: false,
    );
  }

  // Save address data
  void _saveAddressData(int entryIndex, Map<String, TextEditingController> controllers) {
    if (entryIndex >= applicantEntries.length) return;

    final entry = applicantEntries[entryIndex];
    final addressData = entry['address'] as RxMap<String, dynamic>?;

    if (addressData == null) return;

    addressData.addAll({
      'plotNo': controllers['plotNoController']?.text ?? '',
      'address': controllers['addressController']?.text ?? '',
      'mobileNumber': controllers['mobileNumberController']?.text ?? '',
      'email': controllers['emailController']?.text ?? '',
      'pincode': controllers['pincodeController']?.text ?? '',
      'district': controllers['districtController']?.text ?? '',
      'village': controllers['villageController']?.text ?? '',
      'postOffice': controllers['postOfficeController']?.text ?? '',
    });
  }

  // Get formatted address string
  String getFormattedAddress(int entryIndex) {
    if (entryIndex >= applicantEntries.length) return 'Click to add address';

    final addressData = applicantEntries[entryIndex]['address'] as RxMap<String, dynamic>?;
    if (addressData == null) return 'Click to add address';

    final plotNo = addressData['plotNo']?.toString() ?? '';
    final address = addressData['address']?.toString() ?? '';
    final village = addressData['village']?.toString() ?? '';

    if (plotNo.isEmpty && address.isEmpty && village.isEmpty) {
      return 'Click to add address';
    }

    return [plotNo, address, village].where((s) => s.isNotEmpty).join(', ');
  }

  // Validation methods
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'government_survey':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }

  //   bool validateCurrentSubStep(String field) {
  //   validationErrors.clear();
  //   bool isValid = true;
  //
  //   for (int i = 0; i < applicantEntries.length; i++) {
  //     final entry = applicantEntries[i];
  //
  //     // Check required fields
  //     if ((entry['agreementController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_agreement'] = 'Agreement is required';
  //       isValid = false;
  //     }
  //
  //     if ((entry['accountHolderNameController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_accountHolderName'] = 'Account holder name is required';
  //       isValid = false;
  //     }
  //
  //     if ((entry['accountNumberController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_accountNumber'] = 'Account number is required';
  //       isValid = false;
  //     }
  //
  //     if ((entry['mobileNumberController'] as TextEditingController).text.isEmpty) {
  //       validationErrors['${i}_mobileNumber'] = 'Mobile number is required';
  //       isValid = false;
  //     }
  //
  //     // Validate address data
  //     final addressData = entry['address'] as RxMap<String, dynamic>;
  //     if ((addressData['address'] ?? '').isEmpty) {
  //       validationErrors['${i}_address'] = 'Address is required';
  //       isValid = false;
  //     }
  //
  //     if ((addressData['pincode'] ?? '').isEmpty) {
  //       validationErrors['${i}_pincode'] = 'Pincode is required';
  //       isValid = false;
  //     }
  //
  //     if ((addressData['village'] ?? '').isEmpty) {
  //       validationErrors['${i}_village'] = 'Village is required';
  //       isValid = false;
  //     }
  //
  //     if ((addressData['postOffice'] ?? '').isEmpty) {
  //       validationErrors['${i}_postOffice'] = 'Post Office is required';
  //       isValid = false;
  //     }
  //   }
  //
  //   return isValid;
  // }

  // Complete validation method (commented out but fixed)
  bool validateAllFields() {
    validationErrors.clear();
    bool isValid = true;

    for (int i = 0; i < applicantEntries.length; i++) {
      final entry = applicantEntries[i];

      // Check required fields safely
      final agreementText = (entry['agreementController'] as TextEditingController?)?.text ?? '';
      if (agreementText.isEmpty) {
        validationErrors['${i}_agreement'] = 'Agreement is required';
        isValid = false;
      }

      final accountHolderNameText = (entry['accountHolderNameController'] as TextEditingController?)?.text ?? '';
      if (accountHolderNameText.isEmpty) {
        validationErrors['${i}_accountHolderName'] = 'Account holder name is required';
        isValid = false;
      }

      final accountNumberText = (entry['accountNumberController'] as TextEditingController?)?.text ?? '';
      if (accountNumberText.isEmpty) {
        validationErrors['${i}_accountNumber'] = 'Account number is required';
        isValid = false;
      }

      final mobileNumberText = (entry['mobileNumberController'] as TextEditingController?)?.text ?? '';
      if (mobileNumberText.isEmpty) {
        validationErrors['${i}_mobileNumber'] = 'Mobile number is required';
        isValid = false;
      }

      // Validate address data safely
      final addressData = entry['address'] as RxMap<String, dynamic>?;
      if (addressData != null) {
        if ((addressData['address']?.toString() ?? '').isEmpty) {
          validationErrors['${i}_address'] = 'Address is required';
          isValid = false;
        }

        if ((addressData['pincode']?.toString() ?? '').isEmpty) {
          validationErrors['${i}_pincode'] = 'Pincode is required';
          isValid = false;
        }

        if ((addressData['village']?.toString() ?? '').isEmpty) {
          validationErrors['${i}_village'] = 'Village is required';
          isValid = false;
        }

        if ((addressData['postOffice']?.toString() ?? '').isEmpty) {
          validationErrors['${i}_postOffice'] = 'Post Office is required';
          isValid = false;
        }
      }
    }

    return isValid;
  }

  @override
  bool isStepCompleted(List<String> fields) {
    return validateCurrentSubStep('');
  }

  @override
  String getFieldError(String field) {
    return validationErrors[field] ?? 'This field is required';
  }

  @override
  Map<String, dynamic> getStepData() {
    final data = <String, dynamic>{};

    for (int i = 0; i < applicantEntries.length; i++) {
      final entry = applicantEntries[i];
      final addressData = entry['address'] as RxMap<String, dynamic>?;

      data['applicant_$i'] = {
        'agreement': (entry['agreementController'] as TextEditingController?)?.text ?? '',
        'accountHolderName': (entry['accountHolderNameController'] as TextEditingController?)?.text ?? '',
        'accountNumber': (entry['accountNumberController'] as TextEditingController?)?.text ?? '',
        'mobileNumber': (entry['mobileNumberController'] as TextEditingController?)?.text ?? '',
        'serverNumber': (entry['serverNumberController'] as TextEditingController?)?.text ?? '',
        'area': (entry['areaController'] as TextEditingController?)?.text ?? '',
        'potkaharabaArea': (entry['potkaharabaAreaController'] as TextEditingController?)?.text ?? '',
        'totalArea': (entry['totalAreaController'] as TextEditingController?)?.text ?? '',
        'address': addressData != null ? Map<String, dynamic>.from(addressData) : <String, dynamic>{},
      };
    }

    data['applicantCount'] = applicantEntries.length;
    return data;
  }

  @override
  void onClose() {
    // Dispose all controllers safely
    for (final entry in applicantEntries) {
      (entry['agreementController'] as TextEditingController?)?.dispose();
      (entry['accountHolderNameController'] as TextEditingController?)?.dispose();
      (entry['accountNumberController'] as TextEditingController?)?.dispose();
      (entry['mobileNumberController'] as TextEditingController?)?.dispose();
      (entry['serverNumberController'] as TextEditingController?)?.dispose();
      (entry['areaController'] as TextEditingController?)?.dispose();
      (entry['potkaharabaAreaController'] as TextEditingController?)?.dispose();
      (entry['totalAreaController'] as TextEditingController?)?.dispose();

      final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>?;
      addressControllers?.values.forEach((controller) => controller.dispose());
    }
    super.onClose();
  }
}