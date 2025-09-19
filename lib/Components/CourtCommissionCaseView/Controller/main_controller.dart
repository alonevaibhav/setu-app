import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../API Service/api_service.dart';
import '../../../Constants/api_constant.dart';
import '../../CourtCommissionCaseView/Controller/personal_info_controller.dart';
import '../../CourtCommissionCaseView/Controller/step_three_controller.dart';
import '../../CourtCommissionCaseView/Controller/survey_cts.dart';
import 'court_commission_preview_controller.dart';
import 'court_fifth_controller.dart';
import 'court_fourth_controller.dart';
import 'court_seventh_controller.dart';
import 'court_sixth_controller.dart';

// Import all step controllers

class CourtCommissionCaseController extends GetxController {
  // Navigation State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Step Controllers - Initialize them here
  late final PersonalInfoController personalInfoController;
  late final SurveyCTSController surveyCTSController;
  late final CalculationController calculationController; // Add this line
  late final CourtFourthController courtFourthController; // Add this line
  late final CourtFifthController courtFifthController; // Add this line
  late final CourtSixthController courtSixthController; // Add this line
  late final CourtSeventhController courtSeventhController; // Add this line

  // Add more controllers as needed

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: [
      'court_commission_details',
    ], // Personal Info step
    1: [
      'survey_number',
      'department',
      'district',
      'taluka',
      'village',
    ],
    2: ['calculation'], // Survey Information
    3: ['calculation'], // Calculation Information
    4: ['plaintiff_defendant', ], // Applicant Information
    5: ['next_of_kin', ], // Co-owner Information
    6: ['documents', ], // Information about Adjacent Holders
    7: ['documents', 'status'], // Document Upload
    8: ['preview', 'status'], // Preview
    9: ['payment', 'status'], // Payment
  };

  // Validation States
  final isStepValid = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    initializeSurveyData();
    initializeValidationStates();
  }

  void _initializeControllers() {
    personalInfoController = Get.put(PersonalInfoController(), tag: 'personal_info');
    surveyCTSController = Get.put(SurveyCTSController(), tag: 'survey_cts');
    calculationController = Get.put(CalculationController(), tag: 'calculation'); // Add this line
    courtFourthController = Get.put(CourtFourthController(), tag: 'step_four'); // Add this line
    courtFifthController = Get.put(CourtFifthController(), tag: 'court_fifth'); // Add this line
    courtSixthController = Get.put(CourtSixthController(), tag: 'survey_sixth'); // Add this line
    courtSeventhController = Get.put(CourtSeventhController(), tag: 'survey_seventh'); // Add this line
    // Initialize more controllers as needed
  }

  @override
  void onClose() {
    // Controllers will be disposed automatically by GetX
    super.onClose();
  }

  void initializeSurveyData() {
    surveyData.value = {
      'applicationId': '',
      'status': 'draft',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  void initializeValidationStates() {
    // Initialize all 10 steps (0-9)
    for (int i = 0; i <= 9; i++) {
      isStepValid[i] = false;
    }
  }

  // Get total sub-steps for current main step
  int get totalSubStepsInCurrentStep =>
      stepConfigurations[currentStep.value]?.length ?? 1;

  // Get current sub-step field name
  String get currentSubStepField {
    final fields = stepConfigurations[currentStep.value];
    if (fields != null && currentSubStep.value < fields.length) {
      return fields[currentSubStep.value];
    }
    return '';
  }

  // Get the appropriate step controller for current step
  GetxController get currentStepController {
    switch (currentStep.value) {
      case 0:
        return personalInfoController;
      case 1:
        return surveyCTSController;
      case 2: // Add this case for calculation step
        return calculationController;
      case 3: // Add this case for calculation step
        return courtFourthController;
      case 4: // Add this case for calculation step
        return courtFifthController;
      case 5: // Add this case for calculation step
        return courtSixthController;
        case 6: // Add this case for calculation step
        return courtSeventhController;
      case 8: // Add this case for calculation step
        final previewController = Get.put(CourtCommissionPreviewController(), tag: 'court_commission_preview');
        previewController.refreshData(); // Refresh data when navigating to preview
        return previewController;
    // Add more cases as you create more controllers
      default:
        return this; // Fallback to main controller
    }
  }

  // Check if current sub-step is valid
  bool get isCurrentSubStepValid {
    final stepController = currentStepController;
    if (stepController is StepValidationMixin) {
      return stepController.validateCurrentSubStep(currentSubStepField);
    }
    return true; // Default to true if controller doesn't implement validation
  }

  // Check if entire main step is completed
  bool isMainStepCompleted(int step) {
    final fields = stepConfigurations[step];
    if (fields == null) return false;
    GetxController? stepController;
    switch (step) {
      case 0:
        stepController = personalInfoController;
        break;
      case 1:
        stepController = surveyCTSController;
        break;
      case 2: // Add this case
        stepController = calculationController;
        break;
      case 3: // Add this case
        stepController = courtFourthController;
        break;
      case 4: // Add this case
        stepController = courtFifthController;
        break;
      case 5: // Add this case
        stepController = courtSixthController;
        break;
      case 6: // Add this case
        stepController = courtSeventhController;
        break;
      // Add more cases
    }
    if (stepController is StepValidationMixin) {
      return stepController.isStepCompleted(fields);
    }
    return false;
  }

  // Navigation Methods
  void nextSubStep() {
    if (!isCurrentSubStepValid) {
      _showValidationError();
      return;
    }
    _saveCurrentSubStepData();

    // Print the current survey data to the console
    // debugPrintPersonalInfo();
    submitCourtCommissionSurvey();
    // print('Current Survey Data: ${surveyData.value}');

    // Get the current step's total substeps
    final currentStepSubSteps = stepConfigurations[currentStep.value];
    final totalSubSteps = currentStepSubSteps?.length ?? 1;
    if (currentSubStep.value < totalSubSteps - 1) {
      // Move to next substep within current main step
      currentSubStep.value++;
    } else {
      // Move to next main step
      if (currentStep.value < 9) {
        currentStep.value++;
        currentSubStep.value = 0;
        _updateStepValidation();
      }
      if (currentStep.value == 7) {
        final previewController = Get.find<CourtCommissionPreviewController>(tag: 'court_commission_preview');
        previewController.refreshData();
      }

      else {
        // We're at the last step and last substep, submit the survey
        submitCourtCommissionSurvey();
      }
    }
  }

  void previousSubStep() {
    if (currentSubStep.value > 0) {
      currentSubStep.value--;
    } else if (currentStep.value > 0) {
      currentStep.value--;
      // Get the previous step's total substeps
      final previousStepSubSteps = stepConfigurations[currentStep.value];
      final totalSubSteps = previousStepSubSteps?.length ?? 1;
      currentSubStep.value = totalSubSteps - 1;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 9) {
      // Check if previous steps are completed
      bool canNavigate = true;
      for (int i = 0; i < step; i++) {
        if (!isMainStepCompleted(i)) {
          canNavigate = false;
          break;
        }
      }
      if (canNavigate || step <= currentStep.value) {
        currentStep.value = step;
        currentSubStep.value = 0;

        if (currentStep.value == 7) {
          final previewController = Get.find<CourtCommissionPreviewController>(tag: 'court_commission_preview');
          previewController.refreshData();
        }
      }
      else {
        Get.snackbar(
          'Incomplete',
          'Please complete previous steps first',
          backgroundColor: Color(0xFFFFC107),
          colorText: Colors.black,
        );
      }
    }
  }

  void _showValidationError() {
    final stepController = currentStepController;
    String error = 'This field is required';
    if (stepController is StepValidationMixin) {
      error = stepController.getFieldError(currentSubStepField);
    }
    Get.snackbar(
      'Validation Error',
      error,
      backgroundColor: Color(0xFFDC3545),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1200),
    );
  }

  void _saveCurrentSubStepData() {
    final stepController = currentStepController;
    if (stepController is StepDataMixin) {
      final stepData = stepController.getStepData();
      _mergeStepData(stepData);
    }
  }

  void _mergeStepData(Map<String, dynamic> stepData) {
    final currentData = Map<String, dynamic>.from(surveyData.value ?? {});
    currentData.addAll(stepData);
    surveyData.value = currentData;
  }

  void _updateStepValidation() {
    for (int i = 0; i <= 9; i++) {
      isStepValid[i] = isMainStepCompleted(i);
    }
  }

  // Get step indicator color
  Color getStepIndicatorColor(int step) {
    if (isMainStepCompleted(step)) {
      return Color(0xFF52B788); // Green for completed
    } else if (step == currentStep.value) {
      return Color(0xFFFFC107); // Yellow for current
    } else {
      return Colors.white.withOpacity(0.3); // Default
    }
  }

  // Get button text based on current state
  String get nextButtonText {
    if (currentStep.value == 9 &&
        currentSubStep.value == totalSubStepsInCurrentStep - 1) {
      return 'Submit';
    } else if (currentSubStep.value == totalSubStepsInCurrentStep - 1) {
      return 'Next Step';
    } else {
      return 'Save & Next';
    }
  }

  // Update survey data
  void updateSurveyData(String key, dynamic value) {
    final currentData = Map<String, dynamic>.from(surveyData.value ?? {});
    currentData[key] = value;
    surveyData.value = currentData;
  }


  void debugPrintPersonalInfo() {
    developer.log('=== COURT COMMISSION DATA DEBUG ===', name: 'DebugInfo');

    // Court commission details
    developer.log('Court name: "${personalInfoController.courtNameController.text.trim()}"', name: 'CourtCommission');
    developer.log('Court address: "${personalInfoController.courtAddressController.text.trim()}"', name: 'CourtCommission');
    developer.log('Commission order number: "${personalInfoController.commissionOrderNoController.text.trim()}"', name: 'CourtCommission');
    developer.log('Commission date (text): "${personalInfoController.commissionDateController.text.trim()}"', name: 'CourtCommission');
    developer.log('Selected commission date: "${personalInfoController.selectedCommissionDate.value}"', name: 'CourtCommission');
    developer.log('Civil claim: "${personalInfoController.civilClaimController.text.trim()}"', name: 'CourtCommission');
    developer.log('Issuing office: "${personalInfoController.issuingOfficeController.text.trim()}"', name: 'CourtCommission');
    developer.log('Commission order files: "${personalInfoController.commissionOrderFiles}"', name: 'CourtCommission');


    developer.log('=== END COURT COMMISSION DATA DEBUG ===', name: 'DebugInfo');



    developer.log('=== SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('Survey number: "${surveyCTSController.surveyNumberController.text.trim()}"', name: 'SurveyCTS');
    developer.log('Department: "${surveyCTSController.selectedDepartment.value}"', name: 'SurveyCTS');
    developer.log('District: "${surveyCTSController.selectedDistrict.value}"', name: 'SurveyCTS');
    developer.log('Taluka: "${surveyCTSController.selectedTaluka.value}"', name: 'SurveyCTS');
    developer.log('Village: "${surveyCTSController.selectedVillage.value}"', name: 'SurveyCTS');
    developer.log('Office: "${surveyCTSController.selectedOffice.value}"', name: 'SurveyCTS');

    developer.log('=== END SURVEY CTS DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    for (int i = 0; i < calculationController.surveyEntries.length; i++) {
      final entry = calculationController.surveyEntries[i];
      developer.log('--- Survey Entry ${i + 1} ---', name: 'SurveyEntry');
      // developer.log('Entry ID: "${entry['id']}"', name: 'SurveyEntry');
      developer.log('Selected Village: "${entry['selectedVillage']}"', name: 'SurveyEntry');
      developer.log('Survey No: "${entry['surveyNo']}"', name: 'SurveyEntry');
      developer.log('Share: "${entry['share']}"', name: 'SurveyEntry');
      developer.log('Area: "${entry['area']}"', name: 'SurveyEntry');
    }

    developer.log('=== END CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT FOURTH DATA DEBUG ===', name: 'DebugInfo');

    // Selection values
    developer.log('Calculation Type: "${courtFourthController.selectedCalculationType.value}"', name: 'CourtFourth');
    developer.log('Duration: "${courtFourthController.selectedDuration.value}"', name: 'CourtFourth');
    developer.log('Holder Type: "${courtFourthController.selectedHolderType.value}"', name: 'CourtFourth');
    developer.log('Location Category: "${courtFourthController.selectedLocationCategory.value}"', name: 'CourtFourth');
    developer.log('Calculation Fee: "${courtFourthController.calculationFeeController.text.trim()}"', name: 'CourtFourth');

    developer.log('=== END COURT FOURTH DATA DEBUG ===', name: 'DebugInfo');


    developer.log('=== COURT FIFTH DATA DEBUG ===', name: 'DebugInfo');

    for (int i = 0; i < courtFifthController.plaintiffDefendantEntries.length; i++) {
      final entry = courtFifthController.plaintiffDefendantEntries[i];
      final selectedType = entry['selectedType'] as RxString?;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>?;

      developer.log('--- Plaintiff/Defendant Entry ${i + 1} ---', name: 'CourtFifth');
      developer.log('Type: "${selectedType?.value ?? ''}"', name: 'CourtFifth');
      developer.log('Name: "${entry['nameController']?.text ?? ''}"', name: 'CourtFifth');
      developer.log('Address: "${entry['addressController']?.text ?? ''}"', name: 'CourtFifth');
      developer.log('Mobile: "${entry['mobileController']?.text ?? ''}"', name: 'CourtFifth');
      developer.log('Survey Number: "${entry['surveyNumberController']?.text ?? ''}"', name: 'CourtFifth');
    }

    developer.log('=== END COURT FIFTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT SIXTH DATA DEBUG ===', name: 'DebugInfo');

    for (int i = 0; i < courtSixthController.nextOfKinEntries.length; i++) {
      final entry = courtSixthController.nextOfKinEntries[i];

      developer.log('--- Next of Kin Entry ${i + 1} ---', name: 'CourtSixth');
      developer.log('Address: "${entry['address'] ?? ''}"', name: 'CourtSixth');
      developer.log('Mobile: "${entry['mobile'] ?? ''}"', name: 'CourtSixth');
      developer.log('Survey No: "${entry['surveyNo'] ?? ''}"', name: 'CourtSixth');
      developer.log('Direction: "${entry['direction'] ?? ''}"', name: 'CourtSixth');
      developer.log('Natural Resources: "${entry['naturalResources'] ?? ''}"', name: 'CourtSixth');
    }

    developer.log('=== END COURT SIXTH DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT SEVENTH DATA DEBUG ===', name: 'DebugInfo');

    // Identity card info
    developer.log('Selected Identity Type: "${courtSeventhController.selectedIdentityType.value}"', name: 'CourtSeventh');
    developer.log('Identity Card Files: "${courtSeventhController.identityCardFiles}"', name: 'CourtSeventh');

    // Document files
    developer.log('Seven Twelve Files: "${courtSeventhController.sevenTwelveFiles}"', name: 'CourtSeventh');
    developer.log('Note Files: "${courtSeventhController.noteFiles}"', name: 'CourtSeventh');
    developer.log('Partition Files: "${courtSeventhController.partitionFiles}"', name: 'CourtSeventh');
    developer.log('Scheme Sheet Files: "${courtSeventhController.schemeSheetFiles}"', name: 'CourtSeventh');
    developer.log('Old Census Map Files: "${courtSeventhController.oldCensusMapFiles}"', name: 'CourtSeventh');
    developer.log('Demarcation Certificate Files: "${courtSeventhController.demarcationCertificateFiles}"', name: 'CourtSeventh');

    developer.log('=== END COURT SEVENTH DATA DEBUG ===', name: 'DebugInfo');
  }





  Map<String, dynamic> prepareMultipartData(userId) {
    // Debug: Print raw controller data to check what's available
    print('🔍 Survey Entries Length: ${calculationController.surveyEntries.length}');
    print('🔍 Survey Entries: ${calculationController.surveyEntries}');
    print('🔍 Plaintiff/Defendant Entries Length: ${courtFifthController.plaintiffDefendantEntries.length}');
    print('🔍 Plaintiff/Defendant Entries: ${courtFifthController.plaintiffDefendantEntries}');
    print('🔍 Next of Kin Entries Length: ${courtSixthController.nextOfKinEntries.length}');
    print('🔍 Next of Kin Entries: ${courtSixthController.nextOfKinEntries}');

    // Prepare fields (non-file data)
    Map<String, String> fields = {
      // User ID
      "user_id": userId?.toString() ?? "0",

      //User Name
      "declarant_name": "hsf",
      "declarant_address": "hdahf",


      // === COURT COMMISSION INFO ===
      "court_name": personalInfoController.courtNameController.text.trim(),
      "court_address": personalInfoController.courtAddressController.text.trim(),
      "order_number": personalInfoController.commissionOrderNoController.text.trim(),
      "order_date": personalInfoController.commissionDateController.text.trim(),
      "civil_case_ref_number": personalInfoController.civilClaimController.text.trim(),
      "court_office_name": personalInfoController.issuingOfficeController.text.trim(),

      // === SURVEY CTS INFO ===
      // "survey_number": surveyCTSController.selectedSurveyNo.value,
      // "department": surveyCTSController.selectedDepartment.value,
      // "district": surveyCTSController.selectedDistrict.value,
      // "taluka": surveyCTSController.selectedTaluka.value,
      // "village": surveyCTSController.selectedVillage.value,
      // "office": surveyCTSController.selectedOffice.value,


      "survey_number": surveyCTSController.selectedSurveyNo.value,
      "department": surveyCTSController.selectedDepartment.value,
      "division": "1",
      "district": "26",
      "taluka": "5",
      "village": "3",
      "office_name": surveyCTSController.selectedOffice.value,


      // === COURT FOURTH INFO === // there is change in UI as per the conditions we have to manage that in controller
      "type_of_measurement": courtFourthController.selectedCalculationType.value ?? "",
      "duration": courtFourthController.selectedDuration.value ?? "",
      "holder_type": courtFourthController.selectedHolderType.value ?? "",
      "within_municipal": courtFourthController.selectedLocationCategory.value ?? "",
      "measurement_fee": courtFourthController.calculationFeeController.text.trim(),
      "calculation_fee_numeric": courtFourthController.extractNumericFee()?.toString() ?? "0",

      // === IDENTITY TYPE ===
      "identity_card_type": courtSeventhController.selectedIdentityType.value,
    };

    // Convert complex data to JSON strings for multipart
    final surveyAreas = _getCourtSurveyEntries();
    final plaintiffDefendants = _getPlaintiffDefendants();
    final nextOfKin = _getCourtNextOfKin();

    // Debug: Print the arrays before encoding
    print('🔍 Survey Entries: $surveyAreas');
    print('🔍 Plaintiff/Defendants: $plaintiffDefendants');
    print('🔍 Next of Kin: $nextOfKin');

    fields["survey_areas"] = jsonEncode(surveyAreas);
    fields["plaintiff_defendants"] = jsonEncode(plaintiffDefendants);
    fields["next_of_kin"] = jsonEncode(nextOfKin);

    // Prepare files
    List<MultipartFiles> files = [];

    // Add commission order files
    if (personalInfoController.commissionOrderFiles.isNotEmpty) {
        final filePath = personalInfoController.commissionOrderFiles.first.toString();
        if (filePath.isNotEmpty) {
          files.add(MultipartFiles(
            field: "order_document_path",
            filePath: filePath,
          ));

      }
    }

    // Add document files (single entries, not arrays)
    if (courtSeventhController.identityCardFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "identity_proof_path",
        filePath: courtSeventhController.identityCardFiles.first.toString(),
      ));
    }

    if (courtSeventhController.sevenTwelveFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "seven_twelve_extract_path",
        filePath: courtSeventhController.sevenTwelveFiles.first.toString(),
      ));
    }

    if (courtSeventhController.noteFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "tipan_path",
        filePath: courtSeventhController.noteFiles.first.toString(),
      ));
    }

    if (courtSeventhController.partitionFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "fadni_path",
        filePath: courtSeventhController.partitionFiles.first.toString(),
      ));
    }

    if (courtSeventhController.schemeSheetFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "yojana_patrak",
        filePath: courtSeventhController.schemeSheetFiles.first.toString(),
      ));
    }

    if (courtSeventhController.oldCensusMapFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "old_measurement_path",
        filePath: courtSeventhController.oldCensusMapFiles.first.toString(),
      ));
    }

    if (courtSeventhController.demarcationCertificateFiles.isNotEmpty) {
      files.add(MultipartFiles(
        field: "simankan_pramanpatra_path",
        filePath: courtSeventhController.demarcationCertificateFiles.first.toString(),
      ));
    }

    print('🔍 Total Files: ${files.length}');
    for (var file in files) {
      print('🔍 File: ${file.field} -> ${file.filePath}');
    }

    return {
      'fields': fields,
      'files': files,
    };
  }

// Helper method to get survey entries
  List<Map<String, dynamic>> _getCourtSurveyEntries() {
    List<Map<String, dynamic>> entries = [];

    if (calculationController.surveyEntries.isNotEmpty) {
      print('🔍 Processing ${calculationController.surveyEntries.length} survey entries');

      for (int i = 0; i < calculationController.surveyEntries.length; i++) {
        final entry = calculationController.surveyEntries[i];
        entries.add({
          "survey_group_number": entry['surveyNo']?.toString() ?? "",
          "sub_survey_group_number": entry['share']?.toString() ?? "",
          "area": entry['area']?.toString() ?? "",
          "survey_village": entry['selectedVillage']?.toString() ?? "",
        });
      }
    } else {
      print('🔍 No survey entries found in calculationController');
    }

    print('🔍 Generated ${entries.length} survey entries');
    return entries;
  }

// Helper method to get plaintiff/defendants
  List<Map<String, dynamic>> _getPlaintiffDefendants() {
    List<Map<String, dynamic>> plaintiffDefendantsList = [];

    if (courtFifthController.plaintiffDefendantEntries.isNotEmpty) {
      print('🔍 Processing ${courtFifthController.plaintiffDefendantEntries.length} plaintiff/defendant entries');

      for (int i = 0; i < courtFifthController.plaintiffDefendantEntries.length; i++) {
        final entry = courtFifthController.plaintiffDefendantEntries[i];
        final selectedType = entry['selectedType'] as RxString?;
        final detailedAddress = entry['detailedAddress'] as RxMap<String, String>?;

        plaintiffDefendantsList.add({
          "name": entry['nameController']?.text ?? "",
          "address": entry['addressController']?.text ?? "",
          "mobile": entry['mobileController']?.text ?? "",
          "survey_number": entry['surveyNumberController']?.text ?? "",
          "type": selectedType?.value ?? "",
          // Individual detailed address fields
          "plot_no": detailedAddress?['plotNo'] ?? "",
          "detailed_address": detailedAddress?['address'] ?? "",
          "mobile_number": detailedAddress?['mobileNumber'] ?? "",
          "email": detailedAddress?['email'] ?? "",
          "pincode": detailedAddress?['pincode'] ?? "",
          "district": detailedAddress?['district'] ?? "",
          "village": detailedAddress?['village'] ?? "",
          "post_office": detailedAddress?['postOffice'] ?? "",
        });
      }
    } else {
      print('🔍 No plaintiff/defendant entries found in courtFifthController');
    }

    print('🔍 Generated ${plaintiffDefendantsList.length} plaintiff/defendant entries with detailed address fields');
    return plaintiffDefendantsList;
  }

// Helper method to get next of kin
  List<Map<String, dynamic>> _getCourtNextOfKin() {
    List<Map<String, dynamic>> nextOfKinList = [];

    if (courtSixthController.nextOfKinEntries.isNotEmpty) {
      print('🔍 Processing ${courtSixthController.nextOfKinEntries.length} next of kin entries');

      for (int i = 0; i < courtSixthController.nextOfKinEntries.length; i++) {
        final entry = courtSixthController.nextOfKinEntries[i];
        nextOfKinList.add({
          "address": entry['address']?.toString() ?? "",
          "mobile_number": entry['mobile']?.toString() ?? "",
          "survey_no": entry['surveyNo']?.toString() ?? "",
          "direction": entry['direction']?.toString() ?? "",
          "natural_resources": entry['naturalResources']?.toString() ?? "",
        });
      }
    } else {
      print('🔍 No next of kin entries found in courtSixthController');
    }

    print('🔍 Generated ${nextOfKinList.length} next of kin entries');
    return nextOfKinList;
  }

  Future<void> submitCourtCommissionSurvey() async {
    try {
      String userId = (await ApiService.getUid()) ?? "0";
      print('🆔 User ID: $userId');

      final multipartData = prepareMultipartData(userId);
      final fields = multipartData['fields'] as Map<String, String>;
      final files = multipartData['files'] as List<MultipartFiles>;

      developer.log(jsonEncode(fields), name: 'COURT_REQUEST_BODY');

      final response = await ApiService.multipartPost<Map<String, dynamic>>(
        endpoint: courtCommissionCase, // Your API endpoint
        fields: fields,
        files: files,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {

        print('✅ Court commission survey submitted successfully: ${response.data}');
      } else {
        print('❌ Court commission survey submission failed: ${response.errorMessage ?? 'Unknown error'}');
      }
    } catch (e) {
      print('💥 Exception during court commission survey submission: $e');
    }
  }

  void _saveAllStepsData() {
    // Collect data from all step controllers
    final allControllers = [
      personalInfoController,
      surveyCTSController,
      calculationController,
      courtFourthController,
      courtFifthController,
      courtSixthController,
      courtSeventhController,
      // Add more controllers
    ];
    for (final controller in allControllers) {
      if (controller is StepDataMixin) {
        final stepData = controller.getStepData();
        _mergeStepData(stepData);
      }
    }
  }
}

// Mixins for step controllers to implement
mixin StepValidationMixin on GetxController {
  bool validateCurrentSubStep(String field);
  bool isStepCompleted(List<String> fields);
  String getFieldError(String field);
}

mixin StepDataMixin on GetxController {
  Map<String, dynamic> getStepData();
}
