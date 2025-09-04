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
//
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
//   // Updated Fee calculation map with all conditions
//   final Map<String, int> feeCalculationMap = {
//     // Regular - Companies/Other Institutions - म.न.पा./न.पा. अंतर्गत
//     'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत': 3000,
//
//     // Regular - Companies/Other Institutions - म.न.पा./न.पा. बाहेरील
//     'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील': 3000,
//
//     // Fast Track - Companies/Other Institutions - म.न.पा./न.पा. अंतर्गत
//     'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत': 12000,
//
//     // Fast Track - Companies/Other Institutions - म.न.पा./न.पा. बाहेरील
//     'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील': 12000,
//
//     // Regular - Holder (farmer) - म.न.पा./न.पा. अंतर्गत
//     'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 3000,
//
//     // Regular - Holder (farmer) - म.न.पा./न.पा. बाहेरील
//     'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 2000,
//
//     // Fast Track - Holder (farmer) - म.न.पा./न.पा. अंतर्गत
//     'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 12000,
//
//     // Fast Track - Holder (farmer) - म.न.पा./न.पा. बाहेरील
//     'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 8000,
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
//         calculationFeeController.text = '₹${fee}';
//       } else {
//         // Debug print to help identify missing mappings
//         print('Fee calculation key not found: $key');
//         calculationFeeController.text = '₹0';
//       }
//     } else {
//       calculationFeeController.text = '';
//     }
//   }
//
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'government_survey':
//         return true; // Temporarily return true to bypass validation
//       default:
//         return true;
//     }
//   }
// //   // bool validateCurrentSubStep(String field) {
// //   //   switch (field) {
// //   //     case 'calculation':
// //   //       return _validateCalculationFields();
// //   //     case 'status':
// //   //       return true; // Status field validation if needed
// //   //     default:
// //   //       return false;
// //   //   }
// //   // }
//
//   bool _validateCalculationFields() {
//     return selectedCalculationType.value != null &&
//         selectedDuration.value != null &&
//         selectedHolderType.value != null &&
//         selectedLocationCategory.value != null &&
//         calculationFeeController.text.isNotEmpty &&
//         calculationFeeController.text != '₹0';
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
//         if (calculationFeeController.text.isEmpty || calculationFeeController.text == '₹0') {
//           return 'Invalid combination - fee cannot be calculated';
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
//     final text = calculationFeeController.text.replaceAll('₹', '').replaceAll(',', '').trim();
//     return int.tryParse(text);
//   }
//
//   // Helper method to get short holder type display
//   String getShortHolderType(String holderType) {
//     if (holderType == 'धारक(शेतकरी)') {
//       return 'Holder (farmer)';
//     } else if (holderType.contains('कंपन्या')) {
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
  final abdominalSectionController = TextEditingController(text: '1'); // Default value 1

  // Dropdown Values
  final selectedCalculationType = RxnString();
  final selectedDuration = RxnString();
  final selectedHolderType = RxnString();
  final selectedLocationCategory = RxnString();

  final durationOptions = ['Regular', 'Fast Track'].obs;

  final holderTypeOptions = [
    'धारक(शेतकरी)',
    'कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी'
  ].obs;

  final locationCategoryOptions =
      ['म.न.पा./न.पा. अंतर्गत', 'म.न.पा./न.पा. बाहेरील'].obs;

  // Hddkayam Fee calculation map (existing)
  final Map<String, int> hddkayamFeeMap = {
    'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत': 3000,
    'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील': 3000,
    'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत': 12000,
    'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील': 12000,
    'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 3000,
    'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 2000,
    'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 12000,
    'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 8000,
  };

  // Fixed Stomach base fees and increments with correct keys
  final Map<String, Map<String, int>> stomachFeeStructure = {
    // For धारक(शेतकरी) - Holder (farmer)
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {'base': 3000, 'increment': 1500},
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {'base': 2000, 'increment': 1000},
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {'base': 12000, 'increment': 6000},
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {'base': 8000, 'increment': 4000},

    // For कंपन्या/इतर संस्था - Companies/Other Institutions
    'Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी': {'base': 3000, 'increment': 1500},
    'Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी': {'base': 12000, 'increment': 6000},
  };

  @override
  void onInit() {
    super.onInit();
    // Get calculation type from CalculationController - FIXED
    _initializeCalculationType();
    _setupListeners();
  }

  // NEW METHOD: Initialize calculation type properly
  void _initializeCalculationType() {
    try {
      final calculationController = Get.find<CalculationController>(tag: 'calculation');

      // Listen to changes in CalculationController's selectedCalculationType
      ever(calculationController.selectedCalculationType, (String newType) {
        print('CalculationController type changed to: $newType');
        selectedCalculationType.value = newType.isEmpty ? null : newType;
      });

      // Set initial value
      String initialType = calculationController.selectedCalculationType.value;
      selectedCalculationType.value = initialType.isEmpty ? null : initialType;

      print('StepFourController initialized with calculation type: ${selectedCalculationType.value}');

    } catch (e) {
      print('Error finding CalculationController: $e');
      selectedCalculationType.value = null; // Changed from 'Hddkayam' to null
    }
  }

  @override
  void onClose() {
    calculationFeeController.dispose();
    abdominalSectionController.dispose();
    super.onClose();
  }

  void _setupListeners() {
    // Listen for changes in any dropdown to recalculate fee
    ever(selectedCalculationType, (String? type) {
      print('StepFourController calculation type changed to: $type');
      _calculateFee();
    });
    ever(selectedDuration, (_) => _calculateFee());
    ever(selectedHolderType, (_) => _calculateFee());
    ever(selectedLocationCategory, (_) => _calculateFee());

    // Listen for abdominal section changes (for Stomach calculations)
    abdominalSectionController.addListener(() {
      if (selectedCalculationType.value == 'Stomach') {
        _calculateFee();
      }
    });
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

    print('Calculating fee for: $calculationType, $duration, $holderType, $locationCategory');

    if (calculationType != null &&
        duration != null &&
        holderType != null) {

      if (calculationType == 'Hddkayam' && locationCategory != null) {
        _calculateHddkayamFee(calculationType, duration, holderType, locationCategory);
      } else if (calculationType == 'Stomach') {
        _calculateStomachFee(duration, holderType, locationCategory);
      } else {
        calculationFeeController.text = '';
      }
    } else {
      calculationFeeController.text = '';
    }
  }

  void _calculateHddkayamFee(String calculationType, String duration, String holderType, String locationCategory) {
    final key = '${calculationType}_${duration}_${holderType}_${locationCategory}';
    final fee = hddkayamFeeMap[key];

    print('Hddkayam key: $key');
    if (fee != null) {
      calculationFeeController.text = '₹${fee}';
    } else {
      print('Hddkayam fee calculation key not found: $key');
      calculationFeeController.text = '₹0';
    }
  }

  void _calculateStomachFee(String duration, String holderType, String? locationCategory) {
    String key;

    // For companies/institutions, location category is not needed in the key
    if (holderType.contains('कंपन्या')) {
      key = '${duration}_${holderType}';
    } else {
      // For farmers, location category is required
      if (locationCategory == null) {
        calculationFeeController.text = '';
        return;
      }
      key = '${duration}_${holderType}_${locationCategory}';
    }

    print('Stomach calculation key: $key');
    print('Available keys: ${stomachFeeStructure.keys}');

    final feeStructure = stomachFeeStructure[key];

    if (feeStructure != null) {
      final baseFee = feeStructure['base']!;
      final increment = feeStructure['increment']!;
      final sections = int.tryParse(abdominalSectionController.text) ?? 1;

      // Calculate total fee: base fee + (sections - 1) * increment
      final totalFee = baseFee + ((sections - 1) * increment);
      calculationFeeController.text = '₹${totalFee}';

      print('Stomach calculation: Base=$baseFee, Sections=$sections, Increment=$increment, Total=$totalFee');
    } else {
      print('Stomach fee calculation key not found: $key');
      print('Trying to find partial match...');

      // Try to find a partial match for debugging
      for (String availableKey in stomachFeeStructure.keys) {
        if (availableKey.contains(duration) && availableKey.contains('धारक(शेतकरी)')) {
          print('Partial match found: $availableKey');
        }
      }

      calculationFeeController.text = '₹0';
    }
  }

  // Check if current calculation type requires location category
  bool requiresLocationCategory() {
    print('StepFour - requiresLocationCategory check: calculationType=${selectedCalculationType.value}, holderType=${selectedHolderType.value}');
    return selectedCalculationType.value == 'Hddkayam' ||
        (selectedCalculationType.value == 'Stomach' &&
            selectedHolderType.value == 'धारक(शेतकरी)');
  }

  // Check if current calculation type requires abdominal section - FIXED
  bool requiresAbdominalSection() {
    print('StepFour - requiresAbdominalSection check: ${selectedCalculationType.value}');
    bool requires = selectedCalculationType.value == 'Stomach';
    print('StepFour - requiresAbdominalSection result: $requires');
    return requires;
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
    if (selectedCalculationType.value == null ||
        selectedDuration.value == null ||
        selectedHolderType.value == null) {
      return false;
    }

    // For Hddkayam or Stomach with farmer holder type, location category is required
    if (requiresLocationCategory() && selectedLocationCategory.value == null) {
      return false;
    }

    // For Stomach, abdominal section is required and should be > 0
    if (requiresAbdominalSection()) {
      final sections = int.tryParse(abdominalSectionController.text);
      if (sections == null || sections <= 0) {
        return false;
      }
    }

    return calculationFeeController.text.isNotEmpty &&
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
        if (requiresLocationCategory() && selectedLocationCategory.value == null) {
          return 'Please select location category';
        }
        if (requiresAbdominalSection()) {
          final sections = int.tryParse(abdominalSectionController.text);
          if (sections == null || sections <= 0) {
            return 'Please enter valid abdominal section number';
          }
        }
        if (calculationFeeController.text.isEmpty ||
            calculationFeeController.text == '₹0') {
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
    Map<String, dynamic> data = {
      'calculation_type': selectedCalculationType.value,
      'duration': selectedDuration.value,
      'holder_type': selectedHolderType.value,
      'calculation_fee': calculationFeeController.text,
      'calculation_fee_numeric': extractNumericFee(),
    };

    // Add location category only if required
    if (requiresLocationCategory()) {
      data['location_category'] = selectedLocationCategory.value;
    }

    // Add abdominal section only for Stomach calculation
    if (requiresAbdominalSection()) {
      data['abdominal_section'] = int.tryParse(abdominalSectionController.text);
    }

    return data;
  }

  int? extractNumericFee() {
    final text = calculationFeeController.text
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();
    return int.tryParse(text);
  }

  // Helper method to get short holder type display
  String getShortHolderType(String holderType) {
    if (holderType == 'धारक(शेतकरी)') {
      return 'Holder (farmer)';
    } else if (holderType.contains('कंपन्या')) {
      return 'Companies/Other Institutions';
    } else {
      return holderType;
    }
  }

  // Reset all fields
  void resetFields() {
    selectedCalculationType.value = null; // Changed from 'Hddkayam' to null
    selectedDuration.value = null;
    selectedHolderType.value = null;
    selectedLocationCategory.value = null;
    calculationFeeController.clear();
    abdominalSectionController.text = '1';
  }
}