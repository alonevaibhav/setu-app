import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandSurveyView/Steps/survey_ui_utils.dart';
import '../../../Constants/color_constant.dart';
import '../../Widget/preview_widgets.dart';
import '../Controller/main_controller.dart';
import '../Controller/preview_controller.dart';

class SurveyPreviewStep extends StatelessWidget {
  final int currentSubStep;
  final MainSurveyController mainController;

  const SurveyPreviewStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  SurveyPreviewController get controller => Get.put(SurveyPreviewController(), tag: 'survey_preview');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Survey Preview',
          'Review all information before submitting',
        ),
        Gap(24.h),
        SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonalInfoSection(),
                Gap(24.h),
                _buildSurveyInfoSection(),
                Gap(24.h),
                _buildCalculationInfoSection(),
                Gap(24.h),
                _buildFeeInfoSection(),
                Gap(24.h),
                _buildApplicantsSection(),
                Gap(24.h),
                _buildCoOwnersSection(),
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

  Widget _buildPersonalInfoSection() {
    return buildSection(
      title: 'Personal Information',
      icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.applicantName))
          buildInfoRow('Applicant Name', controller.applicantName),
        if (controller.isNotEmpty(controller.applicantAddress))
          buildInfoRow('Applicant Address', controller.applicantAddress),
        buildInfoRow(
            'Is Landholder', controller.formatBoolean(controller.isLandholder)),
        buildInfoRow('Has Power of Attorney',
            controller.formatBoolean(controller.isPowerOfAttorney)),
        buildInfoRow('Has Been Counted Before',
            controller.formatBoolean(controller.hasBeenCountedBefore)),
        if (controller.isPowerOfAttorney) ...[
          if (controller.isNotEmpty(controller.poaRegistrationNumber))
            buildInfoRow(
                'POA Registration Number', controller.poaRegistrationNumber),
          if (controller.isNotEmpty(controller.poaRegistrationDate))
            buildInfoRow(
                'POA Registration Date', controller.poaRegistrationDate),
          if (controller.isNotEmpty(controller.poaGiverName))
            buildInfoRow('POA Giver Name', controller.poaGiverName),
          if (controller.isNotEmpty(controller.poaHolderName))
            buildInfoRow('POA Holder Name', controller.poaHolderName),
          if (controller.isNotEmpty(controller.poaHolderAddress))
            buildInfoRow('POA Holder Address', controller.poaHolderAddress),
        ],
        if (controller.poaFiles.isNotEmpty)
          buildFileRow('POA Documents', controller.poaFiles,controller),
      ],
    );
  }

  Widget _buildSurveyInfoSection() {
    return buildSection(
      title: 'Survey Information',
      icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.surveyType))
          buildInfoRow('Survey Type', controller.surveyType),
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

  Widget _buildCalculationInfoSection() {
    return buildSection(
      title: 'Calculation Information',
      icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
      children: [
        if (controller.isNotEmpty(controller.calculationType))
          buildInfoRow('Calculation Type', controller.calculationType),
        if (controller.isNotEmpty(controller.operationType))
          buildInfoRow('Operation Type', controller.operationType),

        // Show order details if available
        ...controller.orderDetails.entries.map((entry) {
          if (controller.isNotEmpty(entry.value)) {
            return buildInfoRow(
                controller.formatFieldName(entry.key), entry.value);
          }
          return SizedBox.shrink();
        }).toList(),

        // Show calculation entries
        if (controller.calculationEntries.isNotEmpty) ...[
          Gap(16.h),
          Text(
            'Calculation Entries',
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
                  ...data.entries.map((field) {
                    if (controller.isNotEmpty(field.value.toString())) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Text(
                          '${controller.formatFieldName(field.key)}: ${field.value}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }).toList(),
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
        if (controller.isNotEmpty(controller.selectedCalculationType))
          buildInfoRow('Calculation Type', controller.selectedCalculationType),
        if (controller.isNotEmpty(controller.selectedDuration))
          buildInfoRow('Duration', controller.selectedDuration),
        if (controller.isNotEmpty(controller.selectedHolderType))
          buildInfoRow('Holder Type', controller.selectedHolderType),
        if (controller.isNotEmpty(controller.selectedLocationCategory))
          buildInfoRow(
              'Location Category', controller.selectedLocationCategory),
        if (controller.isNotEmpty(controller.calculationFee))
          buildInfoRow('Calculation Fee', controller.calculationFee),
      ],
    );
  }

  Widget _buildApplicantsSection() {
    if (controller.applicantsList.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Applicant Information (${controller.applicantsList.length})',
      icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
      children: controller.applicantsList.asMap().entries.map((entry) {
        final index = entry.key;
        final applicant = entry.value;
        final address = applicant['address'] as Map<String, dynamic>?;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w), // Increased padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with better styling
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

              // Data rows with better formatting
              if (controller
                  .isNotEmpty(applicant['accountHolderName']?.toString()))
                buildDetailRow(
                    'Name', applicant['accountHolderName'].toString()),
              if (controller.isNotEmpty(applicant['accountNumber']?.toString()))
                buildDetailRow(
                    'Account Number', applicant['accountNumber'].toString()),
              if (controller.isNotEmpty(applicant['mobileNumber']?.toString()))
                buildDetailRow('Mobile', applicant['mobileNumber'].toString()),
              if (controller.isNotEmpty(applicant['area']?.toString()))
                buildDetailRow('Area', applicant['area'].toString()),
              if (address != null &&
                  controller.isNotEmpty(address['address']?.toString()))
                buildDetailRow('Address', address['address'].toString()),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCoOwnersSection() {
    if (controller.coOwnersList.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Co-Owner Information (${controller.coOwnersList.length})',
      icon: PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
      children: controller.coOwnersList.asMap().entries.map((entry) {
        final index = entry.key;
        final coOwner = entry.value;
        final address = coOwner['address'] as Map<String, dynamic>?;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w), // Increased padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with better styling
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Co-Owner ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              Gap(12.h),

              // Data rows with better formatting
              if (controller.isNotEmpty(coOwner['name']?.toString()))
                buildDetailRow('Name', coOwner['name'].toString()),
              if (controller.isNotEmpty(coOwner['mobileNumber']?.toString()))
                buildDetailRow('Mobile', coOwner['mobileNumber'].toString()),
              if (controller.isNotEmpty(coOwner['serverNumber']?.toString()))
                buildDetailRow(
                    'Server Number', coOwner['serverNumber'].toString()),
              if (controller.isNotEmpty(coOwner['consent']?.toString()))
                buildDetailRow('Consent', coOwner['consent'].toString()),
              if (address != null &&
                  controller.isNotEmpty(address['address']?.toString()))
                buildDetailRow('Address', address['address'].toString()),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNextOfKinSection() {
    if (controller.nextOfKinList.isEmpty) return SizedBox.shrink();

    return buildSection(
      title: 'Next of Kin Information (${controller.nextOfKinList.length})',
      icon: PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
      children: controller.nextOfKinList.asMap().entries.map((entry) {
        final index = entry.key;
        final nextOfKin = entry.value;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w), // Increased padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with better styling
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

              // Data rows with better formatting
              if (controller.isNotEmpty(nextOfKin['address']?.toString()))
                buildDetailRow('Address', nextOfKin['address'].toString()),
              if (controller.isNotEmpty(nextOfKin['mobile']?.toString()))
                buildDetailRow('Mobile', nextOfKin['mobile'].toString()),
              if (controller.isNotEmpty(nextOfKin['surveyNo']?.toString()))
                buildDetailRow('Survey No', nextOfKin['surveyNo'].toString()),
              if (controller.isNotEmpty(nextOfKin['direction']?.toString()))
                buildDetailRow('Direction', nextOfKin['direction'].toString()),
              if (controller
                  .isNotEmpty(nextOfKin['naturalResources']?.toString()))
                buildDetailRow('Natural Resources',
                    nextOfKin['naturalResources'].toString()),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDocumentsSection() {
    List<Widget> documentWidgets = [];

    if (controller.isNotEmpty(controller.identityCardType)) {
      documentWidgets
          .add(buildInfoRow('Identity Card Type', controller.identityCardType));
    }

    if (controller.identityCardFiles.isNotEmpty) {
      documentWidgets.add(
          buildFileRow('Identity Card Files', controller.identityCardFiles,controller));
    }

    if (controller.sevenTwelveFiles.isNotEmpty) {
      documentWidgets
          .add(buildFileRow('7/12 Files', controller.sevenTwelveFiles,controller));
    }

    if (controller.noteFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Note Files', controller.noteFiles,controller));
    }

    if (controller.partitionFiles.isNotEmpty) {
      documentWidgets
          .add(buildFileRow('Partition Files', controller.partitionFiles,controller));
    }

    if (controller.schemeSheetFiles.isNotEmpty) {
      documentWidgets
          .add(buildFileRow('Scheme Sheet Files', controller.schemeSheetFiles,controller));
    }

    if (controller.oldCensusMapFiles.isNotEmpty) {
      documentWidgets.add(
          buildFileRow('Old Census Map Files', controller.oldCensusMapFiles,controller));
    }

    if (controller.demarcationCertificateFiles.isNotEmpty) {
      documentWidgets.add(buildFileRow('Demarcation Certificate Files',
          controller.demarcationCertificateFiles,controller));
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
            onPressed:
                controller.isSubmitting.value ? null : controller.submitSurvey,
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
                    'Submit Survey',
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
