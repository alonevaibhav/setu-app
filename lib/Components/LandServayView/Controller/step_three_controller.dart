import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_controller.dart';

class CalculationController extends GetxController with StepValidationMixin, StepDataMixin {
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

  // Stomach calculation fields
  final measurementType = ''.obs;
  final totalAreaController = TextEditingController();

  // Non-agricultural fields
  final landType = ''.obs;
  final plotNumberController = TextEditingController();
  final builtUpAreaController = TextEditingController();

  // Knots counting fields
  final knotsCountController = TextEditingController();
  final knotSpacingController = TextEditingController();
  final calculationMethod = ''.obs;

  // Integration calculation fields
  final integrationType = ''.obs;
  final baseLineController = TextEditingController();
  final ordinatesController = TextEditingController();

  // Status fields
  final isCalculationComplete = Rxn<bool>();

  // Hddkayam table entries
  final hddkayamEntries = <Map<String, dynamic>>[].obs;
  final List<String> ctSurveyOptions = [
    'Select CT Survey/TP No.',
  ];

  @override
  void onInit() {
    super.onInit();
    _setupValidation();

    // Initialize with one empty entry when Hddkayam is selected
    ever(selectedCalculationType, (String type) {
      if (type == 'Hddkayam' && hddkayamEntries.isEmpty) {
        addHddkayamEntry();
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
    totalAreaController.dispose();
    plotNumberController.dispose();
    builtUpAreaController.dispose();
    knotsCountController.dispose();
    knotSpacingController.dispose();
    baseLineController.dispose();
    ordinatesController.dispose();

    // Dispose hddkayam entry controllers
    _clearHddkayamEntries();

    super.onClose();
  }

  void _setupValidation() {
    // Add listeners for validation
    selectedCalculationType.listen((_) => update());
    measurementType.listen((_) => update());
    landType.listen((_) => update());
    calculationMethod.listen((_) => update());
    integrationType.listen((_) => update());
    isCalculationComplete.listen((_) => update());
    hddkayamEntries.listen((_) => update());
  }

  void updateCalculationType(String type) {
    selectedCalculationType.value = type;
    _clearTypeSpecificFields();
  }

  void _clearTypeSpecificFields() {
    // Clear fields when calculation type changes
    measurementType.value = '';
    landType.value = '';
    calculationMethod.value = '';
    integrationType.value = '';

    totalAreaController.clear();
    plotNumberController.clear();
    builtUpAreaController.clear();
    knotsCountController.clear();
    knotSpacingController.clear();
    baseLineController.clear();
    ordinatesController.clear();

    // Clear hddkayam entries
    _clearHddkayamEntries();
  }

  // Hddkayam table methods
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

  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'calculation':
        return _validateCalculationStep();

      default:
        return false;
    }
  }

  bool _validateCalculationStep() {
    if (selectedCalculationType.value.isEmpty) {
      return false;
    }

    switch (selectedCalculationType.value) {
      case 'Hddkayam':
        return _validateHddkayamEntries();

      case 'Stomach':
        return measurementType.value.isNotEmpty &&
            totalAreaController.text.trim().isNotEmpty;

      case 'Non-agricultural':
        return landType.value.isNotEmpty &&
            plotNumberController.text.trim().isNotEmpty;

      case 'Counting by number of knots':
        return knotsCountController.text.trim().isNotEmpty &&
            knotSpacingController.text.trim().isNotEmpty &&
            calculationMethod.value.isNotEmpty;

      case 'Integration calculation':
        return integrationType.value.isNotEmpty &&
            baseLineController.text.trim().isNotEmpty &&
            ordinatesController.text.trim().isNotEmpty;

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
          (selectedCTSurvey.isNotEmpty && selectedCTSurvey != 'Select CT Survey/TP No.') ||
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
          if ((entry['ctSurveyNumber']?.toString().trim().isNotEmpty ?? false) ||
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
        if (measurementType.value.isEmpty) {
          return 'Please select measurement type';
        }
        if (totalAreaController.text.trim().isEmpty) {
          return 'Total area is required';
        }
        break;

      case 'Non-agricultural':
        if (landType.value.isEmpty) {
          return 'Please select land type';
        }
        if (plotNumberController.text.trim().isEmpty) {
          return 'Plot number is required';
        }
        break;

      case 'Counting by number of knots':
        if (knotsCountController.text.trim().isEmpty) {
          return 'Number of knots is required';
        }
        if (knotSpacingController.text.trim().isEmpty) {
          return 'Knot spacing is required';
        }
        if (calculationMethod.value.isEmpty) {
          return 'Please select calculation method';
        }
        break;

      case 'Integration calculation':
        if (integrationType.value.isEmpty) {
          return 'Please select integration type';
        }
        if (baseLineController.text.trim().isEmpty) {
          return 'Base line measurement is required';
        }
        if (ordinatesController.text.trim().isEmpty) {
          return 'Number of ordinates is required';
        }
        break;
    }

    return 'Please complete all required fields';
  }

  @override
  Map<String, dynamic> getStepData() {
    Map<String, dynamic> data = {
      'calculationType': selectedCalculationType.value,
      'isCalculationComplete': isCalculationComplete.value,
      'notes': notesController.text.trim(),
    };

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
        data.addAll({
          'measurementType': measurementType.value,
          'totalArea': totalAreaController.text.trim(),
        });
        break;

      case 'Non-agricultural':
        data.addAll({
          'landType': landType.value,
          'plotNumber': plotNumberController.text.trim(),
          'builtUpArea': builtUpAreaController.text.trim(),
        });
        break;

      case 'Counting by number of knots':
        data.addAll({
          'knotsCount': knotsCountController.text.trim(),
          'knotSpacing': knotSpacingController.text.trim(),
          'calculationMethod': calculationMethod.value,
        });
        break;

      case 'Integration calculation':
        data.addAll({
          'integrationType': integrationType.value,
          'baseLine': baseLineController.text.trim(),
          'ordinates': ordinatesController.text.trim(),
        });
        break;
    }

    return data;
  }

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

    // Load type-specific data
    switch (selectedCalculationType.value) {
      case 'Hddkayam':
        _clearHddkayamEntries();
        if (data.containsKey('hddkayamEntries')) {
          List<dynamic> entriesData = data['hddkayamEntries'] ?? [];
          for (var entryData in entriesData) {
            final newEntry = {
              'ctSurveyController': TextEditingController(text: entryData['ctSurveyNumber'] ?? ''),
              'selectedCTSurvey': entryData['selectedCTSurvey'] ?? '',
              'areaController': TextEditingController(text: entryData['area'] ?? ''),
              'areaSqmController': TextEditingController(text: entryData['areaSqm'] ?? ''),
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
        measurementType.value = data['measurementType'] ?? '';
        totalAreaController.text = data['totalArea'] ?? '';
        break;

      case 'Non-agricultural':
        landType.value = data['landType'] ?? '';
        plotNumberController.text = data['plotNumber'] ?? '';
        builtUpAreaController.text = data['builtUpArea'] ?? '';
        break;

      case 'Counting by number of knots':
        knotsCountController.text = data['knotsCount'] ?? '';
        knotSpacingController.text = data['knotSpacing'] ?? '';
        calculationMethod.value = data['calculationMethod'] ?? '';
        break;

      case 'Integration calculation':
        integrationType.value = data['integrationType'] ?? '';
        baseLineController.text = data['baseLine'] ?? '';
        ordinatesController.text = data['ordinates'] ?? '';
        break;
    }
  }
}

