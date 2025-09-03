
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class LandAcquisitionPreviewController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isSubmitting = false.obs;

  // Get reference to main controller
  MainLandAcquisitionController get mainController => Get.find<MainLandAcquisitionController>();

  // Collected data - make these reactive (as per your original structure)
  final landAcquisitionData = Rxn<Map<String, dynamic>>();
  final surveyCTSData = Rxn<Map<String, dynamic>>();
  final calculationData = Rxn<Map<String, dynamic>>();
  final landFourthData = Rxn<Map<String, dynamic>>();
  final holderData = Rxn<Map<String, dynamic>>();
  final nextOfKinData = Rxn<Map<String, dynamic>>();
  final documentsData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh data when the controller becomes ready (when user navigates to preview)
    refreshData();
  }

  // Add a method to refresh data - this should be called whenever user navigates to preview
  void refreshData() {
    loadAllData();
  }

  // === CRITICAL: LOAD ALL DATA METHOD ===
  void loadAllData() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📋 Loading all data for preview...');

      // Load all data from main controller's individual controllers directly
      landAcquisitionData.value = _getLandAcquisitionDataDirect();
      surveyCTSData.value = _getSurveyCTSDataDirect();
      calculationData.value = _getCalculationDataDirect();
      landFourthData.value = _getLandFourthDataDirect();
      holderData.value = _getHolderDataDirect();
      nextOfKinData.value = _getNextOfKinDataDirect();
      documentsData.value = _getDocumentsDataDirect();


    } catch (e) {
      print('❌ Error loading preview data: $e');
      errorMessage.value = 'Failed to load preview data';
    } finally {
      isLoading.value = false;
    }
  }

  // === DIRECT DATA LOADING METHODS ===
  Map<String, dynamic> _getLandAcquisitionDataDirect() {
    return {
      'land_acquisition': {
        'land_acquisition_officer': mainController.personalInfoController.landAcquisitionOfficerController.text.trim(),
        'land_acquisition_board': mainController.personalInfoController.landAcquisitionBoardController.text.trim(),
        'land_acquisition_details': mainController.personalInfoController.landAcquisitionDetailsController.text.trim(),
        'land_acquisition_order_number': mainController.personalInfoController.landAcquisitionOrderNumberController.text.trim(),
        'land_acquisition_order_date': mainController.personalInfoController.landAcquisitionOrderDateController.text.trim(),
        'land_acquisition_office_address': mainController.personalInfoController.landAcquisitionOfficeAddressController.text.trim(),
        'land_acquisition_order_files': mainController.personalInfoController.landAcquisitionOrderFiles.toList(),
        'land_acquisition_map_files': mainController.personalInfoController.landAcquisitionMapFiles.toList(),
        'kml_files': mainController.personalInfoController.kmlFiles.toList(),
      }
    };
  }

  Map<String, dynamic> _getSurveyCTSDataDirect() {
    return {
      'survey_cts': {
        'survey_number': mainController.surveyCTSController.selectedSurveyNo.value.isNotEmpty
            ? mainController.surveyCTSController.selectedSurveyNo.value
            : mainController.surveyCTSController.surveyNumberController.text.trim(),
        'department': mainController.surveyCTSController.selectedDepartment.value,
        'district': mainController.surveyCTSController.selectedDistrict.value,
        'taluka': mainController.surveyCTSController.selectedTaluka.value,
        'village': mainController.surveyCTSController.selectedVillage.value,
        'office': mainController.surveyCTSController.selectedOffice.value,
      }
    };
  }

  Map<String, dynamic> _getCalculationDataDirect() {
    List<Map<String, dynamic>> entriesData = [];

    for (int i = 0; i < mainController.calculationController.surveyEntries.length; i++) {
      final entry = mainController.calculationController.surveyEntries[i];
      entriesData.add({
        'village': entry['village']?.toString() ?? mainController.calculationController.selectedVillage.value,
        'surveyNo': entry['surveyNo']?.toString() ?? '',
        'share': entry['share']?.toString() ?? '',
        'area': entry['area']?.toString() ?? '',
        'landAcquisitionArea': entry['landAcquisitionArea']?.toString() ?? '',
        'abdominalSection': entry['abdominalSection']?.toString() ?? '',
      });
    }

    return {
      'calculation': {
        'selectedVillage': mainController.calculationController.selectedVillage.value,
        'surveyEntries': entriesData,
      }
    };
  }

  Map<String, dynamic> _getLandFourthDataDirect() {
    return {
      'land_fourth': {
        'calculation_type': mainController.landFouthController.selectedCalculationType.value,
        'duration': mainController.landFouthController.selectedDuration.value,
        'holder_type': mainController.landFouthController.selectedHolderType.value,
        'counting_fee': mainController.landFouthController.countingFee.value.toString(),
      }
    };
  }

  Map<String, dynamic> _getHolderDataDirect() {
    List<Map<String, dynamic>> holderData = [];

    for (int i = 0; i < mainController.landFifthController.holderEntries.length; i++) {
      final entry = mainController.landFifthController.holderEntries[i];
      holderData.add({
        'holderName': entry['holderName']?.toString() ?? '',
        'address': entry['address']?.toString() ?? '',
        'accountNumber': entry['accountNumber']?.toString() ?? '',
        'mobileNumber': entry['mobileNumber']?.toString() ?? '',
        'serverNumber': entry['serverNumber']?.toString() ?? '',
        'area': entry['area']?.toString() ?? '',
        'potKharabaArea': entry['potKharabaArea']?.toString() ?? '',
        'totalArea': entry['totalArea']?.toString() ?? '',
        'village': entry['village']?.toString() ?? '',
        'plotNo': entry['plotNo']?.toString() ?? '',
        'email': entry['email']?.toString() ?? '',
        'pincode': entry['pincode']?.toString() ?? '',
        'district': entry['district']?.toString() ?? '',
        'postOffice': entry['postOffice']?.toString() ?? '',
      });
    }

    return {
      'land_fifth': {
        'holderInformation': holderData,
      }
    };
  }

  Map<String, dynamic> _getNextOfKinDataDirect() {
    List<Map<String, dynamic>> entriesData = [];

    for (final entry in mainController.laandSixthController.nextOfKinEntries) {
      entriesData.add({
        'address': entry['address']?.toString() ?? '',
        'mobile': entry['mobile']?.toString() ?? '',
        'surveyNo': entry['surveyNo']?.toString() ?? '',
        'direction': entry['direction']?.toString() ?? '',
        'naturalResources': entry['naturalResources']?.toString() ?? '',
      });
    }

    return {
      'land_sixth': {
        'nextOfKinEntries': entriesData,
      }
    };
  }

  Map<String, dynamic> _getDocumentsDataDirect() {
    return {
      'identityCardType': mainController.landSeventhController.selectedIdentityType.value,
      'identityCardFiles': mainController.landSeventhController.identityCardFiles.map((e) => e.toString()).toList(),
      'sevenTwelveFiles': mainController.landSeventhController.sevenTwelveFiles.map((e) => e.toString()).toList(),
      'noteFiles': mainController.landSeventhController.noteFiles.map((e) => e.toString()).toList(),
      'partitionFiles': mainController.landSeventhController.partitionFiles.map((e) => e.toString()).toList(),
      'schemeSheetFiles': mainController.landSeventhController.schemeSheetFiles.map((e) => e.toString()).toList(),
      'oldCensusMapFiles': mainController.landSeventhController.oldCensusMapFiles.map((e) => e.toString()).toList(),
      'demarcationCertificateFiles': mainController.landSeventhController.demarcationCertificateFiles.map((e) => e.toString()).toList(),
    };
  }

  // === GETTERS (Using reactive data as per your original structure) ===

  // Land Acquisition Info getters
  String get landAcquisitionOfficer => landAcquisitionData.value?['land_acquisition']?['land_acquisition_officer']?.toString() ?? '';
  String get landAcquisitionBoard => landAcquisitionData.value?['land_acquisition']?['land_acquisition_board']?.toString() ?? '';
  String get landAcquisitionDescription => landAcquisitionData.value?['land_acquisition']?['land_acquisition_details']?.toString() ?? '';
  String get orderProposalNumber => landAcquisitionData.value?['land_acquisition']?['land_acquisition_order_number']?.toString() ?? '';
  String get orderProposalDate => landAcquisitionData.value?['land_acquisition']?['land_acquisition_order_date']?.toString() ?? '';
  String get issuingOfficeAddress => landAcquisitionData.value?['land_acquisition']?['land_acquisition_office_address']?.toString() ?? '';

  // Land Acquisition Files
  List<String> get landAcquisitionOrderFiles => List<String>.from(landAcquisitionData.value?['land_acquisition']?['land_acquisition_order_files'] ?? []);
  List<String> get landAcquisitionMapFiles => List<String>.from(landAcquisitionData.value?['land_acquisition']?['land_acquisition_map_files'] ?? []);
  List<String> get kmlFiles => List<String>.from(landAcquisitionData.value?['land_acquisition']?['kml_files'] ?? []);

  // Survey CTS Info getters
  String get surveyNumber => surveyCTSData.value?['survey_cts']?['survey_number']?.toString() ?? '';
  String get department => surveyCTSData.value?['survey_cts']?['department']?.toString() ?? '';
  String get district => surveyCTSData.value?['survey_cts']?['district']?.toString() ?? '';
  String get taluka => surveyCTSData.value?['survey_cts']?['taluka']?.toString() ?? '';
  String get village => surveyCTSData.value?['survey_cts']?['village']?.toString() ?? '';
  String get office => surveyCTSData.value?['survey_cts']?['office']?.toString() ?? '';

  // Calculation Info getters
  String get selectedVillage => calculationData.value?['calculation']?['selectedVillage']?.toString() ?? '';

  List<Map<String, dynamic>> get calculationEntries {
    final entries = calculationData.value?['calculation']?['surveyEntries'] as List<dynamic>?;
    if (entries != null) {
      return entries.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Land Fourth Info getters
  String get calculationType => landFourthData.value?['land_fourth']?['calculation_type']?.toString() ?? '';
  String get duration => landFourthData.value?['land_fourth']?['duration']?.toString() ?? '';
  String get holderType => landFourthData.value?['land_fourth']?['holder_type']?.toString() ?? '';
  String get countingFee => landFourthData.value?['land_fourth']?['counting_fee']?.toString() ?? '';

  // Holder Information getters
  List<Map<String, dynamic>> get holderInformation {
    final holders = holderData.value?['land_fifth']?['holderInformation'] as List<dynamic>?;
    if (holders != null) {
      return holders.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Next of Kin getters
  List<Map<String, dynamic>> get nextOfKinEntries {
    final entries = nextOfKinData.value?['land_sixth']?['nextOfKinEntries'] as List<dynamic>?;
    if (entries != null) {
      return entries.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Document getters
  String get identityCardType => documentsData.value?['identityCardType']?.toString() ?? '';
  List<String> get identityCardFiles => List<String>.from(documentsData.value?['identityCardFiles'] ?? []);
  List<String> get sevenTwelveFiles => List<String>.from(documentsData.value?['sevenTwelveFiles'] ?? []);
  List<String> get noteFiles => List<String>.from(documentsData.value?['noteFiles'] ?? []);
  List<String> get partitionFiles => List<String>.from(documentsData.value?['partitionFiles'] ?? []);
  List<String> get schemeSheetFiles => List<String>.from(documentsData.value?['schemeSheetFiles'] ?? []);
  List<String> get oldCensusMapFiles => List<String>.from(documentsData.value?['oldCensusMapFiles'] ?? []);
  List<String> get demarcationCertificateFiles => List<String>.from(documentsData.value?['demarcationCertificateFiles'] ?? []);

  // === SUBMIT METHOD ===
  Future<void> submitLandAcquisitionSurvey() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      await mainController.submitLandAcquisitionSurvey();

      Get.snackbar(
        'Success',
        'Land Acquisition Survey submitted successfully!',
        backgroundColor: Color(0xFF52B788),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Navigate to success page or close
      Get.back();

    } catch (e) {
      print('❌ Submit error: $e');
      errorMessage.value = 'Failed to submit land acquisition survey: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Failed to submit land acquisition survey. Please try again.',
        backgroundColor: Color(0xFFDC3545),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // === UTILITY METHODS ===
  String formatFieldName(String fieldName) {
    return fieldName
        .split('_')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String getFileName(String filePath) {
    return filePath.split('/').last.split('\\').last;
  }

  bool isImageFile(String fileName) {
    final extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final lowerName = fileName.toLowerCase();
    return extensions.any((ext) => lowerName.endsWith(ext));
  }

  bool isPdfFile(String fileName) {
    return fileName.toLowerCase().endsWith('.pdf');
  }

  bool isWordFile(String fileName) {
    final extensions = ['.doc', '.docx'];
    final lowerName = fileName.toLowerCase();
    return extensions.any((ext) => lowerName.endsWith(ext));
  }

  // Helper method to check if a string is not empty
  bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

  // Helper method to format boolean values
  String formatBoolean(bool value) => value ? 'Yes' : 'No';
}
