import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/color_constant.dart';
import '../../Controller/get_translation_controller/get_text_form.dart';
import 'Controller/main_controller.dart';
import 'nevigation_route.dart';

class CourtCommissionCaseView extends StatelessWidget {
  const CourtCommissionCaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourtCommissionCaseController());
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
            PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress Header
            Container(
              color: SetuColors.primaryGreen,
              padding: EdgeInsets.only(bottom: 20.h * sizeFactor),
              child: Column(
                children: [
                  Gap(16.h * sizeFactor), // Add some top padding
                  // First Row - 4 Steps
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStepIndicator(
                        controller,
                        0,
                        'Court Commission ',
                        PhosphorIcons.lockSimple(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                      _buildStepIndicator(
                        controller,
                        1,
                        'Land\nInformation',
                        PhosphorIcons.clipboard(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                      _buildStepIndicator(
                        controller,
                        2,
                        'Survey\nInformation',
                        PhosphorIcons.fileText(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                      _buildStepIndicator(
                        controller,
                        3,
                        'Calculation\nInformation',
                        PhosphorIcons.calculator(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                    ],
                  ),
                  Gap(12.h * sizeFactor),
                  // Second Row - 4 Steps
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStepIndicator(
                        controller,
                        4,
                        'Plaintiff and Defendant',
                        PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                      _buildStepIndicator(
                        controller,
                        5,
                        'Adjacent Holders',
                        PhosphorIcons.users(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                      _buildStepIndicator(
                        controller,
                        6,
                        'Document\nUpload',
                        PhosphorIcons.user(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                      _buildStepIndicator(
                        controller,
                        7,
                        'Preview',
                        PhosphorIcons.folders(PhosphorIconsStyle.regular),
                        sizeFactor,
                      ),
                    ],
                  ),
                  // Gap(12.h * sizeFactor),
                  // // Third Row - 2 Steps
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _buildStepIndicator(
                  //       controller,
                  //       8,
                  //       'Preview',
                  //       PhosphorIcons.eye(PhosphorIconsStyle.regular),
                  //       sizeFactor,
                  //     ),
                  //     _buildStepIndicator(
                  //       controller,
                  //       9,
                  //       'Payment',
                  //       PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
                  //       sizeFactor,
                  //     ),
                  //   ],
                  // ),
                  Gap(16.h * sizeFactor),
                  // Sub-step Progress Bar
                  Obx(() => _buildSubStepProgress(controller, sizeFactor)),
                ],
              ),
            ),
            // Main Content
            Padding(
              padding: EdgeInsets.all(5.w * sizeFactor),
              child: Column(
                children: [
                  // Dynamic Input Container with Navigation
                  Obx(() => _buildInputContainer(controller, sizeFactor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(
      CourtCommissionCaseController controller,
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
              width: 50.w * sizeFactor,
              height: 50.w * sizeFactor,
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
                size: 20.w * sizeFactor,
              )
                  : Icon(
                icon,
                color: isCurrent
                    ? Colors.black
                    : Colors.white.withOpacity(0.7),
                size: 20.w * sizeFactor,
              ),
            ),
            Gap(6.h * sizeFactor),
            SizedBox(
              width: 70.w * sizeFactor,
              child: GetTranslatableText(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10.sp * sizeFactor,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSubStepProgress(CourtCommissionCaseController controller, double sizeFactor) {
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

  Widget _buildInputContainer(CourtCommissionCaseController controller, double sizeFactor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w * sizeFactor),
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
            mainController: controller,
          ),
          Gap(32.h * sizeFactor),
        ],
      ),
    );
  }
}