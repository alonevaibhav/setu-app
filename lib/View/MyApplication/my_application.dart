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
                  Obx(() => _buildCurrentStatusCard(controller, sizeFactor)),

                  Gap(24.h * sizeFactor),

                  // Timeline Header
                  Text(
                    'Application Timeline',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp * sizeFactor,
                      fontWeight: FontWeight.w600,
                      color: SetuColors.primaryGreen,
                    ),
                  ),

                  Gap(16.h * sizeFactor),

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

  Widget _buildCurrentStatusCard(
      ApplicationLifecycleController controller, double sizeFactor) {
    final currentStep =
        controller.lifecycleSteps[controller.currentStatus.value];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w * sizeFactor),
      decoration: BoxDecoration(
        color: SetuColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r * sizeFactor),
        boxShadow: [
          BoxShadow(
            color: SetuColors.primaryGreen.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: SetuColors.lightGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w * sizeFactor),
                decoration: BoxDecoration(
                  color: currentStep['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r * sizeFactor),
                ),
                child: Icon(
                  currentStep['icon'],
                  color: currentStep['color'],
                  size: 24.w * sizeFactor,
                ),
              ),
              Gap(16.w * sizeFactor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp * sizeFactor,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      currentStep['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp * sizeFactor,
                        fontWeight: FontWeight.w600,
                        color: SetuColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16.h * sizeFactor),
          Text(
            currentStep['description'],
            style: GoogleFonts.poppins(
              fontSize: 14.sp * sizeFactor,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          Gap(16.h * sizeFactor),
          // Progress indicator
          LinearProgressIndicator(
            value: (controller.currentStatus.value + 1) /
                controller.lifecycleSteps.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(SetuColors.primaryGreen),
            minHeight: 6.h * sizeFactor,
          ),
          Gap(8.h * sizeFactor),
          Text(
            '${controller.currentStatus.value + 1} of ${controller.lifecycleSteps.length} steps completed',
            style: GoogleFonts.poppins(
              fontSize: 12.sp * sizeFactor,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
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
        return _buildPendingContent(controller, sizeFactor);

      case ApplicationStatus.reviewing:
        return _buildReviewingContent(controller, sizeFactor);

      case ApplicationStatus.changesRequired:
        return _buildChangesRequiredContent(controller, sizeFactor);

      case ApplicationStatus.verification:
        return _buildVerificationContent(controller, sizeFactor);

      case ApplicationStatus.processing:
        return _buildProcessingContent(controller, sizeFactor);

      case ApplicationStatus.approved:
        return _buildApprovedContent(controller, sizeFactor);

      case ApplicationStatus.completed:
        return _buildCompletedContent(controller, sizeFactor);

      default:
        return _buildDefaultContent(sizeFactor);
    }
  }

  Widget _buildPendingContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.clock(PhosphorIconsStyle.fill),
                  color: Colors.orange, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Application Received',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text(
              'Your application has been successfully submitted and is in queue for review.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.orange.shade700,
              )),
          Gap(8.h * sizeFactor),
          Text('Estimated review time: 2-3 business days',
              style: GoogleFonts.poppins(
                fontSize: 11.sp * sizeFactor,
                color: Colors.orange.shade600,
                fontStyle: FontStyle.italic,
              )),
        ],
      ),
    );
  }

  Widget _buildReviewingContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill),
                  color: Colors.blue, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Under Review',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text(
              'Our team is currently reviewing your application and documents.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.blue.shade700,
              )),
          Gap(16.h * sizeFactor),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.blue.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Gap(8.h * sizeFactor),
          Text('Review Progress: 60%',
              style: GoogleFonts.poppins(
                fontSize: 11.sp * sizeFactor,
                color: Colors.blue.shade600,
              )),
        ],
      ),
    );
  }

  Widget _buildChangesRequiredContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill),
                  color: Colors.amber.shade700, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Action Required',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text('Please address the following issues to proceed:',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.amber.shade700,
              )),
          Gap(16.h * sizeFactor),

          // List of required changes
          ...controller.requiredChanges.asMap().entries.map((entry) {
            final index = entry.key;
            final change = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 8.h * sizeFactor),
              padding: EdgeInsets.all(12.w * sizeFactor),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r * sizeFactor),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(change,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp * sizeFactor,
                          color: Colors.amber.shade800,
                        )),
                  ),
                  Gap(8.w * sizeFactor),
                  GestureDetector(
                    onTap: () => controller.markChangeAsComplete(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w * sizeFactor,
                        vertical: 4.h * sizeFactor,
                      ),
                      decoration: BoxDecoration(
                        color: SetuColors.primaryGreen,
                        borderRadius: BorderRadius.circular(4.r * sizeFactor),
                      ),
                      child: Text('Mark Done',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp * sizeFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          Gap(16.h * sizeFactor),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle upload documents
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                padding: EdgeInsets.symmetric(vertical: 12.h * sizeFactor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r * sizeFactor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.uploadSimple(PhosphorIconsStyle.regular),
                      size: 16.w * sizeFactor, color: Colors.white),
                  Gap(8.w * sizeFactor),
                  Text('Upload Documents',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp * sizeFactor,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.shieldCheck(PhosphorIconsStyle.fill),
                  color: Colors.indigo, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Document Verification',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade800,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text('Verifying submitted documents:',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.indigo.shade700,
              )),
          Gap(16.h * sizeFactor),

          // Document list
          ...controller.uploadedDocuments
              .map((doc) => Container(
                    margin: EdgeInsets.only(bottom: 8.h * sizeFactor),
                    padding: EdgeInsets.all(12.w * sizeFactor),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r * sizeFactor),
                      border: Border.all(color: Colors.indigo.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(PhosphorIcons.filePdf(PhosphorIconsStyle.regular),
                            color: Colors.indigo, size: 16.w * sizeFactor),
                        Gap(8.w * sizeFactor),
                        Expanded(
                          child: Text(doc,
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp * sizeFactor,
                                color: Colors.indigo.shade800,
                              )),
                        ),
                        Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                            color: SetuColors.primaryGreen,
                            size: 16.w * sizeFactor),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProcessingContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.gear(PhosphorIconsStyle.fill),
                  color: Colors.purple, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Processing',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade800,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text(
              'Your application is being processed by the relevant authorities.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.purple.shade700,
              )),
          Gap(16.h * sizeFactor),
          Row(
            children: [
              SizedBox(
                width: 16.w * sizeFactor,
                height: 16.w * sizeFactor,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
              ),
              Gap(12.w * sizeFactor),
              Text('Processing in progress...',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp * sizeFactor,
                    color: Colors.purple.shade600,
                    fontStyle: FontStyle.italic,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: SetuColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  color: SetuColors.primaryGreen, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Application Approved!',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text('Congratulations! Your application has been approved.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.green.shade700,
              )),
          Gap(16.h * sizeFactor),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle download certificate
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SetuColors.primaryGreen,
                padding: EdgeInsets.symmetric(vertical: 12.h * sizeFactor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r * sizeFactor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.downloadSimple(PhosphorIconsStyle.regular),
                      size: 16.w * sizeFactor, color: Colors.white),
                  Gap(8.w * sizeFactor),
                  Text('Download Approval Letter',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp * sizeFactor,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedContent(
      ApplicationLifecycleController controller, double sizeFactor) {
    return Container(
      padding: EdgeInsets.all(16.w * sizeFactor),
      decoration: BoxDecoration(
        color: SetuColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.medal(PhosphorIconsStyle.fill),
                  color: SetuColors.primaryGreen, size: 20.w * sizeFactor),
              Gap(8.w * sizeFactor),
              Text('Process Completed!',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  )),
            ],
          ),
          Gap(12.h * sizeFactor),
          Text('Your application process has been completed successfully.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp * sizeFactor,
                color: Colors.green.shade700,
              )),
          Gap(16.h * sizeFactor),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle download certificate
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SetuColors.primaryGreen,
                    padding: EdgeInsets.symmetric(vertical: 10.h * sizeFactor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r * sizeFactor),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          PhosphorIcons.certificate(PhosphorIconsStyle.regular),
                          size: 14.w * sizeFactor,
                          color: Colors.white),
                      Gap(6.w * sizeFactor),
                      Text('Certificate',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp * sizeFactor,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
              Gap(8.w * sizeFactor),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle view details
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10.h * sizeFactor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r * sizeFactor),
                      side: BorderSide(color: SetuColors.primaryGreen),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(PhosphorIcons.eye(PhosphorIconsStyle.regular),
                          size: 14.w * sizeFactor,
                          color: SetuColors.primaryGreen),
                      Gap(6.w * sizeFactor),
                      Text('View Details',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp * sizeFactor,
                            color: SetuColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(double sizeFactor) {
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
