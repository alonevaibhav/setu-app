import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../../CourtAllocationCaseView/Controller/personal_info_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final CourtAllocationCaseController mainController;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the CourtAllocationController
  PersonalInfoController get controller => Get.find<PersonalInfoController>(tag: 'personal_info');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[0] ?? ['calculation'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCourtAllocationDetails();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'calculation':
        return _buildCourtAllocationDetails();
      default:
        return _buildCourtAllocationDetails();
    }
  }

  Widget _buildCourtAllocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtAllocationCaseUIUtils.buildStepHeader(
          'Court Allocation Calculation',
          'Please provide court allocation information',
        ),
        Gap(24.h),

        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.applicantNameController,
          label: 'Applicant Name',
          hint: 'Enter Your Name',
          icon: PhosphorIcons.identificationBadge(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.trim().length < 3) {
              return 'Please enter the name of the applicant';
            }
            return null;
          },
        ),
        Gap(16.h),
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.applicantAddressController,
          label: 'Applicant Address',
          hint: 'Enter Your Address',
          icon: PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.trim().length < 3) {
              return 'Please enter the Address of the applicant';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Name of the court issuing the court allocation order
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.courtNameController,
          label: 'Name of the court issuing the court allocation order *',
          hint: 'Enter court name',
          icon: PhosphorIcons.scales(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court name is required';
            }
            if (value.trim().length < 3) {
              return 'Court name must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Address of the court that issued the court allocation order
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.courtAddressController,
          label:
              'Address of the court that issued the court allocation order *',
          hint: 'Enter court address',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court address is required';
            }
            if (value.trim().length < 10) {
              return 'Address must be at least 10 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Court Allocation Order Number
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.courtOrderNumberController,
          label: 'Court Allocation Order Number *',
          hint: 'Enter order number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court order number is required';
            }
            if (value.trim().length < 3) {
              return 'Order number must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Court Allotment Date
        CourtAllocationCaseUIUtils.buildDatePickerField(
          controller: controller.courtAllotmentDateController,
          label: 'Court Allotment Date *',
          hint: 'dd-mm-yyyy',
          icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court allotment date is required';
            }
            return null;
          },
          onDateSelected: (DateTime selectedDate) {
            controller.updateCourtAllotmentDate(selectedDate);
          },
        ),
        Gap(16.h),

        // Claim Number and Year
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.claimNumberYearController,
          label: 'Claim Number and Year *',
          hint: 'Enter claim number and year',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Claim number and year is required';
            }
            if (value.trim().length < 4) {
              return 'Claim number and year must be at least 4 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Upload a copy of the court allocation order
        ImagePickerUtil.buildFileUploadField(
          label: 'Upload a copy of the court allocation order *',
          hint: 'Upload court allocation order document',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          uploadedFiles: controller.courtOrderFiles,
          onFilesSelected: (files) =>
              controller.courtOrderFiles.assignAll(files),
        ),
        Gap(16.h),

        // Special order/comments
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.specialOrderCommentsController,
          label:
              'If there is a special order of the court regarding the calculation of court allocation or if you have any comments on this matter, please mention it here *',
          hint: 'Enter special orders or comments',
          icon: PhosphorIcons.note(PhosphorIconsStyle.regular),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Special order or comments are required';
            }
            if (value.trim().length < 10) {
              return 'Comments must be at least 10 characters';
            }
            return null;
          },
        ),
        Gap(32.h),

        CourtAllocationCaseUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }
}
