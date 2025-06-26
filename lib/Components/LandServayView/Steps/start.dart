import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandServayView/Steps/survey_ui_utils.dart';
import '../../../Controller/land_survey_controller.dart';
import '../../../Constants/color_constant.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final SurveyController controller;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the substeps from controller configuration
    final subSteps = controller.stepConfigurations[0] ??
        ['holder_verification', 'enumeration_check'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildHolderVerification(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'holder_verification':
        return _buildHolderVerification();
      case 'enumeration_check':
        return _buildEnumerationCheck();
      default:
        return _buildHolderVerification();
    }
  }

  Widget _buildHolderVerification() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurveyUIUtils.buildStepHeader(
              'Holder Verification',
              'Please confirm your status as the holder',
            ),
            Gap(24.h),

            // Question 1: Are you the holder yourself?
            SurveyUIUtils.buildQuestionCard(
              question: 'Note: Are you the holder yourself?',
              selectedValue: controller.isHolderThemselves.value,
              onChanged: (value) {
                controller.isHolderThemselves.value = value;
                // Reset subsequent values when this changes
                controller.hasAuthorityOnBehalf.value = null;
                controller.applicantNameController.clear();
                controller.applicantPhoneController.clear();
                controller.relationshipController.clear();
                controller.relationshipWithApplicantController.clear();
              },
            ),

            Gap(16.h),

            // Conditional Question 2: Authority on behalf
            if (controller.isHolderThemselves.value == false) ...[
              SurveyUIUtils.buildQuestionCard(
                question:
                    'Note: Are you holding the authority on behalf of the applicant?/or are you applying as a competent Gunthewari Regularization/Gunthewari Planning Authority?',
                selectedValue: controller.hasAuthorityOnBehalf.value,
                onChanged: (value) async {
                  controller.hasAuthorityOnBehalf.value = value;

                  if (value == true) {
                    // Show dialog when user selects Yes
                    await _showAuthorityConfirmationDialog();
                  } else {
                    // Clear the additional fields if user selects No
                    controller.applicantNameController.clear();
                    controller.applicantPhoneController.clear();
                    controller.relationshipController.clear();
                    controller.relationshipWithApplicantController.clear();
                  }
                },
              ),
              Gap(16.h),
            ],

            // Additional fields when has authority on behalf
            if (controller.isHolderThemselves.value == false &&
                controller.hasAuthorityOnBehalf.value == true) ...[
              _buildAdditionalFields(),
              Gap(16.h),
            ],
            Gap(32.h),
            SurveyUIUtils.buildNavigationButtons(controller),
          ],
        ));
  }

  Widget _buildEnumerationCheck() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurveyUIUtils.buildStepHeader(
              'Enumeration Status',
              'Has this property been enumerated before?',
            ),
            Gap(24.h),
            SurveyUIUtils.buildQuestionCard(
              question: 'Note: Has this been counted before?',
              selectedValue: controller.hasBeenCountedBefore.value,
              onChanged: (value) {
                controller.hasBeenCountedBefore.value = value;
              },
            ),
            Gap(32.h),
            SurveyUIUtils.buildNavigationButtons(controller),
          ],
        ));
  }

  Widget _buildAdditionalFields() {
    return Container(
      padding: EdgeInsets.all(16.w * SurveyUIUtils.sizeFactor),
      decoration: BoxDecoration(
        color: SetuColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r * SurveyUIUtils.sizeFactor),
        border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SurveyUIUtils.buildTranslatableText(
            text: 'Power of Attorney Details',
            style: GoogleFonts.poppins(
              fontSize: 18.sp * SurveyUIUtils.sizeFactor,
              fontWeight: FontWeight.w700,
              color: SetuColors.primaryGreen,
            ),
          ),
          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Power of Attorney Registration Number
          SurveyUIUtils.buildTextFormField(
            controller: controller.poaRegistrationNumberController, // Updated
            label: 'Power of Attorney / Registration Number',
            hint: 'Enter registration number',
            icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().length < 3) {
                return 'Registration number must be at least 3 characters';
              }
              return null;
            },
          ),
          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Power of Attorney Registration Date
          SurveyUIUtils.buildTextFormField(
            controller: controller.poaRegistrationDateController, // Updated
            label: 'Power of Attorney Registration Date',
            hint: 'Enter registration date',
            icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Registration date is required';
              }
              return null;
            },
          ),
          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Name of the holder issuing the power of attorney
          SurveyUIUtils.buildTextFormField(
            controller: controller.poaIssuerNameController, // Updated
            label: 'Name of the holder issuing the power of attorney',
            hint: 'Enter holder name',
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().length < 2) {
                return 'Holder name must be at least 2 characters';
              }
              return null;
            },
          ),
          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Name of the holder of the Power of Attorney
          SurveyUIUtils.buildTextFormField(
            controller: controller.poaHolderNameController, // Updated
            label: 'Name of the holder of the Power of Attorney',
            hint: 'Enter attorney holder name',
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().length < 2) {
                return 'Attorney holder name must be at least 2 characters';
              }
              return null;
            },
          ),
          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Address holding Power of Attorney
          SurveyUIUtils.buildTextFormField(
            controller: controller.poaHolderAddressController, // Updated
            label: 'Address holding Power of Attorney',
            hint: 'Enter full address',
            icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().length < 5) {
                return 'Address must be at least 5 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAuthorityConfirmationDialog() async {
    await SurveyUIUtils.showTranslatableDialog(
      context: Get.context!,
      title: 'Authority Confirmation',
      message:
          'You are applying for the enumeration as the holder of the Power of Attorney/Authority Letter or as the competent Gunthewari Regularization/Gunthewari Planning Authority on behalf of the holder of the Group No./Survey No./C. T. Survey No. for which you are applying. Fill in the necessary information.',
      primaryButtonText: 'Understood',
      icon: PhosphorIcons.warning(PhosphorIconsStyle.regular),
      iconColor: SetuColors.primaryGreen,
      onPrimaryPressed: () {
        Navigator.of(Get.context!).pop();
      },
      barrierDismissible: false,
    );
  }
}
