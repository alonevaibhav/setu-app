// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../CourtAllocationCaseView/Controller/main_controller.dart';
//
// class CourtFifthController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Plaintiff and Defendant entries
//   final plaintiffDefendantEntries = <Map<String, dynamic>>[].obs;
//
//   // Dropdown options
//   final typeOptions = <String>['Plaintiff', 'Defendant'].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Add initial entry
//     addPlaintiffDefendantEntry();
//   }
//
//   @override
//   void onClose() {
//     // Dispose all controllers
//     for (var entry in plaintiffDefendantEntries) {
//       entry['nameController']?.dispose();
//       entry['addressController']?.dispose();
//       entry['mobileController']?.dispose();
//       entry['surveyNumberController']?.dispose();
//     }
//     super.onClose();
//   }
//
//   void addPlaintiffDefendantEntry() {
//     final newEntry = {
//       'nameController': TextEditingController(),
//       'addressController': TextEditingController(),
//       'mobileController': TextEditingController(),
//       'surveyNumberController': TextEditingController(),
//       'selectedType': RxString(''),
//       'name': '',
//       'address': '',
//       'mobile': '',
//       'surveyNumber': '',
//       'type': '',
//     };
//
//     plaintiffDefendantEntries.add(newEntry);
//   }
//
//   void removePlaintiffDefendantEntry(int index) {
//     if (plaintiffDefendantEntries.length > 1 && index < plaintiffDefendantEntries.length) {
//       final entry = plaintiffDefendantEntries[index];
//       // Dispose controllers
//       entry['nameController']?.dispose();
//       entry['addressController']?.dispose();
//       entry['mobileController']?.dispose();
//       entry['surveyNumberController']?.dispose();
//
//       plaintiffDefendantEntries.removeAt(index);
//     }
//   }
//
//   void updatePlaintiffDefendantEntry(int index, String field, String value) {
//     if (index < plaintiffDefendantEntries.length) {
//       plaintiffDefendantEntries[index][field] = value;
//       plaintiffDefendantEntries.refresh();
//     }
//   }
//
//   void updateSelectedType(int index, String value) {
//     if (index < plaintiffDefendantEntries.length) {
//       final selectedType = plaintiffDefendantEntries[index]['selectedType'] as RxString;
//       selectedType.value = value;
//       plaintiffDefendantEntries[index]['type'] = value;
//     }
//   }
//
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'plaintiff_defendant':
//         return _validateAllEntries();
//       default:
//         return true;
//     }
//   }
//
//   bool _validateAllEntries() {
//     for (var entry in plaintiffDefendantEntries) {
//       if (!_validateSingleEntry(entry)) {
//         return false;
//       }
//     }
//     return plaintiffDefendantEntries.isNotEmpty;
//   }
//
//   bool _validateSingleEntry(Map<String, dynamic> entry) {
//     final name = entry['nameController']?.text ?? '';
//     final address = entry['addressController']?.text ?? '';
//     final mobile = entry['mobileController']?.text ?? '';
//     final surveyNumber = entry['surveyNumberController']?.text ?? '';
//     final selectedType = entry['selectedType'] as RxString?;
//     final type = selectedType?.value ?? '';
//
//     return name.isNotEmpty &&
//         address.isNotEmpty &&
//         mobile.isNotEmpty &&
//         surveyNumber.isNotEmpty &&
//         type.isNotEmpty;
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
//       case 'plaintiff_defendant':
//         if (plaintiffDefendantEntries.isEmpty) {
//           return 'Please add at least one plaintiff/defendant entry';
//         }
//         for (int i = 0; i < plaintiffDefendantEntries.length; i++) {
//           final entry = plaintiffDefendantEntries[i];
//           if (!_validateSingleEntry(entry)) {
//             return 'Please complete all fields in Entry ${i + 1}';
//           }
//         }
//         return 'Invalid plaintiff/defendant information';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   @override
//   Map<String, dynamic> getStepData() {
//     final List<Map<String, dynamic>> entriesData = [];
//
//     for (var entry in plaintiffDefendantEntries) {
//       final selectedType = entry['selectedType'] as RxString?;
//       entriesData.add({
//         'name': entry['nameController']?.text ?? '',
//         'address': entry['addressController']?.text ?? '',
//         'mobile': entry['mobileController']?.text ?? '',
//         'surveyNumber': entry['surveyNumberController']?.text ?? '',
//         'type': selectedType?.value ?? '',
//       });
//     }
//
//     return {
//       'plaintiffDefendantEntries': entriesData,
//       'stepCompleted': isStepCompleted(['plaintiff_defendant']),
//       'timestamp': DateTime.now().toIso8601String(),
//     };
//   }
//
//   // Validation helpers
//   bool isValidMobileNumber(String mobile) {
//     return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
//   }
//
//   bool isValidName(String name) {
//     return name.trim().length >= 2;
//   }
//
//   bool isValidAddress(String address) {
//     return address.trim().length >= 10;
//   }
//
//   bool isValidSurveyNumber(String surveyNumber) {
//     return surveyNumber.trim().isNotEmpty;
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../CourtAllocationCaseView/Controller/main_controller.dart';
import '../../Widget/address.dart';

class CourtFifthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Plaintiff and Defendant entries
  final plaintiffDefendantEntries = <Map<String, dynamic>>[].obs;

  // Dropdown options
  final typeOptions = <String>['Plaintiff', 'Defendant'].obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial entry
    addPlaintiffDefendantEntry();
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (var entry in plaintiffDefendantEntries) {
      entry['nameController']?.dispose();
      entry['addressController']?.dispose();
      entry['mobileController']?.dispose();
      entry['surveyNumberController']?.dispose();
      // Dispose address popup controllers
      entry['addressPopupControllers']?.forEach((key, controller) {
        controller?.dispose();
      });
    }
    super.onClose();
  }

  void addPlaintiffDefendantEntry() {
    final newEntry = {
      'nameController': TextEditingController(),
      'addressController': TextEditingController(),
      'mobileController': TextEditingController(),
      'surveyNumberController': TextEditingController(),
      'selectedType': RxString(''),
      'name': '',
      'address': '',
      'mobile': '',
      'surveyNumber': '',
      'type': '',
      // Address popup controllers
      'addressPopupControllers': {
        'plotNoController': TextEditingController(),
        'addressController': TextEditingController(),
        'mobileNumberController': TextEditingController(),
        'emailController': TextEditingController(),
        'pincodeController': TextEditingController(),
        'districtController': TextEditingController(),
        'villageController': TextEditingController(),
        'postOfficeController': TextEditingController(),
      },
      'detailedAddress': <String, String>{}.obs, // Store detailed address data
    };

    plaintiffDefendantEntries.add(newEntry);
  }

  void removePlaintiffDefendantEntry(int index) {
    if (plaintiffDefendantEntries.length > 1 && index < plaintiffDefendantEntries.length) {
      final entry = plaintiffDefendantEntries[index];
      // Dispose controllers
      entry['nameController']?.dispose();
      entry['addressController']?.dispose();
      entry['mobileController']?.dispose();
      entry['surveyNumberController']?.dispose();

      // Dispose address popup controllers
      entry['addressPopupControllers']?.forEach((key, controller) {
        controller?.dispose();
      });

      plaintiffDefendantEntries.removeAt(index);
    }
  }

  void updatePlaintiffDefendantEntry(int index, String field, String value) {
    if (index < plaintiffDefendantEntries.length) {
      plaintiffDefendantEntries[index][field] = value;
      plaintiffDefendantEntries.refresh();
    }
  }

  void updateSelectedType(int index, String value) {
    if (index < plaintiffDefendantEntries.length) {
      final selectedType = plaintiffDefendantEntries[index]['selectedType'] as RxString;
      selectedType.value = value;
      plaintiffDefendantEntries[index]['type'] = value;
    }
  }

  // Method to open address popup
  void openAddressPopup(int entryIndex) {
    if (entryIndex < plaintiffDefendantEntries.length) {
      final entry = plaintiffDefendantEntries[entryIndex];
      final controllers = entry['addressPopupControllers'] as Map<String, TextEditingController>;

      // Pre-populate with existing data if available
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>;
      controllers['plotNoController']!.text = detailedAddress['plotNo'] ?? '';
      controllers['addressController']!.text = detailedAddress['address'] ?? '';
      controllers['mobileNumberController']!.text = detailedAddress['mobileNumber'] ?? '';
      controllers['emailController']!.text = detailedAddress['email'] ?? '';
      controllers['pincodeController']!.text = detailedAddress['pincode'] ?? '';
      controllers['districtController']!.text = detailedAddress['district'] ?? '';
      controllers['villageController']!.text = detailedAddress['village'] ?? '';
      controllers['postOfficeController']!.text = detailedAddress['postOffice'] ?? '';

      Get.dialog(
        AddressPopup(
          entryIndex: entryIndex,
          controllers: controllers,
          onSave: () => saveDetailedAddress(entryIndex),
        ),
      );
    }
  }

  // Method to save detailed address
  void saveDetailedAddress(int entryIndex) {
    if (entryIndex < plaintiffDefendantEntries.length) {
      final entry = plaintiffDefendantEntries[entryIndex];
      final controllers = entry['addressPopupControllers'] as Map<String, TextEditingController>;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>;

      // Save all address fields
      detailedAddress['plotNo'] = controllers['plotNoController']!.text;
      detailedAddress['address'] = controllers['addressController']!.text;
      detailedAddress['mobileNumber'] = controllers['mobileNumberController']!.text;
      detailedAddress['email'] = controllers['emailController']!.text;
      detailedAddress['pincode'] = controllers['pincodeController']!.text;
      detailedAddress['district'] = controllers['districtController']!.text;
      detailedAddress['village'] = controllers['villageController']!.text;
      detailedAddress['postOffice'] = controllers['postOfficeController']!.text;

      // Update the main address field with a formatted summary
      String formattedAddress = _formatAddressSummary(detailedAddress);
      entry['addressController'].text = formattedAddress;

      // Also update the mobile number in main form if provided
      if (detailedAddress['mobileNumber']?.isNotEmpty == true) {
        entry['mobileController'].text = detailedAddress['mobileNumber']!;
      }

      plaintiffDefendantEntries.refresh();
      Get.back(); // Close the popup
    }
  }

  // Helper method to format address summary
  String _formatAddressSummary(RxMap<String, String> detailedAddress) {
    List<String> addressParts = [];

    if (detailedAddress['plotNo']?.isNotEmpty == true) {
      addressParts.add(detailedAddress['plotNo']!);
    }
    if (detailedAddress['address']?.isNotEmpty == true) {
      addressParts.add(detailedAddress['address']!);
    }
    if (detailedAddress['village']?.isNotEmpty == true) {
      addressParts.add(detailedAddress['village']!);
    }
    if (detailedAddress['district']?.isNotEmpty == true) {
      addressParts.add(detailedAddress['district']!);
    }
    if (detailedAddress['pincode']?.isNotEmpty == true) {
      addressParts.add(detailedAddress['pincode']!);
    }

    return addressParts.join(', ');
  }

  // Check if detailed address is available
  bool hasDetailedAddress(int index) {
    if (index < plaintiffDefendantEntries.length) {
      final detailedAddress = plaintiffDefendantEntries[index]['detailedAddress'] as RxMap<String, String>;
      return detailedAddress.isNotEmpty &&
          (detailedAddress['address']?.isNotEmpty == true ||
              detailedAddress['village']?.isNotEmpty == true);
    }
    return false;
  }

  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'plaintiff_defendant':
        return _validateAllEntries();
      default:
        return true;
    }
  }

  bool _validateAllEntries() {
    for (var entry in plaintiffDefendantEntries) {
      if (!_validateSingleEntry(entry)) {
        return false;
      }
    }
    return plaintiffDefendantEntries.isNotEmpty;
  }

  bool _validateSingleEntry(Map<String, dynamic> entry) {
    final name = entry['nameController']?.text ?? '';
    final address = entry['addressController']?.text ?? '';
    final mobile = entry['mobileController']?.text ?? '';
    final surveyNumber = entry['surveyNumberController']?.text ?? '';
    final selectedType = entry['selectedType'] as RxString?;
    final type = selectedType?.value ?? '';

    return name.isNotEmpty &&
        address.isNotEmpty &&
        mobile.isNotEmpty &&
        surveyNumber.isNotEmpty &&
        type.isNotEmpty;
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
      case 'plaintiff_defendant':
        if (plaintiffDefendantEntries.isEmpty) {
          return 'Please add at least one plaintiff/defendant entry';
        }
        for (int i = 0; i < plaintiffDefendantEntries.length; i++) {
          final entry = plaintiffDefendantEntries[i];
          if (!_validateSingleEntry(entry)) {
            return 'Please complete all fields in Entry ${i + 1}';
          }
        }
        return 'Invalid plaintiff/defendant information';
      default:
        return 'This field is required';
    }
  }

  @override
  Map<String, dynamic> getStepData() {
    final List<Map<String, dynamic>> entriesData = [];

    for (var entry in plaintiffDefendantEntries) {
      final selectedType = entry['selectedType'] as RxString?;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>;

      entriesData.add({
        'name': entry['nameController']?.text ?? '',
        'address': entry['addressController']?.text ?? '',
        'mobile': entry['mobileController']?.text ?? '',
        'surveyNumber': entry['surveyNumberController']?.text ?? '',
        'type': selectedType?.value ?? '',
        'detailedAddress': Map<String, String>.from(detailedAddress), // Include detailed address
      });
    }

    return {
      'plaintiffDefendantEntries': entriesData,
      'stepCompleted': isStepCompleted(['plaintiff_defendant']),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Validation helpers
  bool isValidMobileNumber(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  bool isValidAddress(String address) {
    return address.trim().length >= 10;
  }

  bool isValidSurveyNumber(String surveyNumber) {
    return surveyNumber.trim().isNotEmpty;
  }
}