import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../Widget/preview_widgets.dart';
import '../Controller/census_preview_controller.dart';
import '../Controller/main_controller.dart';

class GovernmentCensusPreviewStep extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController mainController;

  const GovernmentCensusPreviewStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  GovernmentCensusPreviewController get controller => Get.put(GovernmentCensusPreviewController(), tag: 'government_census_preview');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Government Census Survey Preview',
          'Review all information before submitting',
        ),
        Gap(24.h),
        SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGovernmentCountingSection(),
                Gap(24.h),
                _buildSurveyCTSSection(),
                Gap(24.h),
                _buildGovernmentSurveySection(),
                Gap(24.h),
                _buildCalculationFeeSection(),
                Gap(24.h),
                _buildApplicantSection(),
                Gap(24.h),
                _buildCoownerSection(),
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

  Widget _buildGovernmentCountingSection() {
    return buildSection(
      title: 'Government Counting Information',
      icon: PhosphorIcons.stamp(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.governmentCountingOfficer))
          buildInfoRow('Government Counting Officer', controller.governmentCountingOfficer),
        if (controller.isNotEmpty(controller.governmentCountingOfficerAddress))
          buildInfoRow('Officer Address', controller.governmentCountingOfficerAddress),
        if (controller.isNotEmpty(controller.governmentCountingOrderNumber))
          buildInfoRow('Order Number', controller.governmentCountingOrderNumber),
        if (controller.isNotEmpty(controller.governmentCountingOrderDate))
          buildInfoRow('Order Date', controller.governmentCountingOrderDate),
        if (controller.isNotEmpty(controller.countingApplicantName))
          buildInfoRow('Counting Applicant Name', controller.countingApplicantName),
        if (controller.isNotEmpty(controller.countingApplicantAddress))
          buildInfoRow('Applicant Address', controller.countingApplicantAddress),
        if (controller.isNotEmpty(controller.governmentCountingDetails))
          buildInfoRow('Counting Details', controller.governmentCountingDetails),
        if (controller.governmentCountingOrderFiles.isNotEmpty)
          buildFileRow('Government Order Documents', controller.governmentCountingOrderFiles, controller),
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

  Widget _buildGovernmentSurveySection() {
    return buildSection(
      title: 'Government Survey Information',
      icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
      children: [
        // FIXED: Handle totalArea as double
        if (controller.totalArea > 0)
          buildInfoRow('Total Area', controller.totalArea.toString()),
        if (controller.isNotEmpty(controller.entryCount))
          buildInfoRow('Number of Entries', controller.entryCount),

        if (controller.governmentSurveyEntries.isNotEmpty) ...[
          Gap(16.h),
          Text(
            'Survey Entries (${controller.governmentSurveyEntries.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: SetuColors.primaryGreen,
            ),
          ),
          Gap(8.h),
          ...controller.governmentSurveyEntries.asMap().entries.map((entry) {
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
                  if (controller.isNotEmpty(data['surveyNo']?.toString()))
                    buildDetailRow('Survey No/Group No', data['surveyNo'].toString()),
                  if (controller.isNotEmpty(data['partNo']?.toString()))
                    buildDetailRow('Part No', data['partNo'].toString()),
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

  Widget _buildCalculationFeeSection() {
    return buildSection(
      title: 'Calculation & Fee Information',
      icon: PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.calculationType))
          buildInfoRow('Calculation Type', controller.calculationType??''),
        if (controller.isNotEmpty(controller.duration))
          buildInfoRow('Duration', controller.duration??''),
        if (controller.isNotEmpty(controller.holderType))
          buildInfoRow('Holder Type', controller.holderType??''),
        if (controller.isNotEmpty(controller.calculationFeeRate))
          buildInfoRow('Calculation Fee Rate', controller.calculationFeeRate??''),
        if (controller.isNotEmpty(controller.countingFee))
          buildInfoRow('Counting Fee', controller.countingFee),
      ],
    );
  }

  Widget _buildApplicantSection() {
    if (controller.applicantEntries.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Applicant Information (${controller.applicantEntries.length})',
      icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
      children: controller.applicantEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final applicant = entry.value;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Applicant ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              Gap(12.h),

              if (controller.isNotEmpty(applicant['agreement']?.toString()))
                buildDetailRow('Agreement', applicant['agreement'].toString()),
              if (controller.isNotEmpty(applicant['accountHolderName']?.toString()))
                buildDetailRow('Account Holder Name', applicant['accountHolderName'].toString()),
              if (controller.isNotEmpty(applicant['accountNumber']?.toString()))
                buildDetailRow('Account Number', applicant['accountNumber'].toString()),
              if (controller.isNotEmpty(applicant['mobileNumber']?.toString()))
                buildDetailRow('Mobile Number', applicant['mobileNumber'].toString()),
              if (controller.isNotEmpty(applicant['serverNumber']?.toString()))
                buildDetailRow('Server Number', applicant['serverNumber'].toString()),
              if (controller.isNotEmpty(applicant['area']?.toString()))
                buildDetailRow('Area', applicant['area'].toString()),
              if (controller.isNotEmpty(applicant['potkaharabaArea']?.toString()))
                buildDetailRow('Potkaharaba Area', applicant['potkaharabaArea'].toString()),
              if (controller.isNotEmpty(applicant['totalArea']?.toString()))
                buildDetailRow('Total Area', applicant['totalArea'].toString()),

              if (controller.isNotEmpty(applicant['plotNo']?.toString()) ||
                  controller.isNotEmpty(applicant['address']?.toString()) ||
                  controller.isNotEmpty(applicant['email']?.toString())) ...[
                Gap(8.h),
                Text(
                  'Address Information',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: SetuColors.primaryGreen,
                  ),
                ),
                Gap(4.h),
                if (controller.isNotEmpty(applicant['plotNo']?.toString()))
                  buildDetailRow('Plot No', applicant['plotNo'].toString()),
                if (controller.isNotEmpty(applicant['address']?.toString()))
                  buildDetailRow('Address', applicant['address'].toString()),
                if (controller.isNotEmpty(applicant['addressMobileNumber']?.toString()))
                  buildDetailRow('Mobile Number', applicant['addressMobileNumber'].toString()),
                if (controller.isNotEmpty(applicant['email']?.toString()))
                  buildDetailRow('Email', applicant['email'].toString()),
                if (controller.isNotEmpty(applicant['pincode']?.toString()))
                  buildDetailRow('Pincode', applicant['pincode'].toString()),
                if (controller.isNotEmpty(applicant['district']?.toString()))
                  buildDetailRow('District', applicant['district'].toString()),
                if (controller.isNotEmpty(applicant['village']?.toString()))
                  buildDetailRow('Village', applicant['village'].toString()),
                if (controller.isNotEmpty(applicant['postOffice']?.toString()))
                  buildDetailRow('Post Office', applicant['postOffice'].toString()),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCoownerSection() {
    if (controller.coownerEntries.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Co-owner Information (${controller.coownerEntries.length})',
      icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
      children: controller.coownerEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final coowner = entry.value;
        final address = coowner['address'] as Map<String, dynamic>? ?? {};

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
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Co-owner ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              Gap(12.h),

              if (controller.isNotEmpty(coowner['name']?.toString()))
                buildDetailRow('Name', coowner['name'].toString()),
              if (controller.isNotEmpty(coowner['mobileNumber']?.toString()))
                buildDetailRow('Mobile Number', coowner['mobileNumber'].toString()),
              if (controller.isNotEmpty(coowner['serverNumber']?.toString()))
                buildDetailRow('Server Number', coowner['serverNumber'].toString()),
              if (controller.isNotEmpty(coowner['consent']?.toString()))
                buildDetailRow('Consent', coowner['consent'].toString()),

              if (address.isNotEmpty) ...[
                Gap(8.h),
                Text(
                  'Address Information',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: SetuColors.primaryGreen,
                  ),
                ),
                Gap(4.h),
                if (controller.isNotEmpty(address['plotNo']?.toString()))
                  buildDetailRow('Plot No', address['plotNo'].toString()),
                if (controller.isNotEmpty(address['address']?.toString()))
                  buildDetailRow('Address', address['address'].toString()),
                if (controller.isNotEmpty(address['mobileNumber']?.toString()))
                  buildDetailRow('Mobile Number', address['mobileNumber'].toString()),
                if (controller.isNotEmpty(address['email']?.toString()))
                  buildDetailRow('Email', address['email'].toString()),
                if (controller.isNotEmpty(address['pincode']?.toString()))
                  buildDetailRow('Pincode', address['pincode'].toString()),
                if (controller.isNotEmpty(address['district']?.toString()))
                  buildDetailRow('District', address['district'].toString()),
                if (controller.isNotEmpty(address['village']?.toString()))
                  buildDetailRow('Village', address['village'].toString()),
                if (controller.isNotEmpty(address['postOffice']?.toString()))
                  buildDetailRow('Post Office', address['postOffice'].toString()),
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

              if (controller.isNotEmpty(nextOfKin['name']?.toString()))
                buildDetailRow('Name', nextOfKin['name'].toString()),
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
        onPressed: controller.isSubmitting.value ? null : controller.submitGovernmentCensusSurvey,
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
          'Submit Government Census Survey',
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
