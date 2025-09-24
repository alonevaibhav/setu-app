// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import '../../../Constants/color_constant.dart';
// import '../Controller/census_fifth_controller.dart';
// import '../Controller/main_controller.dart';
// import 'ZLandAcquisitionUIUtils.dart';
//
// class CensusFifthView extends StatelessWidget {
//   final int currentSubStep;
//   final GovernmentCensusController mainController;
//
//   const CensusFifthView({
//     super.key,
//     required this.currentSubStep,
//     required this.mainController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final subSteps = mainController.stepConfigurations[4] ?? ['applicant'];
//
//     if (currentSubStep >= subSteps.length) {
//       return _buildApplicantInput();
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'applicant':
//         return _buildApplicantInput();
//       default:
//         return _buildApplicantInput();
//     }
//   }
//
//   Widget _buildApplicantInput() {
//     final fifthController = Get.put(CensusFifthController(), tag: 'census_fifth');
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildStepHeader(
//           'Applicant Information',
//           'Enter applicant details for land acquisition survey',
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Applicant Entries Section
//         _buildApplicantEntries(fifthController),
//
//         Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
//         GovernmentCensusUIUtils.buildNavigationButtons(mainController),
//       ],
//     );
//   }
//
//   Widget _buildApplicantEntries(CensusFifthController fifthController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildTranslatableText(
//           text: 'Applicant Entries',
//           style: TextStyle(
//             fontSize: 18.sp * GovernmentCensusUIUtils.sizeFactor,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.primaryGreen,
//           ),
//         ),
//
//         Gap(20.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Applicant Entries List
//         Obx(() => Column(
//           children: [
//             for (int i = 0; i < fifthController.applicantEntries.length; i++)
//               _buildApplicantEntryCard(fifthController, i),
//           ],
//         )),
//
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Add Another Entry Button
//         InkWell(
//           onTap: fifthController.addApplicantEntry,
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(
//               horizontal: 16.w * GovernmentCensusUIUtils.sizeFactor,
//               vertical: 16.h * GovernmentCensusUIUtils.sizeFactor,
//             ),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: SetuColors.primaryGreen,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(12.r),
//               color: SetuColors.primaryGreen.withOpacity(0.05),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   PhosphorIcons.plus(PhosphorIconsStyle.bold),
//                   color: SetuColors.primaryGreen,
//                   size: 24.sp * GovernmentCensusUIUtils.sizeFactor,
//                 ),
//                 Gap(12.w * GovernmentCensusUIUtils.sizeFactor),
//                 GovernmentCensusUIUtils.buildTranslatableText(
//                   text: 'Add Another Applicant',
//                   style: TextStyle(
//                     fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                     color: SetuColors.primaryGreen,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildApplicantEntryCard(
//       CensusFifthController fifthController, int index) {
//     final entry = fifthController.applicantEntries[index];
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 20.h * GovernmentCensusUIUtils.sizeFactor),
//       padding: EdgeInsets.all(20.w * GovernmentCensusUIUtils.sizeFactor),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: SetuColors.primaryGreen.withOpacity(0.2),
//           width: 2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Card Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 12.w * GovernmentCensusUIUtils.sizeFactor,
//                   vertical: 8.h * GovernmentCensusUIUtils.sizeFactor,
//                 ),
//                 decoration: BoxDecoration(
//                   color: SetuColors.primaryGreen,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Text(
//                   'Applicant ${index + 1}',
//                   style: TextStyle(
//                     fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               if (fifthController.applicantEntries.length > 1)
//                 InkWell(
//                   onTap: () => fifthController.removeApplicantEntry(index),
//                   child: Container(
//                     padding: EdgeInsets.all(8.w * GovernmentCensusUIUtils.sizeFactor),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Icon(
//                       PhosphorIcons.trash(PhosphorIconsStyle.regular),
//                       color: Colors.red,
//                       size: 18.sp * GovernmentCensusUIUtils.sizeFactor,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           Gap(20.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Agreement Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['agreementController'],
//             label: 'Agreement *',
//             hint: 'Enter agreement details',
//             icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 fifthController.updateApplicantEntry(index, 'agreement', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Account Holder Name Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['accountHolderNameController'],
//             label: 'Account Holder Name *',
//             hint: 'Enter account holder name',
//             icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//             onChanged: (value) => fifthController.updateApplicantEntry(
//                 index, 'accountHolderName', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Account Holder Address (Clickable Field)
//           _buildAddressField(fifthController, index),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Account Number Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['accountNumberController'],
//             label: 'Account Number *',
//             hint: 'Enter account number',
//             icon: PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
//             onChanged: (value) => fifthController.updateApplicantEntry(
//                 index, 'accountNumber', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Mobile Number Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['mobileNumberController'],
//             label: 'Mobile Number *',
//             hint: 'Enter mobile number',
//             icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.phone,
//             onChanged: (value) => fifthController.updateApplicantEntry(
//                 index, 'mobileNumber', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Server Number Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['serverNumberController'],
//             label: 'Server Number',
//             hint: 'Enter server number',
//             icon: PhosphorIcons.infinity(PhosphorIconsStyle.regular),
//             onChanged: (value) => fifthController.updateApplicantEntry(
//                 index, 'serverNumber', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaController'],
//             label: 'Area',
//             hint: 'Enter area',
//             icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) =>
//                 fifthController.updateApplicantEntry(index, 'area', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Potkharaba Area Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['potkaharabaAreaController'],
//             label: 'Potkharaba Area',
//             hint: 'Enter potkharaba area',
//             icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) => fifthController.updateApplicantEntry(
//                 index, 'potkaharabaArea', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Total Area Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['totalAreaController'],
//             label: 'Total Area',
//             hint: 'Enter total area',
//             icon: PhosphorIcons.resize(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) =>
//                 fifthController.updateApplicantEntry(index, 'totalArea', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Summary Row - Updated to use GetBuilder instead of direct text access
//           GetBuilder<CensusFifthController>(
//             tag: 'survey_fifth',
//             builder: (controller) {
//               final accountHolderName = (entry['accountHolderNameController']
//               as TextEditingController)
//                   .text;
//               return Container(
//                 padding: EdgeInsets.all(12.w * GovernmentCensusUIUtils.sizeFactor),
//                 decoration: BoxDecoration(
//                   color: SetuColors.primaryGreen.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8.r),
//                   border: Border.all(
//                     color: SetuColors.primaryGreen.withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       PhosphorIcons.info(PhosphorIconsStyle.regular),
//                       color: SetuColors.primaryGreen,
//                       size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                     ),
//                     Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
//                     Expanded(
//                       child: Text(
//                         'Applicant ${index + 1} - ${accountHolderName.isNotEmpty ? accountHolderName : 'Name not entered'}',
//                         style: TextStyle(
//                           fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
//                           color: SetuColors.primaryGreen,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAddressField(CensusFifthController fifthController, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               'Account Holder\'s Address',
//               style: TextStyle(
//                 fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[700],
//               ),
//             ),
//             Text(
//               ' *',
//               style: TextStyle(
//                 fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//         Gap(8.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Use GetBuilder instead of Obx for better performance
//         GetBuilder<CensusFifthController>(
//           tag: 'survey_fifth',
//           builder: (controller) => InkWell(
//             onTap: () => fifthController.showAddressPopup(Get.context!, index),
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(
//                 horizontal: 16.w * GovernmentCensusUIUtils.sizeFactor,
//                 vertical: 16.h * GovernmentCensusUIUtils.sizeFactor,
//               ),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey.shade300,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(12.r),
//                 color: Colors.grey.shade50,
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//                     color: SetuColors.primaryGreen,
//                     size: 20.sp * GovernmentCensusUIUtils.sizeFactor,
//                   ),
//                   Gap(12.w * GovernmentCensusUIUtils.sizeFactor),
//                   Expanded(
//                     child: Text(
//                       fifthController.getFormattedAddress(index),
//                       style: TextStyle(
//                         fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
//                         color: fifthController.getFormattedAddress(index) ==
//                             'Click to add address'
//                             ? Colors.grey[500]
//                             : Colors.grey[700],
//                         fontWeight: FontWeight.w400,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Icon(
//                     PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
//                     color: Colors.grey[500],
//                     size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         // Show validation error if address is incomplete
//         GetBuilder<CensusFifthController>(
//           tag: 'survey_fifth',
//           builder: (controller) {
//             final hasError = fifthController.validationErrors
//                 .containsKey('${index}_address') ||
//                 fifthController.validationErrors
//                     .containsKey('${index}_pincode') ||
//                 fifthController.validationErrors
//                     .containsKey('${index}_village') ||
//                 fifthController.validationErrors
//                     .containsKey('${index}_postOffice');
//
//             if (hasError) {
//               return Padding(
//                 padding: EdgeInsets.only(top: 8.h * GovernmentCensusUIUtils.sizeFactor),
//                 child: Text(
//                   'Complete address information is required',
//                   style: TextStyle(
//                     fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
//                     color: Colors.red,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               );
//             }
//             return SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/census_fifth_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CensusFifthView extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController mainController;

  const CensusFifthView({
    super.key,
    required this.currentSubStep,
    required this.mainController,
  });

  @override
  Widget build(BuildContext context) {
    final subSteps = mainController.stepConfigurations[4] ?? ['applicant'];

    if (currentSubStep >= subSteps.length) {
      return _buildApplicantInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'applicant':
        return _buildApplicantInput();
      default:
        return _buildApplicantInput();
    }
  }

  Widget _buildApplicantInput() {
    final fifthController = Get.put(CensusFifthController(), tag: 'census_fifth');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildStepHeader(
          'Applicant Information',
          'Enter applicant details for land acquisition survey',
        ),
        Gap(24.h * GovernmentCensusUIUtils.sizeFactor),

        // Applicant Entries Section
        _buildApplicantEntries(fifthController),

        Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
        GovernmentCensusUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildApplicantEntries(CensusFifthController fifthController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildTranslatableText(
          text: 'Applicant Entries',
          style: TextStyle(
            fontSize: 18.sp * GovernmentCensusUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * GovernmentCensusUIUtils.sizeFactor),

        // Applicant Entries List
        Obx(() => Column(
          children: [
            for (int i = 0; i < fifthController.applicantEntries.length; i++)
              _buildApplicantEntryCard(fifthController, i),
          ],
        )),

        Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: fifthController.addApplicantEntry,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w * GovernmentCensusUIUtils.sizeFactor,
              vertical: 16.h * GovernmentCensusUIUtils.sizeFactor,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: SetuColors.primaryGreen,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: SetuColors.primaryGreen.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.plus(PhosphorIconsStyle.bold),
                  color: SetuColors.primaryGreen,
                  size: 24.sp * GovernmentCensusUIUtils.sizeFactor,
                ),
                Gap(12.w * GovernmentCensusUIUtils.sizeFactor),
                GovernmentCensusUIUtils.buildTranslatableText(
                  text: 'Add Another Applicant',
                  style: TextStyle(
                    fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                    color: SetuColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicantEntryCard(
      CensusFifthController fifthController, int index) {
    final entry = fifthController.applicantEntries[index];

    return Container(
      margin: EdgeInsets.only(bottom: 20.h * GovernmentCensusUIUtils.sizeFactor),
      padding: EdgeInsets.all(20.w * GovernmentCensusUIUtils.sizeFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: SetuColors.primaryGreen.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w * GovernmentCensusUIUtils.sizeFactor,
                  vertical: 8.h * GovernmentCensusUIUtils.sizeFactor,
                ),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Applicant ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (fifthController.applicantEntries.length > 1)
                InkWell(
                  onTap: () => fifthController.removeApplicantEntry(index),
                  child: Container(
                    padding: EdgeInsets.all(8.w * GovernmentCensusUIUtils.sizeFactor),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.regular),
                      color: Colors.red,
                      size: 18.sp * GovernmentCensusUIUtils.sizeFactor,
                    ),
                  ),
                ),
            ],
          ),
          Gap(20.h * GovernmentCensusUIUtils.sizeFactor),

          // Agreement Input
          // GovernmentCensusUIUtils.buildTextFormField(
          //   controller: entry['agreementController'] ,
          //   label: 'Agreement *',
          //   hint: 'Enter agreement details',
          //   icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          //   onChanged: (value) =>
          //       fifthController.updateApplicantEntry(index, 'agreement', value),
          // ),
          //
          // Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Account Holder Name Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['accountHolderNameController'] ,
            label: 'Holder Name *',
            hint: 'Enter holder name',
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            onChanged: (value) => fifthController.updateApplicantEntry(
                index, 'accountHolderName', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Account Holder Address (Clickable Field)
          _buildAddressField(fifthController, index),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Account Number Input
          // GovernmentCensusUIUtils.buildTextFormField(
          //   controller: entry['accountNumberController'] ,
          //   label: 'Account Number *',
          //   hint: 'Enter account number',
          //   icon: PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
          //   onChanged: (value) => fifthController.updateApplicantEntry(
          //       index, 'accountNumber', value),
          // ),

          // Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Mobile Number Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['mobileNumberController'] ,
            label: 'Mobile Number *',
            hint: 'Enter mobile number',
            icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.phone,
            onChanged: (value) => fifthController.updateApplicantEntry(
                index, 'mobileNumber', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Server Number Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['serverNumberController'] ,
            label: 'Server Number',
            hint: 'Enter server number',
            icon: PhosphorIcons.infinity(PhosphorIconsStyle.regular),
            onChanged: (value) => fifthController.updateApplicantEntry(
                index, 'serverNumber', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Area Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['areaController'] ,
            label: 'Area',
            hint: 'Enter area',
            icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                fifthController.updateApplicantEntry(index, 'area', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Potkharaba Area Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['potkaharabaAreaController'] ,
            label: 'Potkharaba Area',
            hint: 'Enter potkharaba area',
            icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => fifthController.updateApplicantEntry(
                index, 'potkaharabaArea', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Total Area Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['totalAreaController'] ,
            label: 'Total Area',
            hint: 'Enter total area',
            icon: PhosphorIcons.resize(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                fifthController.updateApplicantEntry(index, 'totalArea', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Summary Row - Fixed with correct tag and safer text access
          // GetBuilder<CensusFifthController>(
          //   tag: 'census_fifth', // Fixed: Use consistent tag
          //   builder: (controller) {
          //     final accountHolderController = entry['accountHolderNameController'] as TextEditingController?;
          //     final accountHolderName = accountHolderController?.text ?? '';
          //
          //     return Container(
          //       padding: EdgeInsets.all(12.w * GovernmentCensusUIUtils.sizeFactor),
          //       decoration: BoxDecoration(
          //         color: SetuColors.primaryGreen.withOpacity(0.05),
          //         borderRadius: BorderRadius.circular(8.r),
          //         border: Border.all(
          //           color: SetuColors.primaryGreen.withOpacity(0.2),
          //           width: 1,
          //         ),
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(
          //             PhosphorIcons.info(PhosphorIconsStyle.regular),
          //             color: SetuColors.primaryGreen,
          //             size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
          //           ),
          //           Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
          //           Expanded(
          //             child: Text(
          //               'Applicant ${index + 1} - ${accountHolderName.isNotEmpty ? accountHolderName : 'Name not entered'}',
          //               style: TextStyle(
          //                 fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
          //                 color: SetuColors.primaryGreen,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildAddressField(CensusFifthController fifthController, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Account Holder\'s Address',
              style: TextStyle(
                fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
        Gap(8.h * GovernmentCensusUIUtils.sizeFactor),

        // Fixed: Use correct tag and safer context access
        GetBuilder<CensusFifthController>(
          tag: 'census_fifth', // Fixed: Use consistent tag
          builder: (controller) => InkWell(
            onTap: () {
              final context = Get.context;
              if (context != null) {
                fifthController.showAddressPopup(context, index);
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w * GovernmentCensusUIUtils.sizeFactor,
                vertical: 16.h * GovernmentCensusUIUtils.sizeFactor,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
                    color: SetuColors.primaryGreen,
                    size: 20.sp * GovernmentCensusUIUtils.sizeFactor,
                  ),
                  Gap(12.w * GovernmentCensusUIUtils.sizeFactor),
                  Expanded(
                    child: Text(
                      fifthController.getFormattedAddress(index),
                      style: TextStyle(
                        fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                        color: fifthController.getFormattedAddress(index) ==
                            'Click to add address'
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
                    color: Colors.grey[500],
                    size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Show validation error if address is incomplete
        GetBuilder<CensusFifthController>(
          tag: 'census_fifth', // Fixed: Use consistent tag
          builder: (controller) {
            final hasError = fifthController.validationErrors
                .containsKey('${index}_address') ||
                fifthController.validationErrors
                    .containsKey('${index}_pincode') ||
                fifthController.validationErrors
                    .containsKey('${index}_village') ||
                fifthController.validationErrors
                    .containsKey('${index}_postOffice');

            if (hasError) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h * GovernmentCensusUIUtils.sizeFactor),
                child: Text(
                  'Complete address information is required',
                  style: TextStyle(
                    fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}