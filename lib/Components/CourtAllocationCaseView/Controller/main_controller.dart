import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../API Service/api_service.dart';
import '../../../Constants/api_constant.dart';
import '../../CourtAllocationCaseView/Controller/personal_info_controller.dart';
import '../../CourtAllocationCaseView/Controller/step_three_controller.dart';
import '../../CourtAllocationCaseView/Controller/survey_cts.dart';
import 'allocation_fifth_controller.dart';
import 'allocation_seventh_controller.dart';
import 'allocation_sixth_controller.dart';
import 'court_all_controller.dart';
import 'court_fouth_controller.dart';
import 'dart:developer' as developer;


class CourtAllocationCaseController extends GetxController {
  // Navigation State
  final currentStep = 0.obs;
  final currentSubStep = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Step Controllers - Initialize them here
  late final PersonalInfoController personalInfoController;
  late final SurveyCTSController surveyCTSController;
  late final CalculationController calculationController; // Add this line
  late final CourtAlloFouthController courtAlloFouthController; // Add this line
  late final AllocationFifthController allocationFifthController; // Add this line
  late final AllocationSixthController allocationSixthController; // Add this line
  late final AllocationSeventhController allocationSeventhController; // Add this line

  // Add more controllers as needed

  // Survey Data Storage
  final surveyData = Rxn<Map<String, dynamic>>();

  // Sub-step configurations for each main step (0-9)
  final Map<int, List<String>> stepConfigurations = {
    0: ['calculation', ], // Personal Info step
    1: [
      'survey_number',
      'department',
      'district',
      'taluka',
      'village',
    ],
    2: ['calculation'], // Survey Information
    3: ['calculation'], // Calculation Information
    4: ['plaintiff_defendant'], // Applicant Information
    5: ['next_of_kin'], // Co-owner Information
    6: ['documents'], // Information about Adjacent Holders
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
    courtAlloFouthController = Get.put(CourtAlloFouthController(), tag: 'court_fourth'); // Add this line
    allocationFifthController = Get.put(AllocationFifthController(), tag: 'court_fifth'); // Add this line
    allocationSixthController = Get.put(AllocationSixthController(), tag: 'court_sixth'); // Add this line
    allocationSeventhController = Get.put(AllocationSeventhController(), tag: 'court_seven'); // Add this line
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
        return courtAlloFouthController;
        case 4: // Add this case for calculation step
        return allocationFifthController;
        case 5: // Add this case for calculation step
        return allocationSixthController;
        case 6: // Add this case for calculation step
        return allocationSeventhController;
      case 7: // Add this case for calculation step
        final previewController = Get.put(CourtAllocationPreviewController(), tag: 'court_allocation_preview');
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
        stepController = courtAlloFouthController;
        break;
        case 4: // Add this case
        stepController = allocationFifthController;
        break;
        case 5: // Add this case
        stepController = allocationSixthController;
        break;
        case 6: // Add this case
        stepController = allocationSeventhController;
        break;
        case 7: // Add this case
        stepController = courtAlloFouthController;
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
    // print('Current Survey Data: ${surveyData.value}');
    // debugPrintInfo();
    submitSurvey();

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
        final previewController = Get.find<CourtAllocationPreviewController>(tag: 'court_allocation_preview');
        previewController.refreshData();
      }else {
        // We're at the last step and last substep, submit the survey
        submitSurvey();
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
        if (step == 7) {
          final previewController = Get.find<CourtAllocationPreviewController>(tag: 'court_allocation_preview');
          previewController.refreshData();
        }
      } else {
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



  void debugPrintInfo() {
    developer.log('=== COURT ORDER DATA DEBUG ===', name: 'DebugInfo');

    // Court order details
    developer.log('Court name: "${personalInfoController.courtNameController.text.trim()}"', name: 'CourtOrder');
    developer.log('Court address: "${personalInfoController.courtAddressController.text.trim()}"', name: 'CourtOrder');
    developer.log('Court order number: "${personalInfoController.courtOrderNumberController.text.trim()}"', name: 'CourtOrder');
    developer.log('Court allotment date (text): "${personalInfoController.courtAllotmentDateController.text.trim()}"', name: 'CourtOrder');
    developer.log('Selected court allotment date: "${personalInfoController.courtAllotmentDate.value}"', name: 'CourtOrder');
    developer.log('Claim number year: "${personalInfoController.claimNumberYearController.text.trim()}"', name: 'CourtOrder');
    developer.log('Special order comments: "${personalInfoController.specialOrderCommentsController.text.trim()}"', name: 'CourtOrder');
    developer.log('Court order files: "${personalInfoController.courtOrderFiles}"', name: 'CourtOrder');

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
      developer.log('Selected Village: "${entry['selectedVillage']}"', name: 'SurveyEntry');
      developer.log('Survey No: "${entry['surveyNo']}"', name: 'SurveyEntry');
      developer.log('Share: "${entry['share']}"', name: 'SurveyEntry');
      developer.log('Area: "${entry['area']}"', name: 'SurveyEntry');
    }

    developer.log('=== END CALCULATION DATA DEBUG ===', name: 'DebugInfo');

    developer.log('=== COURT ALLOCATION FOURTH DATA DEBUG ===', name: 'DebugInfo');

    // Court allocation fourth details
    developer.log('Calculation type: "${courtAlloFouthController.selectedCalculationType.value}"', name: 'CourtAlloFourth');
    developer.log('Duration: "${courtAlloFouthController.selectedDuration.value}"', name: 'CourtAlloFourth');
    developer.log('Holder type: "${courtAlloFouthController.selectedHolderType.value}"', name: 'CourtAlloFourth');
    developer.log('Location category: "${courtAlloFouthController.selectedLocationCategory.value}"', name: 'CourtAlloFourth');
    developer.log('Calculation fee: "${courtAlloFouthController.calculationFeeController.text.trim()}"', name: 'CourtAlloFourth');
    developer.log('Calculation fee numeric: "${courtAlloFouthController.extractNumericFee()}"', name: 'CourtAlloFourth');

    developer.log('=== PLAINTIFF DEFENDANT DATA DEBUG ===', name: 'DebugInfo');

    // Plaintiff defendant entries
    developer.log('Total entries count: "${allocationFifthController.plaintiffDefendantEntries.length}"', name: 'PlaintiffDefendant');

    for (int i = 0; i < allocationFifthController.plaintiffDefendantEntries.length; i++) {
      final entry = allocationFifthController.plaintiffDefendantEntries[i];
      final selectedType = entry['selectedType'] as RxString?;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>;

      developer.log('--- Entry ${i + 1} ---', name: 'PlaintiffDefendant');
      developer.log('Name: "${entry['nameController']?.text ?? ''}"', name: 'PlaintiffDefendant');
      developer.log('Address: "${entry['addressController']?.text ?? ''}"', name: 'PlaintiffDefendant');
      developer.log('Mobile: "${entry['mobileController']?.text ?? ''}"', name: 'PlaintiffDefendant');
      developer.log('Survey Number: "${entry['surveyNumberController']?.text ?? ''}"', name: 'PlaintiffDefendant');
      developer.log('Type: "${selectedType?.value ?? ''}"', name: 'PlaintiffDefendant');
      developer.log('Detailed Address: "${Map<String, String>.from(detailedAddress)}"', name: 'PlaintiffDefendant');
    }

    developer.log('=== NEXT OF KIN DATA DEBUG ===', name: 'DebugInfo');

    // Next of kin entries
    developer.log('Total entries count: "${allocationSixthController.nextOfKinEntries.length}"', name: 'NextOfKin');

    for (int i = 0; i < allocationSixthController.nextOfKinEntries.length; i++) {
      final entry = allocationSixthController.nextOfKinEntries[i];

      developer.log('--- Entry ${i + 1} ---', name: 'NextOfKin');
      developer.log('Address: "${entry['addressController']?.text ?? ''}"', name: 'NextOfKin');
      developer.log('Mobile: "${entry['mobileController']?.text ?? ''}"', name: 'NextOfKin');
      developer.log('Survey No: "${entry['surveyNoController']?.text ?? ''}"', name: 'NextOfKin');
      developer.log('Direction: "${entry['direction'] ?? ''}"', name: 'NextOfKin');
      developer.log('Natural Resources: "${entry['naturalResources'] ?? ''}"', name: 'NextOfKin');
    }

    developer.log('=== COURT SEVENTH DATA DEBUG ===', name: 'DebugInfo');

    // Identity card info
    developer.log('Selected Identity Type: "${allocationSeventhController.selectedIdentityType.value}"', name: 'CourtSeventh');
    developer.log('Identity Card Files: "${allocationSeventhController.identityCardFiles}"', name: 'CourtSeventh');

    // Document files
    developer.log('Seven Twelve Files: "${allocationSeventhController.sevenTwelveFiles}"', name: 'CourtSeventh');
    developer.log('Note Files: "${allocationSeventhController.noteFiles}"', name: 'CourtSeventh');
    developer.log('Partition Files: "${allocationSeventhController.partitionFiles}"', name: 'CourtSeventh');
    developer.log('Scheme Sheet Files: "${allocationSeventhController.schemeSheetFiles}"', name: 'CourtSeventh');
    developer.log('Old Census Map Files: "${allocationSeventhController.oldCensusMapFiles}"', name: 'CourtSeventh');
    developer.log('Demarcation Certificate Files: "${allocationSeventhController.demarcationCertificateFiles}"', name: 'CourtSeventh');

    developer.log('=== END COURT SEVENTH DATA DEBUG ===', name: 'DebugInfo');


  }



  Map<String, dynamic> prepareMultipartData(userId) {
    // Debug: Print data to check what's being collected
    print('🔍 Preparing court allocation multipart data');

    // Prepare fields (non-file data)
    Map<String, String> fields = {
      // User ID
      "user_id": userId?.toString() ?? "0",

      // === COURT ORDER INFO ===
      "court_name": personalInfoController.courtNameController.text.trim(),
      "court_address": personalInfoController.courtAddressController.text.trim(),
      "court_order_number": personalInfoController.courtOrderNumberController.text.trim(),
      "court_allotment_date": personalInfoController.courtAllotmentDateController.text.trim(),
      "court_allotment_date_selected": personalInfoController.courtAllotmentDate.value?.toString() ?? "",
      "claim_number_year": personalInfoController.claimNumberYearController.text.trim(),
      "special_order_comments": personalInfoController.specialOrderCommentsController.text.trim(),

      // === SURVEY CTS INFO ===
      "survey_number": surveyCTSController.surveyNumberController.text.trim(),
      "department": surveyCTSController.selectedDepartment.value ?? "",
      "district": surveyCTSController.selectedDistrict.value ?? "",
      "taluka": surveyCTSController.selectedTaluka.value ?? "",
      "village": surveyCTSController.selectedVillage.value ?? "",
      "office": surveyCTSController.selectedOffice.value ?? "",

      // === COURT ALLOCATION FOURTH INFO ===
      "selected_calculation_type": courtAlloFouthController.selectedCalculationType.value ?? "",
      "selected_duration": courtAlloFouthController.selectedDuration.value ?? "",
      "selected_holder_type": courtAlloFouthController.selectedHolderType.value ?? "",
      "selected_location_category": courtAlloFouthController.selectedLocationCategory.value ?? "",
      "calculation_fee": courtAlloFouthController.calculationFeeController.text.trim(),
      "calculation_fee_numeric": courtAlloFouthController.extractNumericFee()?.toString() ?? "0",

      // === DOCUMENT INFO ===
      "identity_card_type": allocationSeventhController.selectedIdentityType.value ?? "",
    };

    // Convert complex data to JSON strings for multipart
    final surveyEntries = _getSurveyEntries();
    final plaintiffDefendantEntries = _getPlaintiffDefendantEntries();
    final nextOfKinEntries = _getNextOfKinEntries();

    // Debug: Print the arrays before encoding
    print('🔍 Survey Entries: $surveyEntries');
    print('🔍 Plaintiff/Defendant Entries: $plaintiffDefendantEntries');
    print('🔍 Next of Kin Entries: $nextOfKinEntries');

    fields["survey_entries"] = jsonEncode(surveyEntries);
    fields["plaintiff_defendant_entries"] = jsonEncode(plaintiffDefendantEntries);
    fields["next_of_kin_entries"] = jsonEncode(nextOfKinEntries);

    // Prepare files
    List<MultipartFiles> files = [];

    // Add court order files
    if (personalInfoController.courtOrderFiles?.isNotEmpty == true) {
        final filePath = personalInfoController.courtOrderFiles!.toString();
        if (filePath.isNotEmpty) {
          files.add(MultipartFiles(
            field: "court_order_document",
            filePath: filePath,
          ));

      }
    }

    // Add identity card files
    if (allocationSeventhController.identityCardFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "identity_proof_path",
        filePath: allocationSeventhController.identityCardFiles!.first.toString(),
      ));
    }

    // Add seven twelve files
    if (allocationSeventhController.sevenTwelveFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "seven_twelve_path",
        filePath: allocationSeventhController.sevenTwelveFiles!.first.toString(),
      ));
    }

    // Add note files
    if (allocationSeventhController.noteFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "note_path",
        filePath: allocationSeventhController.noteFiles!.first.toString(),
      ));
    }

    // Add partition files
    if (allocationSeventhController.partitionFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "partition_path",
        filePath: allocationSeventhController.partitionFiles!.first.toString(),
      ));
    }

    // Add scheme sheet files
    if (allocationSeventhController.schemeSheetFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "scheme_sheet_path",
        filePath: allocationSeventhController.schemeSheetFiles!.first.toString(),
      ));
    }

    // Add old census map files
    if (allocationSeventhController.oldCensusMapFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "old_census_map_path",
        filePath: allocationSeventhController.oldCensusMapFiles!.first.toString(),
      ));
    }

    // Add demarcation certificate files
    if (allocationSeventhController.demarcationCertificateFiles?.isNotEmpty == true) {
      files.add(MultipartFiles(
        field: "demarcation_certificate_path",
        filePath: allocationSeventhController.demarcationCertificateFiles!.first.toString(),
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
  List<Map<String, dynamic>> _getSurveyEntries() {
    List<Map<String, dynamic>> entries = [];

    print('🔍 Processing ${calculationController.surveyEntries.length} survey entries');

    for (int i = 0; i < calculationController.surveyEntries.length; i++) {
      final entry = calculationController.surveyEntries[i];
      entries.add({
        "selected_village": entry['selectedVillage']?.toString() ?? "",
        "survey_no": entry['surveyNo']?.toString() ?? "",
        "share": entry['share']?.toString() ?? "",
        "area": entry['area']?.toString() ?? "",
      });
    }

    print('🔍 Generated ${entries.length} survey entries');
    return entries;
  }

// Helper method to get plaintiff/defendant entries
  List<Map<String, dynamic>> _getPlaintiffDefendantEntries() {
    List<Map<String, dynamic>> entries = [];

    print('🔍 Processing ${allocationFifthController.plaintiffDefendantEntries.length} plaintiff/defendant entries');

    for (int i = 0; i < allocationFifthController.plaintiffDefendantEntries.length; i++) {
      final entry = allocationFifthController.plaintiffDefendantEntries[i];
      final selectedType = entry['selectedType'] as RxString?;
      final detailedAddress = entry['detailedAddress'] as RxMap<String, String>?;

      entries.add({
        "name": entry['nameController']?.text?.trim() ?? "",
        "address": entry['addressController']?.text?.trim() ?? "",
        "mobile": entry['mobileController']?.text?.trim() ?? "",
        "survey_number": entry['surveyNumberController']?.text?.trim() ?? "",
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

    print('🔍 Generated ${entries.length} plaintiff/defendant entries');
    return entries;
  }

// Helper method to get next of kin entries
  List<Map<String, dynamic>> _getNextOfKinEntries() {
    List<Map<String, dynamic>> entries = [];

    print('🔍 Processing ${allocationSixthController.nextOfKinEntries.length} next of kin entries');

    for (int i = 0; i < allocationSixthController.nextOfKinEntries.length; i++) {
      final entry = allocationSixthController.nextOfKinEntries[i];

      entries.add({
        "address": entry['addressController']?.text?.trim() ?? "",
        "mobile": entry['mobileController']?.text?.trim() ?? "",
        "survey_no": entry['surveyNoController']?.text?.trim() ?? "",
        "direction": entry['direction']?.toString() ?? "",
        "natural_resources": entry['naturalResources']?.toString() ?? "",
      });
    }

    print('🔍 Generated ${entries.length} next of kin entries');
    return entries;
  }



  Future<void> submitSurvey() async {
    try {
      String userId = await ApiService.getUid() ?? "0";
      print('🆔 User ID: $userId');

      final multipartData = prepareMultipartData(userId);
      final fields = multipartData['fields'] as Map<String, String>;
      final files = multipartData['files'] as List<MultipartFiles>;

      developer.log(jsonEncode(fields), name: 'REQUEST_BODY',);

      final response = await ApiService.multipartPost<Map<String, dynamic>>(
        endpoint: haddakayamPost,
        fields: fields,
        files: files,
        fromJson: (json) => json as Map<String, dynamic>,
        includeToken: true,
      );

      if (response.success && response.data != null) {
        print('✅ Survey submitted successfully: ${response.data}');
      } else {
        print('❌ Survey submission failed: ${response.errorMessage ?? 'Unknown error'}');
      }
    } catch (e) {
      print('💥 Exception during survey submission: $e');
    }
  }





  void _saveAllStepsData() {
    // Collect data from all step controllers
    final allControllers = [
      personalInfoController,
      surveyCTSController,
      calculationController,
      courtAlloFouthController,
      allocationFifthController,
      allocationSixthController,
      allocationSeventhController,
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
