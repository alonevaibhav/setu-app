import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class CourtAllocationPreviewController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isSubmitting = false.obs;

  // Get reference to main controller
  CourtAllocationCaseController get mainController => Get.find<CourtAllocationCaseController>();

  // Collected data - make these reactive (as per your structure)
  final courtAllocationData = Rxn<Map<String, dynamic>>();
  final surveyCTSData = Rxn<Map<String, dynamic>>();
  final calculationData = Rxn<Map<String, dynamic>>();
  final courtAllocationFourthData = Rxn<Map<String, dynamic>>();
  final allocationFifthData = Rxn<Map<String, dynamic>>();
  final allocationSixthData = Rxn<Map<String, dynamic>>();
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

      print('📋 Loading all court allocation data for preview...');

      // Load all data from main controller's individual controllers directly
      courtAllocationData.value = _getCourtAllocationDataDirect();
      surveyCTSData.value = _getSurveyCTSDataDirect();
      calculationData.value = _getCalculationDataDirect();
      courtAllocationFourthData.value = _getCourtAllocationFourthDataDirect();
      allocationFifthData.value = _getAllocationFifthDataDirect();
      allocationSixthData.value = _getAllocationSixthDataDirect();
      documentsData.value = _getDocumentsDataDirect();

      print('📋 Court Allocation preview data loaded successfully');
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
  Map<String, dynamic> _getCourtAllocationDataDirect() {
    return {
      'court_allocation': {
        'court_name': mainController.personalInfoController.courtNameController.text.trim(),
        'court_address': mainController.personalInfoController.courtAddressController.text.trim(),
        'court_order_number': mainController.personalInfoController.courtOrderNumberController.text.trim(),
        'court_allotment_date': mainController.personalInfoController.courtAllotmentDateController.text.trim(),
        'court_allotment_date_selected': mainController.personalInfoController.courtAllotmentDate.value?.toString() ?? '',
        'claim_number_year': mainController.personalInfoController.claimNumberYearController.text.trim(),
        'special_order_comments': mainController.personalInfoController.specialOrderCommentsController.text.trim(),
        'court_order_files': mainController.personalInfoController.courtOrderFiles.toList(),
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

  Map<String, dynamic> _getCourtAllocationFourthDataDirect() {
    return {
      'court_allocation_fourth': {
        'calculation_type': mainController.courtAlloFouthController.selectedCalculationType.value,
        'duration': mainController.courtAlloFouthController.selectedDuration.value,
        'holder_type': mainController.courtAlloFouthController.selectedHolderType.value,
        'location_category': mainController.courtAlloFouthController.selectedLocationCategory.value,
        'calculation_fee': mainController.courtAlloFouthController.calculationFeeController.text.trim(),
        'calculation_fee_numeric': mainController.courtAlloFouthController.extractNumericFee()?.toString() ?? '0',
      }
    };
  }

  Map<String, dynamic> _getAllocationFifthDataDirect() {
    List<Map<String, dynamic>> plaintiffDefendantData = [];

    for (int i = 0; i < mainController.allocationFifthController.plaintiffDefendantEntries.length; i++) {
      final entry = mainController.allocationFifthController.plaintiffDefendantEntries[i];
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
      'allocation_fifth': {
        'plaintiffDefendantEntries': plaintiffDefendantData,
      }
    };
  }

  Map<String, dynamic> _getAllocationSixthDataDirect() {
    List<Map<String, dynamic>> entriesData = [];

    for (final entry in mainController.allocationSixthController.nextOfKinEntries) {
      entriesData.add({
        'address': entry['addressController']?.text?.trim() ?? '',
        'mobile': entry['mobileController']?.text?.trim() ?? '',
        'surveyNo': entry['surveyNoController']?.text?.trim() ?? '',
        'direction': entry['direction']?.toString() ?? '',
        'naturalResources': entry['naturalResources']?.toString() ?? '',
      });
    }

    return {
      'allocation_sixth': {
        'nextOfKinEntries': entriesData,
      }
    };
  }

  Map<String, dynamic> _getDocumentsDataDirect() {
    return {
      'identityCardType': mainController.allocationSeventhController.selectedIdentityType.value,
      'identityCardFiles': mainController.allocationSeventhController.identityCardFiles.map((e) => e.toString()).toList(),
      'sevenTwelveFiles': mainController.allocationSeventhController.sevenTwelveFiles.map((e) => e.toString()).toList(),
      'noteFiles': mainController.allocationSeventhController.noteFiles.map((e) => e.toString()).toList(),
      'partitionFiles': mainController.allocationSeventhController.partitionFiles.map((e) => e.toString()).toList(),
      'schemeSheetFiles': mainController.allocationSeventhController.schemeSheetFiles.map((e) => e.toString()).toList(),
      'oldCensusMapFiles': mainController.allocationSeventhController.oldCensusMapFiles.map((e) => e.toString()).toList(),
      'demarcationCertificateFiles': mainController.allocationSeventhController.demarcationCertificateFiles.map((e) => e.toString()).toList(),
    };
  }

  // === GETTERS (Using reactive data) ===

  // Court Allocation Info getters
  String get courtName => courtAllocationData.value?['court_allocation']?['court_name']?.toString() ?? '';
  String get courtAddress => courtAllocationData.value?['court_allocation']?['court_address']?.toString() ?? '';
  String get courtOrderNumber => courtAllocationData.value?['court_allocation']?['court_order_number']?.toString() ?? '';
  String get courtAllotmentDate => courtAllocationData.value?['court_allocation']?['court_allotment_date']?.toString() ?? '';
  String get courtAllotmentDateSelected => courtAllocationData.value?['court_allocation']?['court_allotment_date_selected']?.toString() ?? '';
  String get claimNumberYear => courtAllocationData.value?['court_allocation']?['claim_number_year']?.toString() ?? '';
  String get specialOrderComments => courtAllocationData.value?['court_allocation']?['special_order_comments']?.toString() ?? '';

  // Court Allocation Files
  List<String> get courtOrderFiles => List<String>.from(courtAllocationData.value?['court_allocation']?['court_order_files'] ?? []);

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

  // Court Allocation Fourth Info getters
  String get calculationType => courtAllocationFourthData.value?['court_allocation_fourth']?['calculation_type']?.toString() ?? '';
  String get duration => courtAllocationFourthData.value?['court_allocation_fourth']?['duration']?.toString() ?? '';
  String get holderType => courtAllocationFourthData.value?['court_allocation_fourth']?['holder_type']?.toString() ?? '';
  String get locationCategory => courtAllocationFourthData.value?['court_allocation_fourth']?['location_category']?.toString() ?? '';
  String get calculationFee => courtAllocationFourthData.value?['court_allocation_fourth']?['calculation_fee']?.toString() ?? '';
  String get calculationFeeNumeric => courtAllocationFourthData.value?['court_allocation_fourth']?['calculation_fee_numeric']?.toString() ?? '';

  // Plaintiff/Defendant Information getters
  List<Map<String, dynamic>> get plaintiffDefendantEntries {
    final entries = allocationFifthData.value?['allocation_fifth']?['plaintiffDefendantEntries'] as List<dynamic>?;
    if (entries != null) {
      return entries.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Next of Kin getters
  List<Map<String, dynamic>> get nextOfKinEntries {
    final entries = allocationSixthData.value?['allocation_sixth']?['nextOfKinEntries'] as List<dynamic>?;
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
  Future<void> submitCourtAllocationSurvey() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      await mainController.submitSurvey();

      Get.snackbar(
        'Success',
        'Court Allocation Survey submitted successfully!',
        backgroundColor: Color(0xFF52B788),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Navigate to success page or close
      Get.back();

    } catch (e) {
      print('❌ Submit error: $e');
      errorMessage.value = 'Failed to submit court allocation survey: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Failed to submit court allocation survey. Please try again.',
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
