import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constants/color_constant.dart';
import '../../../Controller/my_application_controller.dart';




Widget buildChangesRequiredContent(
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