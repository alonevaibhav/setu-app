// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'main_controller.dart';
//
// class CourtSixthController extends GetxController
//     with StepValidationMixin, StepDataMixin {
//   // Observable list for next of kin entries
//   final nextOfKinEntries = <Map<String, dynamic>>[].obs;
//
//   // Dropdown options
//   final List<String> directionOptions = ['East', 'West', 'North', 'South'];
//
//   final List<String> naturalResourcesOptions = [
//     'Road',
//     'Pull',
//     'River',
//     'Broomstick',
//     'Forest',
//     'Village',
//     'Lake',
//     'Shiva/Shivarasta',
//     'Others'
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with one entry
//     addNextOfKinEntry();
//   }
//
//   void addNextOfKinEntry() {
//     nextOfKinEntries.add({
//       'addressController': TextEditingController(),
//       'mobileController': TextEditingController(),
//       'surveyNoController': TextEditingController(),
//       'direction': '', // Initialize as empty string, not null
//       'naturalResources': '', // Initialize as empty string, not null
//       'address': '',
//       'mobile': '',
//       'surveyNo': '',
//     });
//   }
//
//   void removeNextOfKinEntry(int index) {
//     if (nextOfKinEntries.length > 1 && index < nextOfKinEntries.length) {
//       // Dispose controllers
//       final entry = nextOfKinEntries[index];
//       (entry['addressController'] as TextEditingController?)?.dispose();
//       (entry['mobileController'] as TextEditingController?)?.dispose();
//       (entry['surveyNoController'] as TextEditingController?)?.dispose();
//
//       nextOfKinEntries.removeAt(index);
//     }
//   }
//
//   void updateNextOfKinEntry(int index, String field, String value) {
//     if (index < nextOfKinEntries.length) {
//       nextOfKinEntries[index][field] = value;
//       nextOfKinEntries.refresh();
//     }
//   }
//
//   void updateDirection(int index, String direction) {
//     if (index < nextOfKinEntries.length) {
//       nextOfKinEntries[index]['direction'] = direction;
//       nextOfKinEntries.refresh();
//     }
//   }
//
//   void updateNaturalResources(int index, String naturalResources) {
//     if (index < nextOfKinEntries.length) {
//       nextOfKinEntries[index]['naturalResources'] = naturalResources;
//       nextOfKinEntries.refresh();
//     }
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
//   //     case 'next_of_kin':
//   //       return _validateNextOfKinEntries();
//   //     case 'government_survey':
//   //       return true; // Temporarily return true to bypass validation
//   //     default:
//   //       return true;
//   //   }
//   // }
//
//   bool _validateNextOfKinEntries() {
//     if (nextOfKinEntries.isEmpty) return false;
//
//     for (final entry in nextOfKinEntries) {
//       // Check required fields with proper null handling (removed 'name' field)
//       if ((entry['address'] as String? ?? '').trim().isEmpty ||
//           (entry['mobile'] as String? ?? '').trim().isEmpty ||
//           (entry['surveyNo'] as String? ?? '').trim().isEmpty ||
//           (entry['direction'] as String? ?? '').trim().isEmpty ||
//           (entry['naturalResources'] as String? ?? '').trim().isEmpty) {
//         return false;
//       }
//
//       // Validate mobile number (basic validation)
//       final mobile = (entry['mobile'] as String? ?? '').trim();
//       if (mobile.length < 10 || !RegExp(r'^\d+$').hasMatch(mobile)) {
//         return false;
//       }
//     }
//     return true;
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
//       case 'next_of_kin':
//         if (nextOfKinEntries.isEmpty) {
//           return 'At least one next of kin entry is required';
//         }
//         for (int i = 0; i < nextOfKinEntries.length; i++) {
//           final entry = nextOfKinEntries[i];
//           // Removed name field validation
//           if ((entry['address'] as String? ?? '').trim().isEmpty) {
//             return 'Address is required in entry ${i + 1}';
//           }
//           if ((entry['mobile'] as String? ?? '').trim().isEmpty) {
//             return 'Mobile number is required in entry ${i + 1}';
//           }
//           if ((entry['surveyNo'] as String? ?? '').trim().isEmpty) {
//             return 'Survey No./Group No. is required in entry ${i + 1}';
//           }
//           if ((entry['direction'] as String? ?? '').trim().isEmpty) {
//             return 'Direction is required in entry ${i + 1}';
//           }
//           if ((entry['naturalResources'] as String? ?? '').trim().isEmpty) {
//             return 'Natural resources is required in entry ${i + 1}';
//           }
//
//           final mobile = (entry['mobile'] as String? ?? '').trim();
//           if (mobile.length < 10 || !RegExp(r'^\d+$').hasMatch(mobile)) {
//             return 'Valid mobile number is required in entry ${i + 1}';
//           }
//         }
//         return 'Please fill all required fields';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   @override
//   Map<String, dynamic> getStepData() {
//     final List<Map<String, dynamic>> entriesData = [];
//
//     for (final entry in nextOfKinEntries) {
//       entriesData.add({
//         // Removed 'name' field from data export
//         'address': entry['address'] as String? ?? '',
//         'mobile': entry['mobile'] as String? ?? '',
//         'surveyNo': entry['surveyNo'] as String? ?? '',
//         'direction': entry['direction'] as String? ?? '',
//         'naturalResources': entry['naturalResources'] as String? ?? '',
//       });
//     }
//
//     return {
//       'nextOfKinEntries': entriesData,
//       'totalNextOfKinEntries': entriesData.length,
//     };
//   }
//
//   @override
//   void onClose() {
//     // Dispose all controllers (removed nameController)
//     for (final entry in nextOfKinEntries) {
//       (entry['addressController'] as TextEditingController?)?.dispose();
//       (entry['mobileController'] as TextEditingController?)?.dispose();
//       (entry['surveyNoController'] as TextEditingController?)?.dispose();
//     }
//     super.onClose();
//   }
// }
//
//
//

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class CourtSixthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable list for next of kin entries
  final nextOfKinEntries = <Map<String, dynamic>>[].obs;

  // Dropdown options
  final List<String> directionOptions = ['East', 'West', 'North', 'South'];

  final List<String> naturalResourcesOptions = [
    'Name',
    'Road',
    'Pull',
    'River',
    'Broomstick',
    'Forest',
    'Village',
    'Lake',
    'Shiva/Shivarasta',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize with one entry
    addNextOfKinEntry();
  }

  void addNextOfKinEntry() {
    nextOfKinEntries.add({
      'addressController': TextEditingController(),
      'mobileController': TextEditingController(),
      'surveyNoController': TextEditingController(),
      'direction': '', // Initialize as empty string, not null
      'naturalResources': '', // Initialize as empty string, not null
      'address': '',
      'mobile': '',
      'surveyNo': '',
      'subEntries': <Map<String, dynamic>>[].obs, // For Name/Other sub-entries
    });
  }

  void removeNextOfKinEntry(int index) {
    if (nextOfKinEntries.length > 1 && index < nextOfKinEntries.length) {
      // Dispose controllers
      final entry = nextOfKinEntries[index];
      (entry['addressController'] as TextEditingController?)?.dispose();
      (entry['mobileController'] as TextEditingController?)?.dispose();
      (entry['surveyNoController'] as TextEditingController?)?.dispose();

      // Dispose sub-entry controllers
      final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>?;
      if (subEntries != null) {
        for (final subEntry in subEntries) {
          (subEntry['nameController'] as TextEditingController?)?.dispose();
          (subEntry['addressController'] as TextEditingController?)?.dispose();
          (subEntry['mobileController'] as TextEditingController?)?.dispose();
          (subEntry['surveyNoController'] as TextEditingController?)?.dispose();
        }
      }

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

      // Clear sub-entries when changing natural resources
      final subEntries =
      nextOfKinEntries[index]['subEntries'] as RxList<Map<String, dynamic>>;
      for (final subEntry in subEntries) {
        (subEntry['nameController'] as TextEditingController?)?.dispose();
        (subEntry['addressController'] as TextEditingController?)?.dispose();
        (subEntry['mobileController'] as TextEditingController?)?.dispose();
        (subEntry['surveyNoController'] as TextEditingController?)?.dispose();
      }
      subEntries.clear();

      // Add initial sub-entry for Name or Other
      if (naturalResources == 'Name' || naturalResources == 'Other') {
        addSubEntry(index);
      }

      nextOfKinEntries.refresh();
    }
  }

  void addSubEntry(int parentIndex) {
    if (parentIndex < nextOfKinEntries.length) {
      final subEntries = nextOfKinEntries[parentIndex]['subEntries']
      as RxList<Map<String, dynamic>>;
      subEntries.add({
        'nameController': TextEditingController(),
        'addressController': TextEditingController(),
        'mobileController': TextEditingController(),
        'surveyNoController': TextEditingController(),
        'name': '',
        'address': '',
        'mobile': '',
        'surveyNo': '',
      });
    }
  }

  void removeSubEntry(int parentIndex, int subIndex) {
    if (parentIndex < nextOfKinEntries.length) {
      final subEntries = nextOfKinEntries[parentIndex]['subEntries']
      as RxList<Map<String, dynamic>>;
      if (subEntries.length > 1 && subIndex < subEntries.length) {
        // Dispose controllers
        final subEntry = subEntries[subIndex];
        (subEntry['nameController'] as TextEditingController?)?.dispose();
        (subEntry['addressController'] as TextEditingController?)?.dispose();
        (subEntry['mobileController'] as TextEditingController?)?.dispose();
        (subEntry['surveyNoController'] as TextEditingController?)?.dispose();

        subEntries.removeAt(subIndex);
      }
    }
  }

  void updateSubEntry(
      int parentIndex, int subIndex, String field, String value) {
    if (parentIndex < nextOfKinEntries.length) {
      final subEntries = nextOfKinEntries[parentIndex]['subEntries']
      as RxList<Map<String, dynamic>>;
      if (subIndex < subEntries.length) {
        subEntries[subIndex][field] = value;
        subEntries.refresh();
      }
    }
  }

  bool shouldShowSubEntries(int index) {
    if (index < nextOfKinEntries.length) {
      final naturalResources =
      nextOfKinEntries[index]['naturalResources'] as String;
      return naturalResources == 'Name' || naturalResources == 'Other';
    }
    return false;
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
  //     case 'next_of_kin':
  //       return _validateNextOfKinEntries();
  //     case 'government_survey':
  //       return true; // Temporarily return true to bypass validation
  //     default:
  //       return true;
  //   }
  // }

  bool _validateNextOfKinEntries() {
    if (nextOfKinEntries.isEmpty) return false;

    for (final entry in nextOfKinEntries) {
      final naturalResources = entry['naturalResources'] as String? ?? '';
      final direction = entry['direction'] as String? ?? '';

      // Always validate natural resources and direction
      if (naturalResources.trim().isEmpty || direction.trim().isEmpty) {
        return false;
      }

      if (naturalResources == 'Name' || naturalResources == 'Other') {
        // Validate sub-entries
        final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>?;
        if (subEntries == null || subEntries.isEmpty) {
          return false;
        }

        for (final subEntry in subEntries) {
          if ((subEntry['name'] as String? ?? '').trim().isEmpty ||
              (subEntry['address'] as String? ?? '').trim().isEmpty ||
              (subEntry['mobile'] as String? ?? '').trim().isEmpty ||
              (subEntry['surveyNo'] as String? ?? '').trim().isEmpty) {
            return false;
          }

          // Validate mobile number
          final mobile = (subEntry['mobile'] as String? ?? '').trim();
          if (mobile.length < 10 || !RegExp(r'^\d+$').hasMatch(mobile)) {
            return false;
          }
        }
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
          final naturalResources = entry['naturalResources'] as String? ?? '';
          final direction = entry['direction'] as String? ?? '';

          if (naturalResources.trim().isEmpty) {
            return 'Natural resources is required in entry ${i + 1}';
          }

          if (direction.trim().isEmpty) {
            return 'Direction is required in entry ${i + 1}';
          }

          if (naturalResources == 'Name' || naturalResources == 'Other') {
            // Validate sub-entries
            final subEntries =
            entry['subEntries'] as RxList<Map<String, dynamic>>?;
            if (subEntries == null || subEntries.isEmpty) {
              return 'At least one sub-entry is required for ${naturalResources} in entry ${i + 1}';
            }

            for (int j = 0; j < subEntries.length; j++) {
              final subEntry = subEntries[j];
              if ((subEntry['name'] as String? ?? '').trim().isEmpty) {
                return 'Full name is required in entry ${i + 1}, sub-entry ${j + 1}';
              }
              if ((subEntry['address'] as String? ?? '').trim().isEmpty) {
                return 'Address is required in entry ${i + 1}, sub-entry ${j + 1}';
              }
              if ((subEntry['mobile'] as String? ?? '').trim().isEmpty) {
                return 'Mobile number is required in entry ${i + 1}, sub-entry ${j + 1}';
              }
              if ((subEntry['surveyNo'] as String? ?? '').trim().isEmpty) {
                return 'Survey No./Group No. is required in entry ${i + 1}, sub-entry ${j + 1}';
              }

              final mobile = (subEntry['mobile'] as String? ?? '').trim();
              if (mobile.length < 10 || !RegExp(r'^\d+$').hasMatch(mobile)) {
                return 'Valid mobile number is required in entry ${i + 1}, sub-entry ${j + 1}';
              }
            }
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
      final naturalResources = entry['naturalResources'] as String? ?? '';
      final direction = entry['direction'] as String? ?? '';

      if (naturalResources == 'Name' || naturalResources == 'Other') {
        // Export sub-entries data
        final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>?;
        final List<Map<String, dynamic>> subEntriesData = [];

        if (subEntries != null) {
          for (final subEntry in subEntries) {
            subEntriesData.add({
              'name': subEntry['name'] as String? ?? '',
              'address': subEntry['address'] as String? ?? '',
              'mobile': subEntry['mobile'] as String? ?? '',
              'surveyNo': subEntry['surveyNo'] as String? ?? '',
            });
          }
        }

        entriesData.add({
          'naturalResources': naturalResources,
          'direction': direction, // Always include direction
          'subEntries': subEntriesData,
          'totalSubEntries': subEntriesData.length,
        });
      } else {
        // Export basic data for other natural resources
        entriesData.add({
          'direction': direction,
          'naturalResources': naturalResources,
        });
      }
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
      (entry['addressController'] as TextEditingController?)?.dispose();
      (entry['mobileController'] as TextEditingController?)?.dispose();
      (entry['surveyNoController'] as TextEditingController?)?.dispose();

      // Dispose sub-entry controllers
      final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>?;
      if (subEntries != null) {
        for (final subEntry in subEntries) {
          (subEntry['nameController'] as TextEditingController?)?.dispose();
          (subEntry['addressController'] as TextEditingController?)?.dispose();
          (subEntry['mobileController'] as TextEditingController?)?.dispose();
          (subEntry['surveyNoController'] as TextEditingController?)?.dispose();
        }
      }
    }
    super.onClose();
  }
}
