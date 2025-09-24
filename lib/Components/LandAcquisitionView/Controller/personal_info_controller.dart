import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';
import '../../Widget/address.dart';

class PersonalInfoController extends GetxController
    with StepValidationMixin, StepDataMixin {
  // Form Controllers (only applicant name is used in the UI)
  final applicantNameController = TextEditingController();

  // Land Acquisition Form Controllers
  final landAcquisitionOfficerController = TextEditingController();
  final landAcquisitionBoardController = TextEditingController();
  final landAcquisitionDetailsController = TextEditingController();
  final landAcquisitionOrderNumberController = TextEditingController();
  final landAcquisitionOrderDateController = TextEditingController();
  final landAcquisitionOfficeAddressController =
      TextEditingController(); // Keep for backward compatibility

  // Observable boolean values (not used in current UI)
  final isHolderThemselves = Rxn<bool>();
  final hasAuthorityOnBehalf = Rxn<bool>();
  final hasBeenCountedBefore = Rxn<bool>();

  // File upload observables for land acquisition
  final landAcquisitionOrderFiles = <String>[].obs;
  final landAcquisitionMapFiles = <String>[].obs;
  final kmlFiles = <String>[].obs;

  //------------------------Address Validation Implementation ------------------------//

  // Office address data storage
  final officeAddressData = <String, String>{
    'plotNo': '',
    'address': '',
    'mobileNumber': '',
    'email': '',
    'pincode': '',
    'district': '',
    'village': '',
    'postOffice': '',
  }.obs;

  // Address validation errors
  final officeAddressValidationErrors = <String, String>{}.obs;

  // Address controllers for the popup
  final officeAddressControllers = <String, TextEditingController>{
    'plotNoController': TextEditingController(),
    'addressController': TextEditingController(),
    'mobileNumberController': TextEditingController(),
    'emailController': TextEditingController(),
    'pincodeController': TextEditingController(),
    'districtController': TextEditingController(),
    'villageController': TextEditingController(),
    'postOfficeController': TextEditingController(),
  };

  @override
  void onClose() {
    // Dispose controllers
    applicantNameController.dispose();

    // Dispose land acquisition controllers
    landAcquisitionOfficerController.dispose();
    landAcquisitionBoardController.dispose();
    landAcquisitionDetailsController.dispose();
    landAcquisitionOrderNumberController.dispose();
    landAcquisitionOrderDateController.dispose();
    landAcquisitionOfficeAddressController.dispose();

    // Dispose address controllers
    officeAddressControllers.values
        .forEach((controller) => controller.dispose());

    super.onClose();
  }

  // Reset methods (not used in current UI but kept for future use)
  void resetAuthorityFields() {
    hasAuthorityOnBehalf.value = null;
    applicantNameController.clear();
    clearPOAFields();
  }

  void clearPOAFields() {
    // POA controllers removed as they're not used
  }

  void clearLandAcquisitionFields() {
    landAcquisitionOfficerController.clear();
    landAcquisitionBoardController.clear();
    landAcquisitionDetailsController.clear();
    landAcquisitionOrderNumberController.clear();
    landAcquisitionOrderDateController.clear();
    landAcquisitionOfficeAddressController.clear();
    landAcquisitionOrderFiles.clear();
    landAcquisitionMapFiles.clear();
    kmlFiles.clear();

    // Clear address data
    clearOfficeAddressFields();
  }

  // Handle holder themselves selection
  void updateHolderThemselves(bool? value) {
    isHolderThemselves.value = value;
    if (value == true) {
      resetAuthorityFields();
    }
  }

  // Handle authority on behalf selection
  void updateAuthorityOnBehalf(bool? value) {
    hasAuthorityOnBehalf.value = value;
    if (value != true) {
      clearPOAFields();
    }
  }

  // Handle enumeration check
  void updateEnumerationCheck(bool? value) {
    hasBeenCountedBefore.value = value;
  }

  // Update land acquisition order date
  void updateLandAcquisitionOrderDate(DateTime selectedDate) {
    landAcquisitionOrderDateController.text =
        "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
  }

  //------------------------Address Methods ------------------------//

  // Office address formatting method
  String getFormattedOfficeAddress() {
    final parts = <String>[];

    if (officeAddressData['plotNo']?.isNotEmpty == true) {
      parts.add(officeAddressData['plotNo']!);
    }
    if (officeAddressData['address']?.isNotEmpty == true) {
      parts.add(officeAddressData['address']!);
    }
    if (officeAddressData['village']?.isNotEmpty == true) {
      parts.add(officeAddressData['village']!);
    }
    if (officeAddressData['postOffice']?.isNotEmpty == true) {
      parts.add(officeAddressData['postOffice']!);
    }
    if (officeAddressData['pincode']?.isNotEmpty == true) {
      parts.add(officeAddressData['pincode']!);
    }

    return parts.isEmpty ? 'Click to add office address' : parts.join(', ');
  }

  // Check if detailed office address is available
  bool hasDetailedOfficeAddress() {
    return officeAddressData.isNotEmpty &&
        (officeAddressData['address']?.isNotEmpty == true ||
            officeAddressData['village']?.isNotEmpty == true);
  }

  // Show office address popup
  void showOfficeAddressPopup(BuildContext context) {
    // Populate controllers with current data
    officeAddressControllers['plotNoController']!.text =
        officeAddressData['plotNo'] ?? '';
    officeAddressControllers['addressController']!.text =
        officeAddressData['address'] ?? '';
    officeAddressControllers['mobileNumberController']!.text =
        officeAddressData['mobileNumber'] ?? '';
    officeAddressControllers['emailController']!.text =
        officeAddressData['email'] ?? '';
    officeAddressControllers['pincodeController']!.text =
        officeAddressData['pincode'] ?? '';
    officeAddressControllers['districtController']!.text =
        officeAddressData['district'] ?? '';
    officeAddressControllers['villageController']!.text =
        officeAddressData['village'] ?? '';
    officeAddressControllers['postOfficeController']!.text =
        officeAddressData['postOffice'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AddressPopup(
        entryIndex: 0,
        controllers: officeAddressControllers,
        onSave: () => _saveOfficeAddressFromPopup(),
      ),
    );
  }

  // Save office address from popup
  void _saveOfficeAddressFromPopup() {
    final newAddressData = {
      'plotNo': officeAddressControllers['plotNoController']!.text,
      'address': officeAddressControllers['addressController']!.text,
      'mobileNumber': officeAddressControllers['mobileNumberController']!.text,
      'email': officeAddressControllers['emailController']!.text,
      'pincode': officeAddressControllers['pincodeController']!.text,
      'district': officeAddressControllers['districtController']!.text,
      'village': officeAddressControllers['villageController']!.text,
      'postOffice': officeAddressControllers['postOfficeController']!.text,
    };

    updateOfficeAddress(newAddressData);
    Get.back(); // Close the popup
  }

  // Update office address with validation
  void updateOfficeAddress(Map<String, String> newAddressData) {
    officeAddressData.assignAll(newAddressData);

    // Update the old controller for backward compatibility
    landAcquisitionOfficeAddressController.text = getFormattedOfficeAddress();

    // Clear validation errors
    officeAddressValidationErrors.clear();

    // Validate address fields
    _validateOfficeAddressFields(newAddressData);

    update(); // Trigger UI update
  }

  // Validate office address fields
  void _validateOfficeAddressFields(Map<String, String> addressData) {
    if (addressData['address']?.trim().isEmpty ?? true) {
      officeAddressValidationErrors['address'] = 'Office address is required';
    }
    if (addressData['pincode']?.trim().isEmpty ?? true) {
      officeAddressValidationErrors['pincode'] = 'Pincode is required';
    }
    if (addressData['village']?.trim().isEmpty ?? true) {
      officeAddressValidationErrors['village'] = 'Village is required';
    }
    if (addressData['postOffice']?.trim().isEmpty ?? true) {
      officeAddressValidationErrors['postOffice'] = 'Post Office is required';
    }
  }

  // Clear office address fields
  void clearOfficeAddressFields() {
    officeAddressData.clear();
    officeAddressValidationErrors.clear();
    officeAddressControllers.values.forEach((controller) => controller.clear());
    landAcquisitionOfficeAddressController.clear();
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
  //     case 'land_acquisition_details':
  //       return _validateLandAcquisitionFields();
  //
  //     default:
  //       return true;
  //   }
  // }

  bool _validateLandAcquisitionFields() {
    // Validate address fields first
    _validateOfficeAddressFields(officeAddressData);

    return landAcquisitionOfficerController.text.trim().length >= 2 &&
        landAcquisitionBoardController.text.trim().length >= 2 &&
        landAcquisitionDetailsController.text.trim().length >= 2 &&
        landAcquisitionOrderNumberController.text.trim().length >= 2 &&
        landAcquisitionOrderDateController.text.trim().isNotEmpty &&
        officeAddressValidationErrors.isEmpty && // Check address validation
        landAcquisitionOrderFiles.isNotEmpty &&
        landAcquisitionMapFiles.isNotEmpty &&
        kmlFiles.isNotEmpty;
  }

  @override
  bool isStepCompleted(List<String> fields) {
    for (String field in fields) {
      if (!validateCurrentSubStep(field)) return false;
    }
    return true;
  }

  @override
  String getFieldError(String field) {
    switch (field) {
      case 'land_acquisition_details':
        return _getLandAcquisitionValidationError();

      default:
        return 'This field is required';
    }
  }

  String _getLandAcquisitionValidationError() {
    if (landAcquisitionOfficerController.text.trim().length < 2) {
      return 'Land Acquisition Officer name must be at least 2 characters';
    }
    if (landAcquisitionBoardController.text.trim().length < 2) {
      return 'Land Acquisition Board details must be at least 2 characters';
    }
    if (landAcquisitionDetailsController.text.trim().length < 2) {
      return 'Land acquisition details must be at least 2 characters';
    }
    if (landAcquisitionOrderNumberController.text.trim().length < 2) {
      return 'Land Acquisition Order Number must be at least 2 characters';
    }
    if (landAcquisitionOrderDateController.text.trim().isEmpty) {
      return 'Land Acquisition Order Date is required';
    }
    if (officeAddressValidationErrors.isNotEmpty) {
      return 'Please complete the office address details';
    }
    if (landAcquisitionOrderFiles.isEmpty) {
      return 'Land Acquisition Order document is required';
    }
    if (landAcquisitionMapFiles.isEmpty) {
      return 'Land Acquisition Simankan Map is required';
    }
    if (kmlFiles.isEmpty) {
      return 'KML File is required';
    }
    return 'Please complete all Land Acquisition fields';
  }

  @override
  Map<String, dynamic> getStepData() {
    return {
      'personal_info': {
        'applicant_name': applicantNameController.text.trim(),
      },
      'land_acquisition': {
        'land_acquisition_officer':
            landAcquisitionOfficerController.text.trim(),
        'land_acquisition_board': landAcquisitionBoardController.text.trim(),
        'land_acquisition_details':
            landAcquisitionDetailsController.text.trim(),
        'land_acquisition_order_number':
            landAcquisitionOrderNumberController.text.trim(),
        'land_acquisition_order_date':
            landAcquisitionOrderDateController.text.trim(),
        'land_acquisition_office_address': getFormattedOfficeAddress(),
        'land_acquisition_office_address_details':
            Map<String, String>.from(officeAddressData),
        'land_acquisition_order_files': landAcquisitionOrderFiles.toList(),
        'land_acquisition_map_files': landAcquisitionMapFiles.toList(),
        'kml_files': kmlFiles.toList(),
      }
    };
  }
}
