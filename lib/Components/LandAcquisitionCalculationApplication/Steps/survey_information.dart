import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:setuapp/Components/LandAcquisitionCalculationApplication/Steps/survey_ui_utils.dart';
import 'package:setuapp/Components/LandServayView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../../Controller/land_survey_controller.dart';
import '../land_acquisition_calculation_controller.dart';

class SurveyInfoStep extends StatelessWidget {
  final int currentSubStep;
  final LandAcquisitionController controller;

  const SurveyInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = controller.stepConfigurations[2] ?? ['remarks'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildRemarksInput(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'remarks':
        return _buildRemarksInput();
      case 'status':
        return _buildSurveyStatus();
      default:
        return _buildRemarksInput();
    }
  }

  Widget _buildRemarksInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Survey Remarks',
          'Enter any additional remarks',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.remarksController,
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
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildSurveyStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Survey Status',
          'Current survey status',
        ),
        Gap(24.h),
        LandAqUIUtils.buildStatusContainer(
          title: 'Survey Status: In Progress',
          subtitle: 'All required information has been collected',
          icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
          backgroundColor: SetuColors.success,
          iconColor: SetuColors.success,
          textColor: SetuColors.success,
        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }
}
