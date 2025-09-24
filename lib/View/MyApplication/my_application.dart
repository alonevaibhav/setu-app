// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../Constants/color_constant.dart';
//
// // Application status enum
// enum ApplicationStatus {
//   pending,
//   reviewing,
//   changesRequired,
//   verification,
//   processing,
//   approved,
//   completed
// }
//
// // Application Lifecycle Controller
// class ApplicationLifecycleController extends GetxController {
//   final RxInt currentStatus = 0.obs;
//   final RxString applicationId = 'APP-2025-001'.obs;
//   final RxString submissionDate = '24 Sep 2025'.obs;
//
//   final List<Map<String, dynamic>> lifecycleSteps = [
//     {
//       'status': ApplicationStatus.pending,
//       'title': 'Pending',
//       'description': 'Application submitted and awaiting initial review',
//       'icon': PhosphorIcons.clock(PhosphorIconsStyle.regular),
//       'color': Colors.orange,
//     },
//     {
//       'status': ApplicationStatus.reviewing,
//       'title': 'Reviewing Application',
//       'description': 'Our team is reviewing your submitted documents',
//       'icon': PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
//       'color': Colors.blue,
//     },
//     {
//       'status': ApplicationStatus.changesRequired,
//       'title': 'Changes Required',
//       'description': 'Modifications needed in your application',
//       'icon': PhosphorIcons.pencilSimple(PhosphorIconsStyle.regular),
//       'color': Colors.amber,
//     },
//     {
//       'status': ApplicationStatus.verification,
//       'title': 'Document Verification',
//       'description': 'Verifying submitted documents and information',
//       'icon': PhosphorIcons.shieldCheck(PhosphorIconsStyle.regular),
//       'color': Colors.indigo,
//     },
//     {
//       'status': ApplicationStatus.processing,
//       'title': 'Processing',
//       'description': 'Application is being processed by authorities',
//       'icon': PhosphorIcons.gear(PhosphorIconsStyle.regular),
//       'color': Colors.purple,
//     },
//     {
//       'status': ApplicationStatus.approved,
//       'title': 'Approved',
//       'description': 'Your application has been approved',
//       'icon': PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
//       'color': SetuColors.primaryGreen,
//     },
//     {
//       'status': ApplicationStatus.completed,
//       'title': 'Completed',
//       'description': 'Process completed successfully',
//       'icon': PhosphorIcons.medal(PhosphorIconsStyle.regular),
//       'color': SetuColors.primaryGreen,
//     },
//   ];
//
//   bool isStepCompleted(int step) {
//     return step < currentStatus.value;
//   }
//
//   bool isCurrentStep(int step) {
//     return step == currentStatus.value;
//   }
//
//   bool isUpcomingStep(int step) {
//     return step > currentStatus.value;
//   }
//
//   Color getStepColor(int step) {
//     if (isStepCompleted(step)) {
//       return SetuColors.primaryGreen;
//     } else if (isCurrentStep(step)) {
//       return lifecycleSteps[step]['color'];
//     } else {
//       return Colors.grey.shade300;
//     }
//   }
//
//   // Mock method to simulate status updates (for demo)
//   void updateStatus(int newStatus) {
//     if (newStatus >= 0 && newStatus < lifecycleSteps.length) {
//       currentStatus.value = newStatus;
//     }
//   }
// }
//
// class MyApplication extends StatelessWidget {
//   const MyApplication({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ApplicationLifecycleController());
//     const double sizeFactor = 0.8;
//
//     return Scaffold(
//       backgroundColor: SetuColors.background,
//       appBar: AppBar(
//         backgroundColor: SetuColors.primaryGreen,
//         elevation: 0,
//         title: Text(
//           'Application Status',
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 20.sp * sizeFactor,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(
//             PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
//             color: Colors.white,
//           ),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Application Info Header
//           Container(
//             width: double.infinity,
//             color: SetuColors.primaryGreen,
//             padding: EdgeInsets.only(
//               left: 20.w * sizeFactor,
//               right: 20.w * sizeFactor,
//               bottom: 20.h * sizeFactor,
//             ),
//             child: Obx(() => Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Application ID: ${controller.applicationId.value}',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 16.sp * sizeFactor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Gap(4.h * sizeFactor),
//                     Text(
//                       'Submitted: ${controller.submissionDate.value}',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 14.sp * sizeFactor,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 )),
//           ),
//
//           // Main Content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(20.w * sizeFactor),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Current Status Card
//                   Obx(() => _buildCurrentStatusCard(controller, sizeFactor)),
//
//                   Gap(24.h * sizeFactor),
//
//                   // Timeline Header
//                   Text(
//                     'Application Timeline',
//                     style: GoogleFonts.poppins(
//                       fontSize: 18.sp * sizeFactor,
//                       fontWeight: FontWeight.w600,
//                       color: SetuColors.primaryGreen,
//                     ),
//                   ),
//
//                   Gap(16.h * sizeFactor),
//
//                   // Timeline Steps
//                   Obx(() => _buildTimeline(controller, sizeFactor)),
//
//                   Gap(32.h * sizeFactor),
//
//                   // Demo Controls (Remove this in production)
//                   _buildDemoControls(controller, sizeFactor),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCurrentStatusCard(
//       ApplicationLifecycleController controller, double sizeFactor) {
//     final currentStep =
//         controller.lifecycleSteps[controller.currentStatus.value];
//
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w * sizeFactor),
//       decoration: BoxDecoration(
//         color: SetuColors.cardBackground,
//         borderRadius: BorderRadius.circular(16.r * sizeFactor),
//         boxShadow: [
//           BoxShadow(
//             color: SetuColors.primaryGreen.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//         border: Border.all(
//           color: SetuColors.lightGreen.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12.w * sizeFactor),
//                 decoration: BoxDecoration(
//                   color: currentStep['color'].withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12.r * sizeFactor),
//                 ),
//                 child: Icon(
//                   currentStep['icon'],
//                   color: currentStep['color'],
//                   size: 24.w * sizeFactor,
//                 ),
//               ),
//               Gap(16.w * sizeFactor),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Current Status',
//                       style: GoogleFonts.poppins(
//                         fontSize: 12.sp * sizeFactor,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     Text(
//                       currentStep['title'],
//                       style: GoogleFonts.poppins(
//                         fontSize: 20.sp * sizeFactor,
//                         fontWeight: FontWeight.w600,
//                         color: SetuColors.primaryGreen,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Gap(16.h * sizeFactor),
//           Text(
//             currentStep['description'],
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp * sizeFactor,
//               fontWeight: FontWeight.w400,
//               color: Colors.grey.shade700,
//               height: 1.5,
//             ),
//           ),
//           Gap(16.h * sizeFactor),
//           // Progress indicator
//           LinearProgressIndicator(
//             value: (controller.currentStatus.value + 1) /
//                 controller.lifecycleSteps.length,
//             backgroundColor: Colors.grey.shade200,
//             valueColor: AlwaysStoppedAnimation<Color>(SetuColors.primaryGreen),
//             minHeight: 6.h * sizeFactor,
//           ),
//           Gap(8.h * sizeFactor),
//           Text(
//             '${controller.currentStatus.value + 1} of ${controller.lifecycleSteps.length} steps completed',
//             style: GoogleFonts.poppins(
//               fontSize: 12.sp * sizeFactor,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeline(
//       ApplicationLifecycleController controller, double sizeFactor) {
//     return Column(
//       children: controller.lifecycleSteps.asMap().entries.map((entry) {
//         final index = entry.key;
//         final step = entry.value;
//         final isLast = index == controller.lifecycleSteps.length - 1;
//
//         return _buildTimelineStep(
//           controller,
//           index,
//           step,
//           isLast,
//           sizeFactor,
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildTimelineStep(
//     ApplicationLifecycleController controller,
//     int index,
//     Map<String, dynamic> step,
//     bool isLast,
//     double sizeFactor,
//   ) {
//     final isCompleted = controller.isStepCompleted(index);
//     final isCurrent = controller.isCurrentStep(index);
//     final isUpcoming = controller.isUpcomingStep(index);
//     final stepColor = controller.getStepColor(index);
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Timeline indicator
//         Column(
//           children: [
//             Container(
//               width: 40.w * sizeFactor,
//               height: 40.w * sizeFactor,
//               decoration: BoxDecoration(
//                 color: stepColor,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: stepColor,
//                   width: 2,
//                 ),
//               ),
//               child: isCompleted
//                   ? Icon(
//                       PhosphorIcons.check(PhosphorIconsStyle.bold),
//                       color: Colors.white,
//                       size: 16.w * sizeFactor,
//                     )
//                   : Icon(
//                       step['icon'],
//                       color: isCurrent
//                           ? Colors.white
//                           : isUpcoming
//                               ? Colors.grey.shade400
//                               : Colors.white,
//                       size: 16.w * sizeFactor,
//                     ),
//             ),
//             if (!isLast) ...[
//               Container(
//                 width: 2,
//                 height: 60.h * sizeFactor,
//                 color: isCompleted
//                     ? SetuColors.primaryGreen
//                     : Colors.grey.shade300,
//               ),
//             ],
//           ],
//         ),
//
//         Gap(16.w * sizeFactor),
//
//         // Step content
//         Expanded(
//           child: Container(
//             margin: EdgeInsets.only(bottom: isLast ? 0 : 20.h * sizeFactor),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   step['title'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp * sizeFactor,
//                     fontWeight: FontWeight.w600,
//                     color: isUpcoming
//                         ? Colors.grey.shade500
//                         : SetuColors.primaryGreen,
//                   ),
//                 ),
//                 Gap(4.h * sizeFactor),
//                 Text(
//                   step['description'],
//                   style: GoogleFonts.poppins(
//                     fontSize: 14.sp * sizeFactor,
//                     fontWeight: FontWeight.w400,
//                     color: isUpcoming
//                         ? Colors.grey.shade400
//                         : Colors.grey.shade700,
//                     height: 1.4,
//                   ),
//                 ),
//                 Gap(8.h * sizeFactor),
//                 // Placeholder for actual content
//                 Container(
//                   padding: EdgeInsets.all(12.w * sizeFactor),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(8.r * sizeFactor),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Text(
//                     'Hello - Content for ${step['title']} will go here',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12.sp * sizeFactor,
//                       fontStyle: FontStyle.italic,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Demo controls - Remove this in production
//   Widget _buildDemoControls(
//       ApplicationLifecycleController controller, double sizeFactor) {
//     return Container(
//       padding: EdgeInsets.all(16.w * sizeFactor),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12.r * sizeFactor),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Demo Controls (Remove in Production)',
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp * sizeFactor,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           Gap(12.h * sizeFactor),
//           Wrap(
//             spacing: 8.w * sizeFactor,
//             children: List.generate(
//               controller.lifecycleSteps.length,
//               (index) => ElevatedButton(
//                 onPressed: () => controller.updateStatus(index),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: SetuColors.primaryGreen,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 12.w * sizeFactor,
//                     vertical: 8.h * sizeFactor,
//                   ),
//                 ),
//                 child: Text(
//                   'Step ${index + 1}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 12.sp * sizeFactor,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
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
import '../../Controller/my_application_controller.dart';
import 'Components/life_five.dart';
import 'Components/life_four.dart';
import 'Components/life_one.dart';
import 'Components/life_seventh.dart';
import 'Components/life_six.dart';
import 'Components/life_three.dart';
import 'Components/life_two.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ApplicationLifecycleController());
    const double sizeFactor = 0.8;

    return Scaffold(
      backgroundColor: SetuColors.background,
      appBar: AppBar(
        backgroundColor: SetuColors.primaryGreen,
        elevation: 0,
        title: Text(
          'Application Status',
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
          // Application Info Header
          Container(
            width: double.infinity,
            color: SetuColors.primaryGreen,
            padding: EdgeInsets.only(
              left: 20.w * sizeFactor,
              right: 20.w * sizeFactor,
              bottom: 20.h * sizeFactor,
            ),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Application ID: ${controller.applicationId.value}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16.sp * sizeFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(4.h * sizeFactor),
                    Text(
                      'Submitted: ${controller.submissionDate.value}',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp * sizeFactor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w * sizeFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Status Card

                  Gap(20.h * sizeFactor),

                  // Timeline Header
                  Text(
                    'Application Timeline',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp * sizeFactor,
                      fontWeight: FontWeight.w600,
                      color: SetuColors.primaryGreen,
                    ),
                  ),

                  Gap(20.h * sizeFactor),

                  // Timeline Steps
                  Obx(() => _buildTimeline(controller, sizeFactor)),

                  Gap(32.h * sizeFactor),

                  // Demo Controls (Remove this in production)
                  _buildDemoControls(controller, sizeFactor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Column(
      children: controller.lifecycleSteps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == controller.lifecycleSteps.length - 1;

        return _buildTimelineStep(
          controller,
          index,
          step,
          isLast,
          sizeFactor,
        );
      }).toList(),
    );
  }

  Widget _buildTimelineStep(
    ApplicationLifecycleController controller,
    int index,
    Map<String, dynamic> step,
    bool isLast,
    double sizeFactor,
  ) {
    final isCompleted = controller.isStepCompleted(index);
    final isCurrent = controller.isCurrentStep(index);
    final isUpcoming = controller.isUpcomingStep(index);
    final stepColor = controller.getStepColor(index);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator column
        Column(
          children: [
            Container(
              width: 40.w * sizeFactor,
              height: 40.w * sizeFactor,
              decoration: BoxDecoration(
                color: stepColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: stepColor,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      PhosphorIcons.check(PhosphorIconsStyle.bold),
                      color: Colors.white,
                      size: 16.w * sizeFactor,
                    )
                  : Icon(
                      step['icon'],
                      color: isCurrent
                          ? Colors.white
                          : isUpcoming
                              ? Colors.grey.shade400
                              : Colors.white,
                      size: 16.w * sizeFactor,
                    ),
            ),
            if (!isLast) ...[
              Container(
                width: 2,
                height: _getStepContentHeight(controller, index, sizeFactor),
                color: isCompleted
                    ? SetuColors.primaryGreen
                    : Colors.grey.shade300,
              ),
            ],
          ],
        ),

        Gap(16.w * sizeFactor),

        // Step content column (expanded to take remaining space)
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 20.h * sizeFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step title and description
                Text(
                  step['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: isUpcoming
                        ? Colors.grey.shade500
                        : SetuColors.primaryGreen,
                  ),
                ),
                Gap(4.h * sizeFactor),
                Text(
                  step['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w400,
                    color: isUpcoming
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                Gap(16.h * sizeFactor),

                // Step-specific content view
                _buildStepContent(controller, index, step, sizeFactor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Calculate the height needed for the connecting line based on content
  double _getStepContentHeight(
      ApplicationLifecycleController controller, int index, double sizeFactor) {
    // Base height for title and description
    double baseHeight = 50.h * sizeFactor;

    // Add extra height based on step content
    if (controller.isCurrentStep(index)) {
      switch (controller.lifecycleSteps[index]['status']) {
        case ApplicationStatus.changesRequired:
          baseHeight +=
              (controller.requiredChanges.length * 60.h * sizeFactor) +
                  100.h * sizeFactor;
          break;
        case ApplicationStatus.verification:
          baseHeight +=
              (controller.uploadedDocuments.length * 50.h * sizeFactor) +
                  80.h * sizeFactor;
          break;
        default:
          baseHeight += 120.h * sizeFactor;
      }
    } else {
      baseHeight += 80.h * sizeFactor;
    }

    return baseHeight;
  }

  // Build step-specific content based on the application status
  Widget _buildStepContent(ApplicationLifecycleController controller, int index,
      Map<String, dynamic> step, double sizeFactor) {
    // Show detailed content only for current step
    if (!controller.isCurrentStep(index)) {
      return Container(
        padding: EdgeInsets.all(16.w * sizeFactor),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r * sizeFactor),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              controller.isStepCompleted(index)
                  ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                  : PhosphorIcons.clock(PhosphorIconsStyle.regular),
              size: 16.w * sizeFactor,
              color: controller.isStepCompleted(index)
                  ? SetuColors.primaryGreen
                  : Colors.grey.shade400,
            ),
            Gap(8.w * sizeFactor),
            Text(
              controller.isStepCompleted(index)
                  ? 'Completed'
                  : 'Awaiting progress',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    // Build content based on current step status
    switch (step['status']) {
      case ApplicationStatus.pending:
        return buildPendingContent(controller, sizeFactor);

      case ApplicationStatus.reviewing:
        return buildReviewingContent(controller, sizeFactor);

      case ApplicationStatus.changesRequired:
        return buildChangesRequiredContent(controller, sizeFactor);

      case ApplicationStatus.verification:
        return buildVerificationContent(controller, sizeFactor);

      case ApplicationStatus.processing:
        return buildProcessingContent(controller, sizeFactor);

      case ApplicationStatus.approved:
        return buildApprovedContent(controller, sizeFactor);

      case ApplicationStatus.completed:
        return buildCompletedContent(controller, sizeFactor);

      default:
        return buildDefaultContent(sizeFactor);
    }
  }

  Widget buildDefaultContent(double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.info(PhosphorIconsStyle.regular),
              size: 16.w * sizeFactor, color: Colors.grey.shade400),
          Gap(8.w * sizeFactor),
          Text('Awaiting progress',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              )),
        ],
      ),
    );
  }

  // Demo controls - Remove this in production
  Widget _buildDemoControls(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo Controls (Remove in Production)',
            style: GoogleFonts.poppins(
              fontSize: 14.sp * sizeFactor,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Gap(12.h * sizeFactor),
          Wrap(
            spacing: 8.w * sizeFactor,
            children: List.generate(
              controller.lifecycleSteps.length,
              (index) => ElevatedButton(
                onPressed: () => controller.updateStatus(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SetuColors.primaryGreen,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w * sizeFactor,
                    vertical: 8.h * sizeFactor,
                  ),
                ),
                child: Text(
                  'Step ${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp * sizeFactor,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
