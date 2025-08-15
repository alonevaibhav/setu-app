// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import '../../../Constants/color_constant.dart';
// import '../Controller/main_controller.dart';
// import '../Controller/survey_eight_controller.dart';
//
// class SurveyEightView extends StatelessWidget {
//   final int currentSubStep;
//   final MainSurveyController mainController;
//
//   const SurveyEightView({
//     Key? key,
//     required this.currentSubStep,
//     required this.mainController,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final docController = Get.put(SurveyEightController(), tag: 'survey_eight');
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Container(
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               color: SetuColors.primaryGreen.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Document Upload',
//                   style: TextStyle(
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.bold,
//                     color: SetuColors.primaryGreen,
//                   ),
//                 ),
//                 Gap(8.h),
//                 Text(
//                   'Please upload all required documents for your land survey application',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Gap(24.h),
//
//           // Progress
//           Obx(() => Container(
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: Row(
//               children: [
//                 CircularProgressIndicator(
//                   value: _getUploadProgress(docController),
//                   backgroundColor: Colors.grey.shade200,
//                   valueColor: AlwaysStoppedAnimation<Color>(SetuColors.primaryGreen),
//                 ),
//                 Gap(16.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Upload Progress',
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         '${_getUploadedCount(docController)} of 7 documents uploaded',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )),
//
//           Gap(24.h),
//
//           // Identity Card Section
//           _buildSection(
//             title: '1. Identity Card',
//             child: Column(
//               children: [
//                 // Dropdown
//                 Obx(() => _buildDropdownField(
//                   label: 'Select Identity Card Type',
//                   value: docController.selectedIdentityType.value,
//                   items: docController.identityCardOptions,
//                   onChanged: docController.updateSelectedIdentityType,
//                   error: docController.validationErrors['identityType'],
//                 )),
//                 Gap(16.h),
//                 // Upload
//                 Obx(() => _buildSimpleFileUpload(
//                   label: 'Upload Identity Card',
//                   fileName: docController.identityCardFileName.value,
//                   isUploaded: docController.identityCardFile.value != null,
//                   onTap: docController.uploadIdentityCard,
//                   onRemove: docController.removeIdentityCard,
//                   enabled: docController.selectedIdentityType.value.isNotEmpty,
//                 )),
//               ],
//             ),
//           ),
//
//           Gap(20.h),
//
//           // Other Documents
//           _buildSection(
//             title: '2. Required Documents',
//             child: Column(
//               children: [
//                 // 7/12 Document
//                 Obx(() => _buildSimpleFileUpload(
//                   label: '7/12 of the 3rd month',
//                   fileName: docController.sevenTwelveFileName.value,
//                   isUploaded: docController.sevenTwelveFile.value != null,
//                   onTap: docController.uploadSevenTwelve,
//                   onRemove: docController.removeSevenTwelve,
//                 )),
//                 Gap(16.h),
//
//                 // Note
//                 Obx(() => _buildSimpleFileUpload(
//                   label: 'Note',
//                   fileName: docController.noteFileName.value,
//                   isUploaded: docController.noteFile.value != null,
//                   onTap: docController.uploadNote,
//                   onRemove: docController.removeNote,
//                 )),
//                 Gap(16.h),
//
//                 // Partition
//                 Obx(() => _buildSimpleFileUpload(
//                   label: 'Partition',
//                   fileName: docController.partitionFileName.value,
//                   isUploaded: docController.partitionFile.value != null,
//                   onTap: docController.uploadPartition,
//                   onRemove: docController.removePartition,
//                 )),
//                 Gap(16.h),
//
//                 // Scheme Sheet
//                 Obx(() => _buildSimpleFileUpload(
//                   label: 'Scheme Sheet Uttrakhand/ 9(3)-9(4)',
//                   fileName: docController.schemeSheetFileName.value,
//                   isUploaded: docController.schemeSheetFile.value != null,
//                   onTap: docController.uploadSchemeSheet,
//                   onRemove: docController.removeSchemeSheet,
//                 )),
//                 Gap(16.h),
//
//                 // Old Census Map
//                 Obx(() => _buildSimpleFileUpload(
//                   label: 'Old census map',
//                   fileName: docController.oldCensusMapFileName.value,
//                   isUploaded: docController.oldCensusMapFile.value != null,
//                   onTap: docController.uploadOldCensusMap,
//                   onRemove: docController.removeOldCensusMap,
//                 )),
//                 Gap(16.h),
//
//                 // Demarcation Certificate
//                 Obx(() => _buildSimpleFileUpload(
//                   label: 'Demarcation certificate',
//                   fileName: docController.demarcationCertificateFileName.value,
//                   isUploaded: docController.demarcationCertificateFile.value != null,
//                   onTap: docController.uploadDemarcationCertificate,
//                   onRemove: docController.removeDemarcationCertificate,
//                 )),
//               ],
//             ),
//           ),
//
//           Gap(32.h),
//
//           // Navigation Buttons
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: mainController.previousSubStep,
//                   style: OutlinedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16.h),
//                     side: BorderSide(color: SetuColors.primaryGreen),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                   child: Text(
//                     'Previous',
//                     style: TextStyle(
//                       color: SetuColors.primaryGreen,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(16.w),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: mainController.nextSubStep,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: SetuColors.primaryGreen,
//                     padding: EdgeInsets.symmetric(vertical: 16.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                   child: Text(
//                     'Next',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           Gap(40.h),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSection({required String title, required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//               color: SetuColors.primaryGreen,
//             ),
//           ),
//           Gap(16.h),
//           child,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String label,
//     required String value,
//     required List<String> items,
//     required Function(String) onChanged,
//     String? error,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         Gap(8.h),
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(
//               color: error != null ? Colors.red : Colors.grey.shade300,
//             ),
//             color: Colors.grey.shade50,
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value.isEmpty ? null : value,
//               hint: Text('Select option'),
//               isExpanded: true,
//               items: items.map((item) => DropdownMenuItem(
//                 value: item,
//                 child: Text(item),
//               )).toList(),
//               onChanged: (newValue) {
//                 if (newValue != null) onChanged(newValue);
//               },
//             ),
//           ),
//         ),
//         if (error != null)
//           Padding(
//             padding: EdgeInsets.only(top: 4.h),
//             child: Text(
//               error,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildSimpleFileUpload({
//     required String label,
//     required String fileName,
//     required bool isUploaded,
//     required VoidCallback onTap,
//     required VoidCallback onRemove,
//     bool enabled = true,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         Gap(8.h),
//         InkWell(
//           onTap: enabled ? onTap : null,
//           borderRadius: BorderRadius.circular(12.r),
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(
//                 color: isUploaded ? SetuColors.primaryGreen : Colors.grey.shade300,
//               ),
//               color: enabled
//                   ? (isUploaded ? SetuColors.primaryGreen.withOpacity(0.05) : Colors.grey.shade50)
//                   : Colors.grey.shade100,
//             ),
//             child: isUploaded ? _buildUploadedContent(fileName, onRemove) : _buildUploadContent(enabled),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUploadContent(bool enabled) {
//     return Row(
//       children: [
//         Icon(
//           PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.regular),
//           color: enabled ? SetuColors.primaryGreen : Colors.grey,
//           size: 24.sp,
//         ),
//         Gap(12.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 enabled ? 'Tap to upload file' : 'Select identity type first',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: enabled ? Colors.black87 : Colors.grey,
//                 ),
//               ),
//               Text(
//                 'PDF, DOC, JPG, PNG (Max 10MB)',
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUploadedContent(String fileName, VoidCallback onRemove) {
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8.w),
//           decoration: BoxDecoration(
//             color: SetuColors.primaryGreen,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Icon(
//             PhosphorIcons.file(PhosphorIconsStyle.fill),
//             color: Colors.white,
//             size: 16.sp,
//           ),
//         ),
//         Gap(12.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 fileName.isNotEmpty ? fileName : 'File uploaded',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 'Uploaded successfully',
//                 style: TextStyle(
//                   fontSize: 12.sp,
//                   color: SetuColors.primaryGreen,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         InkWell(
//           onTap: onRemove,
//           child: Container(
//             padding: EdgeInsets.all(6.w),
//             decoration: BoxDecoration(
//               color: Colors.red.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(6.r),
//             ),
//             child: Icon(
//               PhosphorIcons.trash(PhosphorIconsStyle.regular),
//               color: Colors.red,
//               size: 16.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   double _getUploadProgress(SurveyEightController docController) {
//     return _getUploadedCount(docController) / 7.0;
//   }
//
//   int _getUploadedCount(SurveyEightController docController) {
//     int count = 0;
//     if (docController.selectedIdentityType.value.isNotEmpty && docController.identityCardFile.value != null) count++;
//     if (docController.sevenTwelveFile.value != null) count++;
//     if (docController.noteFile.value != null) count++;
//     if (docController.partitionFile.value != null) count++;
//     if (docController.schemeSheetFile.value != null) count++;
//     if (docController.oldCensusMapFile.value != null) count++;
//     if (docController.demarcationCertificateFile.value != null) count++;
//     return count;
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../Controller/main_controller.dart';
import '../Controller/survey_eight_controller.dart';

class SurveyEightView extends StatelessWidget {
  final int currentSubStep;
  final MainSurveyController mainController;

  const SurveyEightView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docController = Get.put(SurveyEightController(), tag: 'survey_eight');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: SetuColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document Upload',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: SetuColors.primaryGreen,
                  ),
                ),
                Gap(8.h),
                Text(
                  'Please upload all required documents for your land survey application',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Gap(24.h),

          // Progress
          Obx(() => Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircularProgressIndicator(
                  value: _getUploadProgress(docController),
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(SetuColors.primaryGreen),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Progress',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_getUploadedCount(docController)} of 7 documents uploaded',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),

          Gap(24.h),

          // Identity Card Section
          _buildSection(
            title: 'Identity Card',
            child: Column(
              children: [
                // Dropdown
                SurveyUIUtils.buildDropdownField(
                  label: 'Select Identity Card Type',
                  value: docController.selectedIdentityType.value,
                  items: docController.identityCardOptions,
                  onChanged: docController.updateSelectedIdentityType,
                  icon: PhosphorIcons.identificationBadge(PhosphorIconsStyle.regular),
                ),
                Gap(16.h),
                // Upload using ImagePickerUtil
                ImagePickerUtil.buildFileUploadField(
                  label: 'Upload Identity Card *',
                  hint: 'Upload identity card document',
                  icon: PhosphorIcons.identificationCard(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.identityCardFiles,
                  onFilesSelected: (files) => docController.identityCardFiles.assignAll(files),
                ),
              ],
            ),
          ),

          Gap(20.h),

          // Other Documents
          _buildSection(
            title: 'Required Documents',
            child: Column(
              children: [
                // 7/12 Document
                ImagePickerUtil.buildFileUploadField(
                  label: '7/12 of the 3rd month *',
                  hint: 'Upload 7/12 document',
                  icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.sevenTwelveFiles,
                  onFilesSelected: (files) => docController.sevenTwelveFiles.assignAll(files),
                ),
                Gap(16.h),

                // Note
             ImagePickerUtil.buildFileUploadField(
                  label: 'Note *',
                  hint: 'Upload note document',
                  icon: PhosphorIcons.note(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.noteFiles,
                  onFilesSelected: (files) => docController.noteFiles.assignAll(files),
                ),
                Gap(16.h),

                // Partition
                ImagePickerUtil.buildFileUploadField(
                  label: 'Partition *',
                  hint: 'Upload partition document',
                  icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.partitionFiles,
                  onFilesSelected: (files) => docController.partitionFiles.assignAll(files),
                ),
                Gap(16.h),

                // Scheme Sheet
           ImagePickerUtil.buildFileUploadField(
                  label: 'Scheme Sheet Uttrakhand/ 9(3)-9(4) *',
                  hint: 'Upload scheme sheet document',
                  icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.schemeSheetFiles,
                  onFilesSelected: (files) => docController.schemeSheetFiles.assignAll(files),
                ),
                Gap(16.h),

                // Old Census Map
                 ImagePickerUtil.buildFileUploadField(
                  label: 'Old census map *',
                  hint: 'Upload census map',
                  icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.oldCensusMapFiles,
                  onFilesSelected: (files) => docController.oldCensusMapFiles.assignAll(files),
                ),
                Gap(16.h),

                // Demarcation Certificate
             ImagePickerUtil.buildFileUploadField(
                  label: 'Demarcation certificate *',
                  hint: 'Upload demarcation certificate',
                  icon: PhosphorIcons.certificate(PhosphorIconsStyle.regular),
                  uploadedFiles: docController.demarcationCertificateFiles,
                  onFilesSelected: (files) => docController.demarcationCertificateFiles.assignAll(files),
                ),
              ],
            ),
          ),

          Gap(32.h),

          // Navigation Buttons
          SurveyUIUtils.buildNavigationButtons(mainController),


          Gap(40.h),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: SetuColors.primaryGreen,
            ),
          ),
          Gap(16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Gap(8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: error != null ? Colors.red : Colors.grey.shade300,
            ),
            color: Colors.grey.shade50,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: Text('Select option'),
              isExpanded: true,
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              )).toList(),
              onChanged: (newValue) {
                if (newValue != null) onChanged(newValue);
              },
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  double _getUploadProgress(SurveyEightController docController) {
    return _getUploadedCount(docController) / 7.0;
  }

  int _getUploadedCount(SurveyEightController docController) {
    int count = 0;
    if (docController.selectedIdentityType.value.isNotEmpty && docController.identityCardFiles.isNotEmpty) count++;
    if (docController.sevenTwelveFiles.isNotEmpty) count++;
    if (docController.noteFiles.isNotEmpty) count++;
    if (docController.partitionFiles.isNotEmpty) count++;
    if (docController.schemeSheetFiles.isNotEmpty) count++;
    if (docController.oldCensusMapFiles.isNotEmpty) count++;
    if (docController.demarcationCertificateFiles.isNotEmpty) count++;
    return count;
  }
}