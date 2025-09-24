import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/color_constant.dart';
import '../../../Controller/my_application_controller.dart';


Widget buildVerificationContent(
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