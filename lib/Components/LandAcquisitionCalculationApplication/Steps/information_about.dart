import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:setuapp/Components/LandAcquisitionCalculationApplication/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../../Controller/land_survey_controller.dart';
import '../land_acquisition_calculation_controller.dart';

class InformationAbout extends StatelessWidget {
  final int currentSubStep;
  final LandAcquisitionController controller;

  const InformationAbout({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final subSteps = ['address', 'state'];


    // final currentField = subSteps[currentSubStep];
    final subSteps = controller.stepConfigurations[6] ?? ['address'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildAddressInput(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'adjacent':
        return _buildAddressInput();
      case 'status':
        return _buildStateInput();
      default:
        return _buildAddressInput();
    }
  }

  Widget _buildAddressInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Property Information',
          'What is the property address?',
        ),
        Gap(24.h),
        LandAqUIUtils.buildTextFormField(
          controller: controller.addressController,
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
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildStateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAqUIUtils.buildStepHeader(
          'Location Details',
          'Select your state',
        ),
        Gap(24.h),
        Obx(() => LandAqUIUtils.buildDropdownField(
          label: 'State',
          value: controller.selectedState.value,
          items: [
            'Maharashtra',
            'Gujarat',
          ],
          onChanged: controller.updateState,
          icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
        )),
        Gap(32.h),
        LandAqUIUtils.buildNavigationButtons(controller),
      ],
    );
  }
}