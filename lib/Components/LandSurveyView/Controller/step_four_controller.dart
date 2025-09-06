import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../LandSurveyView/Controller/step_three_controller.dart';
import '../Controller/main_controller.dart';

class StepFourController extends GetxController
    with StepValidationMixin, StepDataMixin {
  // Text Controllers
  final calculationFeeController = TextEditingController();
  final abdominalSectionController =
      TextEditingController(text: '1'); // Default value 1
  final totalPlotNumberController =
      TextEditingController(text: '1'); // Default value 1 for Non-agricultural
  final knotCountController = TextEditingController(
      text: '1'); // Default value 1 for Counting by number of knots

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

  // Hddkayam Fee calculation map
  final Map<String, int> hddkayamFeeMap = {
    'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत':
        3000,
    'Hddkayam_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील':
        3000,
    'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. अंतर्गत':
        12000,
    'Hddkayam_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी_म.न.पा./न.पा. बाहेरील':
        12000,
    'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 3000,
    'Hddkayam_Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 2000,
    'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 12000,
    'Hddkayam_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 8000,
  };

  // Stomach base fees and increments
  final Map<String, Map<String, int>> stomachFeeStructure = {
    // For धारक(शेतकरी) - Holder (farmer)
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {
      'base': 3000,
      'increment': 1500
    },
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {
      'base': 2000,
      'increment': 1000
    },
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {
      'base': 12000,
      'increment': 6000
    },
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {
      'base': 8000,
      'increment': 4000
    },

    // For कंपन्या/इतर संस्था - Companies/Other Institutions
    'Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        {'base': 3000, 'increment': 1500},
    'Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        {'base': 12000, 'increment': 6000},
  };

  // Non-agricultural fee structure
  final Map<String, Map<String, int>> nonAgriculturalFeeStructure = {
    // For धारक(शेतकरी) - Holder (farmer)
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {
      'base': 3000,
      'increment': 1500
    },
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {
      'base': 2000,
      'increment': 1000
    },
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {
      'base': 12000,
      'increment': 6000
    },
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {
      'base': 8000,
      'increment': 4000
    },

    // For कंपन्या/इतर संस्था - Companies/Other Institutions
    'Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        {'base': 3000, 'increment': 1500},
    'Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        {'base': 12000, 'increment': 6000},
  };

  // Counting by number of knots fee structure
  final Map<String, Map<String, int>> knotCountingFeeStructure = {
    // For धारक(शेतकरी) - Holder (farmer)
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {
      'base': 3000,
      'increment': 1500
    },
    'Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {
      'base': 2000,
      'increment': 1000
    },
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': {
      'base': 12000,
      'increment': 6000
    },
    'Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': {
      'base': 8000,
      'increment': 4000
    },

    // For कंपन्या/इतर संस्था - Companies/Other Institutions
    'Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        {'base': 3000, 'increment': 1500},
    'Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        {'base': 12000, 'increment': 6000},
  };

  // Integration calculation fee structure (fixed fees, no increments)
  final Map<String, int> integrationCalculationFeeMap = {
    'Integration calculation_Regular_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत': 3000,
    'Integration calculation_Regular_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील': 2000,
    'Integration calculation_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. अंतर्गत':
        12000,
    'Integration calculation_Fast Track_धारक(शेतकरी)_म.न.पा./न.पा. बाहेरील':
        8000,
    'Integration calculation_Regular_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        3000,
    'Integration calculation_Fast Track_कंपन्या/इतर संस्था/ विविध प्राधिकरणे/ महामंडळ व भूसंपादन संयुक्त मोजणी':
        12000,
  };

  @override
  void onInit() {
    super.onInit();
    _initializeCalculationType();
    _setupListeners();
  }

  void _initializeCalculationType() {
    try {
      final calculationController =
          Get.find<CalculationController>(tag: 'calculation');

      ever(calculationController.selectedCalculationType, (String newType) {
        print('CalculationController type changed to: $newType');
        selectedCalculationType.value = newType.isEmpty ? null : newType;
      });

      String initialType = calculationController.selectedCalculationType.value;
      selectedCalculationType.value = initialType.isEmpty ? null : initialType;

      print(
          'StepFourController initialized with calculation type: ${selectedCalculationType.value}');
    } catch (e) {
      print('Error finding CalculationController: $e');
      selectedCalculationType.value = null;
    }
  }

  @override
  void onClose() {
    calculationFeeController.dispose();
    abdominalSectionController.dispose();
    totalPlotNumberController.dispose();
    knotCountController.dispose();
    super.onClose();
  }

  void _setupListeners() {
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

    // Listen for plot number changes (for Non-agricultural calculations)
    totalPlotNumberController.addListener(() {
      if (selectedCalculationType.value == 'Non-agricultural') {
        _calculateFee();
      }
    });

    // Listen for knot count changes (for Counting by number of knots calculations)
    knotCountController.addListener(() {
      if (selectedCalculationType.value == 'Counting by number of knots') {
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

    print(
        'Calculating fee for: $calculationType, $duration, $holderType, $locationCategory');

    if (calculationType != null && duration != null && holderType != null) {
      if (calculationType == 'Hddkayam' && locationCategory != null) {
        _calculateHddkayamFee(
            calculationType, duration, holderType, locationCategory);
      } else if (calculationType == 'Stomach') {
        _calculateStomachFee(duration, holderType, locationCategory);
      } else if (calculationType == 'Non-agricultural') {
        _calculateNonAgriculturalFee(duration, holderType, locationCategory);
      } else if (calculationType == 'Counting by number of knots') {
        _calculateKnotCountingFee(duration, holderType, locationCategory);
      } else if (calculationType == 'Integration calculation') {
        _calculateIntegrationCalculationFee(
            calculationType, duration, holderType, locationCategory);
      } else {
        calculationFeeController.text = '';
      }
    } else {
      calculationFeeController.text = '';
    }
  }

  void _calculateHddkayamFee(String calculationType, String duration,
      String holderType, String locationCategory) {
    final key =
        '${calculationType}_${duration}_${holderType}_${locationCategory}';
    final fee = hddkayamFeeMap[key];

    print('Hddkayam key: $key');
    if (fee != null) {
      calculationFeeController.text = '₹${fee}';
    } else {
      print('Hddkayam fee calculation key not found: $key');
      calculationFeeController.text = '₹0';
    }
  }

  void _calculateStomachFee(
      String duration, String holderType, String? locationCategory) {
    String key;

    if (holderType.contains('कंपन्या')) {
      key = '${duration}_${holderType}';
    } else {
      if (locationCategory == null) {
        calculationFeeController.text = '';
        return;
      }
      key = '${duration}_${holderType}_${locationCategory}';
    }

    print('Stomach calculation key: $key');
    final feeStructure = stomachFeeStructure[key];

    if (feeStructure != null) {
      final baseFee = feeStructure['base']!;
      final increment = feeStructure['increment']!;
      final sections = int.tryParse(abdominalSectionController.text) ?? 1;

      final totalFee = baseFee + ((sections - 1) * increment);
      calculationFeeController.text = '₹${totalFee}';

      print(
          'Stomach calculation: Base=$baseFee, Sections=$sections, Increment=$increment, Total=$totalFee');
    } else {
      print('Stomach fee calculation key not found: $key');
      calculationFeeController.text = '₹0';
    }
  }

  void _calculateNonAgriculturalFee(
      String duration, String holderType, String? locationCategory) {
    String key;

    if (holderType.contains('कंपन्या')) {
      key = '${duration}_${holderType}';
    } else {
      if (locationCategory == null) {
        calculationFeeController.text = '';
        return;
      }
      key = '${duration}_${holderType}_${locationCategory}';
    }

    print('Non-agricultural calculation key: $key');
    final feeStructure = nonAgriculturalFeeStructure[key];

    if (feeStructure != null) {
      final baseFee = feeStructure['base']!;
      final increment = feeStructure['increment']!;
      final plotNumbers = int.tryParse(totalPlotNumberController.text) ?? 1;

      final totalFee = baseFee + ((plotNumbers - 1) * increment);
      calculationFeeController.text = '₹${totalFee}';

      print(
          'Non-agricultural calculation: Base=$baseFee, PlotNumbers=$plotNumbers, Increment=$increment, Total=$totalFee');
    } else {
      print('Non-agricultural fee calculation key not found: $key');
      calculationFeeController.text = '₹0';
    }
  }

  void _calculateKnotCountingFee(
      String duration, String holderType, String? locationCategory) {
    String key;

    if (holderType.contains('कंपन्या')) {
      key = '${duration}_${holderType}';
    } else {
      if (locationCategory == null) {
        calculationFeeController.text = '';
        return;
      }
      key = '${duration}_${holderType}_${locationCategory}';
    }

    print('Knot counting calculation key: $key');
    final feeStructure = knotCountingFeeStructure[key];

    if (feeStructure != null) {
      final baseFee = feeStructure['base']!;
      final increment = feeStructure['increment']!;
      final knotCount = int.tryParse(knotCountController.text) ?? 1;

      final totalFee = baseFee + ((knotCount - 1) * increment);
      calculationFeeController.text = '₹${totalFee}';

      print(
          'Knot counting calculation: Base=$baseFee, KnotCount=$knotCount, Increment=$increment, Total=$totalFee');
    } else {
      print('Knot counting fee calculation key not found: $key');
      calculationFeeController.text = '₹0';
    }
  }

  void _calculateIntegrationCalculationFee(String calculationType,
      String duration, String holderType, String? locationCategory) {
    String key;

    if (holderType.contains('कंपन्या')) {
      key = '${calculationType}_${duration}_${holderType}';
    } else {
      if (locationCategory == null) {
        calculationFeeController.text = '';
        return;
      }
      key = '${calculationType}_${duration}_${holderType}_${locationCategory}';
    }

    print('Integration calculation key: $key');
    final fee = integrationCalculationFeeMap[key];

    if (fee != null) {
      calculationFeeController.text = '₹${fee}';
      print('Integration calculation: Fee=$fee');
    } else {
      print('Integration calculation fee key not found: $key');
      calculationFeeController.text = '₹0';
    }
  }

  // Check if current calculation type requires location category
  bool requiresLocationCategory() {
    print(
        'StepFour - requiresLocationCategory check: calculationType=${selectedCalculationType.value}, holderType=${selectedHolderType.value}');
    return selectedCalculationType.value == 'Hddkayam' ||
        (selectedCalculationType.value == 'Stomach' &&
            selectedHolderType.value == 'धारक(शेतकरी)') ||
        (selectedCalculationType.value == 'Non-agricultural' &&
            selectedHolderType.value == 'धारक(शेतकरी)') ||
        (selectedCalculationType.value == 'Counting by number of knots' &&
            selectedHolderType.value == 'धारक(शेतकरी)') ||
        (selectedCalculationType.value == 'Integration calculation' &&
            selectedHolderType.value == 'धारक(शेतकरी)');
  }

  // Check if current calculation type requires abdominal section
  bool requiresAbdominalSection() {
    print(
        'StepFour - requiresAbdominalSection check: ${selectedCalculationType.value}');
    bool requires = selectedCalculationType.value == 'Stomach';
    print('StepFour - requiresAbdominalSection result: $requires');
    return requires;
  }

  // Check if current calculation type requires total plot number
  bool requiresTotalPlotNumber() {
    print(
        'StepFour - requiresTotalPlotNumber check: ${selectedCalculationType.value}');
    bool requires = selectedCalculationType.value == 'Non-agricultural';
    print('StepFour - requiresTotalPlotNumber result: $requires');
    return requires;
  }

  // Check if current calculation type requires knot count
  bool requiresKnotCount() {
    print(
        'StepFour - requiresKnotCount check: ${selectedCalculationType.value}');
    bool requires =
        selectedCalculationType.value == 'Counting by number of knots';
    print('StepFour - requiresKnotCount result: $requires');
    return requires;
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
  //   switch (field) {
  //     case 'calculation':
  //       return _validateCalculationFields();
  //     case 'government_survey':
  //       return true;
  //     default:
  //       return true;
  //   }
  // }

  bool _validateCalculationFields() {
    if (selectedCalculationType.value == null ||
        selectedDuration.value == null ||
        selectedHolderType.value == null) {
      return false;
    }

    if (requiresLocationCategory() && selectedLocationCategory.value == null) {
      return false;
    }

    if (requiresAbdominalSection()) {
      final sections = int.tryParse(abdominalSectionController.text);
      if (sections == null || sections <= 0) {
        return false;
      }
    }

    if (requiresTotalPlotNumber()) {
      final plotNumbers = int.tryParse(totalPlotNumberController.text);
      if (plotNumbers == null || plotNumbers <= 0) {
        return false;
      }
    }

    if (requiresKnotCount()) {
      final knotCount = int.tryParse(knotCountController.text);
      if (knotCount == null || knotCount <= 0) {
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
        if (requiresLocationCategory() &&
            selectedLocationCategory.value == null) {
          return 'Please select location category';
        }
        if (requiresAbdominalSection()) {
          final sections = int.tryParse(abdominalSectionController.text);
          if (sections == null || sections <= 0) {
            return 'Please enter valid abdominal section number';
          }
        }
        if (requiresTotalPlotNumber()) {
          final plotNumbers = int.tryParse(totalPlotNumberController.text);
          if (plotNumbers == null || plotNumbers <= 0) {
            return 'Please enter valid total plot number';
          }
        }
        if (requiresKnotCount()) {
          final knotCount = int.tryParse(knotCountController.text);
          if (knotCount == null || knotCount <= 0) {
            return 'Please enter valid knot count number';
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

    if (requiresLocationCategory()) {
      data['location_category'] = selectedLocationCategory.value;
    }

    if (requiresAbdominalSection()) {
      data['abdominal_section'] = int.tryParse(abdominalSectionController.text);
    }

    if (requiresTotalPlotNumber()) {
      data['total_plot_number'] = int.tryParse(totalPlotNumberController.text);
    }

    if (requiresKnotCount()) {
      data['knot_count'] = int.tryParse(knotCountController.text);
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

  String getShortHolderType(String holderType) {
    if (holderType == 'धारक(शेतकरी)') {
      return 'Holder (farmer)';
    } else if (holderType.contains('कंपन्या')) {
      return 'Companies/Other Institutions';
    } else {
      return holderType;
    }
  }

  void resetFields() {
    selectedCalculationType.value = null;
    selectedDuration.value = null;
    selectedHolderType.value = null;
    selectedLocationCategory.value = null;
    calculationFeeController.clear();
    abdominalSectionController.text = '1';
    totalPlotNumberController.text = '1';
    knotCountController.text = '1';
  }
}
