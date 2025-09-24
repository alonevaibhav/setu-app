import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/my_application_controller.dart';


Widget buildReviewingContent(
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