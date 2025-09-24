// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import '../../../Constants/color_constant.dart';
// import '../Controller/census_sixth_controller.dart';
// import '../Controller/main_controller.dart';
// import 'ZLandAcquisitionUIUtils.dart';
//
// class CensusSixthView extends StatelessWidget {
//   final int currentSubStep;
//   final GovernmentCensusController mainController;
//
//   const CensusSixthView({
//     super.key,
//     required this.currentSubStep,
//     required this.mainController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final subSteps = mainController.stepConfigurations[5] ?? ['coowner'];
//
//     if (currentSubStep >= subSteps.length) {
//       return _buildCoownerInput();
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'coowner':
//         return _buildCoownerInput();
//       default:
//         return _buildCoownerInput();
//     }
//   }
//
//   Widget _buildCoownerInput() {
//     final sixthController = Get.put(CensusSixthController(), tag: 'census_sixth');
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildStepHeader(
//           'Co-owner Information',
//           'Enter co-owner details and consent information',
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Co-owner Entries Section
//         _buildCoownerEntries(sixthController),
//
//         Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
//         GovernmentCensusUIUtils.buildNavigationButtons(mainController),
//       ],
//     );
//   }
//
//
//   Widget _buildCoownerEntries(CensusSixthController sixthController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildTranslatableText(
//           text: 'Co-owner Entries',
//           style: TextStyle(
//             fontSize: 18.sp * GovernmentCensusUIUtils.sizeFactor,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.primaryGreen,
//           ),
//         ),
//
//         Gap(20.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Co-owner Entries List
//         Obx(() => Column(
//           children: [
//             for (int i = 0; i < sixthController.coownerEntries.length; i++)
//               _buildCoownerEntryCard(sixthController, i),
//           ],
//         )),
//
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Add Another Entry Button
//         InkWell(
//           onTap: sixthController.addCoownerEntry,
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
//                   text: 'Add Another Co-owner',
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
//   Widget _buildCoownerEntryCard(
//       CensusSixthController sixthController, int index) {
//     final entry = sixthController.coownerEntries[index];
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
//                   'Co-owner ${index + 1}',
//                   style: TextStyle(
//                     fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               if (sixthController.coownerEntries.length > 1)
//                 InkWell(
//                   onTap: () => sixthController.removeCoownerEntry(index),
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
//           // Name Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['nameController'],
//             label: 'Co-owner Name *',
//             hint: 'Enter co-owner full name',
//             icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 sixthController.updateCoownerEntry(index, 'name', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Address Field (Clickable)
//           _buildAddressField(sixthController, index),
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
//             onChanged: (value) =>
//                 sixthController.updateCoownerEntry(index, 'mobileNumber', value),
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
//             onChanged: (value) =>
//                 sixthController.updateCoownerEntry(index, 'serverNumber', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Consent Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['consentController'],
//             label: 'Consent of Co-owner *',
//             hint: 'Enter consent details',
//             icon: PhosphorIcons.handshake(PhosphorIconsStyle.regular),
//             maxLines: 3,
//             onChanged: (value) =>
//                 sixthController.updateCoownerEntry(index, 'consent', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Summary Row
//           GetBuilder<CensusSixthController>(
//             tag: 'survey_sixth',
//             builder: (controller) {
//               final coownerName = (entry['nameController'] as TextEditingController).text;
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
//                         'Co-owner ${index + 1} - ${coownerName.isNotEmpty ? coownerName : 'Name not entered'}',
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
//   Widget _buildAddressField(CensusSixthController sixthController, int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               'Co-owner Address',
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
//         // Use GetBuilder for better performance
//         GetBuilder<CensusSixthController>(
//           tag: 'survey_sixth',
//           builder: (controller) => InkWell(
//             onTap: () => sixthController.showAddressPopup(Get.context!, index),
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
//                       sixthController.getFormattedAddress(index),
//                       style: TextStyle(
//                         fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
//                         color: sixthController.getFormattedAddress(index) ==
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
//         GetBuilder<CensusSixthController>(
//           tag: 'survey_sixth',
//           builder: (controller) {
//             final hasError = sixthController.validationErrors
//                 .containsKey('${index}_address') ||
//                 sixthController.validationErrors
//                     .containsKey('${index}_pincode') ||
//                 sixthController.validationErrors
//                     .containsKey('${index}_village') ||
//                 sixthController.validationErrors
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
import '../Controller/census_sixth_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CensusSixthView extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController mainController;

  const CensusSixthView({
    super.key,
    required this.currentSubStep,
    required this.mainController,
  });

  @override
  Widget build(BuildContext context) {
    final subSteps = mainController.stepConfigurations[5] ?? ['coowner'];

    if (currentSubStep >= subSteps.length) {
      return _buildCoownerInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'coowner':
        return _buildCoownerInput();
      default:
        return _buildCoownerInput();
    }
  }

  Widget _buildCoownerInput() {
    final sixthController = Get.put(CensusSixthController(), tag: 'census_sixth');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildStepHeader(
          'Co-owner Information',
          'Enter co-owner details and consent information',
        ),
        Gap(24.h * GovernmentCensusUIUtils.sizeFactor),

        // Co-owner Entries Section
        _buildCoownerEntries(sixthController),

        Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
        GovernmentCensusUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildCoownerEntries(CensusSixthController sixthController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildTranslatableText(
          text: 'Co-owner Entries',
          style: TextStyle(
            fontSize: 18.sp * GovernmentCensusUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * GovernmentCensusUIUtils.sizeFactor),

        // Co-owner Entries List
        Obx(() => Column(
          children: [
            for (int i = 0; i < sixthController.coownerEntries.length; i++)
              _buildCoownerEntryCard(sixthController, i),
          ],
        )),

        Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: sixthController.addCoownerEntry,
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
                  text: 'Add Another Co-owner',
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

  Widget _buildCoownerEntryCard(
      CensusSixthController sixthController, int index) {
    final entry = sixthController.coownerEntries[index];

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
                  'Co-owner ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (sixthController.coownerEntries.length > 1)
                InkWell(
                  onTap: () => sixthController.removeCoownerEntry(index),
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

          // Name Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['nameController'] ,
            label: 'Co-owner Name *',
            hint: 'Enter co-owner full name',
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                sixthController.updateCoownerEntry(index, 'name', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Address Field (Clickable)
          _buildAddressField(sixthController, index),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Mobile Number Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['mobileNumberController'] ,
            label: 'Mobile Number *',
            hint: 'Enter mobile number',
            icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.phone,
            onChanged: (value) =>
                sixthController.updateCoownerEntry(index, 'mobileNumber', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Server Number Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['serverNumberController'] ,
            label: 'Server Number',
            hint: 'Enter server number',
            icon: PhosphorIcons.infinity(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                sixthController.updateCoownerEntry(index, 'serverNumber', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Consent Input
          // GovernmentCensusUIUtils.buildTextFormField(
          //   controller: entry['consentController'] ,
          //   label: 'Consent of Co-owner *',
          //   hint: 'Enter consent details',
          //   icon: PhosphorIcons.handshake(PhosphorIconsStyle.regular),
          //   maxLines: 3,
          //   onChanged: (value) =>
          //       sixthController.updateCoownerEntry(index, 'consent', value),
          // ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Summary Row - Fixed with consistent tag and safer text access
          // GetBuilder<CensusSixthController>(
          //   tag: 'census_sixth', // Fixed: Use consistent tag
          //   builder: (controller) {
          //     final nameController = entry['nameController'] as TextEditingController?;
          //     final coownerName = nameController?.text ?? '';
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
          //               'Co-owner ${index + 1} - ${coownerName.isNotEmpty ? coownerName : 'Name not entered'}',
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

  Widget _buildAddressField(CensusSixthController sixthController, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Co-owner Address',
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

        // Fixed: Use consistent tag and safer context access
        GetBuilder<CensusSixthController>(
          tag: 'census_sixth', // Fixed: Use consistent tag
          builder: (controller) => InkWell(
            onTap: () {
              final context = Get.context;
              if (context != null) {
                sixthController.showAddressPopup(context, index);
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
                      sixthController.getFormattedAddress(index),
                      style: TextStyle(
                        fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                        color: sixthController.getFormattedAddress(index) ==
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
        GetBuilder<CensusSixthController>(
          tag: 'census_sixth', // Fixed: Use consistent tag
          builder: (controller) {
            final hasError = sixthController.validationErrors
                .containsKey('${index}_address') ||
                sixthController.validationErrors
                    .containsKey('${index}_pincode') ||
                sixthController.validationErrors
                    .containsKey('${index}_village') ||
                sixthController.validationErrors
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