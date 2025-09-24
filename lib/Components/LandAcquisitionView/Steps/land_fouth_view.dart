import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandAcquisitionView/Steps/ZLandAcquisitionUIUtils.dart';
import '../Controller/main_controller.dart';
import '../Controller/land_fouth_controller.dart';

class LandFouthView extends StatelessWidget {
  final int currentSubStep;
  final MainLandAcquisitionController mainController;

  const LandFouthView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the LandFouthController
  LandFouthController get controller => Get.find<LandFouthController>(tag: 'land_fouth');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps =
        mainController.stepConfigurations[3] ?? ['land_fouth_step'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCalculationDetails(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'land_fouth_step':
        return _buildCalculationDetails();
      default:
        return _buildCalculationDetails();
    }
  }

  Widget _buildCalculationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Land Acquisition Joint Calculation Information',
          'Please provide calculation details for land acquisition',
        ),
        Gap(24.h),

        // Calculation Type Dropdown
        Obx(() => LandAcquisitionUIUtils.buildDropdownField(
              label: 'Calculation type *',
              value: controller.selectedCalculationType.value,
              items: controller.calculationTypeOptions,
              onChanged: controller.updateCalculationType,
              icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
            )),
        Gap(16.h),

        // Duration Dropdown
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LandAcquisitionUIUtils.buildDropdownField(
                  label: 'Duration *',
                  value: controller.selectedDuration.value.isEmpty
                      ? ''
                      : controller.selectedDuration.value,
                  items: controller.durationOptions,
                  onChanged: controller.updateDuration,
                  icon: PhosphorIcons.clock(PhosphorIconsStyle.regular),
                ),
                if (controller.durationError.value.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 12.w),
                    child: Text(
                      controller.durationError.value,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
              ],
            )),
        Gap(16.h),

        // Holder Type Dropdown
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LandAcquisitionUIUtils.buildDropdownField(
                  label: 'Holder type *',
                  value: controller.selectedHolderType.value.isEmpty
                      ? ''
                      : controller.selectedHolderType.value,
                  items: controller.holderTypeOptions,
                  onChanged: controller.updateHolderType,
                  icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
                ),
                if (controller.holderTypeError.value.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 12.w),
                    child: Text(
                      controller.holderTypeError.value,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
              ],
            )),
        Gap(16.h),

        // Counting Fee Field (Read-only)
        // Obx(() => Container(
        //       width: double.infinity,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             'Counting fee',
        //             style: TextStyle(
        //               fontSize: 14.sp,
        //               fontWeight: FontWeight.w500,
        //               color: Colors.grey.shade700,
        //             ),
        //           ),
        //           Gap(8.h),
        //           Container(
        //             width: double.infinity,
        //             padding:
        //                 EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8.r),
        //               border: Border.all(color: Colors.grey.shade300),
        //               color: Colors.grey.shade50,
        //             ),
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
        //                   size: 20.sp,
        //                   color: Colors.grey.shade600,
        //                 ),
        //                 Gap(8.w),
        //                 Text(
        //                   '₹ ${controller.countingFee.value}',
        //                   style: TextStyle(
        //                     fontSize: 16.sp,
        //                     fontWeight: FontWeight.w600,
        //                     color: controller.countingFee.value > 0
        //                         ? Colors.green.shade700
        //                         : Colors.grey.shade600,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     )),
        // Gap(24.h),

        // Information Card about fee calculation
        // Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.all(16.w),
        //   decoration: BoxDecoration(
        //     color: Colors.blue.shade50,
        //     borderRadius: BorderRadius.circular(8.r),
        //     border: Border.all(color: Colors.blue.shade200),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         children: [
        //           Icon(
        //             PhosphorIcons.info(PhosphorIconsStyle.fill),
        //             color: Colors.blue.shade600,
        //             size: 20.sp,
        //           ),
        //           Gap(8.w),
        //           Text(
        //             'Fee Calculation Information',
        //             style: TextStyle(
        //               fontSize: 14.sp,
        //               fontWeight: FontWeight.w600,
        //               color: Colors.blue.shade800,
        //             ),
        //           ),
        //         ],
        //       ),
        //       Gap(8.h),
        //       Text(
        //         'The counting fee is automatically calculated based on your selection:',
        //         style: TextStyle(
        //           fontSize: 12.sp,
        //           color: Colors.blue.shade700,
        //         ),
        //       ),
        //       Gap(6.h),
        //       _buildFeeInfo(
        //           'Companies/Institutions + Regular Duration', '₹7,500'),
        //       _buildFeeInfo(
        //           'Companies/Institutions + Fast Pace Duration', '₹30,000'),
        //       Gap(4.h),
        //       Text(
        //         'Note: Different rates apply for other holder types.',
        //         style: TextStyle(
        //           fontSize: 11.sp,
        //           color: Colors.blue.shade600,
        //           fontStyle: FontStyle.italic,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Gap(32.h),

        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildFeeInfo(String condition, String fee) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              '$condition: ',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          Text(
            fee,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
