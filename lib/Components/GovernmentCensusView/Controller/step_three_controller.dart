import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class CalculationController extends GetxController
    with StepValidationMixin, StepDataMixin {

  // Observable list to store survey entries
  final surveyEntries = <Map<String, dynamic>>[].obs;

  // Form validation states
  final isFormValid = false.obs;
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one empty entry
    addSurveyEntry();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    for (final entry in surveyEntries) {
      (entry['surveyNoController'] as TextEditingController?)?.dispose();
      (entry['partNoController'] as TextEditingController?)?.dispose();
      (entry['areaController'] as TextEditingController?)?.dispose();
    }
    super.onClose();
  }

  // Add a new survey entry
  void addSurveyEntry() {
    final surveyNoController = TextEditingController();
    final partNoController = TextEditingController();
    final areaController = TextEditingController();

    final newEntry = {
      'surveyNoController': surveyNoController,
      'partNoController': partNoController,
      'areaController': areaController,
      'surveyNo': '',
      'partNo': '',
      'area': '',
      'isValid': false,
    };

    // Add listeners to text controllers
    surveyNoController.addListener(() {
      final index = surveyEntries.indexOf(newEntry);
      if (index != -1) {
        updateSurveyEntry(index, 'surveyNo', surveyNoController.text);
      }
    });

    partNoController.addListener(() {
      final index = surveyEntries.indexOf(newEntry);
      if (index != -1) {
        updateSurveyEntry(index, 'partNo', partNoController.text);
      }
    });

    areaController.addListener(() {
      final index = surveyEntries.indexOf(newEntry);
      if (index != -1) {
        updateSurveyEntry(index, 'area', areaController.text);
      }
    });

    surveyEntries.add(newEntry);
    _validateForm();
  }

  // Remove a survey entry
  void removeSurveyEntry(int index) {
    if (index >= 0 && index < surveyEntries.length && surveyEntries.length > 1) {
      // Dispose controllers before removing
      final entry = surveyEntries[index];
      (entry['surveyNoController'] as TextEditingController?)?.dispose();
      (entry['partNoController'] as TextEditingController?)?.dispose();
      (entry['areaController'] as TextEditingController?)?.dispose();

      surveyEntries.removeAt(index);
      _validateForm();
    }
  }

  // Update a specific field in a survey entry
  void updateSurveyEntry(int index, String field, String value) {
    if (index >= 0 && index < surveyEntries.length) {
      surveyEntries[index][field] = value;
      _validateSurveyEntry(index);
      _validateForm();
    }
  }

  // Validate a specific survey entry
  void _validateSurveyEntry(int index) {
    if (index >= 0 && index < surveyEntries.length) {
      final entry = surveyEntries[index];
      final surveyNo = entry['surveyNo']?.toString().trim() ?? '';
      final partNo = entry['partNo']?.toString().trim() ?? '';
      final area = entry['area']?.toString().trim() ?? '';

      // Validate survey number
      if (surveyNo.isEmpty) {
        validationErrors['surveyNo_$index'] = 'Survey No./Group No. is required';
      } else if (!RegExp(r'^[0-9A-Za-z/-]+$').hasMatch(surveyNo)) {
        validationErrors['surveyNo_$index'] = 'Please enter a valid survey number';
      } else {
        validationErrors.remove('surveyNo_$index');
      }

      // Validate part number
      if (partNo.isEmpty) {
        validationErrors['partNo_$index'] = 'Part No. is required';
      } else if (!RegExp(r'^[0-9A-Za-z/-]+$').hasMatch(partNo)) {
        validationErrors['partNo_$index'] = 'Please enter a valid part number';
      } else {
        validationErrors.remove('partNo_$index');
      }

      // Validate area
      if (area.isEmpty) {
        validationErrors['area_$index'] = 'Area is required';
      } else if (double.tryParse(area) == null || double.parse(area) <= 0) {
        validationErrors['area_$index'] = 'Please enter a valid area';
      } else {
        validationErrors.remove('area_$index');
      }

      // Update entry validity
      entry['isValid'] = surveyNo.isNotEmpty &&
          partNo.isNotEmpty &&
          area.isNotEmpty &&
          double.tryParse(area) != null &&
          double.parse(area) > 0;
    }
  }

  // Validate entire form
  void _validateForm() {
    bool allValid = surveyEntries.isNotEmpty;

    for (int i = 0; i < surveyEntries.length; i++) {
      _validateSurveyEntry(i);
      if (!(surveyEntries[i]['isValid'] ?? false)) {
        allValid = false;
      }
    }

    isFormValid.value = allValid;
  }

  // Check if survey number already exists
  bool _isSurveyNumberDuplicate(String surveyNo, int currentIndex) {
    for (int i = 0; i < surveyEntries.length; i++) {
      if (i != currentIndex && surveyEntries[i]['surveyNo'] == surveyNo) {
        return true;
      }
    }
    return false;
  }

  // Get total area across all entries
  double get totalArea {
    double total = 0.0;
    for (final entry in surveyEntries) {
      final area = entry['area']?.toString().trim() ?? '';
      if (area.isNotEmpty) {
        total += double.tryParse(area) ?? 0.0;
      }
    }
    return total;
  }

  // Get summary of all entries
  List<Map<String, dynamic>> get entriesSummary {
    return surveyEntries.map((entry) => {
      'surveyNo': entry['surveyNo'] ?? '',
      'partNo': entry['partNo'] ?? '',
      'area': entry['area'] ?? '',
      'isValid': entry['isValid'] ?? false,
    }).toList();
  }

  // Implementation of StepValidationMixin
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
  //     case 'government_survey':
  //       _validateForm();
  //       return isFormValid.value;
  //     default:
  //       return true;
  //   }
  // }

  @override
  bool isStepCompleted(List<String> fields) {
    for (final field in fields) {
      if (!validateCurrentSubStep(field)) {
        return false;
      }
    }
    return true;
  }

  @override
  String getFieldError(String field) {
    switch (field) {
      case 'government_survey':
        if (surveyEntries.isEmpty) {
          return 'Please add at least one survey entry';
        }

        // Check for specific field errors
        for (int i = 0; i < surveyEntries.length; i++) {
          final entry = surveyEntries[i];
          if (entry['surveyNo']?.toString().trim().isEmpty ?? true) {
            return 'Survey No./Group No. is required in Entry ${i + 1}';
          }
          if (entry['partNo']?.toString().trim().isEmpty ?? true) {
            return 'Part No. is required in Entry ${i + 1}';
          }
          if (entry['area']?.toString().trim().isEmpty ?? true) {
            return 'Area is required in Entry ${i + 1}';
          }
        }

        return 'Please complete all required fields';
      default:
        return 'This field is required';
    }
  }

  // Implementation of StepDataMixin
  @override
  Map<String, dynamic> getStepData() {
    return {
      'government_survey': {
        'entries': entriesSummary,
        'total_area': totalArea,
        'entry_count': surveyEntries.length,
        'timestamp': DateTime.now().toIso8601String(),
      }
    };
  }

  // Load data from saved state (if needed)
  void loadStepData(Map<String, dynamic> data) {
    final surveyData = data['government_survey'];
    if (surveyData != null && surveyData['entries'] != null) {
      // Clear existing entries
      for (final entry in surveyEntries) {
        (entry['surveyNoController'] as TextEditingController?)?.dispose();
        (entry['partNoController'] as TextEditingController?)?.dispose();
        (entry['areaController'] as TextEditingController?)?.dispose();
      }
      surveyEntries.clear();

      // Load saved entries
      final List<dynamic> entries = surveyData['entries'];
      for (final entryData in entries) {
        final surveyNoController = TextEditingController(text: entryData['surveyNo'] ?? '');
        final partNoController = TextEditingController(text: entryData['partNo'] ?? '');
        final areaController = TextEditingController(text: entryData['area'] ?? '');

        final newEntry = {
          'surveyNoController': surveyNoController,
          'partNoController': partNoController,
          'areaController': areaController,
          'surveyNo': entryData['surveyNo'] ?? '',
          'partNo': entryData['partNo'] ?? '',
          'area': entryData['area'] ?? '',
          'isValid': entryData['isValid'] ?? false,
        };

        // Add listeners to text controllers
        surveyNoController.addListener(() {
          final index = surveyEntries.indexOf(newEntry);
          if (index != -1) {
            updateSurveyEntry(index, 'surveyNo', surveyNoController.text);
          }
        });

        partNoController.addListener(() {
          final index = surveyEntries.indexOf(newEntry);
          if (index != -1) {
            updateSurveyEntry(index, 'partNo', partNoController.text);
          }
        });

        areaController.addListener(() {
          final index = surveyEntries.indexOf(newEntry);
          if (index != -1) {
            updateSurveyEntry(index, 'area', areaController.text);
          }
        });

        surveyEntries.add(newEntry);
      }

      _validateForm();
    }
  }

  // Clear all entries
  void clearAllEntries() {
    for (final entry in surveyEntries) {
      (entry['surveyNoController'] as TextEditingController?)?.dispose();
      (entry['partNoController'] as TextEditingController?)?.dispose();
      (entry['areaController'] as TextEditingController?)?.dispose();
    }
    surveyEntries.clear();
    validationErrors.clear();
    addSurveyEntry(); // Add one empty entry
  }
}