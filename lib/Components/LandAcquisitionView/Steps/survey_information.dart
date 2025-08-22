import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:setuapp/Components/LandAcquisitionView/Steps/ZLandAcquisitionUIUtils.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/main_controller.dart';
import '../Controller/step_three_controller.dart';

class CalculationInformation extends StatelessWidget {
  final int currentSubStep;
  final MainLandAcquisitionController controller;

  const CalculationInformation({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = controller.stepConfigurations[2] ?? ['calculation'];

    if (currentSubStep >= subSteps.length) {
      return _buildCalculationInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'calculation':
        return _buildCalculationInput();
      default:
        return _buildCalculationInput();
    }
  }

  Widget _buildCalculationInput() {
    final calcController = Get.find<CalculationController>(tag: 'calculation');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Land Acquisition Survey Information',
          'Enter survey details and area calculations for land acquisition',
        ),
        Gap(24.h * LandAcquisitionUIUtils.sizeFactor),

        // Survey Entries Section
        _buildSurveyEntries(calcController),

        Gap(32.h * LandAcquisitionUIUtils.sizeFactor),
        LandAcquisitionUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildSurveyEntries(CalculationController calcController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildTranslatableText(
          text: 'Survey Entries',
          style: TextStyle(
            fontSize: 18.sp * LandAcquisitionUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * LandAcquisitionUIUtils.sizeFactor),

        // Survey Entries List
        Obx(() => Column(
              children: [
                for (int i = 0; i < calcController.surveyEntries.length; i++)
                  _buildSurveyEntryCard(calcController, i),
              ],
            )),

        Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: calcController.addSurveyEntry,
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

  Widget _buildSurveyEntryCard(
      CalculationController calcController, int index) {
    final entry = calcController.surveyEntries[index];

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
                  'Entry ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * LandAcquisitionUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (calcController.surveyEntries.length > 1)
                InkWell(
                  onTap: () => calcController.removeSurveyEntry(index),
                  child: Container(
                    padding:
                        EdgeInsets.all(8.w * LandAcquisitionUIUtils.sizeFactor),
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

          // Village Dropdown - Now inside the survey entries section
          Obx(() => LandAcquisitionUIUtils.buildDropdownField(
                label: 'Village *',
                value: calcController.selectedVillage.value,
                items: calcController.villageOptions,
                onChanged: (value) {
                  calcController.updateSelectedVillage(value ?? '');
                },
                icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
              )),

          Gap(20.h * LandAcquisitionUIUtils.sizeFactor),

          // Survey No./Group No. Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['surveyNoController'],
            label: 'Survey No./Group No. *',
            hint: 'Enter survey or group number',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                calcController.updateSurveyEntry(index, 'surveyNo', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Share Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['shareController'],
            label: 'Share *',
            hint: 'Enter share value',
            icon: PhosphorIcons.percent(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                calcController.updateSurveyEntry(index, 'share', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Area Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['areaController'],
            label: 'Area *',
            hint: 'Enter total area',
            icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                calcController.updateSurveyEntry(index, 'area', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Land Acquisition Area Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['landAcquisitionAreaController'],
            label: 'Land Acquisition Area *',
            hint: 'Enter land acquisition area',
            icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => calcController.updateSurveyEntry(
                index, 'landAcquisitionArea', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Abdominal Section Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['abdominalSectionController'],
            label: 'Abdominal Section *',
            hint: 'Enter abdominal section details',
            icon: PhosphorIcons.textAlignLeft(PhosphorIconsStyle.regular),
            maxLines: 3,
            onChanged: (value) => calcController.updateSurveyEntry(
                index, 'abdominalSection', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

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
                    'Entry ${index + 1} - Survey/Group: ${entry['surveyNo'] ?? 'Not entered'}',
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
