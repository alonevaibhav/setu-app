import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/color_constant.dart';
import '../../../Controller/my_application_controller.dart';


Widget buildProcessingContent(
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