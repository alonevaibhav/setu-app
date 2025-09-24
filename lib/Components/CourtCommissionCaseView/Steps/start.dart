import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../../CourtCommissionCaseView/Controller/personal_info_controller.dart';
import '../../Widget/address_view.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final CourtCommissionCaseController mainController;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the CourtCommissionController
  PersonalInfoController get controller => Get.find<PersonalInfoController>(tag: 'personal_info');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[0] ?? ['court_commission_details'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCourtCommissionDetails(context);
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'court_commission_details':
        return _buildCourtCommissionDetails(context);
      default:
        return _buildCourtCommissionDetails(context);
    }
  }

  Widget _buildCourtCommissionDetails(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtCommissionCaseUIUtils.buildStepHeader(
          'Court Commission Details',
          'Please provide court commission information',
        ),
        Gap(24.h),

        CourtCommissionCaseUIUtils.buildTextFormField(
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
        Obx(() => ApplicantAddressField(
          label: 'Applicant Address',
          isRequired: true,
          onTap: () => controller.showCourtAddressPopup(context),
          hasDetailedAddress: controller.hasDetailedCourtAddress(),
          buttonText: 'Enter Applicant Address',
          buttonIcon: PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
        )),

        Gap(16.h),

        // Name of the court that issued the court commission order
      CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.courtNameController,
          label: 'Name of the court that issued the court commission order *',
          hint: 'Enter court name',
          icon: PhosphorIcons.scales(PhosphorIconsStyle.regular),
          // errorText: controller.getFieldValidationError('court_name'),
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

        // Address of the court issuing the court commission order
     CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.courtAddressController,
          label: 'Address of the court issuing the court commission order *',
          hint: 'Enter court address',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          maxLines: 3,
          // errorText: controller.getFieldValidationError('court_address'),
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

        // Court Commission Order No.
     CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.commissionOrderNoController,
          label: 'Court Commission Order No. *',
          hint: 'Enter commission order number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          // errorText: controller.getFieldValidationError('commission_order_no'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Commission order number is required';
            }
            if (value.trim().length < 3) {
              return 'Order number must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Court Commission dated
        CourtCommissionCaseUIUtils.buildDatePickerField(
          controller: controller.commissionDateController,
          label: 'Court Commission dated *',
          hint: 'dd-mm-yyyy',
          icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
          // errorText: controller.getFieldValidationError('commission_date'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Commission date is required';
            }
            return null;
          },
          onDateSelected: (DateTime selectedDate) {
            controller.updateCommissionDate(selectedDate);
          },
        ),
        Gap(16.h),

        // Civil claim in the Court Commission case Re. D. M. No. Serial No.
        CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.civilClaimController,
          label: 'Civil claim in the Court Commission case Re. D. M. No. Serial No. *',
          hint: 'Enter civil claim details with reference numbers',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          maxLines: 3,
        ),
        Gap(16.h),

        // Name and address of the office issuing the court commission order
         CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.issuingOfficeController,
          label: 'Name and address of the office issuing the court commission order *',
          hint: 'Enter issuing office name and address',
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
          maxLines: 3,
          errorText: controller.getFieldValidationError('issuing_office'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Issuing office details are required';
            }
            if (value.trim().length < 5) {
              return 'Office details must be at least 5 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Upload Court Commission Order
        ImagePickerUtil.buildFileUploadField(
          label: 'Upload Court Commission Order *',
          hint: 'Upload court commission order document',
          icon: PhosphorIcons.fileArrowUp(PhosphorIconsStyle.regular),
          uploadedFiles: controller.commissionOrderFiles,
          onFilesSelected: (files) => controller.commissionOrderFiles.assignAll(files),
        ),
        Gap(32.h),

        // Navigation buttons
        CourtCommissionCaseUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }
}




