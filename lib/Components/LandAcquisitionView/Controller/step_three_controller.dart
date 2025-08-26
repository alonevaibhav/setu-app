

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../LandAcquisitionView/Controller/main_controller.dart';

class CalculationController extends GetxController with StepValidationMixin, StepDataMixin {

  // Village Selection
  final selectedVillage = ''.obs;
  final villageOptions = [
    'Village 1',
    'Village 2',
    'Village 3',
    'Village 4',
    'Village 5',
  ];

  // Survey Entries List
  final surveyEntries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    addSurveyEntry(); // Add initial entry
  }

  // Village Methods
  void updateSelectedVillage(String village) {
    selectedVillage.value = village;
  }

  // Survey Entry Methods
  void addSurveyEntry() {
    surveyEntries.add({
      'surveyNoController': TextEditingController(),
      'shareController': TextEditingController(),
      'areaController': TextEditingController(),
      'landAcquisitionAreaController': TextEditingController(),
      'abdominalSectionController': TextEditingController(),
      'surveyNo': '',
      'share': '',
      'area': '',
      'landAcquisitionArea': '',
      'abdominalSection': '',
    });
  }

  void removeSurveyEntry(int index) {
    if (surveyEntries.length > 1 && index < surveyEntries.length) {
      // Dispose controllers to prevent memory leaks
      final entry = surveyEntries[index];
      entry['surveyNoController']?.dispose();
      entry['shareController']?.dispose();
      entry['areaController']?.dispose();
      entry['landAcquisitionAreaController']?.dispose();
      entry['abdominalSectionController']?.dispose();

      surveyEntries.removeAt(index);
    }
  }

  void updateSurveyEntry(int index, String field, String value) {
    if (index < surveyEntries.length) {
      surveyEntries[index][field] = value;
      surveyEntries.refresh();
    }
  }

  // Clear all entries
  void clearAllEntries() {
    // Dispose all controllers
    for (var entry in surveyEntries) {
      entry['surveyNoController']?.dispose();
      entry['shareController']?.dispose();
      entry['areaController']?.dispose();
      entry['landAcquisitionAreaController']?.dispose();
      entry['abdominalSectionController']?.dispose();
    }
    surveyEntries.clear();
    addSurveyEntry(); // Add back initial entry
  }

  // Get entry summary
  String getEntrySummary(int index) {
    if (index < surveyEntries.length) {
      final entry = surveyEntries[index];
      final surveyNo = entry['surveyNo'] ?? '';
      final area = entry['area'] ?? '';
      final landAcqArea = entry['landAcquisitionArea'] ?? '';

      if (surveyNo.isNotEmpty && area.isNotEmpty && landAcqArea.isNotEmpty) {
        return 'Survey: $surveyNo, Area: $area, Land Acq: $landAcqArea';
      }
    }
    return 'Entry ${index + 1} - Incomplete';
  }

  // Calculate total area
  double get totalArea {
    double total = 0.0;
    for (var entry in surveyEntries) {
      final areaStr = entry['area'] ?? '';
      if (areaStr.isNotEmpty) {
        total += double.tryParse(areaStr) ?? 0.0;
      }
    }
    return total;
  }

  // Calculate total land acquisition area
  double get totalLandAcquisitionArea {
    double total = 0.0;
    for (var entry in surveyEntries) {
      final areaStr = entry['landAcquisitionArea'] ?? '';
      if (areaStr.isNotEmpty) {
        total += double.tryParse(areaStr) ?? 0.0;
      }
    }
    return total;
  }

  // Get completed entries count
  int get completedEntriesCount {
    int count = 0;
    for (var entry in surveyEntries) {
      if (isEntryComplete(entry)) {
        count++;
      }
    }
    return count;
  }

  // Check if entry is complete
  bool isEntryComplete(Map<String, dynamic> entry) {
    final requiredFields = ['surveyNo', 'share', 'area', 'landAcquisitionArea', 'abdominalSection'];
    for (String field in requiredFields) {
      final value = entry[field] ?? '';
      if (value.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (var entry in surveyEntries) {
      entry['surveyNoController']?.dispose();
      entry['shareController']?.dispose();
      entry['areaController']?.dispose();
      entry['landAcquisitionAreaController']?.dispose();
      entry['abdominalSectionController']?.dispose();
    }
    super.onClose();
  }

  // StepValidationMixin Implementation
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
  //       return validateCalculationStep();
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
        return getCalculationError();
      default:
        return 'This field is required';
    }
  }

  // Private validation methods
  bool validateCalculationStep() {
    // Check if village is selected
    if (selectedVillage.value.isEmpty) {
      return false;
    }

    // Check if at least one entry exists and is complete
    if (surveyEntries.isEmpty) {
      return false;
    }

    // Check if at least one entry is complete
    bool hasCompleteEntry = false;
    for (var entry in surveyEntries) {
      if (isEntryComplete(entry)) {
        hasCompleteEntry = true;
        break;
      }
    }

    return hasCompleteEntry;
  }

  String getCalculationError() {
    if (selectedVillage.value.isEmpty) {
      return 'Please select a village';
    }

    if (surveyEntries.isEmpty) {
      return 'Please add at least one survey entry';
    }

    bool hasCompleteEntry = false;
    for (var entry in surveyEntries) {
      if (isEntryComplete(entry)) {
        hasCompleteEntry = true;
        break;
      }
    }

    if (!hasCompleteEntry) {
      return 'Please complete at least one survey entry with all required fields';
    }

    return 'Validation passed';
  }

  // StepDataMixin Implementation
  @override
  Map<String, dynamic> getStepData() {
    List<Map<String, dynamic>> entriesData = [];

    for (int i = 0; i < surveyEntries.length; i++) {
      final entry = surveyEntries[i];
      entriesData.add({
        'index': i,
        'surveyNo': entry['surveyNo'] ?? '',
        'share': entry['share'] ?? '',
        'area': entry['area'] ?? '',
        'landAcquisitionArea': entry['landAcquisitionArea'] ?? '',
        'abdominalSection': entry['abdominalSection'] ?? '',
        'isComplete': isEntryComplete(entry),
      });
    }

    return {
      'step': 'calculation',
      'selectedVillage': selectedVillage.value,
      'surveyEntries': entriesData,
      'totalArea': totalArea,
      'totalLandAcquisitionArea': totalLandAcquisitionArea,
      'completedEntriesCount': completedEntriesCount,
      'totalEntriesCount': surveyEntries.length,
      'isStepCompleted': validateCalculationStep(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Reset form
  void resetForm() {
    selectedVillage.value = '';
    clearAllEntries();
  }

  // Load data from saved state
  void loadData(Map<String, dynamic> data) {
    if (data.containsKey('selectedVillage')) {
      selectedVillage.value = data['selectedVillage'] ?? '';
    }

    if (data.containsKey('surveyEntries')) {
      final savedEntries = data['surveyEntries'] as List<dynamic>? ?? [];
      clearAllEntries();

      for (var savedEntry in savedEntries) {
        if (savedEntry is Map<String, dynamic>) {
          addSurveyEntry();
          final index = surveyEntries.length - 1;

          // Load saved values
          final surveyNo = savedEntry['surveyNo'] ?? '';
          final share = savedEntry['share'] ?? '';
          final area = savedEntry['area'] ?? '';
          final landAcqArea = savedEntry['landAcquisitionArea'] ?? '';
          final abdominalSection = savedEntry['abdominalSection'] ?? '';

          // Update controllers and values
          surveyEntries[index]['surveyNoController'].text = surveyNo;
          surveyEntries[index]['shareController'].text = share;
          surveyEntries[index]['areaController'].text = area;
          surveyEntries[index]['landAcquisitionAreaController'].text = landAcqArea;
          surveyEntries[index]['abdominalSectionController'].text = abdominalSection;

          updateSurveyEntry(index, 'surveyNo', surveyNo);
          updateSurveyEntry(index, 'share', share);
          updateSurveyEntry(index, 'area', area);
          updateSurveyEntry(index, 'landAcquisitionArea', landAcqArea);
          updateSurveyEntry(index, 'abdominalSection', abdominalSection);
        }
      }
    }
  }
}