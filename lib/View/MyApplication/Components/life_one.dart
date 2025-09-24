import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/my_application_controller.dart';

Widget buildPendingContent(
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
