// // lib/features/survey/views/widgets/survey_step_widget.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../../Constants/color_constant.dart';
//
//
//
// class SurveyStepWidget extends StatefulWidget {
//   final int currentStep;
//
//   const SurveyStepWidget({Key? key, required this.currentStep}) : super(key: key);
//
//   @override
//   State<SurveyStepWidget> createState() => _SurveyStepWidgetState();
// }
//
// class _SurveyStepWidgetState extends State<SurveyStepWidget> {
//   // Form Controllers
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();
//   final addressController = TextEditingController();
//   final remarksController = TextEditingController();
//
//   // Dropdown Values
//   String selectedGender = '';
//   String selectedCategory = '';
//   String selectedState = '';
//
//   // Image Upload
//   final ImagePicker _picker = ImagePicker();
//   List<File> selectedImages = [];
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     addressController.dispose();
//     remarksController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     switch (widget.currentStep) {
//       case 0:
//         return _buildStartStep();
//       case 1:
//         return _buildSurveyCTSStep();
//       case 2:
//         return _buildSurveyInformationStep();
//       default:
//         return _buildStartStep();
//     }
//   }
//
//   Widget _buildStartStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildStepTitle('Personal Information', 'Enter your basic details'),
//         Gap(24.h),
//
//         // Name Input
//         _buildTextFormField(
//           controller: nameController,
//           label: 'Full Name',
//           hint: 'Enter your full name',
//           icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.name,
//         ),
//         Gap(16.h),
//
//         // Phone Input
//         _buildTextFormField(
//           controller: phoneController,
//           label: 'Mobile Number',
//           hint: 'Enter 10-digit mobile number',
//           icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.phone,
//           maxLength: 10,
//         ),
//         Gap(16.h),
//
//         // Email Input
//         _buildTextFormField(
//           controller: emailController,
//           label: 'Email Address',
//           hint: 'Enter your email address',
//           icon: PhosphorIcons.envelope(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.emailAddress,
//         ),
//         Gap(16.h),
//
//         // Gender Dropdown
//         _buildDropdownField(
//           label: 'Gender',
//           value: selectedGender,
//           items: ['Male', 'Female', 'Other'],
//           onChanged: (value) => setState(() => selectedGender = value ?? ''),
//           icon: PhosphorIcons.genderIntersex(PhosphorIconsStyle.regular),
//         ),
//         Gap(16.h),
//
//         // Category Dropdown
//         _buildDropdownField(
//           label: 'Category',
//           value: selectedCategory,
//           items: ['General', 'OBC', 'SC', 'ST'],
//           onChanged: (value) => setState(() => selectedCategory = value ?? ''),
//           icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSurveyCTSStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildStepTitle('Survey/CTS Information', 'Survey and mapping details'),
//         Gap(24.h),
//
//         // Address Input
//         _buildTextFormField(
//           controller: addressController,
//           label: 'Property Address',
//           hint: 'Enter complete property address',
//           icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.streetAddress,
//           maxLines: 3,
//         ),
//         Gap(16.h),
//
//         // State Dropdown
//         _buildDropdownField(
//           label: 'State',
//           value: selectedState,
//           items: ['Maharashtra', 'Gujarat', 'Karnataka', 'Tamil Nadu', 'Other'],
//           onChanged: (value) => setState(() => selectedState = value ?? ''),
//           icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
//         ),
//         Gap(16.h),
//
//         // Survey Type Selection
//         _buildSurveyTypeSelection(),
//         Gap(16.h),
//
//         // Document Upload Section
//         _buildDocumentUploadSection(),
//       ],
//     );
//   }
//
//   Widget _buildSurveyInformationStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildStepTitle('Survey Information', 'Additional survey details'),
//         Gap(24.h),
//
//         // Survey Details
//         _buildTextFormField(
//           controller: remarksController,
//           label: 'Survey Remarks',
//           hint: 'Enter any additional remarks or observations',
//           icon: PhosphorIcons.notepad(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.multiline,
//           maxLines: 4,
//         ),
//         Gap(16.h),
//
//         // Survey Status
//         _buildSurveyStatusSection(),
//         Gap(16.h),
//
//         // Additional Images
//         _buildAdditionalImagesSection(),
//         Gap(16.h),
//
//         // Survey Summary
//         _buildSurveySummary(),
//       ],
//     );
//   }
//
//   Widget _buildStepTitle(String title, String subtitle) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 22.sp,
//             fontWeight: FontWeight.w700,
//             color: SetuColors.primaryGreen,
//           ),
//         ),
//         Gap(4.h),
//         Text(
//           subtitle,
//           style: GoogleFonts.poppins(
//             fontSize: 14.sp,
//             color: SetuColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     int? maxLength,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.textPrimary,
//           ),
//         ),
//         Gap(8.h),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           maxLength: maxLength,
//           style: GoogleFonts.poppins(fontSize: 16.sp),
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: Icon(icon, color: SetuColors.primaryGreen, size: 20.w),
//             filled: true,
//             fillColor: SetuColors.background,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide(color: SetuColors.primaryGreen, width: 2),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String label,
//     required String value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//     required IconData icon,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.textPrimary,
//           ),
//         ),
//         Gap(8.h),
//         DropdownButtonFormField<String>(
//           value: value.isEmpty ? null : value,
//           items: items.map((item) => DropdownMenuItem(
//             value: item,
//             child: Text(item, style: GoogleFonts.poppins(fontSize: 16.sp)),
//           )).toList(),
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon, color: SetuColors.primaryGreen, size: 20.w),
//             filled: true,
//             fillColor: SetuColors.background,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide(color: SetuColors.primaryGreen, width: 2),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSurveyTypeSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Survey Type',
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.textPrimary,
//           ),
//         ),
//         Gap(12.h),
//         Row(
//           children: [
//             Expanded(
//               child: _buildRadioOption('CTS Survey', 'cts'),
//             ),
//             Gap(16.w),
//             Expanded(
//               child: _buildRadioOption('Revenue Survey', 'revenue'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRadioOption(String title, String value) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: SetuColors.background,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: SetuColors.lightGreen.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(PhosphorIcons.circle(PhosphorIconsStyle.regular), color: SetuColors.primaryGreen, size: 16.w),
//           Gap(8.w),
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp,
//               color: SetuColors.textPrimary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDocumentUploadSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Upload Documents',
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.textPrimary,
//           ),
//         ),
//         Gap(12.h),
//         GestureDetector(
//           onTap: _pickImage,
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(24.w),
//             decoration: BoxDecoration(
//               color: SetuColors.background,
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(
//                 color: SetuColors.lightGreen.withOpacity(0.3),
//                 style: BorderStyle.solid,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   PhosphorIcons.camera(PhosphorIconsStyle.regular),
//                   color: SetuColors.primaryGreen,
//                   size: 32.w,
//                 ),
//                 Gap(8.h),
//                 Text(
//                   'Tap to upload documents',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14.sp,
//                     color: SetuColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (selectedImages.isNotEmpty) ...[
//           Gap(12.h),
//           _buildImagePreview(),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildSurveyStatusSection() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: SetuColors.success.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: SetuColors.success.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.regular), color: SetuColors.success, size: 20.w),
//           Gap(12.w),
//           Text(
//             'Survey Status: In Progress',
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: SetuColors.success,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAdditionalImagesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Additional Images',
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.textPrimary,
//           ),
//         ),
//         Gap(12.h),
//         GestureDetector(
//           onTap: _pickMultipleImages,
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20.w),
//             decoration: BoxDecoration(
//               color: SetuColors.background,
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(
//                 color: SetuColors.lightGreen.withOpacity(0.3),
//                 style: BorderStyle.solid,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   PhosphorIcons.images(PhosphorIconsStyle.regular),
//                   color: SetuColors.primaryGreen,
//                   size: 28.w,
//                 ),
//                 Gap(8.h),
//                 Text(
//                   'Add more images',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14.sp,
//                     color: SetuColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSurveySummary() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: SetuColors.primaryGreen.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Survey Summary',
//             style: GoogleFonts.poppins(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: SetuColors.primaryGreen,
//             ),
//           ),
//           Gap(16.h),
//           _buildSummaryRow('Name', nameController.text.isNotEmpty ? nameController.text : 'Not provided'),
//           _buildSummaryRow('Phone', phoneController.text.isNotEmpty ? phoneController.text : 'Not provided'),
//           _buildSummaryRow('Email', emailController.text.isNotEmpty ? emailController.text : 'Not provided'),
//           _buildSummaryRow('Gender', selectedGender.isNotEmpty ? selectedGender : 'Not selected'),
//           _buildSummaryRow('Category', selectedCategory.isNotEmpty ? selectedCategory : 'Not selected'),
//           _buildSummaryRow('State', selectedState.isNotEmpty ? selectedState : 'Not selected'),
//           _buildSummaryRow('Documents', '${selectedImages.length} uploaded'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSummaryRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100.w,
//             child: Text(
//               '$label:',
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//                 color: SetuColors.textPrimary,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 color: SetuColors.textSecondary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImagePreview() {
//     return Container(
//       height: 100.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: selectedImages.length,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: EdgeInsets.only(right: 12.w),
//             width: 100.w,
//             height: 100.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.r),
//               image: DecorationImage(
//                 image: FileImage(selectedImages[index]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 4.h,
//                   right: 4.w,
//                   child: GestureDetector(
//                     onTap: () => _removeImage(index),
//                     child: Container(
//                       padding: EdgeInsets.all(4.w),
//                       decoration: BoxDecoration(
//                         color: SetuColors.error,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         PhosphorIcons.x(PhosphorIconsStyle.regular),
//                         color: Colors.white,
//                         size: 12.w,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         setState(() {
//           selectedImages.add(File(image.path));
//         });
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick image: $e',
//         backgroundColor: SetuColors.error,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> _pickMultipleImages() async {
//     try {
//       final List<XFile> images = await _picker.pickMultiImage(
//         imageQuality: 80,
//       );
//       if (images.isNotEmpty) {
//         setState(() {
//           selectedImages.addAll(images.map((image) => File(image.path)));
//         });
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to pick images: $e',
//         backgroundColor: SetuColors.error,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   void _removeImage(int index) {
//     setState(() {
//       selectedImages.removeAt(index);
//     });
//   }
// }

// lib/features/survey/views/widgets/survey_step_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../Constants/color_constant.dart';
import '../../Controller/land_survey_controller.dart';

class SurveyStepWidget extends StatefulWidget {
  final int currentStep;
  final int currentSubStep;
  final SurveyController controller;

  const SurveyStepWidget({
    Key? key,
    required this.currentStep,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  State<SurveyStepWidget> createState() => _SurveyStepWidgetState();
}

class _SurveyStepWidgetState extends State<SurveyStepWidget> {
  // Image Upload
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  List<File> documentImages = [];

  @override
  Widget build(BuildContext context) {
    switch (widget.currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildSurveyCTSStep();
      case 2:
        return _buildSurveyInformationStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    final subSteps = ['name', 'phone', 'email', 'gender', 'category'];

    final currentField = subSteps[widget.currentSubStep];

    switch (currentField) {
      case 'name':
        return _buildNameInput();
      case 'phone':
        return _buildPhoneInput();
      case 'email':
        return _buildEmailInput();
      case 'gender':
        return _buildGenderInput();
      case 'category':
        return _buildCategoryInput();
      default:
        return _buildNameInput();
    }
  }

  Widget _buildSurveyCTSStep() {
    final subSteps = ['address', 'state', 'surveyType', 'documents'];

    final currentField = subSteps[widget.currentSubStep];

    switch (currentField) {
      case 'address':
        return _buildAddressInput();
      case 'state':
        return _buildStateInput();
      case 'surveyType':
        return _buildSurveyTypeInput();
      case 'documents':
        return _buildDocumentUpload();
      default:
        return _buildAddressInput();
    }
  }

  Widget _buildSurveyInformationStep() {
    final subSteps = ['remarks', 'status', 'images', 'summary'];

    final currentField = subSteps[widget.currentSubStep];

    switch (currentField) {
      case 'remarks':
        return _buildRemarksInput();
      case 'status':
        return _buildSurveyStatus();
      case 'images':
        return _buildAdditionalImages();
      case 'summary':
        return _buildSurveySummary();
      default:
        return _buildRemarksInput();
    }
  }

  // Personal Info Sub-steps
  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Personal Information', 'What is your full name?'),
        Gap(24.h),
        _buildTextFormField(
          controller: widget.controller.nameController,
          label: 'Full Name',
          hint: 'Enter your complete name',
          icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Contact Information', 'What is your mobile number?'),
        Gap(24.h),
        _buildTextFormField(
          controller: widget.controller.phoneController,
          label: 'Mobile Number',
          hint: 'Enter 10-digit mobile number',
          icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          validator: (value) {
            if (value == null ||
                value.length != 10 ||
                !RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Phone must be exactly 10 digits';
            }
            return null;
          },
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Contact Information', 'What is your email address?'),
        Gap(24.h),
        _buildTextFormField(
          controller: widget.controller.emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: PhosphorIcons.envelope(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null ||
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildGenderInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Personal Details', 'Select your gender'),
        Gap(24.h),
        Obx(() => _buildDropdownField(
              label: 'Gender',
              value: widget.controller.selectedGender.value,
              items: ['Male', 'Female', 'Other'],
              onChanged: widget.controller.updateGender,
              icon: PhosphorIcons.genderIntersex(PhosphorIconsStyle.regular),
            )),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildCategoryInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Personal Details', 'Select your category'),
        Gap(24.h),
        Obx(() => _buildDropdownField(
              label: 'Category',
              value: widget.controller.selectedCategory.value,
              items: ['General', 'OBC', 'SC', 'ST'],
              onChanged: widget.controller.updateCategory,
              icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
            )),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  // Survey/CTS Sub-steps
  Widget _buildAddressInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
            'Property Information', 'What is the property address?'),
        Gap(24.h),
        _buildTextFormField(
          controller: widget.controller.addressController,
          label: 'Property Address',
          hint: 'Enter complete property address',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.streetAddress,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().length < 10) {
              return 'Address must be at least 10 characters';
            }
            return null;
          },
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildStateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Location Details', 'Select your state'),
        Gap(24.h),
        Obx(() => _buildDropdownField(
              label: 'State',
              value: widget.controller.selectedState.value,
              items: [
                'Maharashtra',
                'Gujarat',
                'Karnataka',
                'Tamil Nadu',
                'Rajasthan',
                'Other'
              ],
              onChanged: widget.controller.updateState,
              icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
            )),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildSurveyTypeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Survey Type', 'Select the type of survey'),
        Gap(24.h),
        Obx(() => _buildDropdownField(
              label: 'Survey Type',
              value: widget.controller.selectedSurveyType.value,
              items: [
                'CTS Survey',
                'Revenue Survey',
                'Boundary Survey',
                'Topographical Survey'
              ],
              onChanged: widget.controller.updateSurveyType,
              icon: PhosphorIcons.clipboard(PhosphorIconsStyle.regular),
            )),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildDocumentUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Document Upload', 'Upload required documents'),
        Gap(24.h),

        // Document Upload Section
        GestureDetector(
          onTap: null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: SetuColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: SetuColors.lightGreen.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  PhosphorIcons.camera(PhosphorIconsStyle.regular),
                  color: SetuColors.primaryGreen,
                  size: 32.w,
                ),
                Gap(8.h),
                Text(
                  'Tap to upload documents',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: SetuColors.textSecondary,
                  ),
                ),
                if (documentImages.isNotEmpty)
                  Text(
                    '${documentImages.length} document(s) uploaded',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: SetuColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),

        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  // Survey Information Sub-steps
  Widget _buildRemarksInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Survey Remarks', 'Enter any additional remarks'),
        Gap(24.h),
        _buildTextFormField(
          controller: widget.controller.remarksController,
          label: 'Survey Remarks',
          hint: 'Enter any additional remarks or observations',
          icon: PhosphorIcons.notepad(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().length < 5) {
              return 'Remarks must be at least 5 characters';
            }
            return null;
          },
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildSurveyStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Survey Status', 'Current survey status'),
        Gap(24.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: SetuColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: SetuColors.success.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
                  color: SetuColors.success, size: 24.w),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Survey Status: In Progress',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: SetuColors.success,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      'All required information has been collected',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: SetuColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildAdditionalImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
            'Additional Images', 'Upload additional survey images'),
        Gap(24.h),
        GestureDetector(
          onTap: null,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: SetuColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: SetuColors.lightGreen.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  PhosphorIcons.images(PhosphorIconsStyle.regular),
                  color: SetuColors.primaryGreen,
                  size: 32.w,
                ),
                Gap(8.h),
                Text(
                  'Tap to add survey images',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: SetuColors.textSecondary,
                  ),
                ),
                if (selectedImages.isNotEmpty)
                  Text(
                    '${selectedImages.length} image(s) added',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: SetuColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildSurveySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader('Survey Summary', 'Review your information'),
        Gap(24.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: SetuColors.primaryGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Survey Information',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: SetuColors.primaryGreen,
                ),
              ),
              Gap(16.h),

              // Personal Information
              _buildSummarySection('Personal Information', [
                _buildSummaryRow(
                    'Name',
                    widget.controller.nameController.text.isNotEmpty
                        ? widget.controller.nameController.text
                        : 'Not provided'),
                _buildSummaryRow(
                    'Phone',
                    widget.controller.phoneController.text.isNotEmpty
                        ? widget.controller.phoneController.text
                        : 'Not provided'),
                _buildSummaryRow(
                    'Email',
                    widget.controller.emailController.text.isNotEmpty
                        ? widget.controller.emailController.text
                        : 'Not provided'),
                _buildSummaryRow(
                    'Gender',
                    widget.controller.selectedGender.value.isNotEmpty
                        ? widget.controller.selectedGender.value
                        : 'Not selected'),
                _buildSummaryRow(
                    'Category',
                    widget.controller.selectedCategory.value.isNotEmpty
                        ? widget.controller.selectedCategory.value
                        : 'Not selected'),
              ]),

              Gap(16.h),

              // Survey Information
              _buildSummarySection('Survey Information', [
                _buildSummaryRow(
                    'Address',
                    widget.controller.addressController.text.isNotEmpty
                        ? widget.controller.addressController.text
                        : 'Not provided'),
                _buildSummaryRow(
                    'State',
                    widget.controller.selectedState.value.isNotEmpty
                        ? widget.controller.selectedState.value
                        : 'Not selected'),
                _buildSummaryRow(
                    'Survey Type',
                    widget.controller.selectedSurveyType.value.isNotEmpty
                        ? widget.controller.selectedSurveyType.value
                        : 'Not selected'),
                _buildSummaryRow(
                    'Documents', '${documentImages.length} uploaded'),
                _buildSummaryRow(
                    'Additional Images', '${selectedImages.length} uploaded'),
                _buildSummaryRow(
                    'Remarks',
                    widget.controller.remarksController.text.isNotEmpty
                        ? widget.controller.remarksController.text
                        : 'Not provided'),
              ]),
            ],
          ),
        ),
        Gap(32.h),
        _buildNavigationButtons(),
      ],
    );
  }

  // Helper Widgets
  Widget _buildStepHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(6.h),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: SetuColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          style: GoogleFonts.poppins(fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: SetuColors.primaryGreen, size: 20.w),
            filled: true,
            fillColor: SetuColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: SetuColors.primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: SetuColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: SetuColors.error, width: 2),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child:
                        Text(item, style: GoogleFonts.poppins(fontSize: 16.sp)),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: SetuColors.primaryGreen, size: 20.w),
            filled: true,
            fillColor: SetuColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: SetuColors.primaryGreen, width: 2),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(() => Row(
          children: [
            // Previous Button
            if (widget.controller.currentStep.value > 0 ||
                widget.controller.currentSubStep.value > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.controller.previousSubStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SetuColors.textSecondary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            if (widget.controller.currentStep.value > 0 ||
                widget.controller.currentSubStep.value > 0)
              Gap(16.w),

            // Next/Submit Button
            Expanded(
              flex: (widget.controller.currentStep.value == 0 &&
                      widget.controller.currentSubStep.value == 0)
                  ? 1
                  : 1,
              child: ElevatedButton(
                onPressed: widget.controller.isLoading.value
                    ? null
                    : widget.controller.nextSubStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SetuColors.primaryGreen,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: widget.controller.isLoading.value
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.controller.nextButtonText,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ));
  }

  Widget _buildSummarySection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(8.h),
        ...rows,
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: SetuColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: SetuColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
