//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import 'package:setuapp/Components/LandAcquisitionCalculationApplication/Steps/survey_ui_utils.dart';
// import '../../../Utils/custimize_image_picker.dart';
// import '../land_acquisition_calculation_controller.dart';
//
// class ZeroInfoStep extends StatelessWidget {
//   final int currentSubStep;
//   final LandAcquisitionController controller;
//
//   const ZeroInfoStep({
//     Key? key,
//     required this.currentSubStep,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAqUIUtils.buildStepHeader(
//           'Land Acquisition Calculation Application',
//           'Please provide the required land acquisition details',
//         ),
//         Gap(24.h),
//
//         // Land Acquisition Officer/Office
//         LandAqUIUtils.buildTextFormField(
//           controller: controller.landAcquisitionOfficerController,
//           label: 'Name of Land Acquisition Officer/Office *',
//           hint: 'Enter officer/office name',
//           icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.name,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Land Acquisition Officer/Office name is required';
//             }
//             if (value.trim().length < 2) {
//               return 'Name must be at least 2 characters';
//             }
//             return null;
//           },
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Land Acquisition Board Name and Address
//         LandAqUIUtils.buildTextFormField(
//           controller: controller.landAcquisitionBoardController,
//           label: 'Name and address of Land Acquisition Board *',
//           hint: 'Enter board name and complete address',
//           icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.multiline,
//           maxLines: 2,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Land Acquisition Board details are required';
//             }
//             if (value.trim().length < 10) {
//               return 'Please provide complete name and address';
//             }
//             return null;
//           },
//         ),
//         Gap(24.h * LandAqUIUtils.sizeFactor),
//
//         // Section Header for Land Acquisition Details
//         LandAqUIUtils.buildSectionHeader(
//           title: 'Land Acquisition Details',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Land Acquisition Order/Proposal Number
//         LandAqUIUtils.buildTextFormField(
//           controller: controller.landAcquisitionOrderNumberController,
//           label: 'Land Acquisition Order/Proposal Number *',
//           hint: 'Enter order/proposal number',
//           icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.text,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Order/Proposal number is required';
//             }
//             if (value.trim().length < 3) {
//               return 'Number must be at least 3 characters';
//             }
//             return null;
//           },
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Date of Land Acquisition Order/Proposal
//         LandAqUIUtils.buildDatePickerField(
//           controller: controller.landAcquisitionOrderDateController,
//           label: 'Date of Land Acquisition Order/Proposal *',
//           hint: 'Select order/proposal date',
//           icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Order/Proposal date is required';
//             }
//             return null;
//           },
//           onDateSelected: (DateTime selectedDate) {
//             print('Selected date: $selectedDate');
//           },
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Name and address of issuing office
//         LandAqUIUtils.buildTextFormField(
//           controller: controller.issuingOfficeController,
//           label: 'Name and address of the office issuing the land acquisition order',
//           hint: 'Enter issuing office name and address',
//           icon: PhosphorIcons.bank(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.multiline,
//           maxLines: 3,
//           validator: (value) {
//             if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
//               return 'Please provide complete office details';
//             }
//             return null;
//           },
//         ),
//
//         Gap(24.h * LandAqUIUtils.sizeFactor),
//
//         // Section Header for Document Uploads
//         ImagePickerUtil.buildSectionHeader(
//           title: 'Document Uploads',
//           icon: PhosphorIcons.upload(PhosphorIconsStyle.regular),
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Upload Land Acquisition Order/Proposal - CLEAN VERSION
//         ImagePickerUtil.buildFileUploadField(
//           label: 'Upload Land Acquisition Order/Proposal *',
//           hint: 'Upload images or documents',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           uploadedFiles: controller.landAcquisitionOrderFiles,
//           onFilesSelected: (files) => controller.landAcquisitionOrderFiles.assignAll(files),
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Upload Proposed Land Acquisition Site Map - CLEAN VERSION
//         ImagePickerUtil.buildFileUploadField(
//           label: 'Proposed Land Acquisition Site Map *',
//           hint: 'Upload site map images or documents',
//           icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//           uploadedFiles: controller.proposedLandSiteMapFiles,
//           onFilesSelected: (files) => controller.proposedLandSiteMapFiles.assignAll(files),
//         ),
//         Gap(16.h * LandAqUIUtils.sizeFactor),
//
//         // Upload KML File - CLEAN VERSION
//         ImagePickerUtil.buildFileUploadField(
//           label: 'KML File of proposed land acquisition scheme *',
//           hint: 'Upload KML files or related documents',
//           icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
//           uploadedFiles: controller.kmlFiles,
//           onFilesSelected: (files) => controller.kmlFiles.assignAll(files),
//         ),
//
//         Gap(32.h * LandAqUIUtils.sizeFactor),
//         LandAqUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandAcquisitionCalculationApplication/Steps/survey_ui_utils.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../land_acquisition_calculation_controller.dart';

class ZeroInfoStep extends StatelessWidget {
  final int currentSubStep;
  final LandAcquisitionController controller;

  const ZeroInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = controller.stepConfigurations[0] ?? [
      'land_acquisition_officer',
      'land_acquisition_board',
      'acquisition_order_number',
      'acquisition_order_date',
      'issuing_office',
      'order_document_upload',
      'site_map_upload',
      'kml_file_upload',
    ];

    if (currentSubStep >= subSteps.length) {
      return _buildLandAcquisitionOfficerInput(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'land_acquisition_officer':
        return _buildLandAcquisitionOfficerInput();
      case 'land_acquisition_board':
        return _buildLandAcquisitionBoardInput();
      case 'acquisition_order_number':
        return _buildAcquisitionOrderNumberInput();
      case 'acquisition_order_date':
        return _buildAcquisitionOrderDateInput();
      case 'issuing_office':
        return _buildIssuingOfficeInput();
      case 'order_document_upload':
        return _buildOrderDocumentUploadInput();
      case 'site_map_upload':
        return _buildSiteMapUploadInput();
      case 'kml_file_upload':
        return _buildKmlFileUploadInput();
      default:
        return _buildLandAcquisitionOfficerInput();
    }
  }

  Widget _buildLandAcquisitionOfficerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Land Acquisition Officer Information',
          'Enter the name of Land Acquisition Officer/Office',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.landAcquisitionOfficerController,
          label: 'Name of Land Acquisition Officer/Office *',
          hint: 'Enter officer/office name',
          icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Land Acquisition Officer/Office name is required';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildLandAcquisitionBoardInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Land Acquisition Board Information',
          'Enter the name and address of Land Acquisition Board',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.landAcquisitionBoardController,
          label: 'Name and address of Land Acquisition Board *',
          hint: 'Enter board name and complete address',
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Land Acquisition Board details are required';
            }
            if (value.trim().length < 10) {
              return 'Please provide complete name and address';
            }
            return null;
          },
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildAcquisitionOrderNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Land Acquisition Order Information',
          'Enter the Land Acquisition Order/Proposal Number',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.landAcquisitionOrderNumberController,
          label: 'Land Acquisition Order/Proposal Number *',
          hint: 'Enter order/proposal number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Order/Proposal number is required';
            }
            if (value.trim().length < 3) {
              return 'Number must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildAcquisitionOrderDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Land Acquisition Order Date',
          'Select the date of Land Acquisition Order/Proposal',
        ),
        Gap(24.h),
        LandAqUIUtils.buildDatePickerField(
          controller: controller.landAcquisitionOrderDateController,
          label: 'Date of Land Acquisition Order/Proposal *',
          hint: 'Select order/proposal date',
          icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Order/Proposal date is required';
            }
            return null;
          },
          onDateSelected: (DateTime selectedDate) {
            print('Selected date: $selectedDate');
          },
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildIssuingOfficeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Issuing Office Information',
          'Enter the name and address of the issuing office',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.issuingOfficeController,
          label: 'Name and address of the office issuing the land acquisition order',
          hint: 'Enter issuing office name and address',
          icon: PhosphorIcons.bank(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
              return 'Please provide complete office details';
            }
            return null;
          },
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildOrderDocumentUploadInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Upload Land Acquisition Order',
          'Upload the Land Acquisition Order/Proposal documents',
        ),
        Gap(24.h),
        ImagePickerUtil.buildFileUploadField(
          label: 'Upload Land Acquisition Order/Proposal *',
          hint: 'Upload images or documents',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          uploadedFiles: controller.landAcquisitionOrderFiles,
          onFilesSelected: (files) => controller.landAcquisitionOrderFiles.assignAll(files),
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildSiteMapUploadInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Upload Site Map',
          'Upload the Proposed Land Acquisition Site Map',
        ),
        Gap(24.h),
        ImagePickerUtil.buildFileUploadField(
          label: 'Proposed Land Acquisition Site Map *',
          hint: 'Upload site map images or documents',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          uploadedFiles: controller.proposedLandSiteMapFiles,
          onFilesSelected: (files) => controller.proposedLandSiteMapFiles.assignAll(files),
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildKmlFileUploadInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Upload KML File',
          'Upload the KML file of proposed land acquisition scheme',
        ),
        Gap(24.h),
        ImagePickerUtil.buildFileUploadField(
          label: 'KML File of proposed land acquisition scheme *',
          hint: 'Upload KML files or related documents',
          icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
          uploadedFiles: controller.kmlFiles,
          onFilesSelected: (files) => controller.kmlFiles.assignAll(files),
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }
}