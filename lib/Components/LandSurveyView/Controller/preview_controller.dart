
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'main_controller.dart';

class SurveyPreviewController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isSubmitting = false.obs;

  // Get reference to main controller
  MainSurveyController get mainController => Get.find<MainSurveyController>();

  // Collected data - make these reactive
  final personalInfoData = Rxn<Map<String, dynamic>>();
  final surveyInfoData = Rxn<Map<String, dynamic>>();
  final calculationData = Rxn<Map<String, dynamic>>();
  final stepFourData = Rxn<Map<String, dynamic>>();
  final applicantData = Rxn<Map<String, dynamic>>();
  final coOwnerData = Rxn<Map<String, dynamic>>();
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

  void loadAllData() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Load all data and update reactive variables
      personalInfoData.value = mainController.getPersonalInfoData();
      surveyInfoData.value = mainController.getSurveyInfoData();
      calculationData.value = mainController.getCalculationData();
      stepFourData.value = mainController.getStepFourData();
      applicantData.value = mainController.getFifthController();
      coOwnerData.value = mainController.getSixthController();
      nextOfKinData.value = mainController.getSeventhController();
      documentsData.value = mainController.getDocumentsData();

      print('📋 Preview data loaded successfully');
    } catch (e) {
      print('❌ Error loading preview data: $e');
      errorMessage.value = 'Failed to load preview data';
    } finally {
      isLoading.value = false;
    }
  }

  // Personal Info getters - use reactive data
  String get applicantName => mainController.personalInfoController.applicantNameController.text.trim();
  String get applicantAddress => mainController.personalInfoController.applicantAddressController.text.trim();
  bool get isLandholder => mainController.personalInfoController.isHolderThemselves.value ?? false;
  bool get isPowerOfAttorney => mainController.personalInfoController.hasAuthorityOnBehalf.value ?? false;
  bool get hasBeenCountedBefore => mainController.personalInfoController.hasBeenCountedBefore.value ?? false;
  String get poaRegistrationNumber => mainController.personalInfoController.poaRegistrationNumberController.text.trim();
  String get poaRegistrationDate => mainController.personalInfoController.poaRegistrationDateController.text.trim();
  String get poaGiverName => mainController.personalInfoController.poaIssuerNameController.text.trim();
  String get poaHolderName => mainController.personalInfoController.poaHolderNameController.text.trim();
  String get poaHolderAddress => mainController.personalInfoController.poaHolderAddressController.text.trim();

  // Survey Info getters - use reactive data
  String get surveyType => surveyInfoData.value?['survey_cts']?['Number']?.toString() ?? '';
  String get department => surveyInfoData.value?['survey_cts']?['department']?.toString() ?? '';
  String get district => surveyInfoData.value?['survey_cts']?['district']?.toString() ?? '';
  String get taluka => surveyInfoData.value?['survey_cts']?['taluka']?.toString() ?? '';
  String get village => surveyInfoData.value?['survey_cts']?['village']?.toString() ?? '';
  String get office => surveyInfoData.value?['survey_cts']?['office']?.toString() ?? '';

  // Calculation Info getters - use reactive data
  String get calculationType => calculationData.value?['calculationType']?.toString() ?? '';
  String get operationType => mainController.calculationController.getOperationType();

  // Step Four getters - use reactive data
  String get selectedCalculationType => stepFourData.value?['calculation_type']?.toString() ?? '';
  String get selectedDuration => stepFourData.value?['duration']?.toString() ?? '';
  String get selectedHolderType => stepFourData.value?['holder_type']?.toString() ?? '';
  String get selectedLocationCategory => stepFourData.value?['location_category']?.toString() ?? '';
  String get calculationFee => stepFourData.value?['calculation_fee']?.toString() ?? '';

  // Applicant getters - use reactive data
  int get applicantCount => applicantData.value?['applicantCount'] ?? 0;

  List<Map<String, dynamic>> get applicantsList {
    List<Map<String, dynamic>> list = [];
    final data = applicantData.value;
    if (data != null) {
      for (int i = 0; i < applicantCount; i++) {
        final applicant = data['applicant_$i'] as Map<String, dynamic>?;
        if (applicant != null) {
          list.add(applicant);
        }
      }
    }
    return list;
  }

  // Co-owner getters - use reactive data
  List<Map<String, dynamic>> get coOwnersList =>
      List<Map<String, dynamic>>.from(coOwnerData.value?['coowners'] ?? []);

  // Next of Kin getters - use reactive data
  List<Map<String, dynamic>> get nextOfKinList =>
      List<Map<String, dynamic>>.from(nextOfKinData.value?['nextOfKinEntries'] ?? []);

  // Document getters - use reactive data
  String get identityCardType => documentsData.value?['identityCardType']?.toString() ?? '';
  List<String> get identityCardFiles => List<String>.from(documentsData.value?['identityCardFiles'] ?? []);
  List<String> get sevenTwelveFiles => List<String>.from(documentsData.value?['sevenTwelveFiles'] ?? []);
  List<String> get noteFiles => List<String>.from(documentsData.value?['noteFiles'] ?? []);
  List<String> get partitionFiles => List<String>.from(documentsData.value?['partitionFiles'] ?? []);
  List<String> get schemeSheetFiles => List<String>.from(documentsData.value?['schemeSheetFiles'] ?? []);
  List<String> get oldCensusMapFiles => List<String>.from(documentsData.value?['oldCensusMapFiles'] ?? []);
  List<String> get demarcationCertificateFiles => List<String>.from(documentsData.value?['demarcationCertificateFiles'] ?? []);

  // POA Files
  List<String> get poaFiles => mainController.personalInfoController.sevenTwelveFiles.map((e) => e.toString()).toList();

  // Get calculation entries based on type - use reactive data
  List<Map<String, dynamic>> get calculationEntries {
    final calcType = calculationType;
    switch (calcType) {
      case 'Hddkayam':
        return mainController.calculationController.hddkayamEntries.map((entry) => {
          'survey_number': entry['ctSurveyNumber']?.toString() ?? '',
          'area': entry['area']?.toString() ?? '',
        }).toList();

      case 'Stomach':
        return mainController.calculationController.stomachEntries.map((entry) => {
          'survey_number': entry['surveyNumber']?.toString() ?? '',
          'total_area': entry['totalArea']?.toString() ?? '',
        }).toList();

      case 'Non-agricultural':
        return mainController.calculationController.nonAgriculturalEntries.map((entry) => {
          'survey_number': entry['surveyNumber']?.toString() ?? '',
          'area': entry['area']?.toString() ?? '',
        }).toList();

      case 'Counting by number of knots':
        return mainController.calculationController.knotsCountingEntries.map((entry) => {
          'survey_number': entry['surveyNumber']?.toString() ?? '',
          'area': entry['area']?.toString() ?? '',
        }).toList();

      case 'Integration calculation':
        return mainController.calculationController.integrationCalculationEntries.map((entry) => {
          'ct_survey_number': entry['ctSurveyNumber']?.toString() ?? '',
          'area': entry['area']?.toString() ?? '',
        }).toList();

      default:
        return [];
    }
  }

  // Get order details for relevant calculation types - use reactive data
  Map<String, String> get orderDetails {
    Map<String, String> details = {};
    final calcType = calculationType;

    if (calcType == 'Non-agricultural' || calcType == 'Counting by number of knots') {
      details['order_number'] = mainController.calculationController.orderNumberController.text.trim();
      details['order_date'] = mainController.calculationController.orderDateController.text.trim();
      details['scheme_order_number'] = mainController.calculationController.schemeOrderNumberController.text.trim();
      details['appointment_date'] = mainController.calculationController.appointmentDateController.text.trim();
    }

    if (calcType == 'Integration calculation') {
      details['merger_order_number'] = mainController.calculationController.mergerOrderNumberController.text.trim();
      details['merger_order_date'] = mainController.calculationController.mergerOrderDateController.text.trim();
      details['old_merger_number'] = mainController.calculationController.oldMergerNumberController.text.trim();
    }

    return details;
  }

  // Submit survey
  Future<void> submitSurvey() async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      await mainController.submitSurvey();

      Get.snackbar(
        'Success',
        'Survey submitted successfully!',
        backgroundColor: Color(0xFF52B788),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Navigate to success page or close
      Get.back();

    } catch (e) {
      print('❌ Submit error: $e');
      errorMessage.value = 'Failed to submit survey: ${e.toString()}';

      Get.snackbar(
        'Error',
        'Failed to submit survey. Please try again.',
        backgroundColor: Color(0xFFDC3545),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isSubmitting.value = false;
    }
  }



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