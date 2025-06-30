import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:setuapp/Components/LandServayView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/main_controller.dart';
import '../Controller/step_three_controller.dart';

class CalculationInformation extends StatelessWidget {
  final int currentSubStep;
  final MainSurveyController controller;

  const CalculationInformation({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = controller.stepConfigurations[2] ?? ['calculation'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCalculationInput(); // Fallback
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
    // Get or create calculation controller
    final calcController = Get.put(CalculationController(), tag: 'calculation');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Group No./ Survey No./ C. T. Survey No. /T. P. No. Information about the area',
          'Select calculation type and provide required information',
        ),
        Gap(24.h * SurveyUIUtils.sizeFactor),

        // Calculation Type Dropdown
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Calculation type *',
          value: calcController.selectedCalculationType.value,
          items: calcController.calculationTypes,
          onChanged: (value) {
            calcController.updateCalculationType(value ?? '');
          },
          icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
        )),

        Gap(20.h * SurveyUIUtils.sizeFactor),

        // Dynamic content based on selected calculation type
        Obx(() => _buildDynamicContent(calcController)),

        Gap(32.h * SurveyUIUtils.sizeFactor),
        SurveyUIUtils.buildNavigationButtonss(controller),
      ],
    );
  }

  Widget _buildDynamicContent(CalculationController calcController) {
    if (calcController.selectedCalculationType.value.isEmpty) {
      return Container();
    }

    switch (calcController.selectedCalculationType.value) {
      case 'Hddkayam':
        return _buildHddkayamFields(calcController);
      case 'Stomach':
        return _buildStomachFields(calcController);
      case 'Non-agricultural':
        return _buildNonAgriculturalFields(calcController);
      case 'Counting by number of knots':
        return _buildKnotsCountingFields(calcController);
      case 'Integration calculation':
        return _buildIntegrationCalculationFields(calcController);
      default:
        return Container();
    }
  }

  Widget _buildHddkayamFields(CalculationController calcController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildTranslatableText(
          text: 'Hddkayam Calculation Details',
          style: TextStyle(
            fontSize: 16.sp * SurveyUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Dynamic Entries Cards
        Obx(() => Column(
          children: [
            ...calcController.hddkayamEntries.asMap().entries.map((entry) {
              int index = entry.key;
              var rowData = entry.value;
              return _buildHddkayamCard(calcController, index, rowData);
            }).toList(),
          ],
        )),

        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Add More Information Button
        InkWell(
          onTap: () => calcController.addHddkayamEntry(),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w * SurveyUIUtils.sizeFactor,
              vertical: 12.h * SurveyUIUtils.sizeFactor,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: SetuColors.primaryGreen,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.r),
              color: SetuColors.primaryGreen.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.plus(PhosphorIconsStyle.regular),
                  color: SetuColors.primaryGreen,
                  size: 20.sp * SurveyUIUtils.sizeFactor,
                ),
                Gap(8.w * SurveyUIUtils.sizeFactor),
                SurveyUIUtils.buildTranslatableText(
                  text: 'Fill in more information',
                  style: TextStyle(
                    fontSize: 14.sp * SurveyUIUtils.sizeFactor,
                    color: SetuColors.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHddkayamCard(CalculationController calcController, int index, Map<String, dynamic> rowData) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h * SurveyUIUtils.sizeFactor),
      padding: EdgeInsets.all(16.w * SurveyUIUtils.sizeFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header with Entry Number and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entry ${index + 1}',
                style: TextStyle(
                  fontSize: 16.sp * SurveyUIUtils.sizeFactor,
                  fontWeight: FontWeight.w600,
                  color: SetuColors.primaryGreen,
                ),
              ),
              Row(
                children: [
                  // Check Button
                  InkWell(
                    onTap: () => calcController.markHddkayamEntryCorrect(index),
                    child: Container(
                      padding: EdgeInsets.all(8.w * SurveyUIUtils.sizeFactor),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        PhosphorIcons.check(PhosphorIconsStyle.regular),
                        color: Colors.white,
                        size: 16.sp * SurveyUIUtils.sizeFactor,
                      ),
                    ),
                  ),
                  Gap(8.w * SurveyUIUtils.sizeFactor),
                  // Delete Button
                  InkWell(
                    onTap: () => calcController.removeHddkayamEntry(index),
                    child: Container(
                      padding: EdgeInsets.all(8.w * SurveyUIUtils.sizeFactor),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        PhosphorIcons.trash(PhosphorIconsStyle.regular),
                        color: Colors.white,
                        size: 16.sp * SurveyUIUtils.sizeFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Gap(16.h * SurveyUIUtils.sizeFactor),

          // CT Survey Number Input Field
          SurveyUIUtils.buildTextFormField(
            controller: rowData['ctSurveyController'],
            label: 'CT Survey No.',
            hint: 'Enter CT Survey No.',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) => calcController.updateHddkayamEntry(index, 'ctSurveyNumber', value),
          ),

          Gap(16.h * SurveyUIUtils.sizeFactor),

          // CT Survey/TP No. Dropdown
          SurveyUIUtils.buildDropdownField(
            label: 'CT Survey/TP No.',
            value: rowData['selectedCTSurvey'] ?? '',
            items: calcController.ctSurveyOptions,
            onChanged: (value) => calcController.updateHddkayamEntry(index, 'selectedCTSurvey', value),
            icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
          ),

          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Area Input Field
          SurveyUIUtils.buildTextFormField(
            controller: rowData['areaController'],
            label: 'Area',
            hint: 'Enter area',
            icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
            onChanged: (value) => calcController.updateHddkayamEntry(index, 'area', value),
          ),

          Gap(16.h * SurveyUIUtils.sizeFactor),

          // Area (sq.m.) Input Field
          SurveyUIUtils.buildTextFormField(
            controller: rowData['areaSqmController'],
            label: 'Area (sq.m.)',
            hint: 'Enter area in square meters',
            icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => calcController.updateHddkayamEntry(index, 'areaSqm', value),
          ),
        ],
      ),
    );
  }

  Widget _buildStomachFields(CalculationController calcController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildTranslatableText(
          text: 'Stomach Calculation Details',
          style: TextStyle(
            fontSize: 16.sp * SurveyUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Measurement Type
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Measurement Type',
          value: calcController.measurementType.value,
          items: ['Square meters', 'Square feet', 'Acres'],
          onChanged: (value) => calcController.measurementType.value = value ?? '',
          icon: PhosphorIcons.ruler(PhosphorIconsStyle.regular),
        )),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Total Area
        SurveyUIUtils.buildTextFormField(
          controller: calcController.totalAreaController,
          label: 'Total Area',
          hint: 'Enter total area',
          icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Widget _buildNonAgriculturalFields(CalculationController calcController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildTranslatableText(
          text: 'Non-Agricultural Land Details',
          style: TextStyle(
            fontSize: 16.sp * SurveyUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Land Type
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Land Type',
          value: calcController.landType.value,
          items: ['Residential', 'Commercial', 'Industrial', 'Institutional'],
          onChanged: (value) => calcController.landType.value = value ?? '',
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
        )),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Plot Number
        SurveyUIUtils.buildTextFormField(
          controller: calcController.plotNumberController,
          label: 'Plot Number',
          hint: 'Enter plot number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.text,
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Built-up Area
        SurveyUIUtils.buildTextFormField(
          controller: calcController.builtUpAreaController,
          label: 'Built-up Area (sq ft)',
          hint: 'Enter built-up area',
          icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Widget _buildKnotsCountingFields(CalculationController calcController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildTranslatableText(
          text: 'Knots Counting Method',
          style: TextStyle(
            fontSize: 16.sp * SurveyUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Number of Knots
        SurveyUIUtils.buildTextFormField(
          controller: calcController.knotsCountController,
          label: 'Number of Knots',
          hint: 'Enter total knots count',
          icon: PhosphorIcons.dotsSix(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.number,
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Knot Spacing
        SurveyUIUtils.buildTextFormField(
          controller: calcController.knotSpacingController,
          label: 'Knot Spacing (meters)',
          hint: 'Enter spacing between knots',
          icon: PhosphorIcons.arrowsHorizontal(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Calculation Method
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Calculation Method',
          value: calcController.calculationMethod.value,
          items: ['Linear', 'Grid', 'Triangular'],
          onChanged: (value) => calcController.calculationMethod.value = value ?? '',
          icon: PhosphorIcons.triangle(PhosphorIconsStyle.regular),
        )),
      ],
    );
  }

  Widget _buildIntegrationCalculationFields(CalculationController calcController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildTranslatableText(
          text: 'Integration Calculation',
          style: TextStyle(
            fontSize: 16.sp * SurveyUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Integration Type
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Integration Type',
          value: calcController.integrationType.value,
          items: ['Simpson\'s Rule', 'Trapezoidal Rule', 'Planimeter'],
          onChanged: (value) => calcController.integrationType.value = value ?? '',
          icon: PhosphorIcons.function(PhosphorIconsStyle.regular),
        )),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Base Line
        SurveyUIUtils.buildTextFormField(
          controller: calcController.baseLineController,
          label: 'Base Line (meters)',
          hint: 'Enter base line measurement',
          icon: PhosphorIcons.lineSegment(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
        Gap(16.h * SurveyUIUtils.sizeFactor),

        // Number of Ordinates
        SurveyUIUtils.buildTextFormField(
          controller: calcController.ordinatesController,
          label: 'Number of Ordinates',
          hint: 'Enter number of ordinates',
          icon: PhosphorIcons.chartLine(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}