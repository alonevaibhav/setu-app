// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'main_controller.dart';
//
// class GovernmentCensusPreviewController extends GetxController {
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//   final isSubmitting = false.obs;
//
//   // Get reference to main controller
//   GovernmentCensusController get mainController => Get.find<GovernmentCensusController>();
//
//   // Collected data - make these reactive (as per your structure)
//   final governmentCountingData = Rxn<Map<String, dynamic>>();
//   final surveyCTSData = Rxn<Map<String, dynamic>>();
//   final governmentSurveyData = Rxn<Map<String, dynamic>>();
//   final censusFourthData = Rxn<Map<String, dynamic>>();
//   final censusFifthData = Rxn<Map<String, dynamic>>();
//   final censusSixthData = Rxn<Map<String, dynamic>>();
//   final censusSeventhData = Rxn<Map<String, dynamic>>();
//   final documentsData = Rxn<Map<String, dynamic>>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadAllData();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     refreshData();
//   }
//
//   void refreshData() {
//     loadAllData();
//   }
//
//   // === CRITICAL: LOAD ALL DATA METHOD ===
//   void loadAllData() {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       print('📋 Loading all government census data for preview...');
//
//       // Load data using main controller's methods
//       governmentCountingData.value = mainController.getGovernmentCountingData();
//       surveyCTSData.value = mainController.getSurveyCTSData();
//       governmentSurveyData.value = mainController.getGovernmentSurveyData();
//       censusFourthData.value = mainController.getCensusFourthData();
//       censusFifthData.value = mainController.getCensusFifthData();
//       censusSixthData.value = mainController.getCensusSixthData();
//       censusSeventhData.value = mainController.getCensusSeventhData();
//       documentsData.value = mainController.getCourtEightData();
//
//       print('📋 Government Census preview data loaded successfully');
//       print('📋 Government survey entries count: ${governmentSurveyEntries.length}');
//       print('📋 Applicant entries count: ${applicantEntries.length}');
//       print('📋 Coowner entries count: ${coownerEntries.length}');
//       print('📋 Next of kin entries count: ${nextOfKinEntries.length}');
//
//     } catch (e) {
//       print('❌ Error loading preview data: $e');
//       errorMessage.value = 'Failed to load preview data';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // === GETTERS (Using reactive data from main controller methods) ===
//
//   // Government Counting Info getters
//   String get governmentCountingOfficer => governmentCountingData.value?['government_counting']?['government_counting_officer']?.toString() ?? '';
//   String get governmentCountingOfficerAddress => governmentCountingData.value?['government_counting']?['government_counting_officer_address']?.toString() ?? '';
//   String get governmentCountingOrderNumber => governmentCountingData.value?['government_counting']?['government_counting_order_number']?.toString() ?? '';
//   String get governmentCountingOrderDate => governmentCountingData.value?['government_counting']?['government_counting_order_date']?.toString() ?? '';
//   String get selectedGovernmentCountingOrderDate => governmentCountingData.value?['government_counting']?['selected_government_counting_order_date']?.toString() ?? '';
//   String get countingApplicantName => governmentCountingData.value?['government_counting']?['counting_applicant_name']?.toString() ?? '';
//   String get countingApplicantAddress => governmentCountingData.value?['government_counting']?['counting_applicant_address']?.toString() ?? '';
//   String get governmentCountingDetails => governmentCountingData.value?['government_counting']?['government_counting_details']?.toString() ?? '';
//
//   List<String> get governmentCountingOrderFiles => List<String>.from(governmentCountingData.value?['government_counting']?['government_counting_order_files'] ?? []);
//
//   // Survey CTS Info getters
//   String get surveyNumber => surveyCTSData.value?['survey_cts']?['survey_number']?.toString() ?? '';
//   String get department => surveyCTSData.value?['survey_cts']?['department']?.toString() ?? '';
//   String get district => surveyCTSData.value?['survey_cts']?['district']?.toString() ?? '';
//   String get taluka => surveyCTSData.value?['survey_cts']?['taluka']?.toString() ?? '';
//   String get village => surveyCTSData.value?['survey_cts']?['village']?.toString() ?? '';
//   String get office => surveyCTSData.value?['survey_cts']?['office']?.toString() ?? '';
//
//   // Government Survey Info getters
//   List<Map<String, dynamic>> get governmentSurveyEntries {
//     // Access survey entries directly from main controller
//     List<Map<String, dynamic>> entries = [];
//     for (int i = 0; i < mainController.calculationController.surveyEntries.length; i++) {
//       final entry = mainController.calculationController.surveyEntries[i];
//       entries.add({
//         'surveyNo': entry['surveyNo']?.toString() ?? '',
//         'partNo': entry['partNo']?.toString() ?? '',
//         'area': entry['area']?.toString() ?? '',
//       });
//     }
//     return entries;
//   }
//
//   String get totalArea => governmentSurveyData.value?['government_survey']?['total_area']?.toString() ?? '';
//   String get entryCount => governmentSurveyData.value?['government_survey']?['entry_count']?.toString() ?? '';
//
//   // Census Fourth Info getters
//   String get calculationType => censusFourthData.value?['census_fourth']?['calculationType']?.toString() ?? '';
//   String get duration => censusFourthData.value?['census_fourth']?['duration']?.toString() ?? '';
//   String get holderType => censusFourthData.value?['census_fourth']?['holderType']?.toString() ?? '';
//   String get calculationFeeRate => censusFourthData.value?['census_fourth']?['calculationFeeRate']?.toString() ?? '';
//   String get countingFee => censusFourthData.value?['census_fourth']?['countingFee']?.toString() ?? '';
//
//   // Applicant Information getters
//   List<Map<String, dynamic>> get applicantEntries {
//     List<Map<String, dynamic>> entries = [];
//     final censusFifth = censusFifthData.value?['census_fifth'] as Map<String, dynamic>?;
//     if (censusFifth != null) {
//       final applicantCount = censusFifth['applicantCount'] as int? ?? 0;
//       for (int i = 0; i < applicantCount; i++) {
//         final applicant = censusFifth['applicant_$i'] as Map<String, dynamic>?;
//         if (applicant != null) {
//           final address = applicant['address'] as Map<String, dynamic>? ?? {};
//           entries.add({
//             'agreement': applicant['agreement']?.toString() ?? '',
//             'accountHolderName': applicant['accountHolderName']?.toString() ?? '',
//             'accountNumber': applicant['accountNumber']?.toString() ?? '',
//             'mobileNumber': applicant['mobileNumber']?.toString() ?? '',
//             'serverNumber': applicant['serverNumber']?.toString() ?? '',
//             'area': applicant['area']?.toString() ?? '',
//             'potkaharabaArea': applicant['potkaharabaArea']?.toString() ?? '',
//             'totalArea': applicant['totalArea']?.toString() ?? '',
//             'plotNo': address['plotNo']?.toString() ?? '',
//             'address': address['address']?.toString() ?? '',
//             'addressMobileNumber': address['mobileNumber']?.toString() ?? '',
//             'email': address['email']?.toString() ?? '',
//             'pincode': address['pincode']?.toString() ?? '',
//             'district': address['district']?.toString() ?? '',
//             'village': address['village']?.toString() ?? '',
//             'postOffice': address['postOffice']?.toString() ?? '',
//           });
//         }
//       }
//     }
//     return entries;
//   }
//
//   // Coowner Information getters
//   List<Map<String, dynamic>> get coownerEntries {
//     final entries = censusSixthData.value?['census_sixth']?['coowners'] as List<dynamic>?;
//     if (entries != null) {
//       return entries.cast<Map<String, dynamic>>();
//     }
//     return [];
//   }
//
//   // Next of Kin getters
//   List<Map<String, dynamic>> get nextOfKinEntries {
//     final entries = censusSeventhData.value?['census_seventh']?['nextOfKinEntries'] as List<dynamic>?;
//     if (entries != null) {
//       return entries.cast<Map<String, dynamic>>();
//     }
//     return [];
//   }
//
//   // Document getters
//   String get identityCardType => documentsData.value?['court_seventh']?['selected_identity_type']?.toString() ?? '';
//   List<String> get identityCardFiles => List<String>.from(documentsData.value?['court_seventh']?['identity_card_files'] ?? []);
//   List<String> get sevenTwelveFiles => List<String>.from(documentsData.value?['court_seventh']?['seven_twelve_files'] ?? []);
//   List<String> get noteFiles => List<String>.from(documentsData.value?['court_seventh']?['note_files'] ?? []);
//   List<String> get partitionFiles => List<String>.from(documentsData.value?['court_seventh']?['partition_files'] ?? []);
//   List<String> get schemeSheetFiles => List<String>.from(documentsData.value?['court_seventh']?['scheme_sheet_files'] ?? []);
//   List<String> get oldCensusMapFiles => List<String>.from(documentsData.value?['court_seventh']?['old_census_map_files'] ?? []);
//   List<String> get demarcationCertificateFiles => List<String>.from(documentsData.value?['court_seventh']?['demarcation_certificate_files'] ?? []);
//
//   // === SUBMIT METHOD ===
//   Future<void> submitGovernmentCensusSurvey() async {
//     if (isSubmitting.value) return;
//
//     try {
//       isSubmitting.value = true;
//       errorMessage.value = '';
//
//       await mainController.submitSurvey();
//
//       Get.snackbar(
//         'Success',
//         'Government Census Survey submitted successfully!',
//         backgroundColor: Color(0xFF52B788),
//         colorText: Colors.white,
//         duration: Duration(seconds: 3),
//       );
//
//       Get.back();
//
//     } catch (e) {
//       print('❌ Submit error: $e');
//       errorMessage.value = 'Failed to submit government census survey: ${e.toString()}';
//
//       Get.snackbar(
//         'Error',
//         'Failed to submit government census survey. Please try again.',
//         backgroundColor: Color(0xFFDC3545),
//         colorText: Colors.white,
//         duration: Duration(seconds: 3),
//       );
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   // === UTILITY METHODS ===
//   String formatFieldName(String fieldName) {
//     return fieldName
//         .split('_')
//         .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
//         .join(' ');
//   }
//
//   String getFileName(String filePath) {
//     return filePath.split('/').last.split('\\').last;
//   }
//
//   bool isImageFile(String fileName) {
//     final extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
//     final lowerName = fileName.toLowerCase();
//     return extensions.any((ext) => lowerName.endsWith(ext));
//   }
//
//   bool isPdfFile(String fileName) {
//     return fileName.toLowerCase().endsWith('.pdf');
//   }
//
//   bool isWordFile(String fileName) {
//     final extensions = ['.doc', '.docx'];
//     final lowerName = fileName.toLowerCase();
//     return extensions.any((ext) => lowerName.endsWith(ext));
//   }
//
//   bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;
//   String formatBoolean(bool value) => value ? 'Yes' : 'No';
// }


import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class GovernmentCensusPreviewController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isSubmitting = false.obs;

  // Get reference to main controller
  GovernmentCensusController get mainController => Get.find<GovernmentCensusController>();

  // Collected data - make these reactive (as per your structure)
  final governmentCountingData = Rxn<Map<String, dynamic>>();
  final surveyCTSData = Rxn<Map<String, dynamic>>();
  final governmentSurveyData = Rxn<Map<String, dynamic>>();
  final censusFourthData = Rxn<Map<String, dynamic>>();
  final censusFifthData = Rxn<Map<String, dynamic>>();
  final censusSixthData = Rxn<Map<String, dynamic>>();
  final censusSeventhData = Rxn<Map<String, dynamic>>();
  final documentsData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  @override
  void onReady() {
    super.onReady();
    refreshData();
  }

  void refreshData() {
    loadAllData();
  }

  // === CRITICAL: LOAD ALL DATA METHOD ===
  void loadAllData() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📋 Loading all government census data for preview...');

      // Load data using main controller's methods
      governmentCountingData.value = mainController.getGovernmentCountingData();
      surveyCTSData.value = mainController.getSurveyCTSData();
      governmentSurveyData.value = mainController.getGovernmentSurveyData();
      censusFourthData.value = mainController.getCensusFourthData();
      censusFifthData.value = mainController.getCensusFifthData();
      censusSixthData.value = mainController.getCensusSixthData();
      censusSeventhData.value = mainController.getCensusSeventhData();
      documentsData.value = mainController.getCourtEightData();

      print('📋 Government Census preview data loaded successfully');
      print('📋 Government survey entries count: ${governmentSurveyEntries.length}');
      print('📋 Applicant entries count: ${applicantEntries.length}');
      print('📋 Coowner entries count: ${coownerEntries.length}');
      print('📋 Next of kin entries count: ${nextOfKinEntries.length}');

    } catch (e) {
      print('❌ Error loading preview data: $e');
      errorMessage.value = 'Failed to load preview data';
    } finally {
      isLoading.value = false;
    }
  }

  // === GETTERS (FIXED - Direct Controller Access) ===

  // Government Counting Info getters - DIRECT CONTROLLER ACCESS
  String get governmentCountingOfficer => mainController.personalInfoController.governmentCountingOfficerController.text.trim();
  String get governmentCountingOfficerAddress => mainController.personalInfoController.governmentCountingOfficerAddressController.text.trim();
  String get governmentCountingOrderNumber => mainController.personalInfoController.governmentCountingOrderNumberController.text.trim();
  String get governmentCountingOrderDate => mainController.personalInfoController.governmentCountingOrderDateController.text.trim();
  String get selectedGovernmentCountingOrderDate => mainController.personalInfoController.governmentCountingOrderDate.value?.toIso8601String() ?? '';
  String get countingApplicantName => mainController.personalInfoController.countingApplicantNameController.text.trim();
  String get countingApplicantAddress => mainController.personalInfoController.countingApplicantAddressController.text.trim();
  String get governmentCountingDetails => mainController.personalInfoController.governmentCountingDetailsController.text.trim();

  List<String> get governmentCountingOrderFiles => mainController.personalInfoController.governmentCountingOrderFiles.map((e) => e.toString()).toList();

  // Survey CTS Info getters - DIRECT CONTROLLER ACCESS
  String get surveyNumber => mainController.surveyCTSController.surveyNumberController.text.trim();
  String get department => mainController.surveyCTSController.selectedDepartment.value;
  String get district => mainController.surveyCTSController.selectedDistrict.value;
  String get taluka => mainController.surveyCTSController.selectedTaluka.value;
  String get village => mainController.surveyCTSController.selectedVillage.value;
  String get office => mainController.surveyCTSController.selectedOffice.value;

  // Government Survey Info getters - DIRECT CONTROLLER ACCESS
  List<Map<String, dynamic>> get governmentSurveyEntries {
    List<Map<String, dynamic>> entries = [];
    for (int i = 0; i < mainController.calculationController.surveyEntries.length; i++) {
      final entry = mainController.calculationController.surveyEntries[i];
      entries.add({
        'surveyNo': entry['surveyNo']?.toString() ?? '',
        'partNo': entry['partNo']?.toString() ?? '',
        'area': entry['area']?.toString() ?? '',
      });
    }
    return entries;
  }

  double get totalArea => mainController.calculationController.totalArea;
  String get entryCount => mainController.calculationController.surveyEntries.length.toString();

  // Census Fourth Info getters - DIRECT CONTROLLER ACCESS
  String? get calculationType => mainController.censusFourthController.selectedCalculationType.value;
  String? get duration => mainController.censusFourthController.selectedDuration.value;
  String? get holderType => mainController.censusFourthController.selectedHolderType.value;
  String? get calculationFeeRate => mainController.censusFourthController.selectedCalculationFeeRate.value;
  String get countingFee => mainController.censusFourthController.countingFee.value?.toString() ?? '';

  // Applicant Information getters - DIRECT CONTROLLER ACCESS
  List<Map<String, dynamic>> get applicantEntries {
    List<Map<String, dynamic>> entries = [];

    for (int i = 0; i < mainController.censusFifthController.applicantEntries.length; i++) {
      final entry = mainController.censusFifthController.applicantEntries[i];
      final addressData = entry['address'] as RxMap<String, dynamic>?;

      entries.add({
        'agreement': (entry['agreementController'] as TextEditingController?)?.text ?? '',
        'accountHolderName': (entry['accountHolderNameController'] as TextEditingController?)?.text ?? '',
        'accountNumber': (entry['accountNumberController'] as TextEditingController?)?.text ?? '',
        'mobileNumber': (entry['mobileNumberController'] as TextEditingController?)?.text ?? '',
        'serverNumber': (entry['serverNumberController'] as TextEditingController?)?.text ?? '',
        'area': (entry['areaController'] as TextEditingController?)?.text ?? '',
        'potkaharabaArea': (entry['potkaharabaAreaController'] as TextEditingController?)?.text ?? '',
        'totalArea': (entry['totalAreaController'] as TextEditingController?)?.text ?? '',
        'plotNo': addressData?['plotNo']?.toString() ?? '',
        'address': addressData?['address']?.toString() ?? '',
        'addressMobileNumber': addressData?['mobileNumber']?.toString() ?? '',
        'email': addressData?['email']?.toString() ?? '',
        'pincode': addressData?['pincode']?.toString() ?? '',
        'district': addressData?['district']?.toString() ?? '',
        'village': addressData?['village']?.toString() ?? '',
        'postOffice': addressData?['postOffice']?.toString() ?? '',
      });
    }
    return entries;
  }

  // Coowner Information getters - DIRECT CONTROLLER ACCESS
  List<Map<String, dynamic>> get coownerEntries {
    List<Map<String, dynamic>> entries = [];

    for (int i = 0; i < mainController.censusSixthController.coownerEntries.length; i++) {
      final entry = mainController.censusSixthController.coownerEntries[i];
      final addressEntry = entry['address'];
      final address = addressEntry != null ? addressEntry as Map<String, String> : <String, String>{};

      entries.add({
        'name': (entry['nameController'] as TextEditingController?)?.text ?? '',
        'mobileNumber': (entry['mobileNumberController'] as TextEditingController?)?.text ?? '',
        'serverNumber': (entry['serverNumberController'] as TextEditingController?)?.text ?? '',
        'consent': (entry['consentController'] as TextEditingController?)?.text ?? '',
        'address': address,
      });
    }
    return entries;
  }

  // Next of Kin getters - DIRECT CONTROLLER ACCESS
  List<Map<String, dynamic>> get nextOfKinEntries {
    List<Map<String, dynamic>> entries = [];

    for (final entry in mainController.censusSeventhController.nextOfKinEntries) {
      entries.add({
        'name': (entry['nameController'] as TextEditingController?)?.text ?? '',
        'address': (entry['addressController'] as TextEditingController?)?.text ?? '',
        'mobile': (entry['mobileController'] as TextEditingController?)?.text ?? '',
        'surveyNo': (entry['surveyNoController'] as TextEditingController?)?.text ?? '',
        'direction': entry['direction']?.toString() ?? '',
        'naturalResources': entry['naturalResources']?.toString() ?? '',
      });
    }
    return entries;
  }

  // Document getters - DIRECT CONTROLLER ACCESS
  String get identityCardType => mainController.censusEighthController.selectedIdentityType.value;
  List<String> get identityCardFiles => mainController.censusEighthController.identityCardFiles.map((e) => e.toString()).toList();
  List<String> get sevenTwelveFiles => mainController.censusEighthController.sevenTwelveFiles.map((e) => e.toString()).toList();
  List<String> get noteFiles => mainController.censusEighthController.noteFiles.map((e) => e.toString()).toList();
  List<String> get partitionFiles => mainController.censusEighthController.partitionFiles.map((e) => e.toString()).toList();
  List<String> get schemeSheetFiles => mainController.censusEighthController.schemeSheetFiles.map((e) => e.toString()).toList();
  List<String> get oldCensusMapFiles => mainController.censusEighthController.oldCensusMapFiles.map((e) => e.toString()).toList();
  List<String> get demarcationCertificateFiles => mainController.censusEighthController.demarcationCertificateFiles.map((e) => e.toString()).toList();

  // === SUBMIT METHOD ===
  Future<void> submitGovernmentCensusSurvey() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      await mainController.submitSurvey();

      Get.snackbar(
        'Success',
        'Government Census Survey submitted successfully!',
        backgroundColor: Color(0xFF52B788),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      Get.back();

    } catch (e) {
      print('❌ Submit error: $e');
      errorMessage.value = 'Failed to submit government census survey: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Failed to submit government census survey. Please try again.',
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

  bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;
  String formatBoolean(bool value) => value ? 'Yes' : 'No';
}
