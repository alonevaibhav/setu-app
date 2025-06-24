
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Constants/color_constant.dart';
import '../../../Controller/land_survey_controller.dart';

class SurveyUIUtils {
  static const double sizeFactor = 0.75; // Size constant variable

  static Widget buildStepHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22.sp * sizeFactor,
            fontWeight: FontWeight.w700,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(6.h * sizeFactor),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14.sp * sizeFactor,
            color: SetuColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  static Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp * sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h * sizeFactor),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          style: GoogleFonts.poppins(fontSize: 16.sp * sizeFactor),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: SetuColors.primaryGreen, size: 20.w * sizeFactor),
            filled: true,
            fillColor: SetuColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.error, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w * sizeFactor, vertical: 16.h * sizeFactor),
          ),
        ),
      ],
    );
  }

  static Widget buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16.sp * sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h * sizeFactor),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: GoogleFonts.poppins(fontSize: 16.sp * sizeFactor)),
          ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: SetuColors.primaryGreen, size: 20.w * sizeFactor),
            filled: true,
            fillColor: SetuColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * sizeFactor),
              borderSide: BorderSide(color: SetuColors.primaryGreen, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w * sizeFactor, vertical: 16.h * sizeFactor),
          ),
        ),
      ],
    );
  }

  static Widget buildNavigationButtons(SurveyController controller) {
    return Obx(() => Row(
      children: [
        // Previous Button
        if (controller.currentStep.value > 0 || controller.currentSubStep.value > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: controller.previousSubStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: SetuColors.textSecondary,
                padding: EdgeInsets.symmetric(vertical: 16.h * sizeFactor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r * sizeFactor),
                ),
              ),
              child: Text(
                'Previous',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp * sizeFactor,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (controller.currentStep.value > 0 || controller.currentSubStep.value > 0)
          Gap(16.w * sizeFactor),
        // Next/Submit Button
        Expanded(
          flex: (controller.currentStep.value == 0 && controller.currentSubStep.value == 0) ? 1 : 1,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.nextSubStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: SetuColors.primaryGreen,
              padding: EdgeInsets.symmetric(vertical: 16.h * sizeFactor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r * sizeFactor),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
              height: 20.h * sizeFactor,
              width: 20.w * sizeFactor,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
              controller.nextButtonText,
              style: GoogleFonts.poppins(
                fontSize: 16.sp * sizeFactor,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ));
  }

  static Widget buildStatusContainer({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w * sizeFactor),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r * sizeFactor),
        border: Border.all(color: backgroundColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24.w * sizeFactor),
          Gap(16.w * sizeFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp * sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Gap(4.h * sizeFactor),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp * sizeFactor,
                    color: SetuColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
