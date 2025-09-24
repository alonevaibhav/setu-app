import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../Constants/color_constant.dart';
import '../../GovernmentCensusView/Controller/step_three_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CalculationInformation extends StatelessWidget {
  final int currentSubStep;
  final GovernmentCensusController controller;

  const CalculationInformation({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = controller.stepConfigurations[2] ?? ['government_survey'];

    if (currentSubStep >= subSteps.length) {
      return _buildGovernmentSurveyInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'government_survey':
        return _buildGovernmentSurveyInput();
      default:
        return _buildGovernmentSurveyInput();
    }
  }

  Widget _buildGovernmentSurveyInput() {
    // final surveyController = Get.put(GovernmentSurveyController(), tag: 'government_survey');
    final surveyController = Get.put(CalculationController(), tag: 'calculation');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Header with different styling
        _buildCustomHeader(),
        Gap(24.h * GovernmentCensusUIUtils.sizeFactor),

        // Survey Entries Section
        _buildSurveyEntries(surveyController),

        Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
        GovernmentCensusUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: EdgeInsets.all(20.w * GovernmentCensusUIUtils.sizeFactor),
      decoration: BoxDecoration(
        color: SetuColors.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: SetuColors.primaryGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.notepad(PhosphorIconsStyle.bold),
                color: SetuColors.primaryGreen,
                size: 24.sp * GovernmentCensusUIUtils.sizeFactor,
              ),
              Gap(12.w * GovernmentCensusUIUtils.sizeFactor),
              Expanded(
                child: Text(
                  'Government Survey Information',
                  style: TextStyle(
                    fontSize: 22.sp * GovernmentCensusUIUtils.sizeFactor,
                    fontWeight: FontWeight.w700,
                    color: SetuColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h * GovernmentCensusUIUtils.sizeFactor),
          Text(
            'Survey No. / Group No. Fill in as per your 7/12.',
            style: TextStyle(
              fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyEntries(CalculationController surveyController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Survey Entries List
        Obx(() => Column(
          children: [
            for (int i = 0; i < surveyController.surveyEntries.length; i++)
              _buildSurveyEntryCard(surveyController, i),
          ],
        )),

        Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: surveyController.addSurveyEntry,
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
                Text(
                  'Fill in more information',
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

  Widget _buildSurveyEntryCard(CalculationController surveyController, int index) {
    final entry = surveyController.surveyEntries[index];

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
                  'Entry ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (surveyController.surveyEntries.length > 1)
                InkWell(
                  onTap: () => surveyController.removeSurveyEntry(index),
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

          // Survey No./Group No. Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['surveyNoController'],
            label: 'Survey No./Gat No./CTS No. *',
            hint: 'Enter Survey No./Gat No./CTS No',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                surveyController.updateSurveyEntry(index, 'surveyNo', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Part No. Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['partNoController'],
            label: 'Part No. *',
            hint: 'Enter part number',
            icon: PhosphorIcons.divide(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                surveyController.updateSurveyEntry(index, 'partNo', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Area Input
          GovernmentCensusUIUtils.buildTextFormField(
            controller: entry['areaController'],
            label: 'Area *',
            hint: 'Enter area (in acres/hectares)',
            icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                surveyController.updateSurveyEntry(index, 'area', value),
          ),

          Gap(16.h * GovernmentCensusUIUtils.sizeFactor),

          // Summary Row
          Container(
            padding: EdgeInsets.all(12.w * GovernmentCensusUIUtils.sizeFactor),
            decoration: BoxDecoration(
              color: SetuColors.primaryGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: SetuColors.primaryGreen.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.info(PhosphorIconsStyle.regular),
                  color: SetuColors.primaryGreen,
                  size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
                ),
                Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
                Expanded(
                  child: Text(
                    'Entry ${index + 1} - Survey/Group: ${entry['surveyNo'] ?? 'Not entered'} | Part: ${entry['partNo'] ?? 'Not entered'}',
                    style: TextStyle(
                      fontSize: 12.sp * GovernmentCensusUIUtils.sizeFactor,
                      color: SetuColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
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





//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import '../../../Constants/color_constant.dart';
// import '../../../Utils/custimize_image_picker.dart';
// import '../Controller/main_controller.dart';
// import '../Controller/step_three_controller.dart';
// import 'ZGovernmentCensusUIUtils.dart';
//
// class CalculationInformation extends StatelessWidget {
//   final int currentSubStep;
//   final GovernmentCensusController controller;
//
//   const CalculationInformation({
//     Key? key,
//     required this.currentSubStep,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final subSteps = controller.stepConfigurations[2] ?? ['calculation'];
//
//     if (currentSubStep >= subSteps.length) {
//       return _buildCalculationInput();
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'calculation':
//         return _buildCalculationInput();
//       default:
//         return _buildCalculationInput();
//     }
//   }
//
//   Widget _buildCalculationInput() {
//     final calcController = Get.put(CalculationController(), tag: 'calculation');
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildStepHeader(
//           'Group No./ Survey No./ C. T. Survey No. /T. P. No. Information about the area',
//           'Select calculation type and provide required information',
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Calculation Type Dropdown
//         Obx(() => GovernmentCensusUIUtils.buildDropdownField(
//           label: 'Calculation type *',
//           value: calcController.selectedCalculationType.value,
//           items: calcController.calculationTypes,
//           onChanged: (value) {
//             calcController.updateCalculationType(value ?? '');
//           },
//           icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//         )),
//
//         Gap(20.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Dynamic content based on selected calculation type
//         Obx(() => _buildDynamicContent(calcController)),
//
//         Gap(32.h * GovernmentCensusUIUtils.sizeFactor),
//         GovernmentCensusUIUtils.buildNavigationButtons(controller),
//       ],
//     );
//   }
//
//   Widget _buildDynamicContent(CalculationController calcController) {
//     if (calcController.selectedCalculationType.value.isEmpty) {
//       return Container();
//     }
//
//     switch (calcController.selectedCalculationType.value) {
//       case 'Hddkayam':
//         return _buildHddkayamFields(calcController);
//       case 'Stomach':
//         return _buildStomachFields(calcController);
//       case 'Non-agricultural':
//         return _buildNonAgriculturalFields(calcController);
//       case 'Counting by number of knots':
//         return _buildKnotsCountingFields(calcController);
//       case 'Integration calculation':
//         return _buildIntegrationCalculationFields(calcController);
//       default:
//         return Container();
//     }
//   }
//
//   // ================ COMMON COMPONENTS ================
//
//   Widget _buildEntryCard({
//     required CalculationController calcController,
//     required int index,
//     required Widget child,
//     required VoidCallback onMarkCorrect,
//     required VoidCallback onDelete,
//     required String entryType,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h * GovernmentCensusUIUtils.sizeFactor),
//       padding: EdgeInsets.all(16.w * GovernmentCensusUIUtils.sizeFactor),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: Colors.grey.shade200,
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade100,
//             blurRadius: 4,
//             offset: Offset(0, 2),
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
//               Text(
//                 '$entryType Entry ${index + 1}',
//                 style: TextStyle(
//                   fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                   fontWeight: FontWeight.w600,
//                   color: SetuColors.primaryGreen,
//                 ),
//               ),
//               Row(
//                 children: [
//                   // Check Button
//                   InkWell(
//                     onTap: onMarkCorrect,
//                     child: Container(
//                       padding: EdgeInsets.all(8.w * GovernmentCensusUIUtils.sizeFactor),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       child: Icon(
//                         PhosphorIcons.check(PhosphorIconsStyle.regular),
//                         color: Colors.white,
//                         size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                       ),
//                     ),
//                   ),
//                   Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
//                   // Delete Button
//                   InkWell(
//                     onTap: onDelete,
//                     child: Container(
//                       padding: EdgeInsets.all(8.w * GovernmentCensusUIUtils.sizeFactor),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       child: Icon(
//                         PhosphorIcons.trash(PhosphorIconsStyle.regular),
//                         color: Colors.white,
//                         size: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//           child,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEntryList({
//     required String title,
//     required List<dynamic> entries,
//     required Widget Function(int index) itemBuilder,
//     required VoidCallback onAddMore,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GovernmentCensusUIUtils.buildTranslatableText(
//           text: title,
//           style: TextStyle(
//             fontSize: 16.sp * GovernmentCensusUIUtils.sizeFactor,
//             fontWeight: FontWeight.w600,
//             color: SetuColors.primaryGreen,
//           ),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Dynamic Entries
//         Obx(() => Column(
//           children: [
//             for (int i = 0; i < entries.length; i++) itemBuilder(i),
//           ],
//         )),
//
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Add More Button
//         InkWell(
//           onTap: onAddMore,
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 16.w * GovernmentCensusUIUtils.sizeFactor,
//               vertical: 12.h * GovernmentCensusUIUtils.sizeFactor,
//             ),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: SetuColors.primaryGreen,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(8.r),
//               color: SetuColors.primaryGreen.withOpacity(0.05),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   PhosphorIcons.plus(PhosphorIconsStyle.regular),
//                   color: SetuColors.primaryGreen,
//                   size: 20.sp * GovernmentCensusUIUtils.sizeFactor,
//                 ),
//                 Gap(8.w * GovernmentCensusUIUtils.sizeFactor),
//                 GovernmentCensusUIUtils.buildTranslatableText(
//                   text: 'Add Another Entry',
//                   style: TextStyle(
//                     fontSize: 14.sp * GovernmentCensusUIUtils.sizeFactor,
//                     color: SetuColors.primaryGreen,
//                     fontWeight: FontWeight.w500,
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
//   // ================ HDKAYAM SECTION ================
//
//   Widget _buildHddkayamFields(CalculationController calcController) {
//     return _buildEntryList(
//       title: 'Hddkayam Calculation Details',
//       entries: calcController.hddkayamEntries,
//       onAddMore: calcController.addHddkayamEntry,
//       itemBuilder: (index) => _buildHddkayamCard(calcController, index),
//     );
//   }
//
//   Widget _buildHddkayamCard(CalculationController calcController, int index) {
//     final entry = calcController.hddkayamEntries[index];
//     return _buildEntryCard(
//       calcController: calcController,
//       index: index,
//       onMarkCorrect: () => calcController.markHddkayamEntryCorrect(index),
//       onDelete: () => calcController.removeHddkayamEntry(index),
//       entryType: 'Hddkayam',
//       child: Column(
//         children: [
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['ctSurveyController'],
//             label: 'CT Survey No.',
//             hint: 'Enter CT Survey No.',
//             icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//             onChanged: (value) => calcController.updateHddkayamEntry(
//                 index, 'ctSurveyNumber', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'CT Survey/TP No.',
//             value: entry['selectedCTSurvey'] ?? '',
//             items: calcController.ctSurveyOptions,
//             onChanged: (value) => calcController.updateHddkayamEntry(
//                 index, 'selectedCTSurvey', value),
//             icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaController'],
//             label: 'Area',
//             hint: 'Enter area',
//             icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 calcController.updateHddkayamEntry(index, 'area', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaSqmController'],
//             label: 'Area (sq.m.)',
//             hint: 'Enter area in square meters',
//             icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) =>
//                 calcController.updateHddkayamEntry(index, 'areaSqm', value),
//           ),
//         ],
//       ),
//     );
//   }
//
// // ================ STOMACH SECTION ================
//
//   Widget _buildStomachFields(CalculationController calcController) {
//     return _buildEntryList(
//       title: 'Stomach Calculation Details',
//       entries: calcController.stomachEntries,
//       onAddMore: calcController.addStomachEntry,
//       itemBuilder: (index) => _buildStomachCard(calcController, index),
//     );
//   }
//
//   Widget _buildStomachCard(CalculationController calcController, int index) {
//     final entry = calcController.stomachEntries[index];
//     return _buildEntryCard(
//       calcController: calcController,
//       index: index,
//       onMarkCorrect: () => calcController.markStomachEntryCorrect(index),
//       onDelete: () => calcController.removeStomachEntry(index),
//       entryType: 'Stomach',
//       child: Column(
//         children: [
//           // Survey Number field (similar to CT Survey No. in Hddkayam)
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['surveyNumberController'],
//             label: 'Survey No.',
//             hint: 'Enter Survey No.',
//             icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 calcController.updateStomachEntry(index, 'surveyNumber', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Measurement Type dropdown (similar to CT Survey/TP No. dropdown)
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'Measurement Type *',
//             value: entry['selectedMeasurementType'] ?? '',
//             items: calcController.measurementTypeOptions,
//             onChanged: (value) => calcController.updateStomachEntry(
//                 index, 'selectedMeasurementType', value),
//             icon: PhosphorIcons.ruler(PhosphorIconsStyle.regular),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Total Area field (similar to Area in Hddkayam)
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['totalAreaController'],
//             label: 'Total Area',
//             hint: 'Enter total area',
//             icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) =>
//                 calcController.updateStomachEntry(index, 'totalArea', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Calculated Area field (similar to Area (sq.m.) in Hddkayam)
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['calculatedAreaController'],
//             label: 'Calculated Area (sq.m.)',
//             hint: 'Enter calculated area in square meters',
//             icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) => calcController.updateStomachEntry(
//                 index, 'calculatedArea', value),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// // ================ NON-AGRICULTURAL SECTION ================
//
//   Widget _buildNonAgriculturalFields(CalculationController calcController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Order Number field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildTextFormField(
//           controller: calcController.orderNumberController, // Single controller for all entries
//           label: 'Order number or number of the letter issued for counting approved by the competent authority *',
//           hint: 'Enter order number',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           onChanged: (value) => calcController.updateOrderNumber(value),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Order Date field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildDatePickerField(
//           controller: calcController.orderDateController,
//           label: 'Date of order passed by the competent authority or date of letter issued for counting *',
//           hint: 'dd-mm-yyyy',
//           icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Order date is required';
//             }
//             return null;
//           },
//           onDateSelected: (DateTime selectedDate) {
//             calcController.updateOrderDate(selectedDate);
//           },
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Scheme Order Number field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildTextFormField(
//           controller: calcController.schemeOrderNumberController,
//           label: 'Order number of the scheme approved by the competent authority *',
//           hint: 'Enter scheme order number',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           onChanged: (value) => calcController.updateSchemeOrderNumber(value),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Appointment Date field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildDatePickerField(
//           controller: calcController.appointmentDateController,
//           label: 'Date of the order of appointment approved by the competent authority *',
//           hint: 'dd-mm-yyyy',
//           icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Appointment date is required';
//             }
//             return null;
//           },
//           onDateSelected: (DateTime selectedDate) {
//             calcController.updateAppointmentDate(selectedDate);
//           },
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Entry list with table-like structure
//         _buildEntryList(
//           title: 'Survey number / Group No. to be used for non-agricultural census. Fill in as per your 7/12.',
//           entries: calcController.nonAgriculturalEntries,
//           onAddMore: calcController.addNonAgriculturalEntry,
//           itemBuilder: (index) => _buildNonAgriculturalCard(calcController, index),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNonAgriculturalCard(CalculationController calcController, int index) {
//     final entry = calcController.nonAgriculturalEntries[index];
//     return _buildEntryCard(
//       calcController: calcController,
//       index: index,
//       onMarkCorrect: () => calcController.markNonAgriculturalEntryCorrect(index),
//       onDelete: () => calcController.removeNonAgriculturalEntry(index),
//       entryType: 'Non-Agricultural',
//       child: Column(
//         children: [
//           // Survey Number field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['surveyNumberController'],
//             label: 'Survey No./Group No.',
//             hint: 'Enter Survey No./Group No.',
//             icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//             onChanged: (value) => calcController.updateNonAgriculturalEntry(
//                 index, 'surveyNumber', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Survey Type Dropdown
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'Survey No./Group No.',
//             value: entry['selectedSurveyType'] ?? '',
//             items: calcController.surveyTypeOptions,
//             onChanged: (value) => calcController.updateNonAgriculturalEntry(
//                 index, 'selectedSurveyType', value),
//             icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaController'],
//             label: 'Area',
//             hint: 'Enter area',
//             icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 calcController.updateNonAgriculturalEntry(index, 'area', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area in Hectares field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaHectaresController'],
//             label: 'Area (hectares sq.m.)',
//             hint: 'Enter area in hectares',
//             icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) => calcController.updateNonAgriculturalEntry(
//                 index, 'areaHectares', value),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================ KNOTS COUNTING SECTION ================
//
//   Widget _buildKnotsCountingFields(CalculationController calcController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Order Number field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildTextFormField(
//           controller: calcController.orderNumberController, // Single controller for all entries
//           label: 'Order number or number of the letter issued for counting approved by the competent authority *',
//           hint: 'Enter order number',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           onChanged: (value) => calcController.updateOrderNumber(value),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Order Date field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildDatePickerField(
//           controller: calcController.orderDateController,
//           label: 'Date of order passed by the competent authority or date of letter issued for counting *',
//           hint: 'dd-mm-yyyy',
//           icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Order date is required';
//             }
//             return null;
//           },
//           onDateSelected: (DateTime selectedDate) {
//             calcController.updateOrderDate(selectedDate);
//           },
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Scheme Order Number field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildTextFormField(
//           controller: calcController.schemeOrderNumberController,
//           label: 'Order number of the scheme approved by the competent authority *',
//           hint: 'Enter scheme order number',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           onChanged: (value) => calcController.updateSchemeOrderNumber(value),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Appointment Date field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildDatePickerField(
//           controller: calcController.appointmentDateController,
//           label: 'Date of the order of appointment approved by the competent authority *',
//           hint: 'dd-mm-yyyy',
//           icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Appointment date is required';
//             }
//             return null;
//           },
//           onDateSelected: (DateTime selectedDate) {
//             calcController.updateAppointmentDate(selectedDate);
//           },
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Entry list with table-like structure
//         _buildEntryList(
//           title: 'Fill in the survey number/group number to be counted by gunthewari as per your 7/12.',
//           entries: calcController.knotsCountingEntries,
//           onAddMore: calcController.addKnotsCountingEntry,
//           itemBuilder: (index) => _buildKnotsCountingCard(calcController, index),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildKnotsCountingCard(CalculationController calcController, int index) {
//     final entry = calcController.knotsCountingEntries[index];
//     return _buildEntryCard(
//       calcController: calcController,
//       index: index,
//       onMarkCorrect: () => calcController.markKnotsCountingEntryCorrect(index),
//       onDelete: () => calcController.removeKnotsCountingEntry(index),
//       entryType: 'Knots Counting',
//       child: Column(
//         children: [
//           // Survey Number field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['surveyNumberController'],
//             label: 'Survey No./Group No.',
//             hint: 'Enter Survey No./Group No.',
//             icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//             onChanged: (value) => calcController.updateKnotsCountingEntry(
//                 index, 'surveyNumber', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Survey Type Dropdown
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'Survey No./Group No.',
//             value: entry['selectedSurveyType'] ?? '',
//             items: calcController.surveyTypeOptions,
//             onChanged: (value) => calcController.updateKnotsCountingEntry(
//                 index, 'selectedSurveyType', value),
//             icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaController'],
//             label: 'Area',
//             hint: 'Enter area',
//             icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 calcController.updateKnotsCountingEntry(index, 'area', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area in Hectares field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaHectaresController'],
//             label: 'Area (hectares sq.m.)',
//             hint: 'Enter area in hectares',
//             icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) => calcController.updateKnotsCountingEntry(
//                 index, 'areaHectares', value),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================ INTEGRATION CALCULATION SECTION ================
//   Widget _buildIntegrationCalculationFields(CalculationController calcController) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Number of merger order field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildTextFormField(
//           controller: calcController.mergerOrderNumberController,
//           label: 'Number of the merger order approved by the competent authority *',
//           hint: 'Enter merger order number',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           onChanged: (value) => calcController.updateMergerOrderNumber(value),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Date of merger order field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildDatePickerField(
//           controller: calcController.mergerOrderDateController,
//           label: 'Date of merger order approved by the competent authority *',
//           hint: 'dd-mm-yyyy',
//           icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'Merger order date is required';
//             }
//             return null;
//           },
//           onDateSelected: (DateTime selectedDate) {
//             calcController.updateMergerOrderDate(selectedDate);
//           },
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Old Merger No. field - OUTSIDE the entry list
//         GovernmentCensusUIUtils.buildTextFormField(
//           controller: calcController.oldMergerNumberController,
//           label: 'Old Merger No. *',
//           hint: 'Enter old merger number',
//           icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//           onChanged: (value) => calcController.updateOldMergerNumber(value),
//         ),
//         Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Map of incorporation order field - OUTSIDE the entry list
//         ImagePickerUtil.buildFileUploadField(
//           label: 'Map of the order of incorporation approved by the competent authority *',
//           hint: 'Upload images or documents',
//           icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//           uploadedFiles: calcController.incorporationOrderFiles,
//           onFilesSelected: (files) => calcController.incorporationOrderFiles.assignAll(files),
//         ),
//         Gap(24.h * GovernmentCensusUIUtils.sizeFactor),
//
//         // Entry list with table-like structure
//         _buildEntryList(
//           title: 'CT Survey/TP No. Information',
//           entries: calcController.integrationCalculationEntries,
//           onAddMore: calcController.addIntegrationCalculationEntry,
//           itemBuilder: (index) => _buildIntegrationCalculationCard(calcController, index),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildIntegrationCalculationCard(CalculationController calcController, int index) {
//     final entry = calcController.integrationCalculationEntries[index];
//     return _buildEntryCard(
//       calcController: calcController,
//       index: index,
//       onMarkCorrect: () => calcController.markIntegrationCalculationEntryCorrect(index),
//       onDelete: () => calcController.removeIntegrationCalculationEntry(index),
//       entryType: 'Integration Calculation',
//       child: Column(
//         children: [
//           // CT Survey/TP No. field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['ctSurveyController'],
//             label: 'CT Survey/TP No.',
//             hint: 'Enter CT Survey/TP No.',
//             icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
//             onChanged: (value) => calcController.updateIntegrationCalculationEntry(
//                 index, 'ctSurveyNumber', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // CT Survey/TP No. Dropdown
//           GovernmentCensusUIUtils.buildDropdownField(
//             label: 'CT Survey/TP No.',
//             value: entry['selectedCTSurvey'] ?? '',
//             items: calcController.ctSurveyOptions,
//             onChanged: (value) => calcController.updateIntegrationCalculationEntry(
//                 index, 'selectedCTSurvey', value),
//             icon: PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaController'],
//             label: 'Area',
//             hint: 'Enter area',
//             icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
//             onChanged: (value) =>
//                 calcController.updateIntegrationCalculationEntry(index, 'area', value),
//           ),
//           Gap(16.h * GovernmentCensusUIUtils.sizeFactor),
//
//           // Area in sq.m. field
//           GovernmentCensusUIUtils.buildTextFormField(
//             controller: entry['areaSqmController'],
//             label: 'Area (sq.m.)',
//             hint: 'Enter area in square meters',
//             icon: PhosphorIcons.calculator(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             onChanged: (value) => calcController.updateIntegrationCalculationEntry(
//                 index, 'areaSqm', value),
//           ),
//         ],
//       ),
//     );
//   }
// }
