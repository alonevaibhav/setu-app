
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:setuapp/Components/LandAcquisitionCalculationApplication/Steps/survey_ui_utils.dart';
import 'package:setuapp/Components/LandServayView/Steps/survey_ui_utils.dart';
import '../../../Controller/land_survey_controller.dart';
import '../land_acquisition_calculation_controller.dart';

class OneInfoStep extends StatelessWidget {
  final int currentSubStep;
  final LandAcquisitionController controller;

  const OneInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = controller.stepConfigurations[1] ?? ['survey_number',];

    if (currentSubStep >= subSteps.length) {
      return _buildVillageInput(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'survey_number':
        return _buildSurveyNumberInput();
      case 'department':
        return _buildDepartmentInput();
      case 'district':
        return _buildDistrictInput();
      case 'taluka':
        return _buildTalukaInput();
      case 'village':
        return _buildVillageInput();
      case 'office':
        return _buildOfficeInput();
      default:
        return _buildSurveyNumberInput();
    }
  }

  Widget _buildSurveyNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Group No./ Survey No./ C. T. Survey No./T. P. No. Information',
          'Enter Survey No./Gat No./CTS No.',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.surveyNumberController,
          label: 'Survey No./Gat No./CTS No.*',
          hint: 'Enter survey number',
          icon: PhosphorIcons.listNumbers(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.text,

        ),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildDepartmentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Department Information',
          'Select your department',
        ),
        Gap(24.h),
        Obx(() => LandAqUIUtils.buildDropdownField(
          label: 'Department*',

          value: controller.selectedDepartment.value,
          items: ['Revenue Department', 'Land Records Department'],
          onChanged: controller.updateDepartment,
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildDistrictInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Location Details',
          'Select your district',
        ),
        Gap(24.h),
        Obx(() => LandAqUIUtils.buildDropdownField(
          label: 'District*',
          value: controller.selectedDistrict.value,
          items: ['Pune', 'Mumbai', 'Nagpur', 'Thane'],
          onChanged: controller.updateDistrict,
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildTalukaInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Location Details',
          'Select your taluka',
        ),
        Gap(24.h),
        Obx(() => LandAqUIUtils.buildDropdownField(
          label: 'Taluka*',
          value: controller.selectedTaluka.value,
          items: ['Haveli', 'Mulshi', 'Pune City', 'Bhor'],
          onChanged: controller.updateTaluka,
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildVillageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Location Details',
          'Select your village',
        ),
        Gap(24.h),
        Obx(() => LandAqUIUtils.buildDropdownField(
          label: 'Village*',
          value: controller.selectedVillage.value,
          items: ['Khadakwasla', 'Sinhagad', 'Panshet', 'Lavasa'],
          onChanged: controller.updateVillage,
          icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildOfficeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Office Information',
          'Select your office',
        ),
        Gap(24.h),
        Obx(() => LandAqUIUtils.buildDropdownField(
          label: 'Office*',
          value: controller.selectedOffice.value,
          items: ['Tahsildar Office', 'Collector Office', 'Sub-Registrar Office'],
          onChanged: controller.updateOffice,
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }
}