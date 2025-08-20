// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../Controller/main_controller.dart';
//
// class CourtSixthController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Form controllers
//   final countingFeeController = TextEditingController();
//
//   // Observable variables
//   final selectedCalculationType = 'Land acquisition case'.obs;
//   final selectedDuration = ''.obs;
//   final selectedHolderType = ''.obs;
//   final countingFee = 0.obs;
//
//   // Options for dropdowns
//   final calculationTypeOptions = [
//     'Land acquisition case',
//   ];
//
//   final durationOptions = [
//     'Regular',
//     'Fast pace',
//   ];
//
//   final holderTypeOptions = [
//     'Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)',
//   ];
//
//   // Validation errors
//   final durationError = ''.obs;
//   final holderTypeError = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Listen to changes and calculate fee automatically
//     ever(selectedDuration, (_) => calculateCountingFee());
//     ever(selectedHolderType, (_) => calculateCountingFee());
//   }
//
//   @override
//   void onClose() {
//     countingFeeController.dispose();
//     super.onClose();
//   }
//
//   // Update methods
//   void updateCalculationType(String? value) {
//     if (value != null) {
//       selectedCalculationType.value = value;
//     }
//   }
//
//   void updateDuration(String? value) {
//     if (value != null) {
//       selectedDuration.value = value;
//       durationError.value = '';
//     }
//   }
//
//   void updateHolderType(String? value) {
//     if (value != null) {
//       selectedHolderType.value = value;
//       holderTypeError.value = '';
//     }
//   }
//
//   // Calculate counting fee based on duration and holder type
//   void calculateCountingFee() {
//     if (selectedDuration.value.isEmpty || selectedHolderType.value.isEmpty) {
//       countingFee.value = 0;
//       countingFeeController.text = '0';
//       return;
//     }
//
//     int fee = 0;
//
//     // Check if holder type contains "Companies/Other Institutions/Various Authorities/Corporations"
//     bool isCompanyOrInstitution = selectedHolderType.value.contains('Companies/Other Institutions/Various Authorities/Corporations');
//
//     if (isCompanyOrInstitution) {
//       if (selectedDuration.value == 'Regular') {
//         fee = 7500;
//       } else if (selectedDuration.value == 'Fast pace') {
//         fee = 30000;
//       }
//     } else {
//       // Different fee structures for other holder types
//       if (selectedDuration.value == 'Regular') {
//         fee = 5000; // Example fee for other types
//       } else if (selectedDuration.value == 'Fast pace') {
//         fee = 15000; // Example fee for other types
//       }
//     }
//
//     countingFee.value = fee;
//     countingFeeController.text = fee.toString();
//   }
//
//   // Validation methods
//   bool _validateDuration() {
//     if (selectedDuration.value.isEmpty) {
//       durationError.value = 'Duration is required';
//       return false;
//     }
//     durationError.value = '';
//     return true;
//   }
//
//   bool _validateHolderType() {
//     if (selectedHolderType.value.isEmpty) {
//       holderTypeError.value = 'Holder type is required';
//       return false;
//     }
//     holderTypeError.value = '';
//     return true;
//   }
//
//   // StepValidationMixin implementation
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
//   //     case 'calculation':
//   //       return _validateDuration() && _validateHolderType();
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
//         if (selectedDuration.value.isEmpty) {
//           return 'Duration is required';
//         }
//         if (selectedHolderType.value.isEmpty) {
//           return 'Holder type is required';
//         }
//         return '';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   // StepDataMixin implementation
//   @override
//   Map<String, dynamic> getStepData() {
//     return {
//       'calculation_type': selectedCalculationType.value,
//       'duration': selectedDuration.value,
//       'holder_type': selectedHolderType.value,
//       'counting_fee': countingFee.value,
//     };
//   }
//
//   // Reset form
//   void resetForm() {
//     selectedCalculationType.value = 'Land acquisition case';
//     selectedDuration.value = '';
//     selectedHolderType.value = '';
//     countingFee.value = 0;
//     countingFeeController.clear();
//     durationError.value = '';
//     holderTypeError.value = '';
//   }
//
//   // Load saved data (if needed)
//   void loadSavedData(Map<String, dynamic> data) {
//     if (data.containsKey('calculation_type')) {
//       selectedCalculationType.value = data['calculation_type'] ?? 'Land acquisition case';
//     }
//     if (data.containsKey('duration')) {
//       selectedDuration.value = data['duration'] ?? '';
//     }
//     if (data.containsKey('holder_type')) {
//       selectedHolderType.value = data['holder_type'] ?? '';
//     }
//     if (data.containsKey('counting_fee')) {
//       countingFee.value = data['counting_fee'] ?? 0;
//       countingFeeController.text = countingFee.value.toString();
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class CourtSixthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable list for next of kin entries
  final nextOfKinEntries = <Map<String, dynamic>>[].obs;

  // Dropdown options
  final List<String> directionOptions = [
    'East',
    'West',
    'North',
    'South'
  ];

  final List<String> naturalResourcesOptions = [
    'Road',
    'Pull',
    'River',
    'Broomstick',
    'Forest',
    'Village',
    'Lake',
    'Shiva/Shivarasta',
    'Others'
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize with one entry
    addNextOfKinEntry();
  }

  void addNextOfKinEntry() {
    nextOfKinEntries.add({
      'nameController': TextEditingController(),
      'addressController': TextEditingController(),
      'mobileController': TextEditingController(),
      'surveyNoController': TextEditingController(),
      'direction': '', // Initialize as empty string, not null
      'naturalResources': '', // Initialize as empty string, not null
      'name': '',
      'address': '',
      'mobile': '',
      'surveyNo': '',
    });
  }

  void removeNextOfKinEntry(int index) {
    if (nextOfKinEntries.length > 1 && index < nextOfKinEntries.length) {
      // Dispose controllers
      final entry = nextOfKinEntries[index];
      (entry['nameController'] as TextEditingController?)?.dispose();
      (entry['addressController'] as TextEditingController?)?.dispose();
      (entry['mobileController'] as TextEditingController?)?.dispose();
      (entry['surveyNoController'] as TextEditingController?)?.dispose();

      nextOfKinEntries.removeAt(index);
    }
  }

  void updateNextOfKinEntry(int index, String field, String value) {
    if (index < nextOfKinEntries.length) {
      nextOfKinEntries[index][field] = value;
      nextOfKinEntries.refresh();
    }
  }

  void updateDirection(int index, String direction) {
    if (index < nextOfKinEntries.length) {
      nextOfKinEntries[index]['direction'] = direction;
      nextOfKinEntries.refresh();
    }
  }

  void updateNaturalResources(int index, String naturalResources) {
    if (index < nextOfKinEntries.length) {
      nextOfKinEntries[index]['naturalResources'] = naturalResources;
      nextOfKinEntries.refresh();
    }
  }

  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'next_of_kin':
        return _validateNextOfKinEntries();
      case 'government_survey':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }

  bool _validateNextOfKinEntries() {
    if (nextOfKinEntries.isEmpty) return false;

    for (final entry in nextOfKinEntries) {
      // Check required fields with proper null handling
      if ((entry['name'] as String? ?? '').trim().isEmpty ||
          (entry['address'] as String? ?? '').trim().isEmpty ||
          (entry['mobile'] as String? ?? '').trim().isEmpty ||
          (entry['surveyNo'] as String? ?? '').trim().isEmpty ||
          (entry['direction'] as String? ?? '').trim().isEmpty ||
          (entry['naturalResources'] as String? ?? '').trim().isEmpty) {
        return false;
      }

      // Validate mobile number (basic validation)
      final mobile = (entry['mobile'] as String? ?? '').trim();
      if (mobile.length < 10 || !RegExp(r'^\d+$').hasMatch(mobile)) {
        return false;
      }
    }
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
      case 'next_of_kin':
        if (nextOfKinEntries.isEmpty) {
          return 'At least one next of kin entry is required';
        }
        for (int i = 0; i < nextOfKinEntries.length; i++) {
          final entry = nextOfKinEntries[i];
          if ((entry['name'] as String? ?? '').trim().isEmpty) {
            return 'Name is required in entry ${i + 1}';
          }
          if ((entry['address'] as String? ?? '').trim().isEmpty) {
            return 'Address is required in entry ${i + 1}';
          }
          if ((entry['mobile'] as String? ?? '').trim().isEmpty) {
            return 'Mobile number is required in entry ${i + 1}';
          }
          if ((entry['surveyNo'] as String? ?? '').trim().isEmpty) {
            return 'Survey No./Group No. is required in entry ${i + 1}';
          }
          if ((entry['direction'] as String? ?? '').trim().isEmpty) {
            return 'Direction is required in entry ${i + 1}';
          }
          if ((entry['naturalResources'] as String? ?? '').trim().isEmpty) {
            return 'Natural resources is required in entry ${i + 1}';
          }

          final mobile = (entry['mobile'] as String? ?? '').trim();
          if (mobile.length < 10 || !RegExp(r'^\d+$').hasMatch(mobile)) {
            return 'Valid mobile number is required in entry ${i + 1}';
          }
        }
        return 'Please fill all required fields';
      default:
        return 'This field is required';
    }
  }

  @override
  Map<String, dynamic> getStepData() {
    final List<Map<String, dynamic>> entriesData = [];

    for (final entry in nextOfKinEntries) {
      entriesData.add({
        'name': entry['name'] as String? ?? '',
        'address': entry['address'] as String? ?? '',
        'mobile': entry['mobile'] as String? ?? '',
        'surveyNo': entry['surveyNo'] as String? ?? '',
        'direction': entry['direction'] as String? ?? '',
        'naturalResources': entry['naturalResources'] as String? ?? '',
      });
    }

    return {
      'nextOfKinEntries': entriesData,
      'totalNextOfKinEntries': entriesData.length,
    };
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (final entry in nextOfKinEntries) {
      (entry['nameController'] as TextEditingController?)?.dispose();
      (entry['addressController'] as TextEditingController?)?.dispose();
      (entry['mobileController'] as TextEditingController?)?.dispose();
      (entry['surveyNoController'] as TextEditingController?)?.dispose();
    }
    super.onClose();
  }
}
