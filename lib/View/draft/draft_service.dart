// // 2. Draft Service Class
// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../API Service/api_service.dart';
// import '../../Components/LandSurveyView/Controller/main_controller.dart';
// import 'draft_model.dart';
//
// class DraftService extends GetxService {
//   static DraftService get instance => Get.find<DraftService>();
//
//   final GetStorage _storage = GetStorage();
//   static const String _draftsKey = 'survey_drafts';
//   static const String _currentDraftKey = 'current_draft_id';
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initStorage();
//   }
//
//   void _initStorage() {
//     if (_storage.read(_draftsKey) == null) {
//       _storage.write(_draftsKey, <String, dynamic>{});
//     }
//   }
//
//   // Save draft
//   Future<bool> saveDraft(DraftSurvey draft) async {
//     try {
//       final drafts = _getDrafts();
//       drafts[draft.id] = draft.toJson();
//       await _storage.write(_draftsKey, drafts);
//       await _storage.write(_currentDraftKey, draft.id);
//       return true;
//     } catch (e) {
//       print('Error saving draft: $e');
//       return false;
//     }
//   }
//
//   // Get all drafts for current user
//   List<DraftSurvey> getUserDrafts(String userId) {
//     try {
//       final drafts = _getDrafts();
//       return drafts.values
//           .map((json) => DraftSurvey.fromJson(json))
//           .where((draft) => draft.userId == userId)
//           .toList()
//         ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//     } catch (e) {
//       print('Error getting user drafts: $e');
//       return [];
//     }
//   }
//
//   // Get specific draft
//   DraftSurvey? getDraft(String draftId) {
//     try {
//       final drafts = _getDrafts();
//       final draftJson = drafts[draftId];
//       return draftJson != null ? DraftSurvey.fromJson(draftJson) : null;
//     } catch (e) {
//       print('Error getting draft: $e');
//       return null;
//     }
//   }
//
//   // Delete draft
//   Future<bool> deleteDraft(String draftId) async {
//     try {
//       final drafts = _getDrafts();
//       drafts.remove(draftId);
//       await _storage.write(_draftsKey, drafts);
//
//       // Clear current draft if it's the deleted one
//       if (_storage.read(_currentDraftKey) == draftId) {
//         await _storage.remove(_currentDraftKey);
//       }
//       return true;
//     } catch (e) {
//       print('Error deleting draft: $e');
//       return false;
//     }
//   }
//
//   // Get current draft ID
//   String? getCurrentDraftId() {
//     return _storage.read(_currentDraftKey);
//   }
//
//   // Clear current draft
//   Future<void> clearCurrentDraft() async {
//     await _storage.remove(_currentDraftKey);
//   }
//
//   Map<String, dynamic> _getDrafts() {
//     return Map<String, dynamic>.from(_storage.read(_draftsKey) ?? {});
//   }
//
//   // Auto-save functionality
//   Timer? _autoSaveTimer;
//
//   void startAutoSave(String draftId, VoidCallback onSave) {
//     _autoSaveTimer?.cancel();
//     _autoSaveTimer = Timer.periodic(Duration(seconds: 30), (timer) {
//       onSave();
//     });
//   }
//
//   void stopAutoSave() {
//     _autoSaveTimer?.cancel();
//     _autoSaveTimer = null;
//   }
// }
//
// // 3. Enhanced MainSurveyController with Draft Support
// extension DraftExtension on MainSurveyController {
//   // Current draft
//   final currentDraftId = ''.obs;
//   final isDraftMode = false.obs;
//   final isAutoSaving = false.obs;
//   final lastSaved = Rxn<DateTime>();
//
//   // Initialize draft functionality
//   void initializeDraftMode() {
//     // Check if there's a current draft
//     final draftId = DraftService.instance.getCurrentDraftId();
//     if (draftId != null) {
//       loadDraft(draftId);
//     }
//
//     // Start auto-save
//     startAutoSave();
//   }
//
//   // Create new draft
//   Future<String> createNewDraft() async {
//     final userId = (await ApiService.getUid()) ?? "0";
//     final draftId = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final draft = DraftSurvey(
//       id: draftId,
//       userId: userId,
//       formData: {},
//       currentStep: currentStep.value,
//       currentSubStep: currentSubStep.value,
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       title: _generateDraftTitle(),
//     );
//
//     if (await DraftService.instance.saveDraft(draft)) {
//       currentDraftId.value = draftId;
//       isDraftMode.value = true;
//       return draftId;
//     }
//
//     throw Exception('Failed to create draft');
//   }
//
//   // Save current progress as draft
//   Future<bool> saveToDraft() async {
//     try {
//       isAutoSaving.value = true;
//
//       // Collect all current data
//       saveAllStepsData();
//
//       final userId = (await ApiService.getUid()) ?? "0";
//       String draftId = currentDraftId.value;
//
//       // Create new draft if none exists
//       if (draftId.isEmpty) {
//         draftId = await createNewDraft();
//       }
//
//       final draft = DraftSurvey(
//         id: draftId,
//         userId: userId,
//         formData: Map<String, dynamic>.from(surveyData.value ?? {}),
//         currentStep: currentStep.value,
//         currentSubStep: currentSubStep.value,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         title: _generateDraftTitle(),
//       );
//
//       final success = await DraftService.instance.saveDraft(draft);
//       if (success) {
//         lastSaved.value = DateTime.now();
//         Get.snackbar(
//           'Saved',
//           'Progress saved to drafts',
//           backgroundColor: Colors.green.withOpacity(0.8),
//           colorText: Colors.white,
//           duration: Duration(seconds: 2),
//         );
//       }
//
//       return success;
//     } catch (e) {
//       print('Error saving to draft: $e');
//       return false;
//     } finally {
//       isAutoSaving.value = false;
//     }
//   }
//
//   // Load draft
//   Future<bool> loadDraft(String draftId) async {
//     try {
//       final draft = DraftService.instance.getDraft(draftId);
//       if (draft == null) return false;
//
//       // Set survey data
//       surveyData.value = Map<String, dynamic>.from(draft.formData);
//
//       // Set navigation state
//       currentStep.value = draft.currentStep;
//       currentSubStep.value = draft.currentSubStep;
//
//       // Set draft mode
//       currentDraftId.value = draftId;
//       isDraftMode.value = true;
//
//       // Populate individual controllers with data
//       await _populateControllersFromData(draft.formData);
//
//       Get.snackbar(
//         'Draft Loaded',
//         'Continuing from where you left off',
//         backgroundColor: Colors.blue.withOpacity(0.8),
//         colorText: Colors.white,
//       );
//
//       return true;
//     } catch (e) {
//       print('Error loading draft: $e');
//       return false;
//     }
//   }
//
//   // Populate controllers from draft data
//   Future<void> _populateControllersFromData(Map<String, dynamic> data) async {
//     try {
//       // Personal Info
//       final personalInfo = data['personal_info'] as Map<String, dynamic>?;
//       if (personalInfo != null) {
//         personalInfoController.isHolderThemselves.value =
//             personalInfo['is_holder_themselves'] ?? false;
//         personalInfoController.hasAuthorityOnBehalf.value =
//             personalInfo['has_authority_on_behalf'] ?? false;
//         personalInfoController.hasBeenCountedBefore.value =
//             personalInfo['has_been_counted_before'] ?? false;
//         personalInfoController.poaRegistrationNumberController.text =
//             personalInfo['poa_registration_number'] ?? '';
//         // ... populate other fields
//       }
//
//       // Survey CTS
//       final surveyCTS = data['survey_cts'] as Map<String, dynamic>?;
//       if (surveyCTS != null) {
//         surveyCTSController.surveyNumberController.text =
//             surveyCTS['survey_number'] ?? '';
//         surveyCTSController.selectedDepartment.value =
//             surveyCTS['department'] ?? '';
//         // ... populate other fields
//       }
//
//       // Continue for other controllers...
//
//     } catch (e) {
//       print('Error populating controllers: $e');
//     }
//   }
//
//   // Generate user-friendly title
//   String _generateDraftTitle() {
//     String title = 'Survey Draft';
//
//     // Try to use survey number if available
//     if (surveyCTSController.surveyNumberController.text.isNotEmpty) {
//       title = 'Survey ${surveyCTSController.surveyNumberController.text}';
//     }
//
//     // Add step information
//     title += ' (Step ${currentStep.value + 1})';
//
//     return title;
//   }
//
//   // Auto-save functionality
//   void startAutoSave() {
//     DraftService.instance.startAutoSave(
//       currentDraftId.value,
//           () => saveToDraft(),
//     );
//   }
//
//   void stopAutoSave() {
//     DraftService.instance.stopAutoSave();
//   }
//
//   // Enhanced navigation with auto-save
//   @override
//   void nextSubStep() {
//     // Save before navigating
//     if (isDraftMode.value) {
//       saveToDraft();
//     }
//
//     // Call original method
//     super.nextSubStep();
//   }
//
//   @override
//   void previousSubStep() {
//     // Save before navigating
//     if (isDraftMode.value) {
//       saveToDraft();
//     }
//
//     // Call original method
//     super.previousSubStep();
//   }
//
//   // Finalize and submit (remove from drafts)
//   @override
//   Future<void> submitSurvey() async {
//     try {
//       // Call original submit method
//       await super.submitSurvey();
//
//       // If successful, clean up draft
//       if (currentDraftId.value.isNotEmpty) {
//         await DraftService.instance.deleteDraft(currentDraftId.value);
//         await DraftService.instance.clearCurrentDraft();
//         currentDraftId.value = '';
//         isDraftMode.value = false;
//       }
//     } catch (e) {
//       // Keep draft on error
//       print('Submit failed, keeping draft: $e');
//       rethrow;
//     }
//   }
//
//   // Exit without saving
//   void exitWithoutSaving() {
//     stopAutoSave();
//     Get.back();
//   }
//
//   // Save and exit
//   Future<void> saveAndExit() async {
//     if (await saveToDraft()) {
//       stopAutoSave();
//       Get.back();
//     }
//   }
//
//   @override
//   void onClose() {
//     stopAutoSave();
//     super.onClose();
//   }
// }
//
// // 4. Pending Applications Controller
// class PendingApplicationsController extends GetxController {
//   final drafts = <DraftSurvey>[].obs;
//   final isLoading = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadDrafts();
//   }
//
//   Future<void> loadDrafts() async {
//     try {
//       isLoading.value = true;
//       final userId = (await ApiService.getUid()) ?? "0";
//       drafts.value = DraftService.instance.getUserDrafts(userId);
//     } catch (e) {
//       print('Error loading drafts: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void continueDraft(String draftId) {
//     // Navigate to survey with draft ID
//     Get.toNamed('/survey', parameters: {'draftId': draftId});
//   }
//
//   Future<void> deleteDraft(String draftId) async {
//     if (await DraftService.instance.deleteDraft(draftId)) {
//       drafts.removeWhere((draft) => draft.id == draftId);
//       Get.snackbar('Deleted', 'Draft deleted successfully');
//     }
//   }
//
//   String getProgressText(DraftSurvey draft) {
//     final totalSteps = 10;
//     final progress = ((draft.currentStep / totalSteps) * 100).round();
//     return '$progress% complete';
//   }
//
//   String getTimeAgo(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//
//     if (difference.inDays > 0) {
//       return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
//     } else {
//       return 'Just now';
//     }
//   }
// }
