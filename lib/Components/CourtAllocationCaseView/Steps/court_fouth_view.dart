import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/court_fouth_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CourtFouthView extends StatelessWidget {
  final int currentSubStep;
  final CourtAllocationCaseController mainController;

  const CourtFouthView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  CourtAlloFouthController get controller => Get.find<CourtAlloFouthController>(tag: 'census_fourth');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[3] ?? ['calculation'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCalculationDetails(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'calculation':
        return _buildCalculationDetails();
      default:
        return _buildCalculationDetails();
    }
  }

  Widget _buildCalculationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtAllocationCaseUIUtils.buildStepHeader(
          'Calculation Information',
          'Please provide calculation details',
        ),
        Gap(24.h),

        // Calculation Type Dropdown
        Obx(() => CourtAllocationCaseUIUtils.buildDropdownField(
              label: 'Calculation type *',
              value: controller.selectedCalculationType.value ?? '',
              items: controller.calculationTypeOptions,
              onChanged: controller.updateCalculationType,
              icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
            )),
        Gap(16.h),

        // Duration Dropdown
        Obx(() => CourtAllocationCaseUIUtils.buildDropdownField(
              label: 'Duration *',
              value: controller.selectedDuration.value ?? '',
              items: controller.durationOptions,
              onChanged: controller.updateDuration,
              icon: PhosphorIcons.clock(PhosphorIconsStyle.regular),
            )),
        Gap(16.h),

        // Holder Type Dropdown
        Obx(() => CourtAllocationCaseUIUtils.buildDropdownField(
              label: 'Holder type *',
              value: controller.selectedHolderType.value ?? '',
              items: controller.holderTypeOptions,
              onChanged: controller.updateHolderType,
              icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            )),
        Gap(16.h),

        // Location Category Dropdown
        Obx(() => CourtAllocationCaseUIUtils.buildDropdownField(
              label: 'म.न.पा./न.पा.अंतर्गत / म.न.पा./न.पा.बाहेरील *',
              value: controller.selectedLocationCategory.value ?? '',
              items: controller.locationCategoryOptions,
              onChanged: controller.updateLocationCategory,
              icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
            )),
        Gap(16.h),

        // Calculation Fee (Auto-calculated, read-only)
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.calculationFeeController,
          label: 'Calculation fee',
          hint: 'Auto-calculated based on selections',
          icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please complete all selections above';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Fee breakdown information card
        Obx(() => _buildFeeBreakdownCard()),
        Gap(32.h),

        CourtAllocationCaseUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildFeeBreakdownCard() {
    if (controller.selectedCalculationType.value == null ||
        controller.selectedDuration.value == null ||
        controller.selectedHolderType.value == null ||
        controller.selectedLocationCategory.value == null) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: SetuColors.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: SetuColors.lightGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.info(PhosphorIconsStyle.regular),
                color: SetuColors.lightGreen,
                size: 20.sp,
              ),
              Gap(8.w),
              Text(
                'Fee Calculation Breakdown',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: SetuColors.lightGreen,
                ),
              ),
            ],
          ),
          Gap(12.h),
          _buildBreakdownRow('Calculation Type:',
              controller.selectedCalculationType.value ?? ''),
          _buildBreakdownRow(
              'Duration:', controller.selectedDuration.value ?? ''),
          _buildBreakdownRow(
              'Holder Type:',
              controller.getShortHolderType(
                  controller.selectedHolderType.value ?? '')),
          _buildBreakdownRow(
              'Location:', controller.selectedLocationCategory.value ?? ''),
          Divider(color: SetuColors.lightGreen.withOpacity(0.3)),
          _buildBreakdownRow(
            'Total Fee:',
            controller.calculationFeeController.text,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 14.sp : 13.sp,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                color: isTotal ? SetuColors.primaryGreen : Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isTotal ? 14.sp : 13.sp,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                color: isTotal ? SetuColors.primaryGreen : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
