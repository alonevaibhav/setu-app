// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../Constants/color_constant.dart';
// import '../../Controller/land_survey_controller.dart';
// import 'land_survey_widget.dart';
//
// class SurveyView extends StatelessWidget {
//   const SurveyView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SurveyController());
//
//     return Scaffold(
//       backgroundColor: SetuColors.background,
//       appBar: AppBar(
//         backgroundColor: SetuColors.primaryGreen,
//         elevation: 0,
//         title: Text(
//           'Setu Survey',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
//               color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Progress Header
//           Container(
//             color: SetuColors.primaryGreen,
//             padding: EdgeInsets.only(bottom: 20.h),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildStepIndicator(
//                       controller,
//                       0,
//                       'Personal\nInfo',
//                       PhosphorIcons.user(PhosphorIconsStyle.regular),
//                     ),
//                     _buildStepIndicator(
//                       controller,
//                       1,
//                       'Survey/CTS\nInformation',
//                       PhosphorIcons.clipboard(PhosphorIconsStyle.regular),
//                     ),
//                     _buildStepIndicator(
//                       controller,
//                       2,
//                       'Survey\nDetails',
//                       PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//                     ),
//                   ],
//                 ),
//
//                 Gap(16.h),
//
//                 // Sub-step Progress Bar
//                 Obx(() => _buildSubStepProgress(controller)),
//               ],
//             ),
//           ),
//
//           // Main Content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 children: [
//                   // Dynamic Input Container with Navigation
//                   Obx(() => _buildInputContainer(controller)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStepIndicator(
//     SurveyController controller,
//     int step,
//     String title,
//     IconData icon,
//   ) {
//     return Obx(() {
//       final isCompleted = controller.isMainStepCompleted(step);
//       final isCurrent = controller.currentStep.value == step;
//       final color = controller.getStepIndicatorColor(step);
//
//       return GestureDetector(
//         onTap: () => controller.goToStep(step),
//         child: Column(
//           children: [
//             Container(
//               width: 60.w,
//               height: 60.w,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: color,
//                   width: 2,
//                 ),
//               ),
//               child: isCompleted
//                   ? Icon(
//                       PhosphorIcons.check(PhosphorIconsStyle.bold),
//                       color: Colors.white,
//                       size: 24.w,
//                     )
//                   : Icon(
//                       icon,
//                       color: isCurrent
//                           ? Colors.black
//                           : Colors.white.withOpacity(0.7),
//                       size: 24.w,
//                     ),
//             ),
//             Gap(8.h),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildSubStepProgress(SurveyController controller) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 40.w),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Step ${controller.currentSubStep.value + 1} of ${controller.totalSubStepsInCurrentStep}',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 '${(((controller.currentSubStep.value + 1) / controller.totalSubStepsInCurrentStep) * 100).toInt()}%',
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           Gap(8.h),
//           LinearProgressIndicator(
//             value: (controller.currentSubStep.value + 1) /
//                 controller.totalSubStepsInCurrentStep,
//             backgroundColor: Colors.white.withOpacity(0.3),
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//             minHeight: 4.h,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputContainer(SurveyController controller) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24.w),
//       decoration: BoxDecoration(
//         color: SetuColors.cardBackground,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [
//           BoxShadow(
//             color: SetuColors.primaryGreen.withOpacity(0.1),
//             blurRadius: 20,
//             offset: Offset(0, 10),
//           ),
//         ],
//         border: Border.all(
//           color: SetuColors.lightGreen.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Current Sub-step Content
//           SurveyStepWidget(
//             currentStep: controller.currentStep.value,
//             currentSubStep: controller.currentSubStep.value,
//             controller: controller,
//           ),
//
//           Gap(32.h),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/color_constant.dart';
import '../../Controller/land_survey_controller.dart';
import 'land_survey_widget.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SurveyController());
    const double sizeFactor = 0.9; // Size constant variable

    return Scaffold(
      backgroundColor: SetuColors.background,
      appBar: AppBar(
        backgroundColor: SetuColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Setu Survey',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.sp * sizeFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            color: SetuColors.primaryGreen,
            padding: EdgeInsets.only(bottom: 20.h * sizeFactor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStepIndicator(
                      controller,
                      0,
                      'Personal\nInfo',
                      PhosphorIcons.user(PhosphorIconsStyle.regular),
                      sizeFactor,
                    ),
                    _buildStepIndicator(
                      controller,
                      1,
                      'Survey/CTS\nInformation',
                      PhosphorIcons.clipboard(PhosphorIconsStyle.regular),
                      sizeFactor,
                    ),
                    _buildStepIndicator(
                      controller,
                      2,
                      'Survey\nDetails',
                      PhosphorIcons.fileText(PhosphorIconsStyle.regular),
                      sizeFactor,
                    ),
                  ],
                ),
                Gap(16.h * sizeFactor),
                // Sub-step Progress Bar
                Obx(() => _buildSubStepProgress(controller, sizeFactor)),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15.w * sizeFactor),
              child: Column(
                children: [
                  // Dynamic Input Container with Navigation
                  Obx(() => _buildInputContainer(controller, sizeFactor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
      SurveyController controller,
      int step,
      String title,
      IconData icon,
      double sizeFactor,
      ) {
    return Obx(() {
      final isCompleted = controller.isMainStepCompleted(step);
      final isCurrent = controller.currentStep.value == step;
      final color = controller.getStepIndicatorColor(step);
      return GestureDetector(
        onTap: () => controller.goToStep(step),
        child: Column(
          children: [
            Container(
              width: 60.w * sizeFactor,
              height: 60.w * sizeFactor,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                PhosphorIcons.check(PhosphorIconsStyle.bold),
                color: Colors.white,
                size: 24.w * sizeFactor,
              )
                  : Icon(
                icon,
                color: isCurrent
                    ? Colors.black
                    : Colors.white.withOpacity(0.7),
                size: 24.w * sizeFactor,
              ),
            ),
            Gap(8.h * sizeFactor),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp * sizeFactor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSubStepProgress(SurveyController controller, double sizeFactor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w * sizeFactor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${controller.currentSubStep.value + 1} of ${controller.totalSubStepsInCurrentStep}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp * sizeFactor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(((controller.currentSubStep.value + 1) / controller.totalSubStepsInCurrentStep) * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp * sizeFactor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Gap(8.h * sizeFactor),
          LinearProgressIndicator(
            value: (controller.currentSubStep.value + 1) /
                controller.totalSubStepsInCurrentStep,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 4.h * sizeFactor,
          ),
        ],
      ),
    );
  }

  Widget _buildInputContainer(SurveyController controller, double sizeFactor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w * sizeFactor),
      decoration: BoxDecoration(
        color: SetuColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r * sizeFactor),
        boxShadow: [
          BoxShadow(
            color: SetuColors.primaryGreen.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: SetuColors.lightGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Current Sub-step Content
          SurveyStepWidget(
            currentStep: controller.currentStep.value,
            currentSubStep: controller.currentSubStep.value,
            controller: controller,
          ),
          Gap(32.h * sizeFactor),
        ],
      ),
    );
  }
}
