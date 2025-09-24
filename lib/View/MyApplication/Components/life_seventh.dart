import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/color_constant.dart';
import '../../../Controller/my_application_controller.dart';


Widget buildCompletedContent(
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