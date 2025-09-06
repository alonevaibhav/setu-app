//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
// import '../../../Constants/color_constant.dart';
// import '../../LandSurveyView/Controller/step_three_controller.dart';
// import '../Controller/main_controller.dart';
// import '../Controller/step_four_controller.dart';
//
// class StepFourView extends StatelessWidget {
//   final int currentSubStep;
//   final MainSurveyController mainController;
//
//   const StepFourView({
//     super.key,
//     required this.currentSubStep,
//     required this.mainController,
//   });
//
//   StepFourController get controller => Get.find<StepFourController>(tag: 'step_four');
//
//   @override
//   Widget build(BuildContext context) {
//     final subSteps = mainController.stepConfigurations[3] ?? ['calculation'];
//
//     if (currentSubStep >= subSteps.length) {
//       return _buildCalculationDetails();
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'calculation':
//         return _buildCalculationDetails();
//       default:
//         return _buildCalculationDetails();
//     }
//   }
//
//   Widget _buildCalculationDetails() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SurveyUIUtils.buildStepHeader(
//           'Calculation Information',
//           'Please provide calculation details',
//         ),
//         Gap(24.h),
//
//         // Calculation Type (Read-only, from previous controller)
//         Obx(() {
//           try {
//             final calculationController =
//             Get.find<CalculationController>(tag: 'calculation');
//             final selectedType =
//                 calculationController.selectedCalculationType.value;
//
//             return SurveyUIUtils.buildTextFormField(
//               controller: TextEditingController(text: selectedType),
//               label: 'Calculation type',
//               hint: selectedType.isEmpty
//                   ? 'No calculation type selected'
//                   : selectedType,
//               icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//               readOnly: true,
//             );
//           } catch (e) {
//             return SurveyUIUtils.buildTextFormField(
//               controller:
//               TextEditingController(text: 'Error loading calculation type'),
//               label: 'Calculation type',
//               hint: 'Error loading data',
//               icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//               readOnly: true,
//             );
//           }
//         }),
//         Gap(16.h),
//
//         // Duration Dropdown
//         Obx(() => SurveyUIUtils.buildDropdownField(
//           label: 'Duration *',
//           value: controller.selectedDuration.value ?? '',
//           items: controller.durationOptions,
//           onChanged: controller.updateDuration,
//           icon: PhosphorIcons.clock(PhosphorIconsStyle.regular),
//         )),
//         Gap(16.h),
//
//         // Holder Type Dropdown
//         Obx(() => SurveyUIUtils.buildDropdownField(
//           label: 'Holder type *',
//           value: controller.selectedHolderType.value ?? '',
//           items: controller.holderTypeOptions,
//           onChanged: controller.updateHolderType,
//           icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//         )),
//         Gap(16.h),
//
//         // Location Category Dropdown (conditional)
//         Obx(() {
//           if (controller.requiresLocationCategory()) {
//             return Column(
//               children: [
//                 SurveyUIUtils.buildDropdownField(
//                   label: 'म.न.पा./न.पा.अंतर्गत / म.न.पा./न.पा.बाहेरील *',
//                   value: controller.selectedLocationCategory.value ?? '',
//                   items: controller.locationCategoryOptions,
//                   onChanged: controller.updateLocationCategory,
//                   icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//                 ),
//                 Gap(16.h),
//               ],
//             );
//           }
//           return SizedBox.shrink();
//         }),
//
//         // Total Plot Number Input (for Non-agricultural calculation only)
//         Obx(() {
//           if (controller.requiresTotalPlotNumber()) {
//             return Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(8.r),
//                     border: Border.all(
//                       color: Colors.green.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                   padding: EdgeInsets.all(12.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Plot Number Configuration',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.green[700],
//                         ),
//                       ),
//                       Gap(12.h),
//                       SurveyUIUtils.buildTextFormField(
//                         controller: controller.totalPlotNumberController,
//                         label: 'Total plot number as per approved layout *',
//                         hint: 'Enter total number of plots (minimum 1)',
//                         icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Please enter total plot number';
//                           }
//                           final number = int.tryParse(value);
//                           if (number == null || number <= 0) {
//                             return 'Please enter a valid number greater than 0';
//                           }
//                           if (number > 999) {
//                             return 'Please enter a reasonable number (max 999)';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Gap(16.h),
//               ],
//             );
//           }
//           return SizedBox.shrink();
//         }),
//
//         // NEW: Knot Count Input (for Counting by number of knots calculation only)
//         Obx(() {
//           if (controller.requiresKnotCount()) {
//             return Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(8.r),
//                     border: Border.all(
//                       color: Colors.orange.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                   padding: EdgeInsets.all(12.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SurveyUIUtils.buildTextFormField(
//                         controller: controller.knotCountController,
//                         label: 'Total plot number as per approved layout *',
//                         hint: 'Enter number of knots (minimum 1)',
//                         icon: PhosphorIcons.link(PhosphorIconsStyle.regular),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Please enter knot count';
//                           }
//                           final number = int.tryParse(value);
//                           if (number == null || number <= 0) {
//                             return 'Please enter a valid number greater than 0';
//                           }
//                           if (number > 999) {
//                             return 'Please enter a reasonable number (max 999)';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Gap(16.h),
//               ],
//             );
//           }
//           return SizedBox.shrink();
//         }),
//
//         // Abdominal Section Input (for Stomach calculation only)
//         Obx(() {
//           if (controller.requiresAbdominalSection()) {
//             return Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(8.r),
//                     border: Border.all(
//                       color: Colors.blue.withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                   padding: EdgeInsets.all(12.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Abdominal Section Configuration',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.blue[700],
//                         ),
//                       ),
//                       Gap(12.h),
//                       SurveyUIUtils.buildTextFormField(
//                         controller: controller.abdominalSectionController,
//                         label: 'Abdominal section *',
//                         hint: 'Enter number of abdominal sections (minimum 1)',
//                         icon: PhosphorIcons.listNumbers(PhosphorIconsStyle.regular),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return 'Please enter abdominal section number';
//                           }
//                           final number = int.tryParse(value);
//                           if (number == null || number <= 0) {
//                             return 'Please enter a valid number greater than 0';
//                           }
//                           if (number > 999) {
//                             return 'Please enter a reasonable number (max 999)';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Gap(16.h),
//               ],
//             );
//           }
//           return SizedBox.shrink();
//         }),
//
//         // Calculation Fee (Auto-calculated, read-only)
//         SurveyUIUtils.buildTextFormField(
//           controller: controller.calculationFeeController,
//           label: 'Calculation fee',
//           hint: 'Auto-calculated based on selections',
//           icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
//           readOnly: true,
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Please complete all selections above';
//             }
//             return null;
//           },
//         ),
//         Gap(16.h),
//
//         // Fee breakdown information card
//         Obx(() => _buildFeeBreakdownCard()),
//         Gap(32.h),
//
//         SurveyUIUtils.buildNavigationButtons(mainController),
//       ],
//     );
//   }
//
//   Widget _buildFeeBreakdownCard() {
//     if (controller.selectedCalculationType.value == null ||
//         controller.selectedDuration.value == null ||
//         controller.selectedHolderType.value == null ||
//         (controller.requiresLocationCategory() &&
//             controller.selectedLocationCategory.value == null)) {
//       return SizedBox.shrink();
//     }
//
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: SetuColors.lightGreen.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: SetuColors.lightGreen.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 PhosphorIcons.info(PhosphorIconsStyle.regular),
//                 color: SetuColors.lightGreen,
//                 size: 20.sp,
//               ),
//               Gap(8.w),
//               Text(
//                 'Fee Calculation Breakdown',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: SetuColors.lightGreen,
//                 ),
//               ),
//             ],
//           ),
//           Gap(12.h),
//           _buildBreakdownRow(
//             'Calculation Type:',
//             controller.selectedCalculationType.value ?? '',
//           ),
//           _buildBreakdownRow(
//               'Duration:', controller.selectedDuration.value ?? ''),
//           _buildBreakdownRow(
//               'Holder Type:',
//               controller.getShortHolderType(
//                   controller.selectedHolderType.value ?? '')),
//
//           // Show location category only if required
//           if (controller.requiresLocationCategory())
//             _buildBreakdownRow(
//                 'Location:', controller.selectedLocationCategory.value ?? ''),
//
//           // Show abdominal section only for Stomach calculation
//           if (controller.selectedCalculationType.value == 'Stomach')
//             _buildBreakdownRow('Abdominal Sections:',
//                 controller.abdominalSectionController.text),
//
//           // Show total plot number only for Non-agricultural calculation
//           if (controller.selectedCalculationType.value == 'Non-agricultural')
//             _buildBreakdownRow('Total Plot Numbers:',
//                 controller.totalPlotNumberController.text),
//
//           // NEW: Show knot count only for Counting by number of knots calculation
//           if (controller.selectedCalculationType.value == 'Counting by number of knots')
//             _buildBreakdownRow('Number of Knots:',
//                 controller.knotCountController.text),
//
//           Divider(color: SetuColors.lightGreen.withOpacity(0.3)),
//           _buildBreakdownRow(
//             'Total Fee:',
//             controller.calculationFeeController.text,
//             isTotal: true,
//           ),
//
//         ],
//       ),
//     );
//   }
//
//
//
//
//   Widget _buildBreakdownRow(String label, String value,
//       {bool isTotal = false}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: isTotal ? 14.sp : 13.sp,
//                 fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
//                 color: isTotal ? SetuColors.primaryGreen : Colors.grey[700],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                 fontSize: isTotal ? 14.sp : 13.sp,
//                 fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
//                 color: isTotal ? SetuColors.primaryGreen : Colors.grey[800],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../LandSurveyView/Controller/step_three_controller.dart';
import '../Controller/main_controller.dart';
import '../Controller/step_four_controller.dart';

class StepFourView extends StatelessWidget {
  final int currentSubStep;
  final MainSurveyController mainController;

  const StepFourView({
    super.key,
    required this.currentSubStep,
    required this.mainController,
  });

  StepFourController get controller => Get.find<StepFourController>(tag: 'step_four');

  @override
  Widget build(BuildContext context) {
    final subSteps = mainController.stepConfigurations[3] ?? ['calculation'];

    if (currentSubStep >= subSteps.length) {
      return _buildCalculationDetails();
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
        SurveyUIUtils.buildStepHeader(
          'Calculation Information',
          'Please provide calculation details',
        ),
        Gap(24.h),

        // Calculation Type (Read-only, from previous controller)
        Obx(() {
          try {
            final calculationController =
            Get.find<CalculationController>(tag: 'calculation');
            final selectedType =
                calculationController.selectedCalculationType.value;

            return SurveyUIUtils.buildTextFormField(
              controller: TextEditingController(text: selectedType),
              label: 'Calculation type',
              hint: selectedType.isEmpty
                  ? 'No calculation type selected'
                  : selectedType,
              icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
              readOnly: true,
            );
          } catch (e) {
            return SurveyUIUtils.buildTextFormField(
              controller:
              TextEditingController(text: 'Error loading calculation type'),
              label: 'Calculation type',
              hint: 'Error loading data',
              icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
              readOnly: true,
            );
          }
        }),
        Gap(16.h),

        // Duration Dropdown
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Duration *',
          value: controller.selectedDuration.value ?? '',
          items: controller.durationOptions,
          onChanged: controller.updateDuration,
          icon: PhosphorIcons.clock(PhosphorIconsStyle.regular),
        )),
        Gap(16.h),

        // Holder Type Dropdown
        Obx(() => SurveyUIUtils.buildDropdownField(
          label: 'Holder type *',
          value: controller.selectedHolderType.value ?? '',
          items: controller.holderTypeOptions,
          onChanged: controller.updateHolderType,
          icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
        )),
        Gap(16.h),

        // Location Category Dropdown (conditional)
        Obx(() {
          if (controller.requiresLocationCategory()) {
            return Column(
              children: [
                SurveyUIUtils.buildDropdownField(
                  label: 'म.न.पा./न.पा.अंतर्गत / म.न.पा./न.पा.बाहेरील *',
                  value: controller.selectedLocationCategory.value ?? '',
                  items: controller.locationCategoryOptions,
                  onChanged: controller.updateLocationCategory,
                  icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                ),
                Gap(16.h),
              ],
            );
          }
          return SizedBox.shrink();
        }),

        // Total Plot Number Input (for Non-agricultural calculation only)
        Obx(() {
          if (controller.requiresTotalPlotNumber()) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plot Number Configuration',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                      Gap(12.h),
                      SurveyUIUtils.buildTextFormField(
                        controller: controller.totalPlotNumberController,
                        label: 'Total plot number as per approved layout *',
                        hint: 'Enter total number of plots (minimum 1)',
                        icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter total plot number';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Please enter a valid number greater than 0';
                          }
                          if (number > 999) {
                            return 'Please enter a reasonable number (max 999)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
              ],
            );
          }
          return SizedBox.shrink();
        }),

        // Knot Count Input (for Counting by number of knots calculation only)
        Obx(() {
          if (controller.requiresKnotCount()) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Knot Count Configuration',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        'Enter the number of knots for counting. Fee increases with each additional knot.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.orange[600],
                        ),
                      ),
                      Gap(12.h),
                      SurveyUIUtils.buildTextFormField(
                        controller: controller.knotCountController,
                        label: 'Total plot number as per approved layout *',
                        hint: 'Enter number of knots (minimum 1)',
                        icon: PhosphorIcons.link(PhosphorIconsStyle.regular),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter knot count';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Please enter a valid number greater than 0';
                          }
                          if (number > 999) {
                            return 'Please enter a reasonable number (max 999)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
              ],
            );
          }
          return SizedBox.shrink();
        }),

        // Abdominal Section Input (for Stomach calculation only)
        Obx(() {
          if (controller.requiresAbdominalSection()) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abdominal Section Configuration',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        'Enter the number of abdominal sections. Fee increases with each additional section.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue[600],
                        ),
                      ),
                      Gap(12.h),
                      SurveyUIUtils.buildTextFormField(
                        controller: controller.abdominalSectionController,
                        label: 'Abdominal section *',
                        hint: 'Enter number of abdominal sections (minimum 1)',
                        icon: PhosphorIcons.listNumbers(PhosphorIconsStyle.regular),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter abdominal section number';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Please enter a valid number greater than 0';
                          }
                          if (number > 999) {
                            return 'Please enter a reasonable number (max 999)';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Gap(16.h),
              ],
            );
          }
          return SizedBox.shrink();
        }),

        // Calculation Fee (Auto-calculated, read-only)
        SurveyUIUtils.buildTextFormField(
          controller: controller.calculationFeeController,
          label: 'Calculation fee',
          hint: 'Auto-calculated based on selections',
          icon: PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
          readOnly: true,
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

        SurveyUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildFeeBreakdownCard() {
    if (controller.selectedCalculationType.value == null ||
        controller.selectedDuration.value == null ||
        controller.selectedHolderType.value == null ||
        (controller.requiresLocationCategory() &&
            controller.selectedLocationCategory.value == null)) {
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
          _buildBreakdownRow(
            'Calculation Type:',
            controller.selectedCalculationType.value ?? '',
          ),
          _buildBreakdownRow(
              'Duration:', controller.selectedDuration.value ?? ''),
          _buildBreakdownRow(
              'Holder Type:',
              controller.getShortHolderType(
                  controller.selectedHolderType.value ?? '')),

          // Show location category only if required
          if (controller.requiresLocationCategory())
            _buildBreakdownRow(
                'Location:', controller.selectedLocationCategory.value ?? ''),

          // Show abdominal section only for Stomach calculation
          if (controller.selectedCalculationType.value == 'Stomach')
            _buildBreakdownRow('Abdominal Sections:',
                controller.abdominalSectionController.text),

          // Show total plot number only for Non-agricultural calculation
          if (controller.selectedCalculationType.value == 'Non-agricultural')
            _buildBreakdownRow('Total Plot Numbers:',
                controller.totalPlotNumberController.text),

          // Show knot count only for Counting by number of knots calculation
          if (controller.selectedCalculationType.value == 'Counting by number of knots')
            _buildBreakdownRow('Number of Knots:',
                controller.knotCountController.text),

          Divider(color: SetuColors.lightGreen.withOpacity(0.3)),
          _buildBreakdownRow(
            'Total Fee:',
            controller.calculationFeeController.text,
            isTotal: true,
          ),

          // Show calculation details for Stomach type
          if (controller.selectedCalculationType.value == 'Stomach' &&
              controller.calculationFeeController.text.isNotEmpty)
            _buildStomachCalculationDetails(),

          // Show calculation details for Knot counting type
          if (controller.selectedCalculationType.value == 'Counting by number of knots' &&
              controller.calculationFeeController.text.isNotEmpty)
            _buildKnotCountingCalculationDetails(),

          // Show calculation details for Non-agricultural type
          if (controller.selectedCalculationType.value == 'Non-agricultural' &&
              controller.calculationFeeController.text.isNotEmpty)
            _buildNonAgriculturalCalculationDetails(),
        ],
      ),
    );
  }

  Widget _buildStomachCalculationDetails() {
    final sections = int.tryParse(controller.abdominalSectionController.text) ?? 1;

    return Column(
      children: [
        Gap(8.h),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stomach Calculation Details:',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
              Gap(4.h),
              Text(
                'Base fee + Additional sections × Increment rate',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.blue[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (sections > 1)
                Text(
                  'Additional sections: ${sections - 1}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.blue[600],
                  ),
                ),
              Text(
                'Total sections: $sections',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKnotCountingCalculationDetails() {
    final knotCount = int.tryParse(controller.knotCountController.text) ?? 1;

    return Column(
      children: [
        Gap(8.h),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Knot Counting Calculation Details:',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[700],
                ),
              ),
              Gap(4.h),
              Text(
                'Base fee + Additional knots × Increment rate',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.orange[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (knotCount > 1)
                Text(
                  'Additional knots: ${knotCount - 1}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.orange[600],
                  ),
                ),
              Text(
                'Total knots: $knotCount',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.orange[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNonAgriculturalCalculationDetails() {
    final plotNumbers = int.tryParse(controller.totalPlotNumberController.text) ?? 1;

    return Column(
      children: [
        Gap(8.h),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Non-agricultural Calculation Details:',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
              Gap(4.h),
              Text(
                'Base fee + Additional plots × Increment rate',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.green[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (plotNumbers > 1)
                Text(
                  'Additional plots: ${plotNumbers - 1}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.green[600],
                  ),
                ),
              Text(
                'Total plots: $plotNumbers',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.green[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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