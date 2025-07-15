import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../Controller/main_controller.dart';
import '../Controller/personal_info_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController mainController;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the PersonalInfoController
  PersonalInfoController get controller =>
      Get.find<PersonalInfoController>(tag: 'personal_info');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[0] ?? ['government_counting_details'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildGovernmentCountingDetails(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'government_counting_details':
        return _buildGovernmentCountingDetails();
      default:
        return _buildGovernmentCountingDetails();
    }
  }

  Widget _buildGovernmentCountingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildStepHeader(
          'Government Counting Details',
          'Please provide government counting information',
        ),
        Gap(24.h),

        // Name of the officer who issued the order regarding the government count
        GovernmentCensusUIUtils.buildTextFormField(
          controller: controller.governmentCountingOfficerController,
          label: 'Name of the officer who issued the order regarding the government count *',
          hint: 'Enter officer name',
          icon: PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Officer name is required';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Address of the officer giving orders regarding government counting
        GovernmentCensusUIUtils.buildTextFormField(
          controller: controller.governmentCountingOfficerAddressController,
          label: 'Address of the officer giving orders regarding government counting *',
          hint: 'Enter officer address',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Officer address is required';
            }
            if (value.trim().length < 5) {
              return 'Address must be at least 5 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Government Counting Order Number
        GovernmentCensusUIUtils.buildTextFormField(
          controller: controller.governmentCountingOrderNumberController,
          label: 'Government Counting Order Number *',
          hint: 'Enter order number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Order number is required';
            }
            if (value.trim().length < 3) {
              return 'Order number must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Date of Government Counting Order
        GovernmentCensusUIUtils.buildDatePickerField(
          controller: controller.governmentCountingOrderDateController,
          label: 'Date of Government Counting Order *',
          hint: 'dd-mm-yyyy',
          icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Order date is required';
            }
            return null;
          },
          onDateSelected: (DateTime selectedDate) {
            controller.updateGovernmentCountingOrderDate(selectedDate);
          },
        ),
        Gap(16.h),

        // Counting Applicant Name
        GovernmentCensusUIUtils.buildTextFormField(
          controller: controller.countingApplicantNameController,
          label: 'Counting Applicant Name',
          hint: 'Enter applicant name',
          icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value != null && value.trim().isNotEmpty && value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Address of the applicant for the census
        GovernmentCensusUIUtils.buildTextFormField(
          controller: controller.countingApplicantAddressController,
          label: 'Address of the applicant for the census',
          hint: 'Enter applicant address',
          icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
          maxLines: 3,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
              return 'Address must be at least 5 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Details regarding government counting
        GovernmentCensusUIUtils.buildTextFormField(
          controller: controller.governmentCountingDetailsController,
          label: 'Details regarding government counting *',
          hint: 'Enter detailed government counting information',
          icon: PhosphorIcons.info(PhosphorIconsStyle.regular),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Government counting details are required';
            }
            if (value.trim().length < 10) {
              return 'Details must be at least 10 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Upload Government Counting Order
        ImagePickerUtil.buildFileUploadField(
          label: 'Upload Government Counting Order *',
          hint: 'Upload counting order document',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          uploadedFiles: controller.governmentCountingOrderFiles,
          onFilesSelected: (files) =>
              controller.governmentCountingOrderFiles.assignAll(files),
        ),
        Gap(32.h),

        GovernmentCensusUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }
}