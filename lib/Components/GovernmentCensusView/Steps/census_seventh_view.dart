// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import '../../../Constants/color_constant.dart';
// import '../Controller/census_seventh_controller.dart';
// import '../Controller/main_controller.dart';
// import 'ZLandAcquisitionUIUtils.dart';
//
// class CensusSeventhView extends StatelessWidget {
//   final int currentSubStep;
//   final GovernmentCensusController mainController;
//
//   const CensusSeventhView({
//     Key? key,
//     required this.currentSubStep,
//     required this.mainController,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final subSteps = mainController.stepConfigurations[6] ?? ['next_of_kin'];
//
//     if (currentSubStep >= subSteps.length) {
//       return _buildNextOfKinInput();
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'next_of_kin':
//         return _buildNextOfKinInput();
//       default:
//         return _buildNextOfKinInput();
//     }
//   }
//
//   Widget _buildNextOfKinInput() {
//     final surveyEightController = Get.put(CensusSeventhController(), tag: 'census_seventh');
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildStepHeader(
//           'Name and Address of the Next of Kin',
//           'Enter details of next of kin with location and natural resources information',
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Next of Kin Entries Section
//         _buildNextOfKinEntries(surveyEightController),
//
//         Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
//         GovernmentCensusUIUtils.buildNavigationButtons(mainController),
//       ],
//     );
//   }
//
//   Widget _buildNextOfKinEntries(CensusSeventhController surveyEightController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildTranslatableText(
//           text: 'Next of Kin Information',
//           style: TextStyle(
//             fontSize: 18.sp * GovernmentCensusUIUtils.sizeFactor,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.primaryGreen,
//           ),
//         ),
//
//         Gap(20.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Next of Kin Entries List
//         Obx(() => Column(
//               children: [
//                 for (int i = 0;
//                     i < surveyEightController.nextOfKinEntries.length;
//                     i++)
//                   _buildNextOfKinEntryCard(surveyEightController, i),
//               ],
//             )),
//
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Add Another Entry Button
//         InkWell(
//           onTap: surveyEightController.addNextOfKinEntry,
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
//                   text: 'Add Another Entry',
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
//   Widget _buildNextOfKinEntryCard(
//       CensusSeventhController surveyEightController, int index) {
//     final entry = surveyEightController.nextOfKinEntries[index];
//
//     return Container(
//       margin:
//           EdgeInsets.only(bottom: 20.h * GovernmentCensusUIUtils.sizeFactor),
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
//                   'Next of Kin ${index + 1}',
//                   style: TextStyle(
//                     fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               if (surveyEightController.nextOfKinEntries.length > 1)
//                 InkWell(
//                   onTap: () =>
//                       surveyEightController.removeNextOfKinEntry(index),
//                   child: Container(
//                     padding: EdgeInsets.all(
//                         8.w * GovernmentCensusUIUtils.sizeFactor),
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
//           // Direction Dropdown
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'Direction *',
//             value: entry['direction'] as String? ?? '',
//             items: surveyEightController.directionOptions,
//             onChanged: (value) {
//               surveyEightController.updateDirection(index, value ?? '');
//             },
//             icon: PhosphorIcons.compass(PhosphorIconsStyle.regular),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Natural Resources Dropdown
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'Natural Resources *',
//             value: entry['naturalResources'] as String? ?? '',
//             items: surveyEightController.naturalResourcesOptions,
//             onChanged: (value) {
//               surveyEightController.updateNaturalResources(index, value ?? '');
//             },
//             icon: PhosphorIcons.tree(PhosphorIconsStyle.regular),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Address Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['addressController'] as TextEditingController,
//             label: 'Address *',
//             hint: 'Enter complete address',
//             icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//             maxLines: 3,
//             onChanged: (value) => surveyEightController.updateNextOfKinEntry(
//                 index, 'address', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Mobile Number Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['mobileController'] as TextEditingController,
//             label: 'Mobile Number *',
//             hint: 'Enter 10-digit mobile number',
//             icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.phone,
//             maxLength: 10,
//             onChanged: (value) => surveyEightController.updateNextOfKinEntry(
//                 index, 'mobile', value),
//           ),
//
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Survey No./Group No. Input
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['surveyNoController'] as TextEditingController,
//             label: 'Survey No./Group No. *',
//             hint: 'Enter survey or group number',
//             icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//             onChanged: (value) => surveyEightController.updateNextOfKinEntry(
//                 index, 'surveyNo', value),
//           ),
//
//           Gap(20.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Summary Row
//           Container(
//             padding: EdgeInsets.all(12.w * GovernmentCensusUIUtils.sizeFactor),
//             decoration: BoxDecoration(
//               color: SetuColors.primaryGreen.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(8.r),
//               border: Border.all(
//                 color: SetuColors.primaryGreen.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   PhosphorIcons.info(PhosphorIconsStyle.regular),
//                   color: SetuColors.primaryGreen,
//                   size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                 ),
//                 Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
//                 Expanded(
//                   child: Text(
//                     'Next of Kin ${index + 1} - ${(entry['name'] as String? ?? '').isEmpty ? 'Name not entered' : entry['name']} | ${(entry['direction'] as String? ?? '').isEmpty ? 'Direction not selected' : entry['direction']}',
//                     style: TextStyle(
//                       fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
//                       color: SetuColors.primaryGreen,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/census_seventh_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CensusSeventhView extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController mainController;

  const CensusSeventhView({
    super.key,
    required this.currentSubStep,
    required this.mainController,
  });

  @override
  Widget build(BuildContext context) {
    final subSteps = mainController.stepConfigurations[6] ?? ['next_of_kin'];

    if (currentSubStep >= subSteps.length) {
      return _buildNextOfKinInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'next_of_kin':
        return _buildNextOfKinInput();
      default:
        return _buildNextOfKinInput();
    }
  }

  Widget _buildNextOfKinInput() {
    final surveySevenController = Get.put(CensusSeventhController(), tag: 'census_seventh');


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildStepHeader(
          'Name and Address of the Next of Kin',
          'Enter details of next of kin with location and natural resources information',
        ),
        Gap(24.h * GovernmentCensusUIUtils.sizeFactor),

        // Next of Kin Entries Section
        _buildNextOfKinEntries(surveySevenController),

        Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
        GovernmentCensusUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildNextOfKinEntries(CensusSeventhController surveyEightController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GovernmentCensusUIUtils.buildTranslatableText(
          text: 'Next of Kin Information',
          style: TextStyle(
            fontSize: 18.sp * GovernmentCensusUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * GovernmentCensusUIUtils.sizeFactor),

        // Next of Kin Entries List
        Obx(() => Column(
          children: [
            for (int i = 0;
            i < surveyEightController.nextOfKinEntries.length;
            i++)
              _buildNextOfKinEntryCard(surveyEightController, i),
          ],
        )),

        Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: surveyEightController.addNextOfKinEntry,
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
                  text: 'Add Another Entry',
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

  Widget _buildNextOfKinEntryCard(
      CensusSeventhController surveyEightController, int index) {
    final entry = surveyEightController.nextOfKinEntries[index];

    return Container(
      margin:
      EdgeInsets.only(bottom: 20.h * GovernmentCensusUIUtils.sizeFactor),
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
                  'Next of Kin ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (surveyEightController.nextOfKinEntries.length > 1)
                InkWell(
                  onTap: () =>
                      surveyEightController.removeNextOfKinEntry(index),
                  child: Container(
                    padding: EdgeInsets.all(
                        8.w * GovernmentCensusUIUtils.sizeFactor),
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

          // Direction Dropdown - Always shown for all natural resources
          GovernmentCensusUIUtils.buildDropdownField(
            label: 'Direction *',
            value: entry['direction'] as String? ?? '',
            items: surveyEightController.directionOptions,
            onChanged: (value) {
              surveyEightController.updateDirection(index, value ?? '');
            },
            icon: PhosphorIcons.compass(PhosphorIconsStyle.regular),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Natural Resources Dropdown (Always shown first)
          GovernmentCensusUIUtils.buildDropdownField(
            label: 'Natural Resources *',
            value: entry['naturalResources'] as String? ?? '',
            items: surveyEightController.naturalResourcesOptions,
            onChanged: (value) {
              surveyEightController.updateNaturalResources(index, value ?? '');
            },
            icon: PhosphorIcons.tree(PhosphorIconsStyle.regular),
          ),

          // Conditional rendering based on natural resources selection
          Obx(() {
            if (surveyEightController.shouldShowSubEntries(index)) {
              // Show sub-entries for Name or Other
              return Column(
                children: [
                  Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
                  _buildSubEntriesSection(surveyEightController, index),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          }),

          Gap(20.h * GovernmentCensusUIUtils.sizeFactor),

          // Summary Row
          // Container(
          //   padding:
          //       EdgeInsets.all(12.w * GovernmentCensusUIUtils.sizeFactor),
          //   decoration: BoxDecoration(
          //     color: SetuColors.primaryGreen.withOpacity(0.05),
          //     borderRadius: BorderRadius.circular(8.r),
          //     border: Border.all(
          //       color: SetuColors.primaryGreen.withOpacity(0.2),
          //       width: 1,
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(
          //         PhosphorIcons.info(PhosphorIconsStyle.regular),
          //         color: SetuColors.primaryGreen,
          //         size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
          //       ),
          //       Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
          //       Expanded(
          //         child: Text(
          //           'Next of Kin ${index + 1} - ${(entry['naturalResources'] as String? ?? '').isEmpty ? 'Natural resource not selected' : entry['naturalResources']}',
          //           style: TextStyle(
          //             fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
          //             color: SetuColors.primaryGreen,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSubEntriesSection(
      CensusSeventhController surveyEightController, int index) {
    final entry = surveyEightController.nextOfKinEntries[index];
    final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-entries header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${entry['naturalResources']} Details:',
              style: TextStyle(
                fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                fontWeight: FontWeight.w600,
                color: SetuColors.primaryGreen,
              ),
            ),
            InkWell(
              onTap: () => surveyEightController.addSubEntry(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w * GovernmentCensusUIUtils.sizeFactor,
                  vertical: 8.h * GovernmentCensusUIUtils.sizeFactor,
                ),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: SetuColors.primaryGreen,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.plus(PhosphorIconsStyle.bold),
                      color: SetuColors.primaryGreen,
                      size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                    ),
                    Gap(4.w * GovernmentCensusUIUtils.sizeFactor),
                    Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                        color: SetuColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

        // Sub-entries list
        Obx(() => Column(
          children: [
            for (int i = 0; i < subEntries.length; i++)
              _buildSubEntryCard(surveyEightController, index, i),
          ],
        )),
      ],
    );
  }

  Widget _buildSubEntryCard(CensusSeventhController surveyEightController,
      int parentIndex, int subIndex) {
    final entry = surveyEightController.nextOfKinEntries[parentIndex];
    final subEntries = entry['subEntries'] as RxList<Map<String, dynamic>>;
    final subEntry = subEntries[subIndex];

    return Container(
      margin:
      EdgeInsets.only(bottom: 16.h * GovernmentCensusUIUtils.sizeFactor),
      padding: EdgeInsets.all(16.w * GovernmentCensusUIUtils.sizeFactor),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: SetuColors.primaryGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-entry header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w * GovernmentCensusUIUtils.sizeFactor,
                  vertical: 6.h * GovernmentCensusUIUtils.sizeFactor,
                ),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '${entry['naturalResources']} ${subIndex + 1}',
                  style: TextStyle(
                    fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
              if (subEntries.length > 1)
                InkWell(
                  onTap: () => surveyEightController.removeSubEntry(
                      parentIndex, subIndex),
                  child: Container(
                    padding: EdgeInsets.all(
                        6.w * GovernmentCensusUIUtils.sizeFactor),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.regular),
                      color: Colors.red,
                      size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                    ),
                  ),
                ),
            ],
          ),
          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Full Name Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: subEntry['nameController'] as TextEditingController,
            label: 'Full Name *',
            hint: 'Enter full name',
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            onChanged: (value) => surveyEightController.updateSubEntry(
                parentIndex, subIndex, 'name', value),
          ),

          Gap(12.h * GovernmentCensusUIUtils.sizeFactor),

          // Address Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: subEntry['addressController'] as TextEditingController,
            label: 'Address *',
            hint: 'Enter complete address',
            icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
            maxLines: 3,
            onChanged: (value) => surveyEightController.updateSubEntry(
                parentIndex, subIndex, 'address', value),
          ),

          Gap(12.h * GovernmentCensusUIUtils.sizeFactor),

          // Mobile Number Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: subEntry['mobileController'] as TextEditingController,
            label: 'Mobile Number *',
            hint: 'Enter 10-digit mobile number',
            icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (value) => surveyEightController.updateSubEntry(
                parentIndex, subIndex, 'mobile', value),
          ),

          Gap(12.h * GovernmentCensusUIUtils.sizeFactor),

          // Survey No./Group No. Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: subEntry['surveyNoController'] as TextEditingController,
            label: 'Survey No./Group No. *',
            hint: 'Enter survey or group number',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) => surveyEightController.updateSubEntry(
                parentIndex, subIndex, 'surveyNo', value),
          ),
        ],
      ),
    );
  }
}
