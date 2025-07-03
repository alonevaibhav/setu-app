// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:setuapp/Components/LandServayView/Steps/ZLandAcquisitionUIUtils.dart';
// import '../../../Constants/color_constant.dart';
// import '../../../Controller/land_acquisition_calculation_controller.dart';
//
// class CoownerInformation extends StatelessWidget {
//   final int currentSubStep;
//   final SurveyController controller;
//
//   const CoownerInformation({
//     Key? key,
//     required this.currentSubStep,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // final subSteps = ['address', 'state'];
//
//
//     // final currentField = subSteps[currentSubStep];
//     final subSteps = controller.stepConfigurations[5] ?? ['address'];
//
//     // Ensure currentSubStep is within bounds
//     if (currentSubStep >= subSteps.length) {
//       return _buildAddressInput(); // Fallback
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'coowner':
//         return _buildAddressInput();
//       case 'status':
//         return _buildStateInput();
//       default:
//         return _buildAddressInput();
//     }
//   }
//
//   Widget _buildAddressInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SurveyUIUtils.buildStepHeader(
//           'Property Information',
//           'What is the property address?',
//         ),
//         Gap(24.h),
//         SurveyUIUtils.buildTextFormField(
//           controller: controller.addressController,
//           label: 'Property Address',
//           hint: 'Enter complete property address',
//           icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//           keyboardType: TextInputType.streetAddress,
//           maxLines: 3,
//           validator: (value) {
//             if (value == null || value.trim().length < 10) {
//               return 'Address must be at least 10 characters';
//             }
//             return null;
//           },
//         ),
//         Gap(32.h),
//         SurveyUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildStateInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SurveyUIUtils.buildStepHeader(
//           'Location Details',
//           'Select your state',
//         ),
//         Gap(24.h),
//         Obx(() => SurveyUIUtils.buildDropdownField(
//           label: 'State',
//           value: controller.selectedState.value,
//           items: [
//             'Maharashtra',
//             'Gujarat',
//           ],
//           onChanged: controller.updateState,
//           icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
//         )),
//         Gap(32.h),
//         SurveyUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
// }