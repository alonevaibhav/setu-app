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
  final sevenTwelveFiles = <String>[].obs;


  // Observable boolean values for questions
  final isHolderThemselves = Rxn<bool>();
  final hasAuthorityOnBehalf = Rxn<bool>();
  final hasBeenCountedBefore = Rxn<bool>();

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