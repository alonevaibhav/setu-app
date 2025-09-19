// import 'package:get/get.dart';
// import 'dart:io';
// import '../Controller/main_controller.dart';
//
// class SurveyEightController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Identity Card
//   final selectedIdentityType = ''.obs;
//
//   final identityCardFiles = <String>[].obs; // Changed from File to String
//
//   // Document Files - Changed from List<File> to List<String>
//   final sevenTwelveFiles = <String>[].obs;
//   final noteFiles = <String>[].obs;
//   final partitionFiles = <String>[].obs;
//   final schemeSheetFiles = <String>[].obs;
//   final oldCensusMapFiles = <String>[].obs;
//   final demarcationCertificateFiles = <String>[].obs;
//
//   // Loading states
//   final isUploading = false.obs;
//   final uploadProgress = 0.0.obs;
//
//   // Validation states
//   final validationErrors = <String, String>{}.obs;
//
//   // Identity card options
//   final List<String> identityCardOptions = [
//     'Aadhar Card',
//     'Voter Card',
//     'PAN Card',
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeValidation();
//   }
//
//   void initializeValidation() {
//     validationErrors.clear();
//   }
//
//   // Identity Type Selection
//   void updateSelectedIdentityType(String? value) {
//     if (value != null) {
//       selectedIdentityType.value = value;
//       validationErrors.remove('identityType');
//
//       // Clear previous identity card files if changing type
//       if (identityCardFiles.isNotEmpty) {
//         identityCardFiles.clear();
//       }
//     }
//   }
//
//   // Validation Methods
//   @override
//   bool validateCurrentSubStep(String field) {
//     switch (field) {
//       case 'government_survey':
//         return true; // Temporarily return true to bypass validation
//       default:
//         return true;
//     }
//   }
//   // bool validateCurrentSubStep(String field) {
//   //   switch (field) {
//   //     case 'documents':
//   //       return _validateDocuments();
//   //     case 'status':
//   //       return true; // Status is always valid for this step
//   //     default:
//   //       return true;
//   //   }
//   // }
//
//   bool _validateDocuments() {
//     validationErrors.clear();
//     bool isValid = true;
//
//     // Identity card validation
//     if (selectedIdentityType.value.isEmpty) {
//       validationErrors['identityType'] = 'Please select identity card type';
//       isValid = false;
//     }
//
//     if (identityCardFiles.isEmpty) {
//       validationErrors['identityCard'] = 'Please upload identity card';
//       isValid = false;
//     }
//
//     // Required documents validation
//     if (sevenTwelveFiles.isEmpty) {
//       validationErrors['sevenTwelve'] = 'Please upload 7/12 document';
//       isValid = false;
//     }
//
//     if (noteFiles.isEmpty) {
//       validationErrors['note'] = 'Please upload note document';
//       isValid = false;
//     }
//
//     if (partitionFiles.isEmpty) {
//       validationErrors['partition'] = 'Please upload partition document';
//       isValid = false;
//     }
//
//     if (schemeSheetFiles.isEmpty) {
//       validationErrors['schemeSheet'] = 'Please upload scheme sheet document';
//       isValid = false;
//     }
//
//     if (oldCensusMapFiles.isEmpty) {
//       validationErrors['oldCensusMap'] = 'Please upload old census map';
//       isValid = false;
//     }
//
//     if (demarcationCertificateFiles.isEmpty) {
//       validationErrors['demarcationCertificate'] = 'Please upload demarcation certificate';
//       isValid = false;
//     }
//
//     return isValid;
//   }
//
//   @override
//   bool isStepCompleted(List<String> fields) {
//     for (String field in fields) {
//       if (!validateCurrentSubStep(field)) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   @override
//   String getFieldError(String field) {
//     return validationErrors[field] ?? 'This field is required';
//   }
//
//   @override
//   Map<String, dynamic> getStepData() {
//     return {
//       'identityCardType': selectedIdentityType.value,
//       'identityCardFiles': identityCardFiles.toList(), // Already strings
//       'sevenTwelveFiles': sevenTwelveFiles.toList(),
//       'noteFiles': noteFiles.toList(),
//       'partitionFiles': partitionFiles.toList(),
//       'schemeSheetFiles': schemeSheetFiles.toList(),
//       'oldCensusMapFiles': oldCensusMapFiles.toList(),
//       'demarcationCertificateFiles': demarcationCertificateFiles.toList(),
//     };
//   }
//
//   // Check if all required documents are uploaded
//   bool get areAllDocumentsUploaded {
//     return selectedIdentityType.value.isNotEmpty &&
//         identityCardFiles.isNotEmpty &&
//         sevenTwelveFiles.isNotEmpty &&
//         noteFiles.isNotEmpty &&
//         partitionFiles.isNotEmpty &&
//         schemeSheetFiles.isNotEmpty &&
//         oldCensusMapFiles.isNotEmpty &&
//         demarcationCertificateFiles.isNotEmpty;
//   }
//
//   // Get upload progress for UI
//   String get uploadProgressText {
//     int uploadedCount = 0;
//     int totalRequired = 7;
//
//     if (selectedIdentityType.value.isNotEmpty && identityCardFiles.isNotEmpty) uploadedCount++;
//     if (sevenTwelveFiles.isNotEmpty) uploadedCount++;
//     if (noteFiles.isNotEmpty) uploadedCount++;
//     if (partitionFiles.isNotEmpty) uploadedCount++;
//     if (schemeSheetFiles.isNotEmpty) uploadedCount++;
//     if (oldCensusMapFiles.isNotEmpty) uploadedCount++;
//     if (demarcationCertificateFiles.isNotEmpty) uploadedCount++;
//
//     return '$uploadedCount / $totalRequired documents uploaded';
//   }
//
//   // Helper methods to get file names for display
//   List<String> get identityCardFileNames => identityCardFiles.map((filePath) => filePath.split('/').last).toList();
//   List<String> get sevenTwelveFileNames => sevenTwelveFiles.map((filePath) => filePath.split('/').last).toList();
//   List<String> get noteFileNames => noteFiles.map((filePath) => filePath.split('/').last).toList();
//   List<String> get partitionFileNames => partitionFiles.map((filePath) => filePath.split('/').last).toList();
//   List<String> get schemeSheetFileNames => schemeSheetFiles.map((filePath) => filePath.split('/').last).toList();
//   List<String> get oldCensusMapFileNames => oldCensusMapFiles.map((filePath) => filePath.split('/').last).toList();
//   List<String> get demarcationCertificateFileNames => demarcationCertificateFiles.map((filePath) => filePath.split('/').last).toList();
//
//   // Helper methods to convert between File and String if needed elsewhere
//   List<File> getFilesFromPaths(List<String> paths) {
//     return paths.map((path) => File(path)).toList();
//   }
//
//   List<String> getPathsFromFiles(List<File> files) {
//     return files.map((file) => file.path).toList();
//   }
// }

import 'dart:developer' as Developer;
import 'package:get/get.dart';
import 'dart:io';
import '../../LandSurveyView/Controller/step_three_controller.dart';
import '../Controller/main_controller.dart';

class SurveyEightController extends GetxController with StepValidationMixin, StepDataMixin {
  // Identity Card
  final selectedIdentityType = ''.obs;
  final identityCardFiles = <String>[].obs;

  // Document Files - Changed from List<File> to List<String>
  final sevenTwelveFiles = <String>[].obs;
  final noteFiles = <String>[].obs;
  final partitionFiles = <String>[].obs;
  final schemeSheetFiles = <String>[].obs;
  final oldCensusMapFiles = <String>[].obs;
  final demarcationCertificateFiles = <String>[].obs;
  final adhikarPatra = <String>[].obs;

  // Non-agricultural specific documents
  final sakshamPradikaranAdeshFiles = <String>[].obs;
  final nakashaFiles = <String>[].obs;
  final bhandhakamParvanaFiles = <String>[].obs;

  // Stomach specific documents
  final pratisaKarayaycheNakshaFiles = <String>[].obs;
  final bandPhotoFiles = <String>[].obs;
  final sammatiPatraFiles = <String>[].obs;

  // Loading states
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  // Validation states
  final validationErrors = <String, String>{}.obs;

  // Identity card options
  final List<String> identityCardOptions = [
    'Aadhar Card',
    'Voter Card',
    'PAN Card',
  ];

  @override
  void onInit() {
    super.onInit();
    initializeValidation();
  }

  void initializeValidation() {
    validationErrors.clear();
  }

  // Identity Type Selection
  void updateSelectedIdentityType(String? value) {
    if (value != null) {
      selectedIdentityType.value = value;
      validationErrors.remove('identityType');

      // Clear previous identity card files if changing type
      if (identityCardFiles.isNotEmpty) {
        identityCardFiles.clear();
      }
    }
  }

  // Check if calculation type is Non-agricultural
  bool get isNonAgricultural  {
    try {
      final calculationController = Get.find<CalculationController>(tag: 'calculation');
      bool result = calculationController.selectedCalculationType.value == 'Non-agricultural';

      Developer.log('isNonAgricultural check: ${calculationController.selectedCalculationType.value} -> $result', name: 'SurveyEightController');

      return result;
    } catch (e) {
      print('Error in isNonAgricultural: $e');
      return false;
    }
  }

  // Check if calculation type is Stomach
  bool get isStomach {
    try {
      final calculationController = Get.find<CalculationController>(tag: 'calculation');
      bool result = calculationController.selectedCalculationType.value == 'Stomach';

      Developer.log('isStomach check: ${calculationController.selectedCalculationType.value} -> $result', name: 'SurveyEightController');

      return result;
    } catch (e) {
      print('Error in isStomach: $e');
      return false;
    }
  }

  // Validation Methods
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'government_survey':
        return true; // Temporarily return true to bypass validation
      default:
        return true;
    }
  }

  //   bool validateCurrentSubStep(String field) {
  //   switch (field) {
  //     case 'documents':
  //       return _validateDocuments();
  //     case 'status':
  //       return true; // Status is always valid for this step
  //     default:
  //       return true;
  //   }
  // }

  bool _validateDocuments() {
    validationErrors.clear();
    bool isValid = true;

    // Identity card validation
    if (selectedIdentityType.value.isEmpty) {
      validationErrors['identityType'] = 'Please select identity card type';
      isValid = false;
    }

    if (identityCardFiles.isEmpty) {
      validationErrors['identityCard'] = 'Please upload identity card';
      isValid = false;
    }

    // Required documents validation
    if (sevenTwelveFiles.isEmpty) {
      validationErrors['sevenTwelve'] = 'Please upload 7/12 document';
      isValid = false;
    }

    if (noteFiles.isEmpty) {
      validationErrors['note'] = 'Please upload note document';
      isValid = false;
    }

    if (partitionFiles.isEmpty) {
      validationErrors['partition'] = 'Please upload partition document';
      isValid = false;
    }

    if (schemeSheetFiles.isEmpty) {
      validationErrors['schemeSheet'] = 'Please upload scheme sheet document';
      isValid = false;
    }

    if (oldCensusMapFiles.isEmpty) {
      validationErrors['oldCensusMap'] = 'Please upload old census map';
      isValid = false;
    }

    if (demarcationCertificateFiles.isEmpty) {
      validationErrors['demarcationCertificate'] = 'Please upload demarcation certificate';
      isValid = false;
    }

    // Non-agricultural specific validation
    if (isNonAgricultural) {
      if (sakshamPradikaranAdeshFiles.isEmpty) {
        validationErrors['sakshamPradikaranAdesh'] = 'Please upload Saksham Pradikaran Adesh document';
        isValid = false;
      }

      if (nakashaFiles.isEmpty) {
        validationErrors['nakasha'] = 'Please upload Nakasha document';
        isValid = false;
      }

      if (bhandhakamParvanaFiles.isEmpty) {
        validationErrors['bhandhakamParvana'] = 'Please upload Bhandhakam Parvana document';
        isValid = false;
      }
    }

    // Stomach specific validation
    if (isStomach) {
      if (pratisaKarayaycheNakshaFiles.isEmpty) {
        validationErrors['pratisaKarayaycheNaksha'] = 'Please upload Pratisa Karayayche Naksha document';
        isValid = false;
      }

      if (bandPhotoFiles.isEmpty) {
        validationErrors['bandPhoto'] = 'Please upload Band Photo';
        isValid = false;
      }

      if (sammatiPatraFiles.isEmpty) {
        validationErrors['sammatiPatra'] = 'Please upload Sammati Patra document';
        isValid = false;
      }
    }

    return isValid;
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
    return validationErrors[field] ?? 'This field is required';
  }

  @override
  Map<String, dynamic> getStepData() {
    Map<String, dynamic> data = {
      'identityCardType': selectedIdentityType.value,
      'identityCardFiles': identityCardFiles.toList(),
      'sevenTwelveFiles': sevenTwelveFiles.toList(),
      'noteFiles': noteFiles.toList(),
      'partitionFiles': partitionFiles.toList(),
      'schemeSheetFiles': schemeSheetFiles.toList(),
      'oldCensusMapFiles': oldCensusMapFiles.toList(),
      'demarcationCertificateFiles': demarcationCertificateFiles.toList(),
    };

    // Add non-agricultural specific data
    if (isNonAgricultural) {
      data.addAll({
        'sakshamPradikaranAdeshFiles': sakshamPradikaranAdeshFiles.toList(),
        'nakashaFiles': nakashaFiles.toList(),
        'bhandhakamParvanaFiles': bhandhakamParvanaFiles.toList(),
      });
    }

    // Add stomach specific data
    if (isStomach) {
      data.addAll({
        'pratisaKarayaycheNakshaFiles': pratisaKarayaycheNakshaFiles.toList(),
        'bandPhotoFiles': bandPhotoFiles.toList(),
        'sammatiPatraFiles': sammatiPatraFiles.toList(),
      });
    }

    return data;
  }

  @override
  void loadStepData(Map<String, dynamic> data) {
    selectedIdentityType.value = data['identityCardType'] ?? '';
    identityCardFiles.assignAll(List<String>.from(data['identityCardFiles'] ?? []));
    sevenTwelveFiles.assignAll(List<String>.from(data['sevenTwelveFiles'] ?? []));
    noteFiles.assignAll(List<String>.from(data['noteFiles'] ?? []));
    partitionFiles.assignAll(List<String>.from(data['partitionFiles'] ?? []));
    schemeSheetFiles.assignAll(List<String>.from(data['schemeSheetFiles'] ?? []));
    oldCensusMapFiles.assignAll(List<String>.from(data['oldCensusMapFiles'] ?? []));
    demarcationCertificateFiles.assignAll(List<String>.from(data['demarcationCertificateFiles'] ?? []));

    // Load non-agricultural specific data
    if (data.containsKey('sakshamPradikaranAdeshFiles')) {
      sakshamPradikaranAdeshFiles.assignAll(List<String>.from(data['sakshamPradikaranAdeshFiles'] ?? []));
    }
    if (data.containsKey('nakashaFiles')) {
      nakashaFiles.assignAll(List<String>.from(data['nakashaFiles'] ?? []));
    }
    if (data.containsKey('bhandhakamParvanaFiles')) {
      bhandhakamParvanaFiles.assignAll(List<String>.from(data['bhandhakamParvanaFiles'] ?? []));
    }

    // Load stomach specific data
    if (data.containsKey('pratisaKarayaycheNakshaFiles')) {
      pratisaKarayaycheNakshaFiles.assignAll(List<String>.from(data['pratisaKarayaycheNakshaFiles'] ?? []));
    }
    if (data.containsKey('bandPhotoFiles')) {
      bandPhotoFiles.assignAll(List<String>.from(data['bandPhotoFiles'] ?? []));
    }
    if (data.containsKey('sammatiPatraFiles')) {
      sammatiPatraFiles.assignAll(List<String>.from(data['sammatiPatraFiles'] ?? []));
    }
  }

  // Check if all required documents are uploaded
  bool get areAllDocumentsUploaded {
    bool basicDocsUploaded = selectedIdentityType.value.isNotEmpty &&
        identityCardFiles.isNotEmpty &&
        sevenTwelveFiles.isNotEmpty &&
        noteFiles.isNotEmpty &&
        partitionFiles.isNotEmpty &&
        schemeSheetFiles.isNotEmpty &&
        oldCensusMapFiles.isNotEmpty &&
        demarcationCertificateFiles.isNotEmpty;

    if (isNonAgricultural) {
      return basicDocsUploaded &&
          sakshamPradikaranAdeshFiles.isNotEmpty &&
          nakashaFiles.isNotEmpty &&
          bhandhakamParvanaFiles.isNotEmpty;
    }

    if (isStomach) {
      return basicDocsUploaded &&
          pratisaKarayaycheNakshaFiles.isNotEmpty &&
          bandPhotoFiles.isNotEmpty &&
          sammatiPatraFiles.isNotEmpty;
    }

    return basicDocsUploaded;
  }

  // Get upload progress for UI
  String get uploadProgressText {
    int uploadedCount = 0;
    int totalRequired = 7; // Basic documents

    if (isNonAgricultural) {
      totalRequired += 3; // Add non-agricultural documents
    }

    if (isStomach) {
      totalRequired += 3; // Add stomach documents
    }

    if (selectedIdentityType.value.isNotEmpty && identityCardFiles.isNotEmpty) uploadedCount++;
    if (sevenTwelveFiles.isNotEmpty) uploadedCount++;
    if (noteFiles.isNotEmpty) uploadedCount++;
    if (partitionFiles.isNotEmpty) uploadedCount++;
    if (schemeSheetFiles.isNotEmpty) uploadedCount++;
    if (oldCensusMapFiles.isNotEmpty) uploadedCount++;
    if (demarcationCertificateFiles.isNotEmpty) uploadedCount++;

    if (isNonAgricultural) {
      if (sakshamPradikaranAdeshFiles.isNotEmpty) uploadedCount++;
      if (nakashaFiles.isNotEmpty) uploadedCount++;
      if (bhandhakamParvanaFiles.isNotEmpty) uploadedCount++;
    }

    if (isStomach) {
      if (pratisaKarayaycheNakshaFiles.isNotEmpty) uploadedCount++;
      if (bandPhotoFiles.isNotEmpty) uploadedCount++;
      if (sammatiPatraFiles.isNotEmpty) uploadedCount++;
    }

    return '$uploadedCount / $totalRequired documents uploaded';
  }

  // Helper methods to get file names for display
  List<String> get identityCardFileNames => identityCardFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get sevenTwelveFileNames => sevenTwelveFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get noteFileNames => noteFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get partitionFileNames => partitionFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get schemeSheetFileNames => schemeSheetFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get oldCensusMapFileNames => oldCensusMapFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get demarcationCertificateFileNames => demarcationCertificateFiles.map((filePath) => filePath.split('/').last).toList();

  // Non-agricultural specific file names
  List<String> get sakshamPradikaranAdeshFileNames => sakshamPradikaranAdeshFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get nakashaFileNames => nakashaFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get bhandhakamParvanaFileNames => bhandhakamParvanaFiles.map((filePath) => filePath.split('/').last).toList();

  // Stomach specific file names
  List<String> get pratisaKarayaycheNakshaFileNames => pratisaKarayaycheNakshaFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get bandPhotoFileNames => bandPhotoFiles.map((filePath) => filePath.split('/').last).toList();
  List<String> get sammatiPatraFileNames => sammatiPatraFiles.map((filePath) => filePath.split('/').last).toList();

  // Helper methods to convert between File and String if needed elsewhere
  List<File> getFilesFromPaths(List<String> paths) {
    return paths.map((path) => File(path)).toList();
  }

  List<String> getPathsFromFiles(List<File> files) {
    return files.map((file) => file.path).toList();
  }
}