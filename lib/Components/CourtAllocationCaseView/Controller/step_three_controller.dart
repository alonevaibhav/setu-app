import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class CalculationController extends GetxController
    with StepValidationMixin, StepDataMixin {

  // Survey entries list
  final surveyEntries = <Map<String, dynamic>>[].obs;

  // Village selection
  final selectedVillage = ''.obs;

  // Village options - you can populate this from your data source
  final List<String> villageOptions = [
    'Village 1',
    'Village 2',
    'Village 3',
    'Village 4',
    'Village 5',
  ];

  // Validation states
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one empty survey entry
    addSurveyEntry();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    for (var entry in surveyEntries) {
      entry['surveyNoController']?.dispose();
      entry['areaController']?.dispose();
      entry['abdominalController']?.dispose();
    }
    super.onClose();
  }

  // Add a new survey entry
  void addSurveyEntry() {
    final newEntry = {
      'surveyNoController': TextEditingController(),
      'areaController': TextEditingController(),
      'abdominalController': TextEditingController(),
      'surveyNo': '',
      'area': '',
      'abdominalSection': '',
      'village': selectedVillage.value,
    };

    surveyEntries.add(newEntry);
  }

  // Remove a survey entry
  void removeSurveyEntry(int index) {
    if (surveyEntries.length > 1 && index >= 0 && index < surveyEntries.length) {
      // Dispose controllers before removing
      surveyEntries[index]['surveyNoController']?.dispose();
      surveyEntries[index]['areaController']?.dispose();
      surveyEntries[index]['abdominalController']?.dispose();

      surveyEntries.removeAt(index);
    }
  }

  // Update survey entry data
  void updateSurveyEntry(int index, String field, String value) {
    if (index >= 0 && index < surveyEntries.length) {
      surveyEntries[index][field] = value;

      // Update the survey entries list to trigger UI update
      surveyEntries.refresh();

      // Clear validation error for this field
      validationErrors.remove('${index}_$field');
    }
  }

  // Update selected village
  void updateSelectedVillage(String village) {
    selectedVillage.value = village;

    // Update village for all existing entries
    for (var entry in surveyEntries) {
      entry['village'] = village;
    }

    // Clear validation error
    validationErrors.remove('selectedVillage');
  }

  // Validation Methods (from StepValidationMixin)
  @override
  bool validateCurrentSubStep(String field) {
    validationErrors.clear();

    switch (field) {
      case 'calculation':
        return _validateCalculationStep();
      default:
        return true;
    }
  }

  bool _validateCalculationStep() {
    bool isValid = true;

    // Validate village selection
    if (selectedVillage.value.isEmpty) {
      validationErrors['selectedVillage'] = 'Please select a village';
      isValid = false;
    }

    // Validate survey entries
    for (int i = 0; i < surveyEntries.length; i++) {
      final entry = surveyEntries[i];

      // Validate Survey No./TP No.
      if (entry['surveyNo'] == null || entry['surveyNo'].toString().trim().isEmpty) {
        validationErrors['${i}_surveyNo'] = 'Survey No./TP No. is required';
        isValid = false;
      }

      // Validate Area
      if (entry['area'] == null || entry['area'].toString().trim().isEmpty) {
        validationErrors['${i}_area'] = 'Area is required';
        isValid = false;
      } else {
        // Check if area is a valid number
        final areaValue = double.tryParse(entry['area'].toString());
        if (areaValue == null || areaValue <= 0) {
          validationErrors['${i}_area'] = 'Please enter a valid area';
          isValid = false;
        }
      }

      // Validate Abdominal Section
      if (entry['abdominalSection'] == null || entry['abdominalSection'].toString().trim().isEmpty) {
        validationErrors['${i}_abdominalSection'] = 'Abdominal section is required';
        isValid = false;
      }
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
      case 'calculation':
        if (validationErrors.containsKey('selectedVillage')) {
          return validationErrors['selectedVillage']!;
        }
        // Return the first validation error found
        if (validationErrors.isNotEmpty) {
          return validationErrors.values.first;
        }
        return 'Please fill all required fields';
      default:
        return 'This field is required';
    }
  }

  // Data Methods (from StepDataMixin)
  @override
  Map<String, dynamic> getStepData() {
    final List<Map<String, dynamic>> surveyData = [];

    for (int i = 0; i < surveyEntries.length; i++) {
      final entry = surveyEntries[i];
      surveyData.add({
        'entryIndex': i + 1,
        'surveyNo': entry['surveyNo'] ?? '',
        'area': entry['area'] ?? '',
        'abdominalSection': entry['abdominalSection'] ?? '',
        'village': selectedVillage.value,
      });
    }

    return {
      'calculationStep': {
        'selectedVillage': selectedVillage.value,
        'surveyEntries': surveyData,
        'totalEntries': surveyEntries.length,
        'timestamp': DateTime.now().toIso8601String(),
      }
    };
  }

  // Helper Methods

  // Get total area from all entries
  double getTotalArea() {
    double total = 0.0;
    for (var entry in surveyEntries) {
      final area = double.tryParse(entry['area'] ?? '0') ?? 0.0;
      total += area;
    }
    return total;
  }

  // Get formatted total area string
  String getFormattedTotalArea() {
    final total = getTotalArea();
    return total.toStringAsFixed(2);
  }

  // Check if entry has validation errors
  bool hasEntryError(int index, String field) {
    return validationErrors.containsKey('${index}_$field');
  }

  // Get entry error message
  String getEntryError(int index, String field) {
    return validationErrors['${index}_$field'] ?? '';
  }

  // Clear all validation errors
  void clearValidationErrors() {
    validationErrors.clear();
  }

  // Load data from previous save (if needed)
  void loadStepData(Map<String, dynamic> data) {
    if (data.containsKey('calculationStep')) {
      final stepData = data['calculationStep'];

      // Load village selection
      if (stepData.containsKey('selectedVillage')) {
        selectedVillage.value = stepData['selectedVillage'] ?? '';
      }

      // Load survey entries
      if (stepData.containsKey('surveyEntries')) {
        final entriesData = stepData['surveyEntries'] as List<dynamic>;

        // Clear existing entries
        for (var entry in surveyEntries) {
          entry['surveyNoController']?.dispose();
          entry['areaController']?.dispose();
          entry['abdominalController']?.dispose();
        }
        surveyEntries.clear();

        // Add loaded entries
        for (var entryData in entriesData) {
          final surveyController = TextEditingController(text: entryData['surveyNo'] ?? '');
          final areaController = TextEditingController(text: entryData['area'] ?? '');
          final abdominalController = TextEditingController(text: entryData['abdominalSection'] ?? '');

          final entry = {
            'surveyNoController': surveyController,
            'areaController': areaController,
            'abdominalController': abdominalController,
            'surveyNo': entryData['surveyNo'] ?? '',
            'area': entryData['area'] ?? '',
            'abdominalSection': entryData['abdominalSection'] ?? '',
            'village': entryData['village'] ?? '',
          };

          surveyEntries.add(entry);
        }

        // If no entries were loaded, add a default one
        if (surveyEntries.isEmpty) {
          addSurveyEntry();
        }
      }
    }
  }
}