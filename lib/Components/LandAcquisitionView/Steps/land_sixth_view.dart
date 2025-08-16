import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandAcquisitionView/Steps/ZLandAcquisitionUIUtils.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/land_sixth_controller.dart';
import '../Controller/main_controller.dart';

class landSixthView extends StatelessWidget {
  final int currentSubStep;
  final MainLandAcquisitionController mainController;

  const landSixthView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = mainController.stepConfigurations[5] ?? ['next_of_kin'];

    if (currentSubStep >= subSteps.length) {
      return _buildNextOfKinInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'next_of_kin':
        return _buildNextOfKinInput();
      default:
        return _buildNextOfKinInput();
    }
  }

  Widget _buildNextOfKinInput() {
    final surveyEightController = Get.put(landSixthController(), tag: 'survey_eight');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Name and Address of the Next of Kin',
          'Enter details of next of kin with location and natural resources information',
        ),
        Gap(24.h * LandAcquisitionUIUtils.sizeFactor),

        // Next of Kin Entries Section
        _buildNextOfKinEntries(surveyEightController),

        Gap(32.h * LandAcquisitionUIUtils.sizeFactor),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildNextOfKinEntries(landSixthController surveyEightController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildTranslatableText(
          text: 'Next of Kin Information',
          style: TextStyle(
            fontSize: 18.sp * LandAcquisitionUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * LandAcquisitionUIUtils.sizeFactor),

        // Next of Kin Entries List
        Obx(() => Column(
          children: [
            for (int i = 0; i < surveyEightController.nextOfKinEntries.length; i++)
              _buildNextOfKinEntryCard(surveyEightController, i),
          ],
        )),

        Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: surveyEightController.addNextOfKinEntry,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w * LandAcquisitionUIUtils.sizeFactor,
              vertical: 16.h * LandAcquisitionUIUtils.sizeFactor,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: SetuColors.primaryGreen,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: SetuColors.primaryGreen.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.plus(PhosphorIconsStyle.bold),
                  color: SetuColors.primaryGreen,
                  size: 24.sp * LandAcquisitionUIUtils.sizeFactor,
                ),
                Gap(12.w * LandAcquisitionUIUtils.sizeFactor),
                LandAcquisitionUIUtils.buildTranslatableText(
                  text: 'Add Another Entry',
                  style: TextStyle(
                    fontSize: 16.sp * LandAcquisitionUIUtils.sizeFactor,
                    color: SetuColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextOfKinEntryCard(
      landSixthController surveyEightController, int index) {
    final entry = surveyEightController.nextOfKinEntries[index];

    return Container(
      margin: EdgeInsets.only(bottom: 20.h * LandAcquisitionUIUtils.sizeFactor),
      padding: EdgeInsets.all(20.w * LandAcquisitionUIUtils.sizeFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: SetuColors.primaryGreen.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w * LandAcquisitionUIUtils.sizeFactor,
                  vertical: 8.h * LandAcquisitionUIUtils.sizeFactor,
                ),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Next of Kin ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * LandAcquisitionUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (surveyEightController.nextOfKinEntries.length > 1)
                InkWell(
                  onTap: () => surveyEightController.removeNextOfKinEntry(index),
                  child: Container(
                    padding: EdgeInsets.all(8.w * LandAcquisitionUIUtils.sizeFactor),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.regular),
                      color: Colors.red,
                      size: 18.sp * LandAcquisitionUIUtils.sizeFactor,
                    ),
                  ),
                ),
            ],
          ),
          Gap(20.h * LandAcquisitionUIUtils.sizeFactor),

          // Direction Dropdown
          LandAcquisitionUIUtils.buildDropdownField(
            label: 'Direction *',
            value: (entry['direction'] as String? ?? ''),
            items: surveyEightController.directionOptions,
            onChanged: (value) {
              surveyEightController.updateDirection(index, value ?? '');
            },
            icon: PhosphorIcons.compass(PhosphorIconsStyle.regular),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Natural Resources Dropdown
          LandAcquisitionUIUtils.buildDropdownField(
            label: 'Natural Resources *',
            value: entry['naturalResources'] as String? ?? '',
            items: surveyEightController.naturalResourcesOptions,
            onChanged: (value) {
              surveyEightController.updateNaturalResources(index, value ?? '');
            },
            icon: PhosphorIcons.tree(PhosphorIconsStyle.regular),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Address Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['addressController'] as TextEditingController,
            label: 'Address *',
            hint: 'Enter complete address',
            icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
            maxLines: 3,
            onChanged: (value) =>
                surveyEightController.updateNextOfKinEntry(index, 'address', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Mobile Number Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['mobileController'] as TextEditingController,
            label: 'Mobile Number *',
            hint: 'Enter 10-digit mobile number',
            icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (value) =>
                surveyEightController.updateNextOfKinEntry(index, 'mobile', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Survey No./Group No. Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['surveyNoController'] as TextEditingController,
            label: 'Survey No./Group No. *',
            hint: 'Enter survey or group number',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                surveyEightController.updateNextOfKinEntry(index, 'surveyNo', value),
          ),

          Gap(20.h * LandAcquisitionUIUtils.sizeFactor),




          // Summary Row
          Container(
            padding: EdgeInsets.all(12.w * LandAcquisitionUIUtils.sizeFactor),
            decoration: BoxDecoration(
              color: SetuColors.primaryGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: SetuColors.primaryGreen.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.info(PhosphorIconsStyle.regular),
                  color: SetuColors.primaryGreen,
                  size: 16.sp * LandAcquisitionUIUtils.sizeFactor,
                ),
                Gap(8.w * LandAcquisitionUIUtils.sizeFactor),
                Expanded(
                  child: Text(
                    'Next of Kin ${index + 1} - ${(entry['name'] as String? ?? '').isEmpty ? 'Name not entered' : entry['name']} | ${(entry['direction'] as String? ?? '').isEmpty ? 'Direction not selected' : entry['direction']}',
                    style: TextStyle(
                      fontSize: 12.sp * LandAcquisitionUIUtils.sizeFactor,
                      color: SetuColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
