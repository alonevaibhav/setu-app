import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:setuapp/Components/LandSurveyView/Controller/main_controller.dart';
import '../../Widget/address.dart';

class SurveySixthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Co-owner entries list - each entry contains controllers and data
  final coownerEntries = <Map<String, dynamic>>[].obs;

  // Validation errors map
  final validationErrors = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with one co-owner entry by default
    addCoownerEntry();
  }

  @override
  void onClose() {
    // Dispose all controllers
    for (var entry in coownerEntries) {
      _disposeEntryControllers(entry);
    }
    super.onClose();
  }

  void addCoownerEntry() {
    final newEntry = _createNewCoownerEntry();
    coownerEntries.add(newEntry);
    clearValidationErrors();
    update(); // Trigger UI update
  }

  void removeCoownerEntry(int index) {
    if (index < coownerEntries.length && coownerEntries.length > 1) {
      final entry = coownerEntries[index];
      _disposeEntryControllers(entry);
      coownerEntries.removeAt(index);
      clearValidationErrors();
      update(); // Trigger UI update
    }
  }

  Map<String, dynamic> _createNewCoownerEntry() {
    return {
      // Basic fields
      'nameController': TextEditingController(),
      'mobileNumberController': TextEditingController(),
      'serverNumberController': TextEditingController(),
      'consentController': TextEditingController(),

      // Address controllers - these will be used in the popup
      'addressControllers': {
        'plotNoController': TextEditingController(),
        'addressController': TextEditingController(),
        'mobileNumberController': TextEditingController(), // For address popup
        'emailController': TextEditingController(),
        'pincodeController': TextEditingController(),
        'districtController': TextEditingController(),
        'villageController': TextEditingController(),
        'postOfficeController': TextEditingController(),
      },

      // Data storage
      'name': '',
      'mobileNumber': '',
      'serverNumber': '',
      'consent': '',
      'address': {
        'plotNo': '',
        'address': '',
        'mobileNumber': '',
        'email': '',
        'pincode': '',
        'district': '',
        'village': '',
        'postOffice': '',
      },
    };
  }

  void _disposeEntryControllers(Map<String, dynamic> entry) {
    // Dispose basic controllers
    (entry['nameController'] as TextEditingController?)?.dispose();
    (entry['mobileNumberController'] as TextEditingController?)?.dispose();
    (entry['serverNumberController'] as TextEditingController?)?.dispose();
    (entry['consentController'] as TextEditingController?)?.dispose();

    // Dispose address controllers
    final addressControllers = entry['addressControllers'] as Map<String, TextEditingController>?;
    addressControllers?.values.forEach((controller) => controller.dispose());
  }

  void updateCoownerEntry(int index, String field, String value) {
    if (index < coownerEntries.length) {
      coownerEntries[index][field] = value;

      // Clear validation error for this field
      validationErrors.remove('${index}_$field');

      // Validate the field
      _validateField(index, field, value);

      update(); // Trigger UI update
    }
  }

  void updateCoownerAddress(int index, Map<String, String> addressData) {
    if (index < coownerEntries.length) {
      coownerEntries[index]['address'] = addressData;

      // Clear address validation errors
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_address'));
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_pincode'));
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_village'));
      validationErrors.removeWhere((key, value) => key.startsWith('${index}_postOffice'));

      // Validate address fields
      _validateAddressFields(index, addressData);

      update(); // Trigger UI update
    }
  }

  void _validateField(int index, String field, String value) {
    switch (field) {
      case 'name':
        if (value.trim().isEmpty) {
          validationErrors['${index}_$field'] = 'Co-owner name is required';
        }
        break;
      case 'mobileNumber':
        if (value.trim().isEmpty) {
          validationErrors['${index}_$field'] = 'Mobile number is required';
        } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
          validationErrors['${index}_$field'] = 'Enter valid 10-digit mobile number';
        }
        break;
      case 'consent':
        if (value.trim().isEmpty) {
          validationErrors['${index}_$field'] = 'Consent information is required';
        }
        break;
    }
  }

  void _validateAddressFields(int index, Map<String, String> addressData) {
    if (addressData['address']?.trim().isEmpty ?? true) {
      validationErrors['${index}_address'] = 'Address is required';
    }
    if (addressData['pincode']?.trim().isEmpty ?? true) {
      validationErrors['${index}_pincode'] = 'Pincode is required';
    }
    if (addressData['village']?.trim().isEmpty ?? true) {
      validationErrors['${index}_village'] = 'Village is required';
    }
    if (addressData['postOffice']?.trim().isEmpty ?? true) {
      validationErrors['${index}_postOffice'] = 'Post Office is required';
    }
  }

  void clearValidationErrors() {
    validationErrors.clear();
  }

  // Get formatted address for display
  String getFormattedAddress(int index) {
    if (index >= coownerEntries.length) return 'Click to add address';

    final address = coownerEntries[index]['address'] as Map<String, String>;
    final parts = <String>[];

    if (address['plotNo']?.isNotEmpty == true) parts.add(address['plotNo']!);
    if (address['address']?.isNotEmpty == true) parts.add(address['address']!);
    if (address['village']?.isNotEmpty == true) parts.add(address['village']!);
    if (address['postOffice']?.isNotEmpty == true) parts.add(address['postOffice']!);
    if (address['pincode']?.isNotEmpty == true) parts.add(address['pincode']!);

    return parts.isEmpty ? 'Click to add address' : parts.join(', ');
  }

  // Show address popup
  void showAddressPopup(BuildContext context, int index) {
    if (index >= coownerEntries.length) return;

    final addressControllers = coownerEntries[index]['addressControllers'] as Map<String, TextEditingController>;
    final currentAddress = coownerEntries[index]['address'] as Map<String, String>;

    // Populate controllers with current data
    addressControllers['plotNoController']!.text = currentAddress['plotNo'] ?? '';
    addressControllers['addressController']!.text = currentAddress['address'] ?? '';
    addressControllers['mobileNumberController']!.text = currentAddress['mobileNumber'] ?? '';
    addressControllers['emailController']!.text = currentAddress['email'] ?? '';
    addressControllers['pincodeController']!.text = currentAddress['pincode'] ?? '';
    addressControllers['districtController']!.text = currentAddress['district'] ?? '';
    addressControllers['villageController']!.text = currentAddress['village'] ?? '';
    addressControllers['postOfficeController']!.text = currentAddress['postOffice'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AddressPopup(
        entryIndex: index,
        controllers: addressControllers,
        onSave: () => _saveAddressFromPopup(index),
      ),
    );
  }

  void _saveAddressFromPopup(int index) {
    final addressControllers = coownerEntries[index]['addressControllers'] as Map<String, TextEditingController>;

    final addressData = {
      'plotNo': addressControllers['plotNoController']!.text,
      'address': addressControllers['addressController']!.text,
      'mobileNumber': addressControllers['mobileNumberController']!.text,
      'email': addressControllers['emailController']!.text,
      'pincode': addressControllers['pincodeController']!.text,
      'district': addressControllers['districtController']!.text,
      'village': addressControllers['villageController']!.text,
      'postOffice': addressControllers['postOfficeController']!.text,
    };

    updateCoownerAddress(index, addressData);
    Get.back(); // Close the popup
  }

  // StepValidationMixin implementation
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
  //   clearValidationErrors();
  //   bool isValid = true;
  //
  //   for (int i = 0; i < coownerEntries.length; i++) {
  //     final entry = coownerEntries[i];
  //
  //     // Validate required fields
  //     final name = (entry['nameController'] as TextEditingController).text;
  //     final mobileNumber = (entry['mobileNumberController'] as TextEditingController).text;
  //     final consent = (entry['consentController'] as TextEditingController).text;
  //     final address = entry['address'] as Map<String, String>;
  //
  //     _validateField(i, 'name', name);
  //     _validateField(i, 'mobileNumber', mobileNumber);
  //     _validateField(i, 'consent', consent);
  //     _validateAddressFields(i, address);
  //
  //     // Update the entry data
  //     entry['name'] = name;
  //     entry['mobileNumber'] = mobileNumber;
  //     entry['consent'] = consent;
  //     entry['serverNumber'] = (entry['serverNumberController'] as TextEditingController).text;
  //   }
  //
  //   isValid = validationErrors.isEmpty;
  //   return isValid;
  // }

  @override
  bool isStepCompleted(List<String> fields) {
    return validateCurrentSubStep('');
  }

  @override
  String getFieldError(String field) {
    if (validationErrors.isNotEmpty) {
      return validationErrors.values.first;
    }
    return 'Please complete all required fields';
  }

  // StepDataMixin implementation
  @override
  Map<String, dynamic> getStepData() {
    final List<Map<String, dynamic>> coownerData = [];

    for (int i = 0; i < coownerEntries.length; i++) {
      final entry = coownerEntries[i];
      coownerData.add({
        'name': entry['name'] ?? '',
        'mobileNumber': entry['mobileNumber'] ?? '',
        'serverNumber': entry['serverNumber'] ?? '',
        'consent': entry['consent'] ?? '',
        'address': Map<String, String>.from(entry['address'] as Map? ?? {}),
      });
    }

    return {
      'coowners': coownerData,
      'coownerCount': coownerEntries.length,
    };
  }
}

