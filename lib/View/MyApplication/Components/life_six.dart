import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/color_constant.dart';
import '../../../Controller/my_application_controller.dart';


Widget buildApprovedContent(
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