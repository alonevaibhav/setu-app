import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class landSixthController extends GetxController
    with StepValidationMixin, StepDataMixin {
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
    final addressController = TextEditingController();
    final mobileController = TextEditingController();
    final surveyNoController = TextEditingController();

    // Add listeners to sync controller text with map data
    addressController.addListener(() {
      final index = nextOfKinEntries.length - 1; // Current entry index
      if (index >= 0 && index < nextOfKinEntries.length) {
        nextOfKinEntries[index]['address'] = addressController.text;
      }
    });

    mobileController.addListener(() {
      final index = nextOfKinEntries.length - 1; // Current entry index
      if (index >= 0 && index < nextOfKinEntries.length) {
        nextOfKinEntries[index]['mobile'] = mobileController.text;
      }
    });

    surveyNoController.addListener(() {
      final index = nextOfKinEntries.length - 1; // Current entry index
      if (index >= 0 && index < nextOfKinEntries.length) {
        nextOfKinEntries[index]['surveyNo'] = surveyNoController.text;
      }
    });

    nextOfKinEntries.add({
      'addressController': addressController,
      'mobileController': mobileController,
      'surveyNoController': surveyNoController,
      'direction': '',
      'naturalResources': '',
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
      case 'next_of_kin':
        return _validateNextOfKinEntries();
      default:
        return true;
    }
  }

  bool _validateNextOfKinEntries() {
    if (nextOfKinEntries.isEmpty) return false;

    for (final entry in nextOfKinEntries) {
      // Get current values from controllers to ensure we have the latest data
      final addressController =
          entry['addressController'] as TextEditingController?;
      final mobileController =
          entry['mobileController'] as TextEditingController?;
      final surveyNoController =
          entry['surveyNoController'] as TextEditingController?;

      final address = addressController?.text.trim() ?? '';
      final mobile = mobileController?.text.trim() ?? '';
      final surveyNo = surveyNoController?.text.trim() ?? '';
      final direction = (entry['direction'] as String? ?? '').trim();
      final naturalResources =
          (entry['naturalResources'] as String? ?? '').trim();

      // Check required fields
      if (address.isEmpty ||
          mobile.isEmpty ||
          surveyNo.isEmpty ||
          direction.isEmpty ||
          naturalResources.isEmpty) {
        return false;
      }

      // Validate mobile number (basic validation)
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

          // Get current values from controllers
          final addressController =
              entry['addressController'] as TextEditingController?;
          final mobileController =
              entry['mobileController'] as TextEditingController?;
          final surveyNoController =
              entry['surveyNoController'] as TextEditingController?;

          final address = addressController?.text.trim() ?? '';
          final mobile = mobileController?.text.trim() ?? '';
          final surveyNo = surveyNoController?.text.trim() ?? '';
          final direction = (entry['direction'] as String? ?? '').trim();
          final naturalResources =
              (entry['naturalResources'] as String? ?? '').trim();

          if (address.isEmpty) {
            return 'Address is required in entry ${i + 1}';
          }
          if (mobile.isEmpty) {
            return 'Mobile number is required in entry ${i + 1}';
          }
          if (surveyNo.isEmpty) {
            return 'Survey No./Group No. is required in entry ${i + 1}';
          }
          if (direction.isEmpty) {
            return 'Direction is required in entry ${i + 1}';
          }
          if (naturalResources.isEmpty) {
            return 'Natural resources is required in entry ${i + 1}';
          }

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
      final addressController =
          entry['addressController'] as TextEditingController?;
      final mobileController =
          entry['mobileController'] as TextEditingController?;
      final surveyNoController =
          entry['surveyNoController'] as TextEditingController?;

      entriesData.add({
        'address': addressController?.text ?? '',
        'mobile': mobileController?.text ?? '',
        'surveyNo': surveyNoController?.text ?? '',
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
      (entry['addressController'] as TextEditingController?)?.dispose();
      (entry['mobileController'] as TextEditingController?)?.dispose();
      (entry['surveyNoController'] as TextEditingController?)?.dispose();
    }
    super.onClose();
  }
}
