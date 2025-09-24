// import 'package:get/get.dart';
// import 'dart:io';
// import '../Controller/main_controller.dart';
//
// class CensusEighthController extends GetxController with StepValidationMixin, StepDataMixin {
//   // Identity Card
//   final selectedIdentityType = ''.obs;
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
//       case 'documents':
//         return _validateDocuments();
//       case 'status':
//         return true; // Status is always valid for this step
//       default:
//         return true;
//     }
//   }
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



import 'package:get/get.dart';
import 'dart:io';
import '../Controller/main_controller.dart';

class CensusEighthController extends GetxController with StepValidationMixin, StepDataMixin {
  // Identity Card
  final selectedIdentityType = ''.obs;
  final identityCardFiles = <String>[].obs; // Changed from File to String

  // Document Files - Changed from List<File> to List<String>
  final sevenTwelveFiles = <String>[].obs;
  final noteFiles = <String>[].obs;
  final partitionFiles = <String>[].obs;
  final schemeSheetFiles = <String>[].obs;
  final oldCensusMapFiles = <String>[].obs;
  final demarcationCertificateFiles = <String>[].obs;

  final adhikarPatra = <String>[].obs;
  final utaraAkharband = <String>[].obs;
  final otherDocument = <String>[].obs;

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

  // Validation Methods
  @override
  bool validateCurrentSubStep(String field) {
    switch (field) {
      case 'documents':
        return _validateDocuments();
      case 'status':
        return true; // Status is always valid for this step
      default:
        return true;
    }
  }

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
    return {
      'identityCardType': selectedIdentityType.value,
      'identityCardFiles': identityCardFiles.toList(), // Already strings
      'sevenTwelveFiles': sevenTwelveFiles.toList(),
      'noteFiles': noteFiles.toList(),
      'partitionFiles': partitionFiles.toList(),
      'schemeSheetFiles': schemeSheetFiles.toList(),
      'oldCensusMapFiles': oldCensusMapFiles.toList(),
      'demarcationCertificateFiles': demarcationCertificateFiles.toList(),
    };
  }

  // Check if all required documents are uploaded
  bool get areAllDocumentsUploaded {
    return selectedIdentityType.value.isNotEmpty &&
        identityCardFiles.isNotEmpty &&
        sevenTwelveFiles.isNotEmpty &&
        noteFiles.isNotEmpty &&
        partitionFiles.isNotEmpty &&
        schemeSheetFiles.isNotEmpty &&
        oldCensusMapFiles.isNotEmpty &&
        demarcationCertificateFiles.isNotEmpty;
  }

  // Get upload progress for UI
  String get uploadProgressText {
    int uploadedCount = 0;
    int totalRequired = 7;

    if (selectedIdentityType.value.isNotEmpty && identityCardFiles.isNotEmpty) uploadedCount++;
    if (sevenTwelveFiles.isNotEmpty) uploadedCount++;
    if (noteFiles.isNotEmpty) uploadedCount++;
    if (partitionFiles.isNotEmpty) uploadedCount++;
    if (schemeSheetFiles.isNotEmpty) uploadedCount++;
    if (oldCensusMapFiles.isNotEmpty) uploadedCount++;
    if (demarcationCertificateFiles.isNotEmpty) uploadedCount++;

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

  // Helper methods to convert between File and String if needed elsewhere
  List<File> getFilesFromPaths(List<String> paths) {
    return paths.map((path) => File(path)).toList();
  }

  List<String> getPathsFromFiles(List<File> files) {
    return files.map((file) => file.path).toList();
  }
}
