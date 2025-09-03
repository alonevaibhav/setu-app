import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../Constants/color_constant.dart';
import '../../Utils/file_full_screen_view.dart';
import '../LandSurveyView/Controller/preview_controller.dart';



Widget buildFileRow(String label, List<String> files,controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
      ),
      Gap(8.h),
      Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: files.asMap().entries.map((entry) {
          final index = entry.key;
          final filePath = entry.value;
          final fileName = controller.getFileName(filePath);
          final isImage = controller.isImageFile(fileName);
          final isPdf = controller.isPdfFile(fileName);
          final isWord = controller.isWordFile(fileName);

          return GestureDetector(
            onTap: () {
              // Use the new FileFullScreenView for all file types
              Get.to(() => FileFullScreenView(
                filePath: filePath,
                allFiles: files,
                initialIndex: index,
              ));
            },
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isImage
                        ? PhosphorIcons.image(PhosphorIconsStyle.regular)
                        : isPdf
                        ? PhosphorIcons.filePdf(
                        PhosphorIconsStyle.regular)
                        : isWord
                        ? PhosphorIcons.fileDoc(
                        PhosphorIconsStyle.regular)
                        : PhosphorIcons.file(
                        PhosphorIconsStyle.regular),
                    size: 24.w,
                    color: isImage
                        ? Colors.blue
                        : isPdf
                        ? Colors.red
                        : isWord
                        ? Colors.blue.shade800
                        : Colors.grey,
                  ),
                  Gap(4.h),
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      Gap(8.h),
    ],
  );
}


Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Gap(8.w),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}


Widget buildSection({
  required String title,
  required PhosphorIconData icon,
  required List<Widget> children,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: SetuColors.primaryGreen, size: 20.w),
            Gap(8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: SetuColors.primaryGreen,
              ),
            ),
          ],
        ),
        Gap(16.h),
        ...children,
      ],
    ),
  );
}


Widget buildDetailRow(String label, String value) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: SetuColors.primaryGreen,
            ),
          ),
        ),
        Text(
          ': ',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}

