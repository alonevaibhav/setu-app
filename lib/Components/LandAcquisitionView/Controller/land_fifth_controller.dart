import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Controller/main_controller.dart';

class LandFifthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Observable list for holder entries
  final holderEntries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one empty holder entry
    addHolderEntry();
  }

  void addHolderEntry() {
    final newEntry = {
      'holderNameController': TextEditingController(),
      'addressController': TextEditingController(),
      'accountNumberController': TextEditingController(),
      'mobileNumberController': TextEditingController(),
      'serverNumberController': TextEditingController(),
      'areaController': TextEditingController(),
      'potKharabaAreaController': TextEditingController(),
      'totalAreaController': TextEditingController(),
      'villageController': TextEditingController(),

      // Address popup controllers
      'plotNoController': TextEditingController(),
      'emailController': TextEditingController(),
      'pincodeController': TextEditingController(),
      'districtController': TextEditingController(),
      'postOfficeController': TextEditingController(),

      // Store values for validation and data collection
      'holderName': '',
      'address': '',
      'accountNumber': '',
      'mobileNumber': '',
      'serverNumber': '',
      'area': '',
      'potKharabaArea': '',
      'totalArea': '',
      'village': '',
      'plotNo': '',
      'email': '',
      'pincode': '',
      'district': '',
      'postOffice': '',
    };
    holderEntries.add(newEntry);
  }

  void removeHolderEntry(int index) {
    if (holderEntries.length > 1 && index < holderEntries.length) {
      // Dispose controllers to prevent memory leaks
      final entry = holderEntries[index];
      entry['holderNameController']?.dispose();
      entry['addressController']?.dispose();
      entry['accountNumberController']?.dispose();
      entry['mobileNumberController']?.dispose();
      entry['serverNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['potKharabaAreaController']?.dispose();
      entry['totalAreaController']?.dispose();
      entry['villageController']?.dispose();

      // Address popup controllers
      entry['plotNoController']?.dispose();
      entry['emailController']?.dispose();
      entry['pincodeController']?.dispose();
      entry['districtController']?.dispose();
      entry['postOfficeController']?.dispose();

      holderEntries.removeAt(index);
    }
  }

  void updateHolderEntry(int index, String field, String value) {
    if (index < holderEntries.length) {
      holderEntries[index][field] = value;
      holderEntries.refresh(); // Trigger UI update
    }
  }

  void updateSelectedVillage(int index, String village) {
    if (index < holderEntries.length) {
      holderEntries[index]['village'] = village;
      holderEntries.refresh();
    }
  }

  Map<String, TextEditingController> getAddressControllers(int index) {
    if (index < holderEntries.length) {
      final entry = holderEntries[index];
      return {
        'plotNoController': entry['plotNoController'],
        'addressController': entry['addressController'],
        'mobileNumberController': entry['mobileNumberController'],
        'emailController': entry['emailController'],
        'pincodeController': entry['pincodeController'],
        'districtController': entry['districtController'],
        'villageController': entry['villageController'],
        'postOfficeController': entry['postOfficeController'],
      };
    }
    return {};
  }

  void saveAddressData(int index) {
    if (index < holderEntries.length) {
      final entry = holderEntries[index];
      entry['plotNo'] = entry['plotNoController'].text;
      entry['address'] = entry['addressController'].text;
      entry['mobileNumber'] = entry['mobileNumberController'].text;
      entry['email'] = entry['emailController'].text;
      entry['pincode'] = entry['pincodeController'].text;
      entry['district'] = entry['districtController'].text;
      entry['village'] = entry['villageController'].text;
      entry['postOffice'] = entry['postOfficeController'].text;
      holderEntries.refresh();
    }
  }

  @override
  bool validateCurrentSubStep(String field) {
    // Validate all holder entries
    for (int i = 0; i < holderEntries.length; i++) {
      final entry = holderEntries[i];
      if (entry['holderName']?.isEmpty ?? true) return false;
      if (entry['address']?.isEmpty ?? true) return false;
      if (entry['accountNumber']?.isEmpty ?? true) return false;
      if (entry['mobileNumber']?.isEmpty ?? true) return false;
      if (entry['serverNumber']?.isEmpty ?? true) return false;
      if (entry['area']?.isEmpty ?? true) return false;
      if (entry['potKharabaArea']?.isEmpty ?? true) return false;
      if (entry['totalArea']?.isEmpty ?? true) return false;
      if (entry['village']?.isEmpty ?? true) return false;
      if (entry['pincode']?.isEmpty ?? true) return false;
      if (entry['postOffice']?.isEmpty ?? true) return false;

      // Validate mobile number format (10 digits)
      final mobileNumber = entry['mobileNumber'] ?? '';
      if (mobileNumber.length != 10 ||
          !RegExp(r'^\d{10}$').hasMatch(mobileNumber)) {
        return false;
      }
    }
    return holderEntries.isNotEmpty;
  }

  @override
  bool isStepCompleted(List<String> fields) {
    return validateCurrentSubStep('');
  }

  @override
  String getFieldError(String field) {
    if (holderEntries.isEmpty) {
      return 'Please add at least one holder entry';
    }

    for (int i = 0; i < holderEntries.length; i++) {
      final entry = holderEntries[i];
      if (entry['holderName']?.isEmpty ?? true) {
        return 'Holder name is required in entry ${i + 1}';
      }
      if (entry['address']?.isEmpty ?? true) {
        return 'Address is required in entry ${i + 1}';
      }
      if (entry['accountNumber']?.isEmpty ?? true) {
        return 'Account number is required in entry ${i + 1}';
      }
      if (entry['mobileNumber']?.isEmpty ?? true) {
        return 'Mobile number is required in entry ${i + 1}';
      }
      final mobileNumber = entry['mobileNumber'] ?? '';
      if (mobileNumber.length != 10 ||
          !RegExp(r'^\d{10}$').hasMatch(mobileNumber)) {
        return 'Please enter a valid 10-digit mobile number in entry ${i + 1}';
      }
      if (entry['serverNumber']?.isEmpty ?? true) {
        return 'Server number is required in entry ${i + 1}';
      }
      if (entry['area']?.isEmpty ?? true) {
        return 'Area is required in entry ${i + 1}';
      }
      if (entry['potKharabaArea']?.isEmpty ?? true) {
        return 'Pot Kharaba area is required in entry ${i + 1}';
      }
      if (entry['totalArea']?.isEmpty ?? true) {
        return 'Total area is required in entry ${i + 1}';
      }
      if (entry['village']?.isEmpty ?? true) {
        return 'Village is required in entry ${i + 1}';
      }
      if (entry['pincode']?.isEmpty ?? true) {
        return 'Pincode is required in entry ${i + 1}';
      }
      if (entry['postOffice']?.isEmpty ?? true) {
        return 'Post Office is required in entry ${i + 1}';
      }
    }
    return 'Please fill all required fields';
  }

  @override
  Map<String, dynamic> getStepData() {
    final List<Map<String, dynamic>> holderData = [];

    for (int i = 0; i < holderEntries.length; i++) {
      final entry = holderEntries[i];
      holderData.add({
        'holderName': entry['holderName'] ?? '',
        'address': entry['address'] ?? '',
        'accountNumber': entry['accountNumber'] ?? '',
        'mobileNumber': entry['mobileNumber'] ?? '',
        'serverNumber': entry['serverNumber'] ?? '',
        'area': entry['area'] ?? '',
        'potKharabaArea': entry['potKharabaArea'] ?? '',
        'totalArea': entry['totalArea'] ?? '',
        'village': entry['village'] ?? '',
        'plotNo': entry['plotNo'] ?? '',
        'email': entry['email'] ?? '',
        'pincode': entry['pincode'] ?? '',
        'district': entry['district'] ?? '',
        'postOffice': entry['postOffice'] ?? '',
      });
    }

    return {
      'holderInformation': holderData,
      'totalHolderEntries': holderEntries.length,
    };
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (final entry in holderEntries) {
      entry['holderNameController']?.dispose();
      entry['addressController']?.dispose();
      entry['accountNumberController']?.dispose();
      entry['mobileNumberController']?.dispose();
      entry['serverNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['potKharabaAreaController']?.dispose();
      entry['totalAreaController']?.dispose();
      entry['villageController']?.dispose();

      // Address popup controllers
      entry['plotNoController']?.dispose();
      entry['emailController']?.dispose();
      entry['pincodeController']?.dispose();
      entry['districtController']?.dispose();
      entry['postOfficeController']?.dispose();
    }
    super.onClose();
  }
}
