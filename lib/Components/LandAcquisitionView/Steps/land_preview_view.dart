import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../Widget/preview_widgets.dart';
import '../Controller/land_preview_controller.dart';
import '../Controller/main_controller.dart';

class LandAcquisitionPreviewStep extends StatelessWidget {
  final int currentSubStep;
  final MainLandAcquisitionController mainController;

  const LandAcquisitionPreviewStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  LandAcquisitionPreviewController get controller => Get.put(LandAcquisitionPreviewController(), tag: 'land_acquisition_preview');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Land Acquisition Preview',
          'Review all information before submitting',
        ),
        Gap(24.h),
        SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLandAcquisitionSection(),
                Gap(24.h),
                _buildSurveyCTSSection(),
                Gap(24.h),
                _buildCalculationSection(),
                Gap(24.h),
                _buildFeeInfoSection(),
                Gap(24.h),
                _buildHolderInformationSection(),
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

  Widget _buildLandAcquisitionSection() {
    return buildSection(
      title: 'Land Acquisition Information',
      icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.landAcquisitionOfficer))
          buildInfoRow('Land Acquisition Officer', controller.landAcquisitionOfficer),
        if (controller.isNotEmpty(controller.landAcquisitionBoard))
          buildInfoRow('Board Name & Address', controller.landAcquisitionBoard),
        if (controller.isNotEmpty(controller.landAcquisitionDescription))
          buildInfoRow('Land Acquisition Description', controller.landAcquisitionDescription),
        if (controller.isNotEmpty(controller.orderProposalNumber))
          buildInfoRow('Order/Proposal Number', controller.orderProposalNumber),
        if (controller.isNotEmpty(controller.orderProposalDate))
          buildInfoRow('Order/Proposal Date', controller.orderProposalDate),
        if (controller.isNotEmpty(controller.issuingOfficeAddress))
          buildInfoRow('Issuing Office Address', controller.issuingOfficeAddress),
        if (controller.landAcquisitionOrderFiles.isNotEmpty)
          buildFileRow('Order Proposal Documents', controller.landAcquisitionOrderFiles,controller),
        if (controller.landAcquisitionMapFiles.isNotEmpty)
          buildFileRow('Demarcation Map Files', controller.landAcquisitionMapFiles,controller),
        if (controller.kmlFiles.isNotEmpty)
          buildFileRow('KML Files', controller.kmlFiles,controller),
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
      title: 'Calculation Information',
      icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.selectedVillage))
          buildInfoRow('Selected Village', controller.selectedVillage),

        // Show calculation entries
        if (controller.calculationEntries.isNotEmpty) ...[
          Gap(16.h),
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
                  if (controller.isNotEmpty(data['village']?.toString()))
                    buildDetailRow('Village', data['village'].toString()),
                  if (controller.isNotEmpty(data['surveyNo']?.toString()))
                    buildDetailRow('Survey No', data['surveyNo'].toString()),
                  if (controller.isNotEmpty(data['share']?.toString()))
                    buildDetailRow('Share', data['share'].toString()),
                  if (controller.isNotEmpty(data['area']?.toString()))
                    buildDetailRow('Area', data['area'].toString()),
                  if (controller.isNotEmpty(data['landAcquisitionArea']?.toString()))
                    buildDetailRow('Land Acquisition Area', data['landAcquisitionArea'].toString()),
                  if (controller.isNotEmpty(data['abdominalSection']?.toString()))
                    buildDetailRow('Abdominal Section', data['abdominalSection'].toString()),
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
      title: 'Fee Information',
      icon: PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.calculationType))
          buildInfoRow('Calculation Type', controller.calculationType),
        if (controller.isNotEmpty(controller.duration))
          buildInfoRow('Duration', controller.duration),
        if (controller.isNotEmpty(controller.holderType))
          buildInfoRow('Holder Type', controller.holderType),
        if (controller.isNotEmpty(controller.countingFee))
          buildInfoRow('Counting Fee', controller.countingFee),
      ],
    );
  }

  Widget _buildHolderInformationSection() {
    if (controller.holderInformation.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Holder Information (${controller.holderInformation.length})',
      icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
      children: controller.holderInformation.asMap().entries.map((entry) {
        final index = entry.key;
        final holder = entry.value;

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
                  'Holder ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              Gap(12.h),

              // Data rows
              if (controller.isNotEmpty(holder['holderName']?.toString()))
                buildDetailRow('Holder Name', holder['holderName'].toString()),
              if (controller.isNotEmpty(holder['address']?.toString()))
                buildDetailRow('Address', holder['address'].toString()),
              if (controller.isNotEmpty(holder['accountNumber']?.toString()))
                buildDetailRow('Account Number', holder['accountNumber'].toString()),
              if (controller.isNotEmpty(holder['mobileNumber']?.toString()))
                buildDetailRow('Mobile Number', holder['mobileNumber'].toString()),
              if (controller.isNotEmpty(holder['serverNumber']?.toString()))
                buildDetailRow('Server Number', holder['serverNumber'].toString()),
              if (controller.isNotEmpty(holder['area']?.toString()))
                buildDetailRow('Area', holder['area'].toString()),
              if (controller.isNotEmpty(holder['potKharabaArea']?.toString()))
                buildDetailRow('Pot Kharaba Area', holder['potKharabaArea'].toString()),
              if (controller.isNotEmpty(holder['totalArea']?.toString()))
                buildDetailRow('Total Area', holder['totalArea'].toString()),
              if (controller.isNotEmpty(holder['village']?.toString()))
                buildDetailRow('Village', holder['village'].toString()),
              if (controller.isNotEmpty(holder['plotNo']?.toString()))
                buildDetailRow('Plot No', holder['plotNo'].toString()),
              if (controller.isNotEmpty(holder['email']?.toString()))
                buildDetailRow('Email', holder['email'].toString()),
              if (controller.isNotEmpty(holder['pincode']?.toString()))
                buildDetailRow('Pincode', holder['pincode'].toString()),
              if (controller.isNotEmpty(holder['district']?.toString()))
                buildDetailRow('District', holder['district'].toString()),
              if (controller.isNotEmpty(holder['postOffice']?.toString()))
                buildDetailRow('Post Office', holder['postOffice'].toString()),
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
      documentWidgets.add(buildFileRow('Identity Card Files', controller.identityCardFiles,controller));
    }

    if (controller.sevenTwelveFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('7/12 Files', controller.sevenTwelveFiles,controller));
    }

    if (controller.noteFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Note Files', controller.noteFiles,controller));
    }

    if (controller.partitionFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Partition Files', controller.partitionFiles,controller));
    }

    if (controller.schemeSheetFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Scheme Sheet Files', controller.schemeSheetFiles,controller));
    }

    if (controller.oldCensusMapFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Old Census Map Files', controller.oldCensusMapFiles,controller));
    }

    if (controller.demarcationCertificateFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Demarcation Certificate Files', controller.demarcationCertificateFiles,controller));
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
        onPressed: controller.isSubmitting.value ? null : mainController.submitLandAcquisitionSurvey,
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
          'Submit Land Acquisition Survey',
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