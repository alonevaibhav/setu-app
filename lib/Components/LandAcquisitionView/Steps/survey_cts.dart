//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:setuapp/Components/LandServayView/Steps/ZLandAcquisitionUIUtils.dart';
// import '../../../Controller/land_survey_controller.dart';
//
// class SurveyCTSStep extends StatelessWidget {
//   final int currentSubStep;
//   final SurveyController controller;
//
//   const SurveyCTSStep({
//     Key? key,
//     required this.currentSubStep,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final subSteps = controller.stepConfigurations[1] ?? ['survey_number',];
//
//     if (currentSubStep >= subSteps.length) {
//       return _buildVillageInput(); // Fallback
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'survey_number':
//         return _buildSurveyNumberInput();
//       case 'department':
//         return _buildDepartmentInput();
//       case 'district':
//         return _buildDistrictInput();
//       case 'taluka':
//         return _buildTalukaInput();
//       case 'village':
//         return _buildVillageInput();
//       case 'office':
//         return _buildOfficeInput();
//       default:
//         return _buildSurveyNumberInput();
//     }
//   }
//
//   Widget _buildSurveyNumberInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAcquisitionUIUtils.buildStepHeader(
//           'Group No./ Survey No./ C. T. Survey No./T. P. No. Information',
//           'Enter Survey No./Gat No./CTS No.',
//         ),
//         Gap(24.h),
//         LandAcquisitionUIUtils.buildTextFormField(
//           controller: controller.surveyNumberController,
//           label: 'Survey No./Gat No./CTS No.*',
//           hint: 'Enter survey number',
//           icon: PhosphorIcons.listNumbers(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.text,
//
//         ),
//         Gap(32.h),
//         LandAcquisitionUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildDepartmentInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAcquisitionUIUtils.buildStepHeader(
//           'Department Information',
//           'Select your department',
//         ),
//         Gap(24.h),
//         Obx(() => LandAcquisitionUIUtils.buildDropdownField(
//           label: 'Department*',
//
//           value: controller.selectedDepartment.value,
//           items: ['Revenue Department', 'Land Records Department'],
//           onChanged: controller.updateDepartment,
//           icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
//         )),
//         Gap(32.h),
//         LandAcquisitionUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildDistrictInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAcquisitionUIUtils.buildStepHeader(
//           'Location Details',
//           'Select your district',
//         ),
//         Gap(24.h),
//         Obx(() => LandAcquisitionUIUtils.buildDropdownField(
//           label: 'District*',
//           value: controller.selectedDistrict.value,
//           items: ['Pune', 'Mumbai', 'Nagpur', 'Thane'],
//           onChanged: controller.updateDistrict,
//           icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//         )),
//         Gap(32.h),
//         LandAcquisitionUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildTalukaInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAcquisitionUIUtils.buildStepHeader(
//           'Location Details',
//           'Select your taluka',
//         ),
//         Gap(24.h),
//         Obx(() => LandAcquisitionUIUtils.buildDropdownField(
//           label: 'Taluka*',
//           value: controller.selectedTaluka.value,
//           items: ['Haveli', 'Mulshi', 'Pune City', 'Bhor'],
//           onChanged: controller.updateTaluka,
//           icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//         )),
//         Gap(32.h),
//         LandAcquisitionUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildVillageInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAcquisitionUIUtils.buildStepHeader(
//           'Location Details',
//           'Select your village',
//         ),
//         Gap(24.h),
//         Obx(() => LandAcquisitionUIUtils.buildDropdownField(
//           label: 'Village*',
//           value: controller.selectedVillage.value,
//           items: ['Khadakwasla', 'Sinhagad', 'Panshet', 'Lavasa'],
//           onChanged: controller.updateVillage,
//           icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
//         )),
//         Gap(32.h),
//         LandAcquisitionUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildOfficeInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LandAcquisitionUIUtils.buildStepHeader(
//           'Office Information',
//           'Select your office',
//         ),
//         Gap(24.h),
//         Obx(() => LandAcquisitionUIUtils.buildDropdownField(
//           label: 'Office*',
//           value: controller.selectedOffice.value,
//           items: ['Tahsildar Office', 'Collector Office', 'Sub-Registrar Office'],
//           onChanged: controller.updateOffice,
//           icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
//         )),
//         Gap(32.h),
//         LandAcquisitionUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:setuapp/Components/LandAcquisitionView/Steps/ZLandAcquisitionUIUtils.dart';
import '../Controller/main_controller.dart';
import '../Controller/survey_cts.dart';

class SurveyCTSStep extends StatelessWidget {
  final int currentSubStep;
  final MainLandAcquisitionController mainController;

  const SurveyCTSStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the SurveyCTSController
  SurveyCTSController get controller => Get.find<SurveyCTSController>(tag: 'survey_cts');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[1] ?? ['survey_number'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildOfficeInput(); // Fallback
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
        LandAcquisitionUIUtils.buildStepHeader(
          'Group No./ Survey No./ C. T. Survey No./T. P. No. Information',
          'Enter Survey No./Gat No./CTS No.',
        ),
        Gap(24.h),
        LandAcquisitionUIUtils.buildTextFormField(
          controller: controller.surveyNumberController,
          label: 'Survey No./Gat No./CTS No.*',
          hint: 'Enter survey number',
          icon: PhosphorIcons.listNumbers(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (!controller.isSurveyNumberValid) {
              return controller.getFieldError('survey_number');
            }
            return null;
          },
        ),
        Gap(32.h),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildDepartmentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Department Information',
          'Select your department',
        ),
        Gap(24.h),
        Obx(() => LandAcquisitionUIUtils.buildDropdownField(
          label: 'Department*',
          value: controller.selectedDepartment.value,
          items: controller.departmentOptions,
          onChanged: controller.updateDepartment,
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildDistrictInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Location Details',
          'Select your district',
        ),
        Gap(24.h),
        Obx(() => LandAcquisitionUIUtils.buildDropdownField(
          label: 'District*',
          value: controller.selectedDistrict.value,
          items: controller.districtOptions,
          onChanged: controller.updateDistrict,
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildTalukaInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Location Details',
          'Select your taluka',
        ),
        Gap(24.h),
        Obx(() => LandAcquisitionUIUtils.buildDropdownField(
          label: 'Taluka*',
          value: controller.selectedTaluka.value,
          items: controller.getTalukaOptions(),
          onChanged: controller.updateTaluka,
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildVillageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Location Details',
          'Select your village',
        ),
        Gap(24.h),
        Obx(() => LandAcquisitionUIUtils.buildDropdownField(
          label: 'Village*',
          value: controller.selectedVillage.value,
          items: controller.getVillageOptions(),
          onChanged: controller.updateVillage,
          icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildOfficeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Office Information',
          'Select your office',
        ),
        Gap(24.h),
        Obx(() => LandAcquisitionUIUtils.buildDropdownField(
          label: 'Office*',
          value: controller.selectedOffice.value,
          items: controller.officeOptions,
          onChanged: controller.updateOffice,
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }
}