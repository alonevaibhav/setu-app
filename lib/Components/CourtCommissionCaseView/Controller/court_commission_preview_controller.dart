import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class CourtCommissionPreviewController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isSubmitting = false.obs;

  // Get reference to main controller
  CourtCommissionCaseController get mainController => Get.find<CourtCommissionCaseController>();

  // Collected data - make these reactive (as per your structure)
  final courtCommissionData = Rxn<Map<String, dynamic>>();
  final surveyCTSData = Rxn<Map<String, dynamic>>();
  final calculationData = Rxn<Map<String, dynamic>>();
  final courtFourthData = Rxn<Map<String, dynamic>>();
  final courtFifthData = Rxn<Map<String, dynamic>>();
  final courtSixthData = Rxn<Map<String, dynamic>>();
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

      print('📋 Loading all court commission data for preview...');

      // Load all data from main controller's individual controllers directly
      courtCommissionData.value = _getCourtCommissionDataDirect();
      surveyCTSData.value = _getSurveyCTSDataDirect();
      calculationData.value = _getCalculationDataDirect();
      courtFourthData.value = _getCourtFourthDataDirect();
      courtFifthData.value = _getCourtFifthDataDirect();
      courtSixthData.value = _getCourtSixthDataDirect();
      documentsData.value = _getDocumentsDataDirect();

      print('📋 Court Commission preview data loaded successfully');
      print('📋 Calculation entries count: ${calculationEntries.length}');
      print('📋 Plaintiff/Defendant count: ${plaintiffDefendantEntries.length}');
      print('📋 Next of kin entries count: ${nextOfKinEntries.length}');

    } catch (e) {
      print('❌ Error loading preview data: $e');
      errorMessage.value = 'Failed to load preview data';
    } finally {
      isLoading.value = false;
    }
  }

  // === DIRECT DATA LOADING METHODS ===
  Map<String, dynamic> _getCourtCommissionDataDirect() {
    return {
      'court_commission': {
        'court_name': mainController.personalInfoController.courtNameController.text.trim(),
        'court_address': mainController.personalInfoController.courtAddressController.text.trim(),
        'commission_order_number': mainController.personalInfoController.commissionOrderNoController.text.trim(),
        'commission_date': mainController.personalInfoController.commissionDateController.text.trim(),
        'selected_commission_date': mainController.personalInfoController.selectedCommissionDate.value,
        'civil_claim': mainController.personalInfoController.civilClaimController.text.trim(),
        'issuing_office': mainController.personalInfoController.issuingOfficeController.text.trim(),
        'commission_order_files': mainController.personalInfoController.commissionOrderFiles.toList(),
      }
    };
  }

  Map<String, dynamic> _getSurveyCTSDataDirect() {
    return {
      'survey_cts': {
        'survey_number': mainController.surveyCTSController.surveyNumberController.text.trim(),
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
        'selectedVillage': entry['selectedVillage']?.toString() ?? '',
        'surveyNo': entry['surveyNo']?.toString() ?? '',
        'share': entry['share']?.toString() ?? '',
        'area': entry['area']?.toString() ?? '',
      });
    }

    return {
      'calculation': {
        'surveyEntries': entriesData,
      }
    };
  }

  Map<String, dynamic> _getCourtFourthDataDirect() {
    return {
      'court_fourth': {
        'calculation_type': mainController.courtFourthController.selectedCalculationType.value,
        'duration': mainController.courtFourthController.selectedDuration.value,
        'holder_type': mainController.courtFourthController.selectedHolderType.value,
        'location_category': mainController.courtFourthController.selectedLocationCategory.value,
        'calculation_fee': mainController.courtFourthController.calculationFeeController.text.trim(),
      }
    };
  }

  Map<String, dynamic> _getCourtFifthDataDirect() {
    List<Map<String, dynamic>> plaintiffDefendantData = [];

    for (int i = 0; i < mainController.courtFifthController.plaintiffDefendantEntries.length; i++) {
      final entry = mainController.courtFifthController.plaintiffDefendantEntries[i];
      final selectedType = entry['selectedType'] as RxString?;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>?;

      plaintiffDefendantData.add({
        'selectedType': selectedType?.value ?? '',
        'name': entry['nameController']?.text ?? '',
        'address': entry['addressController']?.text ?? '',
        'mobile': entry['mobileController']?.text ?? '',
        'surveyNumber': entry['surveyNumberController']?.text ?? '',
        'plotNo': detailedAddress?['plotNo'] ?? '',
        'detailedAddress': detailedAddress?['address'] ?? '',
        'mobileNumber': detailedAddress?['mobileNumber'] ?? '',
        'email': detailedAddress?['email'] ?? '',
        'pincode': detailedAddress?['pincode'] ?? '',
        'district': detailedAddress?['district'] ?? '',
        'village': detailedAddress?['village'] ?? '',
        'postOffice': detailedAddress?['postOffice'] ?? '',
      });
    }

    return {
      'court_fifth': {
        'plaintiffDefendantEntries': plaintiffDefendantData,
      }
    };
  }

  Map<String, dynamic> _getCourtSixthDataDirect() {
    List<Map<String, dynamic>> entriesData = [];

    for (final entry in mainController.courtSixthController.nextOfKinEntries) {
      entriesData.add({
        'address': entry['address']?.toString() ?? '',
        'mobile': entry['mobile']?.toString() ?? '',
        'surveyNo': entry['surveyNo']?.toString() ?? '',
        'direction': entry['direction']?.toString() ?? '',
        'naturalResources': entry['naturalResources']?.toString() ?? '',
      });
    }

    return {
      'court_sixth': {
        'nextOfKinEntries': entriesData,
      }
    };
  }

  Map<String, dynamic> _getDocumentsDataDirect() {
    return {
      'identityCardType': mainController.courtSeventhController.selectedIdentityType.value,
      'identityCardFiles': mainController.courtSeventhController.identityCardFiles.map((e) => e.toString()).toList(),
      'sevenTwelveFiles': mainController.courtSeventhController.sevenTwelveFiles.map((e) => e.toString()).toList(),
      'noteFiles': mainController.courtSeventhController.noteFiles.map((e) => e.toString()).toList(),
      'partitionFiles': mainController.courtSeventhController.partitionFiles.map((e) => e.toString()).toList(),
      'schemeSheetFiles': mainController.courtSeventhController.schemeSheetFiles.map((e) => e.toString()).toList(),
      'oldCensusMapFiles': mainController.courtSeventhController.oldCensusMapFiles.map((e) => e.toString()).toList(),
      'demarcationCertificateFiles': mainController.courtSeventhController.demarcationCertificateFiles.map((e) => e.toString()).toList(),
    };
  }

  // === GETTERS (Using reactive data) ===

  // Court Commission Info getters
  String get courtName => courtCommissionData.value?['court_commission']?['court_name']?.toString() ?? '';
  String get courtAddress => courtCommissionData.value?['court_commission']?['court_address']?.toString() ?? '';
  String get commissionOrderNumber => courtCommissionData.value?['court_commission']?['commission_order_number']?.toString() ?? '';
  String get commissionDate => courtCommissionData.value?['court_commission']?['commission_date']?.toString() ?? '';
  String get selectedCommissionDate => courtCommissionData.value?['court_commission']?['selected_commission_date']?.toString() ?? '';
  String get civilClaim => courtCommissionData.value?['court_commission']?['civil_claim']?.toString() ?? '';
  String get issuingOffice => courtCommissionData.value?['court_commission']?['issuing_office']?.toString() ?? '';

  // Court Commission Files
  List<String> get commissionOrderFiles => List<String>.from(courtCommissionData.value?['court_commission']?['commission_order_files'] ?? []);

  // Survey CTS Info getters
  String get surveyNumber => surveyCTSData.value?['survey_cts']?['survey_number']?.toString() ?? '';
  String get department => surveyCTSData.value?['survey_cts']?['department']?.toString() ?? '';
  String get district => surveyCTSData.value?['survey_cts']?['district']?.toString() ?? '';
  String get taluka => surveyCTSData.value?['survey_cts']?['taluka']?.toString() ?? '';
  String get village => surveyCTSData.value?['survey_cts']?['village']?.toString() ?? '';
  String get office => surveyCTSData.value?['survey_cts']?['office']?.toString() ?? '';

  // Calculation Info getters
  List<Map<String, dynamic>> get calculationEntries {
    final entries = calculationData.value?['calculation']?['surveyEntries'] as List<dynamic>?;
    if (entries != null) {
      return entries.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Court Fourth Info getters
  String get calculationType => courtFourthData.value?['court_fourth']?['calculation_type']?.toString() ?? '';
  String get duration => courtFourthData.value?['court_fourth']?['duration']?.toString() ?? '';
  String get holderType => courtFourthData.value?['court_fourth']?['holder_type']?.toString() ?? '';
  String get locationCategory => courtFourthData.value?['court_fourth']?['location_category']?.toString() ?? '';
  String get calculationFee => courtFourthData.value?['court_fourth']?['calculation_fee']?.toString() ?? '';

  // Plaintiff/Defendant Information getters
  List<Map<String, dynamic>> get plaintiffDefendantEntries {
    final entries = courtFifthData.value?['court_fifth']?['plaintiffDefendantEntries'] as List<dynamic>?;
    if (entries != null) {
      return entries.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Next of Kin getters
  List<Map<String, dynamic>> get nextOfKinEntries {
    final entries = courtSixthData.value?['court_sixth']?['nextOfKinEntries'] as List<dynamic>?;
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
  Future<void> submitCourtCommissionSurvey() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      await mainController.submitCourtCommissionSurvey();

      Get.snackbar(
        'Success',
        'Court Commission Survey submitted successfully!',
        backgroundColor: Color(0xFF52B788),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Navigate to success page or close
      Get.back();

    } catch (e) {
      print('❌ Submit error: $e');
      errorMessage.value = 'Failed to submit court commission survey: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Failed to submit court commission survey. Please try again.',
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
