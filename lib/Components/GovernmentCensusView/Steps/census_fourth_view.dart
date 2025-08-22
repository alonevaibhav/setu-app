import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../Controller/main_controller.dart';
import '../Controller/census_fourth_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CensusFourthView extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController mainController;

  const CensusFourthView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the CensusFourthController
  CensusFourthController get controller => Get.find<CensusFourthController>(tag: 'census_fourth');

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
      case 'status':
        return _buildStatusView();
      default:
        return _buildCalculationDetails();
    }
  }

  Widget _buildCalculationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildStepHeader(
          'Government Census Calculation',
          'Please provide calculation details',
        ),
        Gap(24.h),

        // Calculation Type
        Obx(() => GovernmentCensusUIUtils.buildDropdownField(
          label: 'Calculation type *',
          value: controller.selectedCalculationType.value?? '',
          items: controller.calculationTypeOptions,
          onChanged: controller.updateCalculationType,
          icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
        )),
        Gap(16.h),

        // Duration
        Obx(() => GovernmentCensusUIUtils.buildDropdownField(
          label: 'Duration *',
          value: controller.selectedDuration.value ?? '',
          items: controller.durationOptions,
          onChanged: controller.updateDuration,
          icon: PhosphorIcons.clock(PhosphorIconsStyle.regular),
        )),
        Gap(16.h),

        // Holder Type
        Obx(() => GovernmentCensusUIUtils.buildDropdownField(
          label: 'Holder type *',
          value: controller.selectedHolderType.value ?? '',
          items: controller.holderTypeOptions,
          onChanged: controller.updateHolderType,
          icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
        )),
        Gap(16.h),

        // Calculation Fee Rate
        Obx(() => GovernmentCensusUIUtils.buildDropdownField(
          label: 'Calculation fee rate *',
          value: controller.selectedCalculationFeeRate.value ?? '',
          items: controller.calculationFeeRateOptions,
          onChanged: controller.updateCalculationFeeRate,
          icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
        )),
        Gap(24.h),

        // Counting Fee Display
        Obx(() => Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xFFE9ECEF)),
          ),
          child: Row(
            children: [
              Icon(
                PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
                color: Color(0xFF6C757D),
                size: 20.w,
              ),
              Gap(12.w),
              Text(
                'Counting Fee:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF495057),
                ),
              ),
              Spacer(),
              Text(
                '₹${controller.countingFee.value}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF28A745),
                ),
              ),
            ],
          ),
        )),
        Gap(32.h),

        // Navigation Buttons
        GovernmentCensusUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildStatusView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildStepHeader(
          'Calculation Status',
          'Review your calculation details',
        ),
        Gap(24.h),

        // Summary Card
        Obx(() => Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xFFE9ECEF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                    color: Color(0xFF28A745),
                    size: 24.w,
                  ),
                  Gap(12.w),
                  Text(
                    'Calculation Summary',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212529),
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Divider(color: Color(0xFFE9ECEF)),
              Gap(16.h),

              _buildSummaryRow('Calculation Type', controller.selectedCalculationType.value ?? '-'),
              Gap(12.h),
              _buildSummaryRow('Duration', controller.selectedDuration.value ?? '-'),
              Gap(12.h),
              _buildSummaryRow('Holder Type', controller.selectedHolderType.value ?? '-'),
              Gap(12.h),
              _buildSummaryRow('Fee Rate', controller.selectedCalculationFeeRate.value ?? '-'),
              Gap(16.h),
              Divider(color: Color(0xFFE9ECEF)),
              Gap(16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Counting Fee',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212529),
                    ),
                  ),
                  Text(
                    '₹${controller.countingFee.value}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF28A745),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
        Gap(32.h),

        // Navigation Buttons
        GovernmentCensusUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6C757D),
            ),
          ),
        ),
        Gap(8.w),
        Text(
          ':',
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFF6C757D),
          ),
        ),
        Gap(8.w),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF212529),
            ),
          ),
        ),
      ],
    );
  }
}