import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class PersonalInfoController extends GetxController with StepValidationMixin, StepDataMixin {
  // Form Controllers
  final applicantNameController = TextEditingController();
  final applicantPhoneController = TextEditingController();
  final relationshipController = TextEditingController();
  final relationshipWithApplicantController = TextEditingController();
  final poaRegistrationNumberController = TextEditingController();
  final poaRegistrationDateController = TextEditingController();
  final poaIssuerNameController = TextEditingController();
  final poaHolderNameController = TextEditingController();
  final poaHolderAddressController = TextEditingController();

  // Land Acquisition Form Controllers
  final landAcquisitionOfficerController = TextEditingController();
  final landAcquisitionBoardController = TextEditingController();
  final landAcquisitionDetailsController = TextEditingController();
  final landAcquisitionOrderNumberController = TextEditingController();
  final landAcquisitionOrderDateController = TextEditingController();
  final landAcquisitionOfficeAddressController = TextEditingController();

  // Observable boolean values for questions
  final isHolderThemselves = Rxn<bool>();
  final hasAuthorityOnBehalf = Rxn<bool>();
  final hasBeenCountedBefore = Rxn<bool>();

  // File upload observables for land acquisition
  final landAcquisitionOrderFiles = <String>[].obs;
  final landAcquisitionMapFiles = <String>[].obs;
  final kmlFiles = <String>[].obs;

  @override
  void onClose() {
    // Dispose all controllers
    applicantNameController.dispose();
    applicantPhoneController.dispose();
    relationshipController.dispose();
    relationshipWithApplicantController.dispose();
    poaRegistrationNumberController.dispose();
    poaRegistrationDateController.dispose();
    poaIssuerNameController.dispose();
    poaHolderNameController.dispose();
    poaHolderAddressController.dispose();

    // Dispose land acquisition controllers
    landAcquisitionOfficerController.dispose();
    landAcquisitionBoardController.dispose();
    landAcquisitionDetailsController.dispose();
    landAcquisitionOrderNumberController.dispose();
    landAcquisitionOrderDateController.dispose();
    landAcquisitionOfficeAddressController.dispose();

    super.onClose();
  }

  // Reset methods for dependent fields
  void resetAuthorityFields() {
    hasAuthorityOnBehalf.value = null;
    applicantNameController.clear();
    applicantPhoneController.clear();
    relationshipController.clear();
    relationshipWithApplicantController.clear();
    clearPOAFields();
  }

  void clearPOAFields() {
    poaRegistrationNumberController.clear();
    poaRegistrationDateController.clear();
    poaIssuerNameController.clear();
    poaHolderNameController.clear();
    poaHolderAddressController.clear();
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
  //     case 'holder_verification':
  //     // Check if holder themselves is selected
  //       if (isHolderThemselves.value == null) return false;
  //
  //       // If not holder themselves, check authority
  //       if (isHolderThemselves.value == false) {
  //         if (hasAuthorityOnBehalf.value == null) return false;
  //
  //         // If has authority, validate POA fields
  //         if (hasAuthorityOnBehalf.value == true) {
  //           return _validatePOAFields();
  //         }
  //       }
  //       return true;
  //
  //     case 'enumeration_check':
  //       return hasBeenCountedBefore.value != null;
  //
  //     case 'land_acquisition_details':
  //       return _validateLandAcquisitionFields();
  //
  //     default:
  //       return true;
  //   }
  // }

  bool _validatePOAFields() {
    return poaRegistrationNumberController.text.trim().length >= 3 &&
        poaRegistrationDateController.text.trim().isNotEmpty &&
        poaIssuerNameController.text.trim().length >= 2 &&
        poaHolderNameController.text.trim().length >= 2 &&
        poaHolderAddressController.text.trim().length >= 5;
  }

  bool _validateLandAcquisitionFields() {
    return landAcquisitionOfficerController.text.trim().length >= 3 &&
        landAcquisitionBoardController.text.trim().length >= 5 &&
        landAcquisitionDetailsController.text.trim().length >= 10 &&
        landAcquisitionOrderNumberController.text.trim().length >= 3 &&
        landAcquisitionOrderDateController.text.trim().isNotEmpty &&
        landAcquisitionOfficeAddressController.text.trim().length >= 10 &&
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
      case 'holder_verification':
        if (isHolderThemselves.value == null) {
          return 'Please select if you are the holder';
        }
        if (isHolderThemselves.value == false &&
            hasAuthorityOnBehalf.value == null) {
          return 'Please select if you have authority on behalf';
        }
        if (isHolderThemselves.value == false &&
            hasAuthorityOnBehalf.value == true) {
          return _getPOAValidationError();
        }
        return 'Please complete holder verification';

      case 'enumeration_check':
        return 'Please select if this has been counted before';

      case 'land_acquisition_details':
        return _getLandAcquisitionValidationError();

      default:
        return 'This field is required';
    }
  }

  String _getPOAValidationError() {
    if (poaRegistrationNumberController.text.trim().length < 3) {
      return 'Registration number must be at least 3 characters';
    }
    if (poaRegistrationDateController.text.trim().isEmpty) {
      return 'Registration date is required';
    }
    if (poaIssuerNameController.text.trim().length < 2) {
      return 'Issuer name must be at least 2 characters';
    }
    if (poaHolderNameController.text.trim().length < 2) {
      return 'Holder name must be at least 2 characters';
    }
    if (poaHolderAddressController.text.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    return 'Please complete all Power of Attorney fields';
  }

  String _getLandAcquisitionValidationError() {
    if (landAcquisitionOfficerController.text.trim().isEmpty) {
      return 'Fill Land Acquisition Officer name ';
    }
    if (landAcquisitionBoardController.text.trim().isEmpty) {
      return 'Fill Land Acquisition Board details ';
    }
    if (landAcquisitionDetailsController.text.trim().isEmpty) {
      return 'Fill Land acquisition details ';
    }
    if (landAcquisitionOrderNumberController.text.trim().isEmpty) {
      return 'Fill Land Acquisition Order Number ';
    }
    if (landAcquisitionOrderDateController.text.trim().isEmpty) {
      return 'Fill Land Acquisition Order Date is required';
    }
    if (landAcquisitionOfficeAddressController.text.trim().isEmpty) {
      return 'Fill Office address ';
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
        'is_holder_themselves': isHolderThemselves.value,
        'has_authority_on_behalf': hasAuthorityOnBehalf.value,
        'has_been_counted_before': hasBeenCountedBefore.value,
        'applicant_name': applicantNameController.text.trim(),
        'applicant_phone': applicantPhoneController.text.trim(),
        'relationship': relationshipController.text.trim(),
        'relationship_with_applicant': relationshipWithApplicantController.text.trim(),
        'poa_registration_number': poaRegistrationNumberController.text.trim(),
        'poa_registration_date': poaRegistrationDateController.text.trim(),
        'poa_issuer_name': poaIssuerNameController.text.trim(),
        'poa_holder_name': poaHolderNameController.text.trim(),
        'poa_holder_address': poaHolderAddressController.text.trim(),
      },
      'land_acquisition': {
        'land_acquisition_officer': landAcquisitionOfficerController.text.trim(),
        'land_acquisition_board': landAcquisitionBoardController.text.trim(),
        'land_acquisition_details': landAcquisitionDetailsController.text.trim(),
        'land_acquisition_order_number': landAcquisitionOrderNumberController.text.trim(),
        'land_acquisition_order_date': landAcquisitionOrderDateController.text.trim(),
        'land_acquisition_office_address': landAcquisitionOfficeAddressController.text.trim(),
        'land_acquisition_order_files': landAcquisitionOrderFiles.toList(),
        'land_acquisition_map_files': landAcquisitionMapFiles.toList(),
        'kml_files': kmlFiles.toList(),
      }
    };
  }

  // Utility method to check if POA fields should be shown
  bool get shouldShowPOAFields {
    return isHolderThemselves.value == false &&
        hasAuthorityOnBehalf.value == true;
  }

  // Utility method to check if authority question should be shown
  bool get shouldShowAuthorityQuestion {
    return isHolderThemselves.value == false;
  }
}