import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class LandSixthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable list for next of kin entries
  final nextOfKinEntries = <Map<String, dynamic>>[].obs;

  // Dropdown options
  final List<String> directionOptions = ['East', 'West', 'North', 'South'];

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
      'addressController': TextEditingController(),
      'mobileController': TextEditingController(),
      'surveyNoController': TextEditingController(),
      'direction': '', // Initialize as empty string, not null
      'naturalResources': '', // Initialize as empty string, not null
      'address': '',
      'mobile': '',
      'surveyNo': '',
    });
  }

  void removeNextOfKinEntry(int index) {
    if (nextOfKinEntries.length > 1 && index < nextOfKinEntries.length) {
      // Dispose controllers
      final entry = nextOfKinEntries[index];
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
      // Check required fields with proper null handling (removed 'name' field)
      if ((entry['address'] as String? ?? '').trim().isEmpty ||
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
          // Removed name field validation
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
        // Removed 'name' field from data export
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
    // Dispose all controllers (removed nameController)
    for (final entry in nextOfKinEntries) {
      (entry['addressController'] as TextEditingController?)?.dispose();
      (entry['mobileController'] as TextEditingController?)?.dispose();
      (entry['surveyNoController'] as TextEditingController?)?.dispose();
    }
    super.onClose();
  }
}
