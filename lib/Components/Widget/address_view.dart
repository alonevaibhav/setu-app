import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../Constants/color_constant.dart';
import '../LandSurveyView/Steps/survey_ui_utils.dart';

class ApplicantAddressField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final VoidCallback onTap;
  final bool hasDetailedAddress;
  final String? buttonText;
  final IconData? buttonIcon;

  const ApplicantAddressField({
    Key? key,
    this.label = 'Applicant Address',
    this.isRequired = true,
    required this.onTap,
    required this.hasDetailedAddress,
    this.buttonText = 'Detailed Address',
    this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required asterisk
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16.sp * SurveyUIUtils.sizeFactor,
                fontWeight: FontWeight.w600,
                color: SetuColors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 16.sp * SurveyUIUtils.sizeFactor,
                  fontWeight: FontWeight.w500,
                  color: SetuColors.textPrimary,
                ),
              ),
          ],
        ),
        Gap(8.h * SurveyUIUtils.sizeFactor),

        // Button with status indicator
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w * SurveyUIUtils.sizeFactor,
                    vertical: 15.h * SurveyUIUtils.sizeFactor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SetuColors.primaryGreen.withOpacity(0.5),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                    color: SetuColors.primaryGreen.withOpacity(0.03),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        buttonIcon ?? PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
                        color: SetuColors.primaryGreen,
                        size: 18.sp * SurveyUIUtils.sizeFactor,
                      ),
                      Gap(8.w * SurveyUIUtils.sizeFactor),
                      Text(
                        buttonText!,
                        style: TextStyle(
                          fontSize: 14.sp * SurveyUIUtils.sizeFactor,
                          color: SetuColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(12.w * SurveyUIUtils.sizeFactor),

            // Status indicator
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w * SurveyUIUtils.sizeFactor,
                vertical: 6.h * SurveyUIUtils.sizeFactor,
              ),
              decoration: BoxDecoration(
                color: hasDetailedAddress
                    ? SetuColors.primaryGreen.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                hasDetailedAddress
                    ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                    : PhosphorIcons.circle(PhosphorIconsStyle.regular),
                color: hasDetailedAddress
                    ? SetuColors.primaryGreen
                    : Colors.grey,
                size: 16.sp * SurveyUIUtils.sizeFactor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}