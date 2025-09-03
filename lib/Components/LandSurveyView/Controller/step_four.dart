// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../Controller/main_controller.dart';
//
// class StepFourController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Text Controllers
//   final calculationFeeController = TextEditingController();
//
//   // Dropdown Values
//   final selectedCalculationType = RxnString();
//   final selectedDuration = RxnString();
//   final selectedHolderType = RxnString();
//   final selectedLocationCategory = RxnString();
//
//   // Dropdown Options
//   final calculationTypeOptions = ['Hddkayam'].obs;
//
//   final durationOptions = [
//     'Regular',
//     'Fast Track'
//   ].obs;
//
//   final holderTypeOptions = [
//     'धारक(शेतकरी)',
//     'कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी'
//   ].obs;
//
//   final locationCategoryOptions = [
//     'म.न.पा./न.पा. अंतर्गत',
//     'म.न.पा./न.पा. बाहेरील'
//   ].obs;
//
//   // Fee calculation map
//   final Map<String, int> feeCalculationMap = {
//     'Hddkayam_Regular_Holder (farmer)_म.न.पा./न.पा. अंतर्गत': 3000,
//     'Hddkayam_Regular_Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)_म.न.पा./न.पा. अंतर्गत': 3000,
//     'Hddkayam_Regular_Holder (farmer)_म.न.पा./न.पा. बाहेरील': 2000,
//     'Hddkayam_Fast pace_Holder (farmer)_म.न.पा./न.पा. अंतर्गत': 12000,
//     'Hddkayam_Fast pace_Holder (farmer)_म.न.पा./न.पा. बाहेरील': 8000,
//     'Hddkayam_Fast pace_Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)_म.न.पा./न.पा. अंतर्गत': 12000,
//     'Hddkayam_Fast pace_Companies/Other Institutions/Various Authorities/Corporations and Land Acquisition Joint Enumeration Holders (Other than Farmers)_म.न.पा./न.पा. बाहेरील': 8000,
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Set default calculation type
//     selectedCalculationType.value = 'Hddkayam';
//     _setupListeners();
//   }
//
//   @override
//   void onClose() {
//     calculationFeeController.dispose();
//     super.onClose();
//   }
//
//   void _setupListeners() {
//     // Listen for changes in any dropdown to recalculate fee
//     ever(selectedCalculationType, (_) => _calculateFee());
//     ever(selectedDuration, (_) => _calculateFee());
//     ever(selectedHolderType, (_) => _calculateFee());
//     ever(selectedLocationCategory, (_) => _calculateFee());
//   }
//
//   void updateCalculationType(String? value) {
//     selectedCalculationType.value = value;
//   }
//
//   void updateDuration(String? value) {
//     selectedDuration.value = value;
//   }
//
//   void updateHolderType(String? value) {
//     selectedHolderType.value = value;
//   }
//
//   void updateLocationCategory(String? value) {
//     selectedLocationCategory.value = value;
//   }
//
//   void _calculateFee() {
//     final calculationType = selectedCalculationType.value;
//     final duration = selectedDuration.value;
//     final holderType = selectedHolderType.value;
//     final locationCategory = selectedLocationCategory.value;
//
//     if (calculationType != null &&
//         duration != null &&
//         holderType != null &&
//         locationCategory != null) {
//
//       final key = '${calculationType}_${duration}_${holderType}_${locationCategory}';
//       final fee = feeCalculationMap[key];
//
//       if (fee != null) {
//         calculationFeeController.text = '${fee}₹';
//       } else {
//         calculationFeeController.text = '0₹';
//       }
//     } else {
//       calculationFeeController.text = '';
//     }
//   }
//
//   // StepValidationMixin implementation
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'government_survey':
//         return true; // Temporarily return true to bypass validation
//       default:
//         return true;
//     }
//   }
//   // bool validateCurrentSubStep(String field) {
//   //   switch (field) {
//   //     case 'calculation':
//   //       return _validateCalculationFields();
//   //     case 'status':
//   //       return true; // Status field validation if needed
//   //     default:
//   //       return false;
//   //   }
//   // }
//
//   bool _validateCalculationFields() {
//     return selectedCalculationType.value != null &&
//         selectedDuration.value != null &&
//         selectedHolderType.value != null &&
//         selectedLocationCategory.value != null &&
//         calculationFeeController.text.isNotEmpty;
//   }
//
//   @override
//   bool isStepCompleted(List<String> fields) {
//     for (String field in fields) {
//       if (!validateCurrentSubStep(field)) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   @override
//   String getFieldError(String field) {
//     switch (field) {
//       case 'calculation':
//         if (selectedCalculationType.value == null) {
//           return 'Please select calculation type';
//         }
//         if (selectedDuration.value == null) {
//           return 'Please select duration';
//         }
//         if (selectedHolderType.value == null) {
//           return 'Please select holder type';
//         }
//         if (selectedLocationCategory.value == null) {
//           return 'Please select location category';
//         }
//         if (calculationFeeController.text.isEmpty) {
//           return 'Calculation fee is required';
//         }
//         return 'Please complete all calculation fields';
//       default:
//         return 'This field is required';
//     }
//   }
//
//   // StepDataMixin implementation
//   @override
//   Map<String, dynamic> getStepData() {
//     return {
//       'calculation_type': selectedCalculationType.value,
//       'duration': selectedDuration.value,
//       'holder_type': selectedHolderType.value,
//       'location_category': selectedLocationCategory.value,
//       'calculation_fee': calculationFeeController.text,
//       'calculation_fee_numeric': extractNumericFee(),
//     };
//   }
//
//   int? extractNumericFee() {
//     final text = calculationFeeController.text.replaceAll('₹', '').trim();
//     return int.tryParse(text);
//   }
//
//   // Helper method to get short holder type display
//   String getShortHolderType(String holderType) {
//     if (holderType == 'Holder (farmer)') {
//       return 'Holder (farmer)';
//     } else if (holderType.contains('Companies')) {
//       return 'Companies/Other Institutions';
//     } else {
//       return holderType; // Return as-is if it doesn't match expected patterns
//     }
//   }
//
//   // Reset all fields
//   void resetFields() {
//     selectedCalculationType.value = 'Hddkayam';
//     selectedDuration.value = null;
//     selectedHolderType.value = null;
//     selectedLocationCategory.value = null;
//     calculationFeeController.clear();
//   }
// }
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../LandSurveyView/Controller/step_three_controller.dart';
import '../Controller/main_controller.dart';

class StepFourController extends GetxController with StepValidationMixin, StepDataMixin {
  // Text Controllers
  final calculationFeeController = TextEditingController();

  // Dropdown Values
  final selectedCalculationType = RxnString();
  final selectedDuration = RxnString();
  final selectedHolderType = RxnString();
  final selectedLocationCategory = RxnString();



  // Dropdown Options - Get from CalculationController
  List<String> get calculationTypeOptions {
    try {
      final calculationController = Get.find<CalculationController>();
      return calculationController.calculationTypes;
    } catch (e) {
      // Fallback if CalculationController is not found
      return ['Hddkayam'];
    }
  }

  final durationOptions = [
    'Regular',
    'Fast Track'
  ].obs;

  final holderTypeOptions = [
    'धारक(शेतकरी)',
    'कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी'
  ].obs;

  final locationCategoryOptions = [
    'म.न.पा./न.पा. अंतर्गत',
    'म.न.पा./न.पा. बाहेरील'
  ].obs;

  // Updated Fee calculation map with all conditions
  final Map<String, int> feeCalculationMap = {
    // Regular - Companies/Other Institutions - म.न.पा./न.पा. अंतर्गत
    'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत': 3000,

    // Regular - Companies/Other Institutions - म.न.पा./न.पा. बाहेरील
    'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील': 3000,

    // Fast Track - Companies/Other Institutions - म.न.पा./न.पा. अंतर्गत
    'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत': 12000,

    // Fast Track - Companies/Other Institutions - म.न.पा./न.पा. बाहेरील
    'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील': 12000,

    // Regular - Holder (farmer) - म.न.पा./न.पा. अंतर्गत
    'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 3000,

    // Regular - Holder (farmer) - म.न.पा./न.पा. बाहेरील
    'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 2000,

    // Fast Track - Holder (farmer) - म.न.पा./न.पा. अंतर्गत
    'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 12000,

    // Fast Track - Holder (farmer) - म.न.पा./न.पा. बाहेरील
    'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 8000,
  };

  @override
  void onInit() {
    super.onInit();
    // Set default calculation type
    selectedCalculationType.value = 'Hddkayam';
    _setupListeners();
  }

  @override
  void onClose() {
    calculationFeeController.dispose();
    super.onClose();
  }

  void _setupListeners() {
    // Listen for changes in any dropdown to recalculate fee
    ever(selectedCalculationType, (_) => _calculateFee());
    ever(selectedDuration, (_) => _calculateFee());
    ever(selectedHolderType, (_) => _calculateFee());
    ever(selectedLocationCategory, (_) => _calculateFee());
  }

  void updateCalculationType(String? value) {
    selectedCalculationType.value = value;
  }

  void updateDuration(String? value) {
    selectedDuration.value = value;
  }

  void updateHolderType(String? value) {
    selectedHolderType.value = value;
  }

  void updateLocationCategory(String? value) {
    selectedLocationCategory.value = value;
  }

  void _calculateFee() {
    final calculationType = selectedCalculationType.value;
    final duration = selectedDuration.value;
    final holderType = selectedHolderType.value;
    final locationCategory = selectedLocationCategory.value;

    if (calculationType != null &&
        duration != null &&
        holderType != null &&
        locationCategory != null) {

      final key = '${calculationType}_${duration}_${holderType}_${locationCategory}';
      final fee = feeCalculationMap[key];

      if (fee != null) {
        calculationFeeController.text = '₹${fee}';
      } else {
        // Debug print to help identify missing mappings
        print('Fee calculation key not found: $key');
        calculationFeeController.text = '₹0';
      }
    } else {
      calculationFeeController.text = '';
    }
  }

  // StepValidationMixin implementation
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'calculation':
        return _validateCalculationFields();
      case 'government_survey':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }

  bool _validateCalculationFields() {
    return selectedCalculationType.value != null &&
        selectedDuration.value != null &&
        selectedHolderType.value != null &&
        selectedLocationCategory.value != null &&
        calculationFeeController.text.isNotEmpty &&
        calculationFeeController.text != '₹0';
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
        if (selectedCalculationType.value == null) {
          return 'Please select calculation type';
        }
        if (selectedDuration.value == null) {
          return 'Please select duration';
        }
        if (selectedHolderType.value == null) {
          return 'Please select holder type';
        }
        if (selectedLocationCategory.value == null) {
          return 'Please select location category';
        }
        if (calculationFeeController.text.isEmpty || calculationFeeController.text == '₹0') {
          return 'Invalid combination - fee cannot be calculated';
        }
        return 'Please complete all calculation fields';
      default:
        return 'This field is required';
    }
  }

  // StepDataMixin implementation
  @override
  Map<String, dynamic> getStepData() {
    return {
      'calculation_type': selectedCalculationType.value,
      'duration': selectedDuration.value,
      'holder_type': selectedHolderType.value,
      'location_category': selectedLocationCategory.value,
      'calculation_fee': calculationFeeController.text,
      'calculation_fee_numeric': extractNumericFee(),
    };
  }

  int? extractNumericFee() {
    final text = calculationFeeController.text.replaceAll('₹', '').replaceAll(',', '').trim();
    return int.tryParse(text);
  }

  // Helper method to get short holder type display
  String getShortHolderType(String holderType) {
    if (holderType == 'धारक(शेतकरी)') {
      return 'Holder (farmer)';
    } else if (holderType.contains('कंपन्या')) {
      return 'Companies/Other Institutions';
    } else {
      return holderType; // Return as-is if it doesn't match expected patterns
    }
  }

  // Reset all fields
  void resetFields() {
    selectedCalculationType.value = 'Hddkayam';
    selectedDuration.value = null;
    selectedHolderType.value = null;
    selectedLocationCategory.value = null;
    calculationFeeController.clear();
  }
}