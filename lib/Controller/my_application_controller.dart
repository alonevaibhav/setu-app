import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Constants/color_constant.dart';

// Application status enum
enum ApplicationStatus {
  pending,
  reviewing,
  changesRequired,
  verification,
  processing,
  approved,
  completed
}

// Application Lifecycle Controller
class ApplicationLifecycleController extends GetxController {
  final RxInt currentStatus = 2.obs; // Set to changesRequired for demo
  final RxString applicationId = 'APP-2025-001'.obs;
  final RxString submissionDate = '24 Sep 2025'.obs;
  final RxList<String> requiredChanges = <String>[
    'Update address proof document',
    'Provide clearer signature on form 2',
    'Submit income certificate',
  ].obs;
  final RxList<String> uploadedDocuments = <String>[
    'Identity Proof.pdf',
    'Address Proof.pdf',
    'Application Form.pdf',
  ].obs;

  final List<Map<String, dynamic>> lifecycleSteps = [
    {
      'status': ApplicationStatus.pending,
      'title': 'Pending',
      'description': 'Application submitted and awaiting initial review',
      'icon': PhosphorIcons.clock(PhosphorIconsStyle.regular),
      'color': Colors.orange,
    },
    {
      'status': ApplicationStatus.reviewing,
      'title': 'Reviewing Application',
      'description': 'Our team is reviewing your submitted documents',
      'icon': PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
      'color': Colors.blue,
    },
    {
      'status': ApplicationStatus.changesRequired,
      'title': 'Changes Required',
      'description': 'Modifications needed in your application',
      'icon': PhosphorIcons.pencilSimple(PhosphorIconsStyle.regular),
      'color': Colors.amber,
    },
    {
      'status': ApplicationStatus.verification,
      'title': 'Document Verification',
      'description': 'Verifying submitted documents and information',
      'icon': PhosphorIcons.shieldCheck(PhosphorIconsStyle.regular),
      'color': Colors.indigo,
    },
    {
      'status': ApplicationStatus.processing,
      'title': 'Processing',
      'description': 'Application is being processed by authorities',
      'icon': PhosphorIcons.gear(PhosphorIconsStyle.regular),
      'color': Colors.purple,
    },
    {
      'status': ApplicationStatus.approved,
      'title': 'Approved',
      'description': 'Your application has been approved',
      'icon': PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
      'color': SetuColors.primaryGreen,
    },
    {
      'status': ApplicationStatus.completed,
      'title': 'Completed',
      'description': 'Process completed successfully',
      'icon': PhosphorIcons.medal(PhosphorIconsStyle.regular),
      'color': SetuColors.primaryGreen,
    },
  ];

  bool isStepCompleted(int step) {
    return step < currentStatus.value;
  }

  bool isCurrentStep(int step) {
    return step == currentStatus.value;
  }

  bool isUpcomingStep(int step) {
    return step > currentStatus.value;
  }

  Color getStepColor(int step) {
    if (isStepCompleted(step)) {
      return SetuColors.primaryGreen;
    } else if (isCurrentStep(step)) {
      return lifecycleSteps[step]['color'];
    } else {
      return Colors.grey.shade300;
    }
  }

  void updateStatus(int newStatus) {
    if (newStatus >= 0 && newStatus < lifecycleSteps.length) {
      currentStatus.value = newStatus;
    }
  }

  void markChangeAsComplete(int index) {
    requiredChanges.removeAt(index);
  }

  void uploadDocument(String docName) {
    uploadedDocuments.add(docName);
  }
}
