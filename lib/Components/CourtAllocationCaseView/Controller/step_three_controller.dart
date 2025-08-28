// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../Controller/main_controller.dart';
//
// class CalculationController extends GetxController with StepValidationMixin, StepDataMixin {
//
//   // Survey entries list
//   final surveyEntries = <Map<String, dynamic>>[].obs;
//
//   // Village selection
//   final selectedVillage = ''.obs;
//
//   // Village options - you can populate this from your data source
//   final List<String> villageOptions = [
//     'Village 1',
//     'Village 2',
//     'Village 3',
//     'Village 4',
//     'Village 5',
//   ];
//
//   // Validation states
//   final validationErrors = <String, String>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with one empty survey entry
//     addSurveyEntry();
//   }
//
//   @override
//   void onClose() {
//     // Dispose all text controllers
//     for (var entry in surveyEntries) {
//       entry['surveyNoController']?.dispose();
//       entry['areaController']?.dispose();
//       entry['abdominalController']?.dispose();
//     }
//     super.onClose();
//   }
//
//   // Add a new survey entry
//   void addSurveyEntry() {
//     final newEntry = {
//       'surveyNoController': TextEditingController(),
//       'areaController': TextEditingController(),
//       'abdominalController': TextEditingController(),
//       'surveyNo': '',
//       'area': '',
//       'abdominalSection': '',
//       'village': selectedVillage.value,
//     };
//
//     surveyEntries.add(newEntry);
//   }
//
//   // Remove a survey entry
//   void removeSurveyEntry(int index) {
//     if (surveyEntries.length > 1 && index >= 0 && index < surveyEntries.length) {
//       // Dispose controllers before removing
//       surveyEntries[index]['surveyNoController']?.dispose();
//       surveyEntries[index]['areaController']?.dispose();
//       surveyEntries[index]['abdominalController']?.dispose();
//
//       surveyEntries.removeAt(index);
//     }
//   }
//
//   // Update survey entry data
//   void updateSurveyEntry(int index, String field, String value) {
//     if (index >= 0 && index < surveyEntries.length) {
//       surveyEntries[index][field] = value;
//
//       // Update the survey entries list to trigger UI update
//       surveyEntries.refresh();
//
//       // Clear validation error for this field
//       validationErrors.remove('${index}_$field');
//     }
//   }
//
//   // Update selected village
//   void updateSelectedVillage(String village) {
//     selectedVillage.value = village;
//
//     // Update village for all existing entries
//     for (var entry in surveyEntries) {
//       entry['village'] = village;
//     }
//
//     // Clear validation error
//     validationErrors.remove('selectedVillage');
//   }
//
//   // Validation Methods (from StepValidationMixin)
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
//   //   validationErrors.clear();
//   //
//   //   switch (field) {
//   //     case 'calculation':
//   //       return _validateCalculationStep();
//   //     default:
//   //       return true;
//   //   }
//   // }
//
//   bool _validateCalculationStep() {
//     bool isValid = true;
//
//     // Validate village selection
//     if (selectedVillage.value.isEmpty) {
//       validationErrors['selectedVillage'] = 'Please select a village';
//       isValid = false;
//     }
//
//     // Validate survey entries
//     for (int i = 0; i < surveyEntries.length; i++) {
//       final entry = surveyEntries[i];
//
//       // Validate Survey No./TP No.
//       if (entry['surveyNo'] == null || entry['surveyNo'].toString().trim().isEmpty) {
//         validationErrors['${i}_surveyNo'] = 'Survey No./TP No. is required';
//         isValid = false;
//       }
//
//       // Validate Area
//       if (entry['area'] == null || entry['area'].toString().trim().isEmpty) {
//         validationErrors['${i}_area'] = 'Area is required';
//         isValid = false;
//       } else {
//         // Check if area is a valid number
//         final areaValue = double.tryParse(entry['area'].toString());
//         if (areaValue == null || areaValue <= 0) {
//           validationErrors['${i}_area'] = 'Please enter a valid area';
//           isValid = false;
//         }
//       }
//
//       // Validate Abdominal Section
//       if (entry['abdominalSection'] == null || entry['abdominalSection'].toString().trim().isEmpty) {
//         validationErrors['${i}_abdominalSection'] = 'Abdominal section is required';
//         isValid = false;
//       }
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
//       case 'calculation':
//         if (validationErrors.containsKey('selectedVillage')) {
//           return validationErrors['selectedVillage']!;
//         }
//         // Return the first validation error found
//         if (validationErrors.isNotEmpty) {
//           return validationErrors.values.first;
//         }
//         return 'Please fill all required fields';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   // Data Methods (from StepDataMixin)
//   @override
//   Map<String, dynamic> getStepData() {
//     final List<Map<String, dynamic>> surveyData = [];
//
//     for (int i = 0; i < surveyEntries.length; i++) {
//       final entry = surveyEntries[i];
//       surveyData.add({
//         'entryIndex': i + 1,
//         'surveyNo': entry['surveyNo'] ?? '',
//         'area': entry['area'] ?? '',
//         'abdominalSection': entry['abdominalSection'] ?? '',
//         'village': selectedVillage.value,
//       });
//     }
//
//     return {
//       'calculationStep': {
//         'selectedVillage': selectedVillage.value,
//         'surveyEntries': surveyData,
//         'totalEntries': surveyEntries.length,
//         'timestamp': DateTime.now().toIso8601String(),
//       }
//     };
//   }
//
//   // Helper Methods
//
//   // Get total area from all entries
//   double getTotalArea() {
//     double total = 0.0;
//     for (var entry in surveyEntries) {
//       final area = double.tryParse(entry['area'] ?? '0') ?? 0.0;
//       total += area;
//     }
//     return total;
//   }
//
//   // Get formatted total area string
//   String getFormattedTotalArea() {
//     final total = getTotalArea();
//     return total.toStringAsFixed(2);
//   }
//
//   // Check if entry has validation errors
//   bool hasEntryError(int index, String field) {
//     return validationErrors.containsKey('${index}_$field');
//   }
//
//   // Get entry error message
//   String getEntryError(int index, String field) {
//     return validationErrors['${index}_$field'] ?? '';
//   }
//
//   // Clear all validation errors
//   void clearValidationErrors() {
//     validationErrors.clear();
//   }
//
//   // Load data from previous save (if needed)
//   void loadStepData(Map<String, dynamic> data) {
//     if (data.containsKey('calculationStep')) {
//       final stepData = data['calculationStep'];
//
//       // Load village selection
//       if (stepData.containsKey('selectedVillage')) {
//         selectedVillage.value = stepData['selectedVillage'] ?? '';
//       }
//
//       // Load survey entries
//       if (stepData.containsKey('surveyEntries')) {
//         final entriesData = stepData['surveyEntries'] as List<dynamic>;
//
//         // Clear existing entries
//         for (var entry in surveyEntries) {
//           entry['surveyNoController']?.dispose();
//           entry['areaController']?.dispose();
//           entry['abdominalController']?.dispose();
//         }
//         surveyEntries.clear();
//
//         // Add loaded entries
//         for (var entryData in entriesData) {
//           final surveyController = TextEditingController(text: entryData['surveyNo'] ?? '');
//           final areaController = TextEditingController(text: entryData['area'] ?? '');
//           final abdominalController = TextEditingController(text: entryData['abdominalSection'] ?? '');
//
//           final entry = {
//             'surveyNoController': surveyController,
//             'areaController': areaController,
//             'abdominalController': abdominalController,
//             'surveyNo': entryData['surveyNo'] ?? '',
//             'area': entryData['area'] ?? '',
//             'abdominalSection': entryData['abdominalSection'] ?? '',
//             'village': entryData['village'] ?? '',
//           };
//
//           surveyEntries.add(entry);
//         }
//
//         // If no entries were loaded, add a default one
//         if (surveyEntries.isEmpty) {
//           addSurveyEntry();
//         }
//       }
//     }
//   }
// }



import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class CalculationController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable variables
  final surveyEntries = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Village dropdown options
  final List<String> villageOptions = [
    'Select Village',
    'Village 1',
    'Village 2',
    'Village 3',
    'Village 4',
    'Village 5',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    // Initialize with one default survey entry
    addSurveyEntry();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    for (var entry in surveyEntries) {
      entry['surveyNoController']?.dispose();
      entry['shareController']?.dispose();
      entry['areaController']?.dispose();
    }
    super.onClose();
  }

  // Add new survey entry
  void addSurveyEntry() {
    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'surveyNoController': TextEditingController(),
      'shareController': TextEditingController(),
      'areaController': TextEditingController(),
      'surveyNo': '',
      'share': '',
      'area': '',
      'selectedVillage': 'Select Village', // Individual village selection per entry
    };
    surveyEntries.add(newEntry);
  }

  // Remove survey entry
  void removeSurveyEntry(int index) {
    if (surveyEntries.length > 1 && index >= 0 && index < surveyEntries.length) {
      // Dispose controllers before removing
      final entry = surveyEntries[index];
      entry['surveyNoController']?.dispose();
      entry['shareController']?.dispose();
      entry['areaController']?.dispose();

      surveyEntries.removeAt(index);
    }
  }

  // Update survey entry data
  void updateSurveyEntry(int index, String field, String value) {
    if (index >= 0 && index < surveyEntries.length) {
      surveyEntries[index][field] = value;
      surveyEntries.refresh(); // Trigger UI update
    }
  }

  // Update selected village for specific entry
  void updateSelectedVillage(int index, String village) {
    if (index >= 0 && index < surveyEntries.length) {
      surveyEntries[index]['selectedVillage'] = village;
      surveyEntries.refresh(); // Trigger UI update
    }
  }

  // Get selected village for specific entry
  String getSelectedVillage(int index) {
    if (index >= 0 && index < surveyEntries.length) {
      return surveyEntries[index]['selectedVillage'] ?? 'Select Village';
    }
    return 'Select Village';
  }

  // Calculate total area from all entries
  double get totalArea {
    double total = 0.0;
    for (var entry in surveyEntries) {
      final areaStr = entry['area']?.toString() ?? '';
      final area = double.tryParse(areaStr) ?? 0.0;
      total += area;
    }
    return total;
  }

  // Calculate total share from all entries
  double get totalShare {
    double total = 0.0;
    for (var entry in surveyEntries) {
      final shareStr = entry['share']?.toString() ?? '';
      final share = double.tryParse(shareStr) ?? 0.0;
      total += share;
    }
    return total;
  }

  // Get survey entry summary
  String getSurveyEntrySummary(int index) {
    if (index >= 0 && index < surveyEntries.length) {
      final entry = surveyEntries[index];
      final surveyNo = entry['surveyNo']?.toString() ?? 'Not entered';
      final share = entry['share']?.toString() ?? '0';
      final area = entry['area']?.toString() ?? '0';
      final village = entry['selectedVillage']?.toString() ?? 'Not selected';
      return 'Village: $village, Survey: $surveyNo, Share: $share, Area: $area';
    }
    return 'Invalid entry';
  }

  // Validation Methods (StepValidationMixin)
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
  //     case 'calculation':
  //       return _validateCalculationStep();
  //     default:
  //       return true;
  //   }
  // }

  bool _validateCalculationStep() {
    // Check if at least one survey entry exists and is valid
    if (surveyEntries.isEmpty) {
      return false;
    }

    // Validate each survey entry
    for (var entry in surveyEntries) {
      if (!_validateSurveyEntry(entry)) {
        return false;
      }
    }

    return true;
  }

  bool _validateSurveyEntry(Map<String, dynamic> entry) {
    // Check village selection
    final selectedVillage = entry['selectedVillage']?.toString() ?? '';
    if (selectedVillage.isEmpty || selectedVillage == 'Select Village') {
      return false;
    }

    // Check survey number
    final surveyNo = entry['surveyNo']?.toString().trim() ?? '';
    if (surveyNo.isEmpty) {
      return false;
    }

    // Check share
    final shareStr = entry['share']?.toString().trim() ?? '';
    if (shareStr.isEmpty) {
      return false;
    }
    final share = double.tryParse(shareStr);
    if (share == null || share <= 0) {
      return false;
    }

    // Check area
    final areaStr = entry['area']?.toString().trim() ?? '';
    if (areaStr.isEmpty) {
      return false;
    }
    final area = double.tryParse(areaStr);
    if (area == null || area <= 0) {
      return false;
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
      case 'calculation':
        return _getCalculationError();
      default:
        return 'This field is required';
    }
  }

  String _getCalculationError() {
    // Check survey entries
    if (surveyEntries.isEmpty) {
      return 'Please add at least one survey entry';
    }

    // Check individual entries
    for (int i = 0; i < surveyEntries.length; i++) {
      final entry = surveyEntries[i];
      final entryError = _getSurveyEntryError(entry, i + 1);
      if (entryError.isNotEmpty) {
        return entryError;
      }
    }

    return 'Please fill all required fields';
  }

  String _getSurveyEntryError(Map<String, dynamic> entry, int entryNumber) {
    // Check village selection
    final selectedVillage = entry['selectedVillage']?.toString() ?? '';
    if (selectedVillage.isEmpty || selectedVillage == 'Select Village') {
      return 'Entry $entryNumber: Please select a village';
    }

    final surveyNo = entry['surveyNo']?.toString().trim() ?? '';
    if (surveyNo.isEmpty) {
      return 'Entry $entryNumber: Survey number is required';
    }

    final shareStr = entry['share']?.toString().trim() ?? '';
    if (shareStr.isEmpty) {
      return 'Entry $entryNumber: Share is required';
    }
    final share = double.tryParse(shareStr);
    if (share == null || share <= 0) {
      return 'Entry $entryNumber: Share must be a valid positive number';
    }

    final areaStr = entry['area']?.toString().trim() ?? '';
    if (areaStr.isEmpty) {
      return 'Entry $entryNumber: Area is required';
    }
    final area = double.tryParse(areaStr);
    if (area == null || area <= 0) {
      return 'Entry $entryNumber: Area must be a valid positive number';
    }

    return '';
  }

  // Data Methods (StepDataMixin)
  @override
  Map<String, dynamic> getStepData() {
    return {
      'calculation': {
        'surveyEntries': surveyEntries.map((entry) => {
          'id': entry['id'],
          'surveyNo': entry['surveyNo'],
          'share': entry['share'],
          'area': entry['area'],
          'selectedVillage': entry['selectedVillage'],
        }).toList(),
        'totalArea': totalArea,
        'totalShare': totalShare,
        'timestamp': DateTime.now().toIso8601String(),
      }
    };
  }

  // Load data from saved state (if needed)
  void loadStepData(Map<String, dynamic> data) {
    final calculationData = data['calculation'] as Map<String, dynamic>?;
    if (calculationData != null) {
      // Load survey entries
      final entriesData = calculationData['surveyEntries'] as List<dynamic>?;
      if (entriesData != null && entriesData.isNotEmpty) {
        // Clear existing entries
        for (var entry in surveyEntries) {
          entry['surveyNoController']?.dispose();
          entry['shareController']?.dispose();
          entry['areaController']?.dispose();
        }
        surveyEntries.clear();

        // Load saved entries
        for (var entryData in entriesData) {
          final entry = {
            'id': entryData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
            'surveyNoController': TextEditingController(text: entryData['surveyNo'] ?? ''),
            'shareController': TextEditingController(text: entryData['share'] ?? ''),
            'areaController': TextEditingController(text: entryData['area'] ?? ''),
            'surveyNo': entryData['surveyNo'] ?? '',
            'share': entryData['share'] ?? '',
            'area': entryData['area'] ?? '',
            'selectedVillage': entryData['selectedVillage'] ?? 'Select Village',
          };
          surveyEntries.add(entry);
        }
      }
    }
  }

  // Clear all data
  void clearAllData() {
    for (var entry in surveyEntries) {
      entry['surveyNoController']?.dispose();
      entry['shareController']?.dispose();
      entry['areaController']?.dispose();
    }
    surveyEntries.clear();
    addSurveyEntry(); // Add one default entry
  }

  // Get calculation summary for display
  Map<String, dynamic> getCalculationSummary() {
    return {
      'totalEntries': surveyEntries.length,
      'totalArea': totalArea,
      'totalShare': totalShare,
      'entries': surveyEntries.map((entry) => {
        'surveyNo': entry['surveyNo'],
        'share': entry['share'],
        'area': entry['area'],
        'selectedVillage': entry['selectedVillage'],
      }).toList(),
    };
  }

  // Additional helper methods

  // Check if any entry has the specified village
  bool hasVillageInEntries(String village) {
    return surveyEntries.any((entry) => entry['selectedVillage'] == village);
  }

  // Get all unique villages selected across entries
  List<String> getSelectedVillages() {
    final villages = <String>[];
    for (var entry in surveyEntries) {
      final village = entry['selectedVillage']?.toString() ?? '';
      if (village.isNotEmpty &&
          village != 'Select Village' &&
          !villages.contains(village)) {
        villages.add(village);
      }
    }
    return villages;
  }

  // Get entries count for a specific village
  int getEntriesCountForVillage(String village) {
    return surveyEntries
        .where((entry) => entry['selectedVillage'] == village)
        .length;
  }

  // Get total area for a specific village
  double getTotalAreaForVillage(String village) {
    double total = 0.0;
    for (var entry in surveyEntries) {
      if (entry['selectedVillage'] == village) {
        final areaStr = entry['area']?.toString() ?? '';
        final area = double.tryParse(areaStr) ?? 0.0;
        total += area;
      }
    }
    return total;
  }

  // Get total share for a specific village
  double getTotalShareForVillage(String village) {
    double total = 0.0;
    for (var entry in surveyEntries) {
      if (entry['selectedVillage'] == village) {
        final shareStr = entry['share']?.toString() ?? '';
        final share = double.tryParse(shareStr) ?? 0.0;
        total += share;
      }
    }
    return total;
  }

  // Validate if all entries are complete
  bool areAllEntriesComplete() {
    if (surveyEntries.isEmpty) return false;

    for (var entry in surveyEntries) {
      if (!_validateSurveyEntry(entry)) {
        return false;
      }
    }
    return true;
  }

  // Get completion percentage
  double getCompletionPercentage() {
    if (surveyEntries.isEmpty) return 0.0;

    int completeEntries = 0;
    for (var entry in surveyEntries) {
      if (_validateSurveyEntry(entry)) {
        completeEntries++;
      }
    }

    return (completeEntries / surveyEntries.length) * 100;
  }
}