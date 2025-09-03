import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../Widget/preview_widgets.dart';
import '../Controller/court_all_controller.dart';
import '../Controller/main_controller.dart';

class CourtAllocationPreviewStep extends StatelessWidget {
  final int currentSubStep;
  final CourtAllocationCaseController mainController;

  const CourtAllocationPreviewStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  CourtAllocationPreviewController get controller => Get.put(CourtAllocationPreviewController(), tag: 'court_allocation_preview');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Court Allocation Case Preview',
          'Review all information before submitting',
        ),
        Gap(24.h),
        SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCourtAllocationSection(),
                Gap(24.h),
                _buildSurveyCTSSection(),
                Gap(24.h),
                _buildCalculationSection(),
                Gap(24.h),
                _buildFeeInfoSection(),
                Gap(24.h),
                _buildPlaintiffDefendantSection(),
                Gap(24.h),
                _buildNextOfKinSection(),
                Gap(24.h),
                _buildDocumentsSection(),
                Gap(32.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourtAllocationSection() {
    return buildSection(
      title: 'Court Allocation Order Information',
      icon: PhosphorIcons.gavel(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.courtName))
          buildInfoRow('Court Name', controller.courtName),
        if (controller.isNotEmpty(controller.courtAddress))
          buildInfoRow('Court Address', controller.courtAddress),
        if (controller.isNotEmpty(controller.courtOrderNumber))
          buildInfoRow('Court Order Number', controller.courtOrderNumber),
        if (controller.isNotEmpty(controller.courtAllotmentDate))
          buildInfoRow('Court Allotment Date', controller.courtAllotmentDate),
        if (controller.isNotEmpty(controller.claimNumberYear))
          buildInfoRow('Claim Number/Year', controller.claimNumberYear),
        if (controller.isNotEmpty(controller.specialOrderComments))
          buildInfoRow('Special Order Comments', controller.specialOrderComments),
        if (controller.courtOrderFiles.isNotEmpty)
          buildFileRow('Court Order Documents', controller.courtOrderFiles, controller),
      ],
    );
  }

  Widget _buildSurveyCTSSection() {
    return buildSection(
      title: 'Survey CTS Information',
      icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.surveyNumber))
          buildInfoRow('Survey Number', controller.surveyNumber),
        if (controller.isNotEmpty(controller.department))
          buildInfoRow('Department', controller.department),
        if (controller.isNotEmpty(controller.district))
          buildInfoRow('District', controller.district),
        if (controller.isNotEmpty(controller.taluka))
          buildInfoRow('Taluka', controller.taluka),
        if (controller.isNotEmpty(controller.village))
          buildInfoRow('Village', controller.village),
        if (controller.isNotEmpty(controller.office))
          buildInfoRow('Office', controller.office),
      ],
    );
  }

  Widget _buildCalculationSection() {
    return buildSection(
      title: 'Survey Calculation Information',
      icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
      children: [
        // Show calculation entries
        if (controller.calculationEntries.isNotEmpty) ...[
          Text(
            'Survey Entries (${controller.calculationEntries.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: SetuColors.primaryGreen,
            ),
          ),
          Gap(8.h),
          ...controller.calculationEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entry ${index + 1}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: SetuColors.primaryGreen,
                    ),
                  ),
                  Gap(4.h),
                  if (controller.isNotEmpty(data['selectedVillage']?.toString()))
                    buildDetailRow('Village', data['selectedVillage'].toString()),
                  if (controller.isNotEmpty(data['surveyNo']?.toString()))
                    buildDetailRow('Survey No', data['surveyNo'].toString()),
                  if (controller.isNotEmpty(data['share']?.toString()))
                    buildDetailRow('Share', data['share'].toString()),
                  if (controller.isNotEmpty(data['area']?.toString()))
                    buildDetailRow('Area', data['area'].toString()),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildFeeInfoSection() {
    return buildSection(
      title: 'Calculation & Fee Information',
      icon: PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.calculationType))
          buildInfoRow('Calculation Type', controller.calculationType),
        if (controller.isNotEmpty(controller.duration))
          buildInfoRow('Duration', controller.duration),
        if (controller.isNotEmpty(controller.holderType))
          buildInfoRow('Holder Type', controller.holderType),
        if (controller.isNotEmpty(controller.locationCategory))
          buildInfoRow('Location Category', controller.locationCategory),
        if (controller.isNotEmpty(controller.calculationFee))
          buildInfoRow('Calculation Fee', controller.calculationFee),
        if (controller.isNotEmpty(controller.calculationFeeNumeric))
          buildInfoRow('Calculation Fee (Numeric)', controller.calculationFeeNumeric),
      ],
    );
  }

  Widget _buildPlaintiffDefendantSection() {
    if (controller.plaintiffDefendantEntries.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Plaintiff/Defendant Information (${controller.plaintiffDefendantEntries.length})',
      icon: PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
      children: controller.plaintiffDefendantEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final plaintiff = entry.value;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Entry ${index + 1} - ${plaintiff['selectedType']?.toString() ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              Gap(12.h),

              // Basic Info
              if (controller.isNotEmpty(plaintiff['name']?.toString()))
                buildDetailRow('Name', plaintiff['name'].toString()),
              if (controller.isNotEmpty(plaintiff['address']?.toString()))
                buildDetailRow('Address', plaintiff['address'].toString()),
              if (controller.isNotEmpty(plaintiff['mobile']?.toString()))
                buildDetailRow('Mobile', plaintiff['mobile'].toString()),
              if (controller.isNotEmpty(plaintiff['surveyNumber']?.toString()))
                buildDetailRow('Survey Number', plaintiff['surveyNumber'].toString()),

              // Detailed Address Information
              if (controller.isNotEmpty(plaintiff['plotNo']?.toString()) ||
                  controller.isNotEmpty(plaintiff['detailedAddress']?.toString()) ||
                  controller.isNotEmpty(plaintiff['email']?.toString())) ...[
                Gap(8.h),
                Text(
                  'Detailed Address Information',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: SetuColors.primaryGreen,
                  ),
                ),
                Gap(4.h),
                if (controller.isNotEmpty(plaintiff['plotNo']?.toString()))
                  buildDetailRow('Plot No', plaintiff['plotNo'].toString()),
                if (controller.isNotEmpty(plaintiff['detailedAddress']?.toString()))
                  buildDetailRow('Detailed Address', plaintiff['detailedAddress'].toString()),
                if (controller.isNotEmpty(plaintiff['mobileNumber']?.toString()))
                  buildDetailRow('Mobile Number', plaintiff['mobileNumber'].toString()),
                if (controller.isNotEmpty(plaintiff['email']?.toString()))
                  buildDetailRow('Email', plaintiff['email'].toString()),
                if (controller.isNotEmpty(plaintiff['pincode']?.toString()))
                  buildDetailRow('Pincode', plaintiff['pincode'].toString()),
                if (controller.isNotEmpty(plaintiff['district']?.toString()))
                  buildDetailRow('District', plaintiff['district'].toString()),
                if (controller.isNotEmpty(plaintiff['village']?.toString()))
                  buildDetailRow('Village', plaintiff['village'].toString()),
                if (controller.isNotEmpty(plaintiff['postOffice']?.toString()))
                  buildDetailRow('Post Office', plaintiff['postOffice'].toString()),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNextOfKinSection() {
    if (controller.nextOfKinEntries.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Next of Kin Information (${controller.nextOfKinEntries.length})',
      icon: PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
      children: controller.nextOfKinEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final nextOfKin = entry.value;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Next of Kin ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              Gap(12.h),

              // Data rows
              if (controller.isNotEmpty(nextOfKin['address']?.toString()))
                buildDetailRow('Address', nextOfKin['address'].toString()),
              if (controller.isNotEmpty(nextOfKin['mobile']?.toString()))
                buildDetailRow('Mobile', nextOfKin['mobile'].toString()),
              if (controller.isNotEmpty(nextOfKin['surveyNo']?.toString()))
                buildDetailRow('Survey No', nextOfKin['surveyNo'].toString()),
              if (controller.isNotEmpty(nextOfKin['direction']?.toString()))
                buildDetailRow('Direction', nextOfKin['direction'].toString()),
              if (controller.isNotEmpty(nextOfKin['naturalResources']?.toString()))
                buildDetailRow('Natural Resources', nextOfKin['naturalResources'].toString()),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDocumentsSection() {
    List<Widget> documentWidgets = [];

    if (controller.isNotEmpty(controller.identityCardType)) {
      documentWidgets.add(buildInfoRow('Identity Card Type', controller.identityCardType));
    }

    if (controller.identityCardFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Identity Card Files', controller.identityCardFiles, controller));
    }

    if (controller.sevenTwelveFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('7/12 Files', controller.sevenTwelveFiles, controller));
    }

    if (controller.noteFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Note Files', controller.noteFiles, controller));
    }

    if (controller.partitionFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Partition Files', controller.partitionFiles, controller));
    }

    if (controller.schemeSheetFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Scheme Sheet Files', controller.schemeSheetFiles, controller));
    }

    if (controller.oldCensusMapFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Old Census Map Files', controller.oldCensusMapFiles, controller));
    }

    if (controller.demarcationCertificateFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Demarcation Certificate Files', controller.demarcationCertificateFiles, controller));
    }

    if (documentWidgets.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Documents',
      icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
      children: documentWidgets,
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isSubmitting.value ? null : controller.submitCourtAllocationSurvey,
        style: ElevatedButton.styleFrom(
          backgroundColor: SetuColors.primaryGreen,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: controller.isSubmitting.value
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Gap(12.w),
            Text(
              'Submitting...',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        )
            : Text(
          'Submit Court Allocation Survey',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}
