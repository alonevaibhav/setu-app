
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_controller.dart';

class CalculationController extends GetxController
    with StepValidationMixin, StepDataMixin {
  // Main calculation type
  final selectedCalculationType = ''.obs;
  final List<String> calculationTypes = [
    'Hddkayam',
    'Stomach',
    'Non-agricultural',
    'Counting by number of knots',
    'Integration calculation'
  ];

  // Common controllers
  final surveyNumberController = TextEditingController();
  final areaController = TextEditingController();
  final subdivisionController = TextEditingController();
  final notesController = TextEditingController();

  // Non-agricultural fields (moved outside entries)
  final landType = ''.obs;
  final plotNumberController = TextEditingController();
  final builtUpAreaController = TextEditingController();

  // Common fields for Non-agricultural & Knots counting (outside entries)
  final orderNumberController = TextEditingController();
  final orderDateController = TextEditingController();
  final schemeOrderNumberController = TextEditingController();
  final appointmentDateController = TextEditingController();

  // Knots counting fields (moved outside entries)
  final knotsCountController = TextEditingController();
  final knotSpacingController = TextEditingController();
  final calculationMethod = ''.obs;

  // Integration calculation fields (moved outside entries)
  final integrationType = ''.obs;
  final baseLineController = TextEditingController();
  final ordinatesController = TextEditingController();

  // Integration calculation - outside entry fields
  final mergerOrderNumberController = TextEditingController();
  final mergerOrderDateController = TextEditingController();
  final oldMergerNumberController = TextEditingController();
  final RxList<String> incorporationOrderFiles = <String>[].obs;

  // Status fields
  final isCalculationComplete = Rxn<bool>();

  // Date controller for non-agricultural
  final datecontroller = TextEditingController();

  // Hddkayam table entries
  final hddkayamEntries = <Map<String, dynamic>>[].obs;
  final List<String> ctSurveyOptions = [
    'Select CT Survey/TP No.',
  ];

  // Stomach table entries
  final stomachEntries = <Map<String, dynamic>>[].obs;
  final List<String> measurementTypeOptions = [
    'Square meters',
    'Square feet',
    'Acres',
    'Hectares'
  ];

  // Non-agricultural table entries (simplified - removed common fields)
  final nonAgriculturalEntries = <Map<String, dynamic>>[].obs;

  // Knots counting table entries (simplified - removed common fields)
  final knotsCountingEntries = <Map<String, dynamic>>[].obs;

  // Integration calculation entries
  final integrationCalculationEntries = <Map<String, dynamic>>[].obs;

  // Survey type options
  final List<String> surveyTypeOptions = [
    'Survey No./Group No.',
    'CT Survey No.',
    'TP No.',
    'Village Survey No.',
  ];

  @override
  void onInit() {
    super.onInit();
    _setupValidation();

    // Initialize with one empty entry when calculation type is selected
    ever(selectedCalculationType, (String type) {
      if (type == 'Hddkayam' && hddkayamEntries.isEmpty) {
        addHddkayamEntry();
      } else if (type == 'Stomach' && stomachEntries.isEmpty) {
        addStomachEntry();
      } else if (type == 'Non-agricultural' && nonAgriculturalEntries.isEmpty) {
        addNonAgriculturalEntry();
      } else if (type == 'Counting by number of knots' &&
          knotsCountingEntries.isEmpty) {
        addKnotsCountingEntry();
      } else if (type == 'Integration calculation' &&
          integrationCalculationEntries.isEmpty) {
        addIntegrationCalculationEntry();
      }
    });
  }

  @override
  void onClose() {
    // Dispose all controllers
    surveyNumberController.dispose();
    areaController.dispose();
    subdivisionController.dispose();
    notesController.dispose();
    plotNumberController.dispose();
    builtUpAreaController.dispose();
    knotsCountController.dispose();
    knotSpacingController.dispose();
    baseLineController.dispose();
    ordinatesController.dispose();
    datecontroller.dispose();

    // Dispose common field controllers
    orderNumberController.dispose();
    orderDateController.dispose();
    schemeOrderNumberController.dispose();
    appointmentDateController.dispose();

    // Dispose integration calculation controllers
    mergerOrderNumberController.dispose();
    mergerOrderDateController.dispose();
    oldMergerNumberController.dispose();

    // Dispose entry controllers
    _clearHddkayamEntries();
    _clearStomachEntries();
    _clearNonAgriculturalEntries();
    _clearKnotsCountingEntries();
    _clearIntegrationCalculationEntries();

    super.onClose();
  }

  void _setupValidation() {
    // Add listeners for validation
    selectedCalculationType.listen((_) => update());
    landType.listen((_) => update());
    calculationMethod.listen((_) => update());
    integrationType.listen((_) => update());
    isCalculationComplete.listen((_) => update());
    hddkayamEntries.listen((_) => update());
    stomachEntries.listen((_) => update());
    nonAgriculturalEntries.listen((_) => update());
    knotsCountingEntries.listen((_) => update());
    integrationCalculationEntries.listen((_) => update());
    incorporationOrderFiles.listen((_) => update());
  }

  void updateCalculationType(String type) {
    selectedCalculationType.value = type;
    _clearTypeSpecificFields();
  }

  void _clearTypeSpecificFields() {
    // Clear fields when calculation type changes
    landType.value = '';
    calculationMethod.value = '';
    integrationType.value = '';

    plotNumberController.clear();
    builtUpAreaController.clear();
    knotsCountController.clear();
    knotSpacingController.clear();
    baseLineController.clear();
    ordinatesController.clear();
    datecontroller.clear();

    // Clear common fields
    orderNumberController.clear();
    orderDateController.clear();
    schemeOrderNumberController.clear();
    appointmentDateController.clear();

    // Clear integration calculation fields
    mergerOrderNumberController.clear();
    mergerOrderDateController.clear();
    oldMergerNumberController.clear();
    incorporationOrderFiles.clear();

    // Clear entries
    _clearHddkayamEntries();
    _clearStomachEntries();
    _clearNonAgriculturalEntries();
    _clearKnotsCountingEntries();
    _clearIntegrationCalculationEntries();
  }

  // ================ COMMON FIELD UPDATE METHODS ================

  void updateOrderNumber(String value) {
    orderNumberController.text = value;
    update();
  }

  void updateOrderDate(DateTime selectedDate) {
    orderDateController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    update();
  }

  void updateSchemeOrderNumber(String value) {
    schemeOrderNumberController.text = value;
    update();
  }

  void updateAppointmentDate(DateTime selectedDate) {
    appointmentDateController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    update();
  }

  // ================ INTEGRATION CALCULATION FIELD UPDATE METHODS ================

  void updateMergerOrderNumber(String value) {
    mergerOrderNumberController.text = value;
    update();
  }

  void updateMergerOrderDate(DateTime selectedDate) {
    mergerOrderDateController.text =
        "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
    update();
  }

  void updateOldMergerNumber(String value) {
    oldMergerNumberController.text = value;
    update();
  }

  // ================ HDDKAYAM TABLE METHODS ================

  void addHddkayamEntry() {
    final newEntry = {
      'ctSurveyController': TextEditingController(),
      'selectedCTSurvey': '',
      'areaController': TextEditingController(),
      'areaSqmController': TextEditingController(),
      'ctSurveyNumber': '',
      'area': '',
      'areaSqm': '',
      'isCorrect': false,
    };

    hddkayamEntries.add(newEntry);
  }

  void removeHddkayamEntry(int index) {
    if (index < hddkayamEntries.length) {
      // Dispose controllers before removing
      final entry = hddkayamEntries[index];
      entry['ctSurveyController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaSqmController']?.dispose();

      hddkayamEntries.removeAt(index);
    }
  }

  void updateHddkayamEntry(int index, String field, String? value) {
    if (index < hddkayamEntries.length) {
      hddkayamEntries[index][field] = value ?? '';
      hddkayamEntries.refresh();
    }
  }

  void markHddkayamEntryCorrect(int index) {
    if (index < hddkayamEntries.length) {
      hddkayamEntries[index]['isCorrect'] = true;
      hddkayamEntries.refresh();
    }
  }

  void _clearHddkayamEntries() {
    // Dispose all controllers in hddkayam entries
    for (var entry in hddkayamEntries) {
      entry['ctSurveyController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaSqmController']?.dispose();
    }
    hddkayamEntries.clear();
  }

  // ================ STOMACH TABLE METHODS ================

  void addStomachEntry() {
    final newEntry = {
      'surveyNumberController': TextEditingController(),
      'selectedMeasurementType': '',
      'totalAreaController': TextEditingController(),
      'calculatedAreaController': TextEditingController(),
      'surveyNumber': '',
      'measurementType': '', // Keep for backward compatibility
      'totalArea': '',
      'calculatedArea': '',
      'isCorrect': false,
    };

    stomachEntries.add(newEntry);
  }

  void removeStomachEntry(int index) {
    if (index < stomachEntries.length) {
      // Dispose controllers before removing
      final entry = stomachEntries[index];
      entry['surveyNumberController']?.dispose();
      entry['totalAreaController']?.dispose();
      entry['calculatedAreaController']?.dispose();

      stomachEntries.removeAt(index);
    }
  }

  void updateStomachEntry(int index, String field, String? value) {
    if (index < stomachEntries.length) {
      stomachEntries[index][field] = value ?? '';
      stomachEntries.refresh();
    }
  }

  void markStomachEntryCorrect(int index) {
    if (index < stomachEntries.length) {
      stomachEntries[index]['isCorrect'] = true;
      stomachEntries.refresh();
    }
  }

  void _clearStomachEntries() {
    // Dispose all controllers in stomach entries
    for (var entry in stomachEntries) {
      entry['surveyNumberController']?.dispose();
      entry['totalAreaController']?.dispose();
      entry['calculatedAreaController']?.dispose();
    }
    stomachEntries.clear();
  }

  // ================ NON-AGRICULTURAL TABLE METHODS ================

  void addNonAgriculturalEntry() {
    // Simplified entry - only survey-specific fields
    final newEntry = {
      'surveyNumberController': TextEditingController(),
      'selectedSurveyType': '',
      'areaController': TextEditingController(),
      'areaHectaresController': TextEditingController(),
      'surveyNumber': '',
      'area': '',
      'areaHectares': '',
      'isCorrect': false,
    };

    nonAgriculturalEntries.add(newEntry);
  }

  void removeNonAgriculturalEntry(int index) {
    if (index < nonAgriculturalEntries.length) {
      // Dispose controllers before removing
      final entry = nonAgriculturalEntries[index];
      entry['surveyNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaHectaresController']?.dispose();

      nonAgriculturalEntries.removeAt(index);
    }
  }

  void updateNonAgriculturalEntry(int index, String field, String? value) {
    if (index < nonAgriculturalEntries.length) {
      nonAgriculturalEntries[index][field] = value ?? '';
      nonAgriculturalEntries.refresh();
    }
  }

  void markNonAgriculturalEntryCorrect(int index) {
    if (index < nonAgriculturalEntries.length) {
      nonAgriculturalEntries[index]['isCorrect'] = true;
      nonAgriculturalEntries.refresh();
    }
  }

  void _clearNonAgriculturalEntries() {
    // Dispose all controllers in non-agricultural entries
    for (var entry in nonAgriculturalEntries) {
      entry['surveyNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaHectaresController']?.dispose();
    }
    nonAgriculturalEntries.clear();
  }

  // ================ KNOTS COUNTING TABLE METHODS ================

  void addKnotsCountingEntry() {
    // Simplified entry - only survey-specific fields
    final newEntry = {
      'surveyNumberController': TextEditingController(),
      'selectedSurveyType': '',
      'areaController': TextEditingController(),
      'areaHectaresController': TextEditingController(),
      'surveyNumber': '',
      'area': '',
      'areaHectares': '',
      'isCorrect': false,
    };

    knotsCountingEntries.add(newEntry);
  }

  void removeKnotsCountingEntry(int index) {
    if (index < knotsCountingEntries.length) {
      // Dispose controllers before removing
      final entry = knotsCountingEntries[index];
      entry['surveyNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaHectaresController']?.dispose();

      knotsCountingEntries.removeAt(index);
    }
  }

  void updateKnotsCountingEntry(int index, String field, String? value) {
    if (index < knotsCountingEntries.length) {
      knotsCountingEntries[index][field] = value ?? '';
      knotsCountingEntries.refresh();
    }
  }

  void markKnotsCountingEntryCorrect(int index) {
    if (index < knotsCountingEntries.length) {
      knotsCountingEntries[index]['isCorrect'] = true;
      knotsCountingEntries.refresh();
    }
  }

  void _clearKnotsCountingEntries() {
    // Dispose all controllers in knots counting entries
    for (var entry in knotsCountingEntries) {
      entry['surveyNumberController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaHectaresController']?.dispose();
    }
    knotsCountingEntries.clear();
  }

  // ================ INTEGRATION CALCULATION TABLE METHODS ================

  void addIntegrationCalculationEntry() {
    final newEntry = {
      'ctSurveyController': TextEditingController(),
      'selectedCTSurvey': '',
      'areaController': TextEditingController(),
      'areaSqmController': TextEditingController(),
      'ctSurveyNumber': '',
      'area': '',
      'areaSqm': '',
      'isCorrect': false,
    };

    integrationCalculationEntries.add(newEntry);
    update();
  }

  void removeIntegrationCalculationEntry(int index) {
    if (index < integrationCalculationEntries.length) {
      // Dispose controllers before removing
      final entry = integrationCalculationEntries[index];
      entry['ctSurveyController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaSqmController']?.dispose();

      integrationCalculationEntries.removeAt(index);
      update();
    }
  }

  void updateIntegrationCalculationEntry(
      int index, String field, dynamic value) {
    if (index < integrationCalculationEntries.length) {
      integrationCalculationEntries[index][field] = value;
      integrationCalculationEntries.refresh();
      update();
    }
  }

  void markIntegrationCalculationEntryCorrect(int index) {
    if (index < integrationCalculationEntries.length) {
      integrationCalculationEntries[index]['isCorrect'] = true;
      integrationCalculationEntries.refresh();
      Get.snackbar('Success', 'Entry ${index + 1} marked as correct');
    }
  }

  void _clearIntegrationCalculationEntries() {
    // Dispose all controllers in integration calculation entries
    for (var entry in integrationCalculationEntries) {
      entry['ctSurveyController']?.dispose();
      entry['areaController']?.dispose();
      entry['areaSqmController']?.dispose();
    }
    integrationCalculationEntries.clear();
  }

  // ================ VALIDATION METHODS ================

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
  //       return _validateCalculationStep();
  //
  //     default:
  //       return false;
  //   }
  // }

  bool _validateCalculationStep() {
    if (selectedCalculationType.value.isEmpty) {
      return false;
    }

    switch (selectedCalculationType.value) {
      case 'Hddkayam':
        return _validateHddkayamEntries();

      case 'Stomach':
        return _validateStomachEntries();

      case 'Non-agricultural':
        return _validateNonAgriculturalStep();

      case 'Counting by number of knots':
        return _validateKnotsCountingStep();

      case 'Integration calculation':
        return _validateIntegrationCalculationStep();

      default:
        return false;
    }
  }

  bool _validateHddkayamEntries() {
    if (hddkayamEntries.isEmpty) {
      return false;
    }

    // At least one entry should have required fields filled
    for (var entry in hddkayamEntries) {
      String ctSurveyNumber = entry['ctSurveyNumber'] ?? '';
      String selectedCTSurvey = entry['selectedCTSurvey'] ?? '';
      String area = entry['area'] ?? '';
      String areaSqm = entry['areaSqm'] ?? '';

      if (ctSurveyNumber.trim().isNotEmpty ||
          (selectedCTSurvey.isNotEmpty &&
              selectedCTSurvey != 'Select CT Survey/TP No.') ||
          area.trim().isNotEmpty ||
          areaSqm.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  bool _validateStomachEntries() {
    if (stomachEntries.isEmpty) {
      return false;
    }

    // At least one entry should have required fields filled
    for (var entry in stomachEntries) {
      String surveyNumber = entry['surveyNumber'] ?? '';
      String selectedMeasurementType = entry['selectedMeasurementType'] ?? '';
      String totalArea = entry['totalArea'] ?? '';
      String calculatedArea = entry['calculatedArea'] ?? '';

      if (surveyNumber.trim().isNotEmpty ||
          (selectedMeasurementType.isNotEmpty &&
              selectedMeasurementType.isNotEmpty) ||
          totalArea.trim().isNotEmpty ||
          calculatedArea.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  bool _validateNonAgriculturalStep() {
    // Check common fields first
    if (orderNumberController.text.trim().isEmpty ||
        orderDateController.text.trim().isEmpty ||
        schemeOrderNumberController.text.trim().isEmpty ||
        appointmentDateController.text.trim().isEmpty) {
      return false;
    }

    // Check if at least one entry has required fields
    return _validateNonAgriculturalEntries();
  }

  bool _validateNonAgriculturalEntries() {
    if (nonAgriculturalEntries.isEmpty) {
      return false;
    }

    // At least one entry should have some required fields filled
    for (var entry in nonAgriculturalEntries) {
      String surveyNumber = entry['surveyNumber'] ?? '';
      String selectedSurveyType = entry['selectedSurveyType'] ?? '';
      String area = entry['area'] ?? '';
      String areaHectares = entry['areaHectares'] ?? '';

      if (surveyNumber.trim().isNotEmpty ||
          selectedSurveyType.isNotEmpty ||
          area.trim().isNotEmpty ||
          areaHectares.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  bool _validateKnotsCountingStep() {
    // Check common fields first
    if (orderNumberController.text.trim().isEmpty ||
        orderDateController.text.trim().isEmpty ||
        schemeOrderNumberController.text.trim().isEmpty ||
        appointmentDateController.text.trim().isEmpty) {
      return false;
    }

    // Check if at least one entry has required fields
    return _validateKnotsCountingEntries();
  }

  bool _validateKnotsCountingEntries() {
    if (knotsCountingEntries.isEmpty) {
      return false;
    }

    // At least one entry should have some required fields filled
    for (var entry in knotsCountingEntries) {
      String surveyNumber = entry['surveyNumber'] ?? '';
      String selectedSurveyType = entry['selectedSurveyType'] ?? '';
      String area = entry['area'] ?? '';
      String areaHectares = entry['areaHectares'] ?? '';

      if (surveyNumber.trim().isNotEmpty ||
          selectedSurveyType.isNotEmpty ||
          area.trim().isNotEmpty ||
          areaHectares.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  bool _validateIntegrationCalculationStep() {
    // Check required fields outside entries
    if (mergerOrderNumberController.text.trim().isEmpty ||
        mergerOrderDateController.text.trim().isEmpty ||
        oldMergerNumberController.text.trim().isEmpty ||
        incorporationOrderFiles.isEmpty) {
      return false;
    }

    // Check if at least one entry has required fields
    return _validateIntegrationCalculationEntries();
  }

  bool _validateIntegrationCalculationEntries() {
    if (integrationCalculationEntries.isEmpty) {
      return false;
    }

    // At least one entry should have some required fields filled
    for (var entry in integrationCalculationEntries) {
      String ctSurveyNumber = entry['ctSurveyNumber'] ?? '';
      String selectedCTSurvey = entry['selectedCTSurvey'] ?? '';
      String area = entry['area'] ?? '';
      String areaSqm = entry['areaSqm'] ?? '';

      if (ctSurveyNumber.trim().isNotEmpty ||
          (selectedCTSurvey.isNotEmpty &&
              selectedCTSurvey != 'Select CT Survey/TP No.') ||
          area.trim().isNotEmpty ||
          areaSqm.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
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
        return _getCalculationError();
      default:
        return 'This field is required';
    }
  }

  String _getCalculationError() {
    if (selectedCalculationType.value.isEmpty) {
      return 'Please select a calculation type';
    }

    switch (selectedCalculationType.value) {
      case 'Hddkayam':
        if (hddkayamEntries.isEmpty) {
          return 'At least one entry is required';
        }
        bool hasValidEntry = false;
        for (var entry in hddkayamEntries) {
          if ((entry['ctSurveyNumber']?.toString().trim().isNotEmpty ??
                  false) ||
              ((entry['selectedCTSurvey']?.toString().isNotEmpty ?? false) &&
                  entry['selectedCTSurvey'] != 'Select CT Survey/TP No.') ||
              (entry['area']?.toString().trim().isNotEmpty ?? false) ||
              (entry['areaSqm']?.toString().trim().isNotEmpty ?? false)) {
            hasValidEntry = true;
            break;
          }
        }
        if (!hasValidEntry) {
          return 'At least one valid entry is required';
        }
        break;

      case 'Stomach':
        if (stomachEntries.isEmpty) {
          return 'At least one entry is required';
        }
        bool hasValidEntry = false;
        for (var entry in stomachEntries) {
          if ((entry['surveyNumber']?.toString().trim().isNotEmpty ?? false) ||
              (entry['selectedMeasurementType']?.toString().isNotEmpty ??
                  false) ||
              (entry['totalArea']?.toString().trim().isNotEmpty ?? false) ||
              (entry['calculatedArea']?.toString().trim().isNotEmpty ??
                  false)) {
            hasValidEntry = true;
            break;
          }
        }
        if (!hasValidEntry) {
          return 'At least one valid entry is required';
        }
        break;

      case 'Non-agricultural':
        if (orderNumberController.text.trim().isEmpty) {
          return 'Order number is required';
        }
        if (orderDateController.text.trim().isEmpty) {
          return 'Order date is required';
        }
        if (schemeOrderNumberController.text.trim().isEmpty) {
          return 'Scheme order number is required';
        }
        if (appointmentDateController.text.trim().isEmpty) {
          return 'Appointment date is required';
        }
        if (nonAgriculturalEntries.isEmpty) {
          return 'At least one entry is required';
        }
        break;

      case 'Counting by number of knots':
        if (orderNumberController.text.trim().isEmpty) {
          return 'Order number is required';
        }
        if (orderDateController.text.trim().isEmpty) {
          return 'Order date is required';
        }
        if (schemeOrderNumberController.text.trim().isEmpty) {
          return 'Scheme order number is required';
        }
        if (appointmentDateController.text.trim().isEmpty) {
          return 'Appointment date is required';
        }
        if (knotsCountingEntries.isEmpty) {
          return 'At least one entry is required';
        }
        break;

      case 'Integration calculation':
        if (mergerOrderNumberController.text.trim().isEmpty) {
          return 'Merger order number is required';
        }
        if (mergerOrderDateController.text.trim().isEmpty) {
          return 'Merger order date is required';
        }
        if (oldMergerNumberController.text.trim().isEmpty) {
          return 'Old merger number is required';
        }
        if (incorporationOrderFiles.isEmpty) {
          return 'Incorporation order map is required';
        }
        if (integrationCalculationEntries.isEmpty) {
          return 'At least one entry is required';
        }
        break;
    }

    return 'Please complete all required fields';
  }

// ================ DATA PERSISTENCE METHODS ================

  @override
  Map<String, dynamic> getStepData() {
    Map<String, dynamic> data = {
      'calculationType': selectedCalculationType.value,
      'isCalculationComplete': isCalculationComplete.value,
      'notes': notesController.text.trim(),
      'date': datecontroller.text.trim(),
    };

    // Add common fields for Non-agricultural and Knots counting
    if (selectedCalculationType.value == 'Non-agricultural' ||
        selectedCalculationType.value == 'Counting by number of knots') {
      data.addAll({
        'orderNumber': orderNumberController.text.trim(),
        'orderDate': orderDateController.text.trim(),
        'schemeOrderNumber': schemeOrderNumberController.text.trim(),
        'appointmentDate': appointmentDateController.text.trim(),
      });
    }

    // Add type-specific data
    switch (selectedCalculationType.value) {
      case 'Hddkayam':
        List<Map<String, dynamic>> entriesData = [];
        for (var entry in hddkayamEntries) {
          entriesData.add({
            'ctSurveyNumber': entry['ctSurveyNumber'] ?? '',
            'selectedCTSurvey': entry['selectedCTSurvey'] ?? '',
            'area': entry['area'] ?? '',
            'areaSqm': entry['areaSqm'] ?? '',
            'isCorrect': entry['isCorrect'] ?? false,
          });
        }
        data['hddkayamEntries'] = entriesData;
        data.addAll({
          'surveyNumber': surveyNumberController.text.trim(),
          'area': areaController.text.trim(),
          'subdivision': subdivisionController.text.trim(),
        });
        break;

      case 'Stomach':
        List<Map<String, dynamic>> entriesData = [];
        for (var entry in stomachEntries) {
          entriesData.add({
            'surveyNumber': entry['surveyNumber'] ?? '',
            'selectedMeasurementType': entry['selectedMeasurementType'] ?? '',
            'totalArea': entry['totalArea'] ?? '',
            'calculatedArea': entry['calculatedArea'] ?? '',
            'isCorrect': entry['isCorrect'] ?? false,
          });
        }
        data['stomachEntries'] = entriesData;
        break;

      case 'Non-agricultural':
        List<Map<String, dynamic>> entriesData = [];
        for (var entry in nonAgriculturalEntries) {
          entriesData.add({
            'surveyNumber': entry['surveyNumber'] ?? '',
            'selectedSurveyType': entry['selectedSurveyType'] ?? '',
            'area': entry['area'] ?? '',
            'areaHectares': entry['areaHectares'] ?? '',
            'isCorrect': entry['isCorrect'] ?? false,
          });
        }
        data['nonAgriculturalEntries'] = entriesData;
        data.addAll({
          'landType': landType.value,
          'plotNumber': plotNumberController.text.trim(),
          'builtUpArea': builtUpAreaController.text.trim(),
        });
        break;

      case 'Counting by number of knots':
        List<Map<String, dynamic>> entriesData = [];
        for (var entry in knotsCountingEntries) {
          entriesData.add({
            'surveyNumber': entry['surveyNumber'] ?? '',
            'selectedSurveyType': entry['selectedSurveyType'] ?? '',
            'area': entry['area'] ?? '',
            'areaHectares': entry['areaHectares'] ?? '',
            'isCorrect': entry['isCorrect'] ?? false,
          });
        }
        data['knotsCountingEntries'] = entriesData;
        data.addAll({
          'knotsCount': knotsCountController.text.trim(),
          'knotSpacing': knotSpacingController.text.trim(),
          'calculationMethod': calculationMethod.value,
        });
        break;

      case 'Integration calculation':
        List<Map<String, dynamic>> entriesData = [];
        for (var entry in integrationCalculationEntries) {
          entriesData.add({
            'ctSurveyNumber': entry['ctSurveyNumber'] ?? '',
            'selectedCTSurvey': entry['selectedCTSurvey'] ?? '',
            'area': entry['area'] ?? '',
            'areaSqm': entry['areaSqm'] ?? '',
            'isCorrect': entry['isCorrect'] ?? false,
          });
        }
        data['integrationCalculationEntries'] = entriesData;
        data.addAll({
          'integrationType': integrationType.value,
          'baseLine': baseLineController.text.trim(),
          'ordinates': ordinatesController.text.trim(),
          'mergerOrderNumber': mergerOrderNumberController.text.trim(),
          'mergerOrderDate': mergerOrderDateController.text.trim(),
          'oldMergerNumber': oldMergerNumberController.text.trim(),
          'incorporationOrderFiles': incorporationOrderFiles.toList(),
        });
        break;
    }

    return data;
  }

  @override
  void loadStepData(Map<String, dynamic> data) {
    if (data.containsKey('calculationType')) {
      selectedCalculationType.value = data['calculationType'] ?? '';
    }

    if (data.containsKey('isCalculationComplete')) {
      isCalculationComplete.value = data['isCalculationComplete'];
    }

    if (data.containsKey('notes')) {
      notesController.text = data['notes'] ?? '';
    }

    if (data.containsKey('date')) {
      datecontroller.text = data['date'] ?? '';
    }

    // Load common fields for Non-agricultural and Knots counting
    if (selectedCalculationType.value == 'Non-agricultural' ||
        selectedCalculationType.value == 'Counting by number of knots') {
      orderNumberController.text = data['orderNumber'] ?? '';
      orderDateController.text = data['orderDate'] ?? '';
      schemeOrderNumberController.text = data['schemeOrderNumber'] ?? '';
      appointmentDateController.text = data['appointmentDate'] ?? '';
    }

    // Load type-specific data
    switch (selectedCalculationType.value) {
      case 'Hddkayam':
        _clearHddkayamEntries();
        if (data.containsKey('hddkayamEntries')) {
          List<dynamic> entriesData = data['hddkayamEntries'] ?? [];
          for (var entryData in entriesData) {
            final newEntry = {
              'ctSurveyController': TextEditingController(
                  text: entryData['ctSurveyNumber'] ?? ''),
              'selectedCTSurvey': entryData['selectedCTSurvey'] ?? '',
              'areaController':
                  TextEditingController(text: entryData['area'] ?? ''),
              'areaSqmController':
                  TextEditingController(text: entryData['areaSqm'] ?? ''),
              'ctSurveyNumber': entryData['ctSurveyNumber'] ?? '',
              'area': entryData['area'] ?? '',
              'areaSqm': entryData['areaSqm'] ?? '',
              'isCorrect': entryData['isCorrect'] ?? false,
            };
            hddkayamEntries.add(newEntry);
          }
        }
        surveyNumberController.text = data['surveyNumber'] ?? '';
        areaController.text = data['area'] ?? '';
        subdivisionController.text = data['subdivision'] ?? '';
        break;

      case 'Stomach':
        _clearStomachEntries();
        if (data.containsKey('stomachEntries')) {
          List<dynamic> entriesData = data['stomachEntries'] ?? [];
          for (var entryData in entriesData) {
            final newEntry = {
              'surveyNumberController':
                  TextEditingController(text: entryData['surveyNumber'] ?? ''),
              'selectedMeasurementType':
                  entryData['selectedMeasurementType'] ?? '',
              'totalAreaController':
                  TextEditingController(text: entryData['totalArea'] ?? ''),
              'calculatedAreaController': TextEditingController(
                  text: entryData['calculatedArea'] ?? ''),
              'surveyNumber': entryData['surveyNumber'] ?? '',
              'measurementType': entryData['selectedMeasurementType'] ??
                  '', // Keep for backward compatibility
              'totalArea': entryData['totalArea'] ?? '',
              'calculatedArea': entryData['calculatedArea'] ?? '',
              'isCorrect': entryData['isCorrect'] ?? false,
            };
            stomachEntries.add(newEntry);
          }
        }
        break;

      case 'Non-agricultural':
        _clearNonAgriculturalEntries();
        if (data.containsKey('nonAgriculturalEntries')) {
          List<dynamic> entriesData = data['nonAgriculturalEntries'] ?? [];
          for (var entryData in entriesData) {
            final newEntry = {
              'surveyNumberController':
                  TextEditingController(text: entryData['surveyNumber'] ?? ''),
              'selectedSurveyType': entryData['selectedSurveyType'] ?? '',
              'areaController':
                  TextEditingController(text: entryData['area'] ?? ''),
              'areaHectaresController':
                  TextEditingController(text: entryData['areaHectares'] ?? ''),
              'surveyNumber': entryData['surveyNumber'] ?? '',
              'area': entryData['area'] ?? '',
              'areaHectares': entryData['areaHectares'] ?? '',
              'isCorrect': entryData['isCorrect'] ?? false,
            };
            nonAgriculturalEntries.add(newEntry);
          }
        }
        landType.value = data['landType'] ?? '';
        plotNumberController.text = data['plotNumber'] ?? '';
        builtUpAreaController.text = data['builtUpArea'] ?? '';
        break;

      case 'Counting by number of knots':
        _clearKnotsCountingEntries();
        if (data.containsKey('knotsCountingEntries')) {
          List<dynamic> entriesData = data['knotsCountingEntries'] ?? [];
          for (var entryData in entriesData) {
            final newEntry = {
              'surveyNumberController':
                  TextEditingController(text: entryData['surveyNumber'] ?? ''),
              'selectedSurveyType': entryData['selectedSurveyType'] ?? '',
              'areaController':
                  TextEditingController(text: entryData['area'] ?? ''),
              'areaHectaresController':
                  TextEditingController(text: entryData['areaHectares'] ?? ''),
              'surveyNumber': entryData['surveyNumber'] ?? '',
              'area': entryData['area'] ?? '',
              'areaHectares': entryData['areaHectares'] ?? '',
              'isCorrect': entryData['isCorrect'] ?? false,
            };
            knotsCountingEntries.add(newEntry);
          }
        }
        knotsCountController.text = data['knotsCount'] ?? '';
        knotSpacingController.text = data['knotSpacing'] ?? '';
        calculationMethod.value = data['calculationMethod'] ?? '';
        break;

      case 'Integration calculation':
        _clearIntegrationCalculationEntries();
        if (data.containsKey('integrationCalculationEntries')) {
          List<dynamic> entriesData =
              data['integrationCalculationEntries'] ?? [];
          for (var entryData in entriesData) {
            final newEntry = {
              'ctSurveyController': TextEditingController(
                  text: entryData['ctSurveyNumber'] ?? ''),
              'selectedCTSurvey': entryData['selectedCTSurvey'] ?? '',
              'areaController':
                  TextEditingController(text: entryData['area'] ?? ''),
              'areaSqmController':
                  TextEditingController(text: entryData['areaSqm'] ?? ''),
              'ctSurveyNumber': entryData['ctSurveyNumber'] ?? '',
              'area': entryData['area'] ?? '',
              'areaSqm': entryData['areaSqm'] ?? '',
              'isCorrect': entryData['isCorrect'] ?? false,
            };
            integrationCalculationEntries.add(newEntry);
          }
        }
        integrationType.value = data['integrationType'] ?? '';
        baseLineController.text = data['baseLine'] ?? '';
        ordinatesController.text = data['ordinates'] ?? '';
        mergerOrderNumberController.text = data['mergerOrderNumber'] ?? '';
        mergerOrderDateController.text = data['mergerOrderDate'] ?? '';
        oldMergerNumberController.text = data['oldMergerNumber'] ?? '';
        if (data.containsKey('incorporationOrderFiles')) {
          incorporationOrderFiles.value =
              List<String>.from(data['incorporationOrderFiles'] ?? []);
        }
        break;

      default:
        break;
    }

    // Trigger UI update after loading data
    update();
  }

  // ================ FILE HANDLING METHODS ================

  void addIncorporationOrderFile(dynamic file) {
    incorporationOrderFiles.add(file);
    update();
  }

  void removeIncorporationOrderFile(int index) {
    if (index < incorporationOrderFiles.length) {
      incorporationOrderFiles.removeAt(index);
      update();
    }
  }

  // ================ UTILITY METHODS ================

  void updateLandType(String type) {
    landType.value = type;
    update();
  }

  void updateCalculationMethod(String method) {
    calculationMethod.value = method;
    update();
  }

  void updateIntegrationType(String type) {
    integrationType.value = type;
    update();
  }

  void updateDate(DateTime selectedDate) {
    datecontroller.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    update();
  }

  void updateIsCalculationComplete(bool? value) {
    isCalculationComplete.value = value;
    update();
  }

  void updateNotes(String value) {
    notesController.text = value;
    update();
  }

  // ================ RESET METHODS ================

  void resetCalculationData() {
    selectedCalculationType.value = '';
    isCalculationComplete.value = null;
    _clearTypeSpecificFields();
    update();
  }

  void resetAllData() {
    resetCalculationData();

    // Clear common controllers
    surveyNumberController.clear();
    areaController.clear();
    subdivisionController.clear();
    notesController.clear();

    update();
  }
}
