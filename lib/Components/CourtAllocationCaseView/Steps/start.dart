// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:get/get.dart';
// import '../../../Constants/color_constant.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../Controller/main_controller.dart';
// import '../Controller/personal_info_controller.dart';
// import 'ZLandAcquisitionUIUtils.dart';
//
// class PersonalInfoStep extends StatelessWidget {
//   final int currentSubStep;
//   final CourtAllocationCaseController mainController;
//
//   const PersonalInfoStep({
//     Key? key,
//     required this.currentSubStep,
//     required this.mainController,
//   }) : super(key: key);
//
//   // Get the PersonalInfoController
//   PersonalInfoController get controller => Get.find<PersonalInfoController>(tag: 'personal_info');
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the substeps from main controller configuration
//     final subSteps = mainController.stepConfigurations[0] ?? ['holder_verification'];
//
//     // Ensure currentSubStep is within bounds
//     if (currentSubStep >= subSteps.length) {
//       return _buildHolderVerification(); // Fallback
//     }
//
//     final currentField = subSteps[currentSubStep];
//
//     switch (currentField) {
//       case 'holder_verification':
//         return _buildHolderVerification();
//       case 'enumeration_check':
//         return _buildEnumerationCheck();
//       default:
//         return _buildHolderVerification();
//     }
//   }
//
//   Widget _buildHolderVerification() {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CourtAllocationCaseUIUtils.buildStepHeader(
//               'Holder Verification',
//               'Please confirm your status as the holder',
//             ),
//             Gap(24.h),
//
//             // Question 1: Are you the holder yourself?
//             CourtAllocationCaseUIUtils.buildQuestionCard(
//               question: 'Note: Are you the holder yourself?',
//               selectedValue: controller.isHolderThemselves.value,
//               onChanged: (value) {
//                 controller.updateHolderThemselves(value);
//               },
//             ),
//
//             Gap(16.h),
//
//             // Conditional Question 2: Authority on behalf
//             if (controller.shouldShowAuthorityQuestion) ...[
//               CourtAllocationCaseUIUtils.buildQuestionCard(
//                 question:
//                     'Note: Are you holding the authority on behalf of the applicant?/or are you applying as a competent Gunthewari Regularization/Gunthewari Planning Authority?',
//                 selectedValue: controller.hasAuthorityOnBehalf.value,
//                 onChanged: (value) async {
//                   controller.updateAuthorityOnBehalf(value);
//
//                   if (value == true) {
//                     // Show dialog when user selects Yes
//                     await _showAuthorityConfirmationDialog();
//                   }
//                 },
//               ),
//               Gap(16.h),
//             ],
//
//             // Additional fields when has authority on behalf
//             if (controller.shouldShowPOAFields) ...[
//               _buildAdditionalFields(),
//               Gap(16.h),
//             ],
//
//             Gap(32.h),
//             CourtAllocationCaseUIUtils.buildNavigationButtons(mainController),
//           ],
//         ));
//   }
//
//   Widget _buildEnumerationCheck() {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CourtAllocationCaseUIUtils.buildStepHeader(
//               'Enumeration Status',
//               'Has this property been enumerated before?',
//             ),
//             Gap(24.h),
//             CourtAllocationCaseUIUtils.buildQuestionCard(
//               question: 'Note: Has this been counted before?',
//               selectedValue: controller.hasBeenCountedBefore.value,
//               onChanged: (value) {
//                 controller.updateEnumerationCheck(value);
//               },
//             ),
//             Gap(32.h),
//             CourtAllocationCaseUIUtils.buildNavigationButtons(mainController),
//           ],
//         ));
//   }
//
//   Widget _buildAdditionalFields() {
//     return Container(
//       padding: EdgeInsets.all(16.w * CourtAllocationCaseUIUtils.sizeFactor),
//       decoration: BoxDecoration(
//         color: SetuColors.primaryGreen.withOpacity(0.05),
//         borderRadius:
//             BorderRadius.circular(12.r * CourtAllocationCaseUIUtils.sizeFactor),
//         border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CourtAllocationCaseUIUtils.buildTranslatableText(
//             text: 'Power of Attorney Details',
//             style: GoogleFonts.poppins(
//               fontSize: 18.sp * CourtAllocationCaseUIUtils.sizeFactor,
//               fontWeight: FontWeight.w700,
//               color: SetuColors.primaryGreen,
//             ),
//           ),
//           Gap(16.h * CourtAllocationCaseUIUtils.sizeFactor),
//
//           // Power of Attorney Registration Number
//           CourtAllocationCaseUIUtils.buildTextFormField(
//             controller: controller.poaRegistrationNumberController,
//             label: 'Power of Attorney / Registration Number',
//             hint: 'Enter registration number',
//             icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.text,
//             validator: (value) {
//               if (value == null || value.trim().length < 3) {
//                 return 'Registration number must be at least 3 characters';
//               }
//               return null;
//             },
//           ),
//           Gap(16.h * CourtAllocationCaseUIUtils.sizeFactor),
//
//           // Power of Attorney Registration Date
//           CourtAllocationCaseUIUtils.buildTextFormField(
//             controller: controller.poaRegistrationDateController,
//             label: 'Power of Attorney Registration Date',
//             hint: 'Enter registration date',
//             icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.datetime,
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Registration date is required';
//               }
//               return null;
//             },
//           ),
//           Gap(16.h * CourtAllocationCaseUIUtils.sizeFactor),
//
//           // Name of the holder issuing the power of attorney
//           CourtAllocationCaseUIUtils.buildTextFormField(
//             controller: controller.poaIssuerNameController,
//             label: 'Name of the holder issuing the power of attorney',
//             hint: 'Enter holder name',
//             icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.name,
//             validator: (value) {
//               if (value == null || value.trim().length < 2) {
//                 return 'Holder name must be at least 2 characters';
//               }
//               return null;
//             },
//           ),
//           Gap(16.h * CourtAllocationCaseUIUtils.sizeFactor),
//
//           // Name of the holder of the Power of Attorney
//           CourtAllocationCaseUIUtils.buildTextFormField(
//             controller: controller.poaHolderNameController,
//             label: 'Name of the holder of the Power of Attorney',
//             hint: 'Enter attorney holder name',
//             icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.name,
//             validator: (value) {
//               if (value == null || value.trim().length < 2) {
//                 return 'Attorney holder name must be at least 2 characters';
//               }
//               return null;
//             },
//           ),
//           Gap(16.h * CourtAllocationCaseUIUtils.sizeFactor),
//
//           // Address holding Power of Attorney
//           CourtAllocationCaseUIUtils.buildTextFormField(
//             controller: controller.poaHolderAddressController,
//             label: 'Address holding Power of Attorney',
//             hint: 'Enter full address',
//             icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
//             keyboardType: TextInputType.streetAddress,
//             maxLines: 3,
//             validator: (value) {
//               if (value == null || value.trim().length < 5) {
//                 return 'Address must be at least 5 characters';
//               }
//               return null;
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _showAuthorityConfirmationDialog() async {
//     await CourtAllocationCaseUIUtils.showTranslatableDialog(
//       context: Get.context!,
//       title: 'Authority Confirmation',
//       message:
//           'You are applying for the enumeration as the holder of the Power of Attorney/Authority Letter or as the competent Gunthewari Regularization/Gunthewari Planning Authority on behalf of the holder of the Group No./Survey No./C. T. Survey No. for which you are applying. Fill in the necessary information.',
//       primaryButtonText: 'Understood',
//       icon: PhosphorIcons.warning(PhosphorIconsStyle.regular),
//       iconColor: SetuColors.primaryGreen,
//       onPrimaryPressed: () {
//         Navigator.of(Get.context!).pop();
//       },
//       barrierDismissible: false,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Constants/color_constant.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../../CourtAllocationCaseView/Controller/personal_info_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final CourtAllocationCaseController mainController;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the CourtAllocationController
  PersonalInfoController get controller => Get.find<PersonalInfoController>(tag: 'personal_info');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[0] ?? ['calculation'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCourtAllocationDetails(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'calculation':
        return _buildCourtAllocationDetails();
      default:
        return _buildCourtAllocationDetails();
    }
  }

  Widget _buildCourtAllocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtAllocationCaseUIUtils.buildStepHeader(
          'Court Allocation Calculation',
          'Please provide court allocation information',
        ),
        Gap(24.h),

        // Name of the court issuing the court allocation order
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.courtNameController,
          label: 'Name of the court issuing the court allocation order *',
          hint: 'Enter court name',
          icon: PhosphorIcons.scales(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court name is required';
            }
            if (value.trim().length < 3) {
              return 'Court name must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Address of the court that issued the court allocation order
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.courtAddressController,
          label: 'Address of the court that issued the court allocation order *',
          hint: 'Enter court address',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court address is required';
            }
            if (value.trim().length < 10) {
              return 'Address must be at least 10 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Court Allocation Order Number
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.courtOrderNumberController,
          label: 'Court Allocation Order Number *',
          hint: 'Enter order number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court order number is required';
            }
            if (value.trim().length < 3) {
              return 'Order number must be at least 3 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Court Allotment Date
        CourtAllocationCaseUIUtils.buildDatePickerField(
          controller: controller.courtAllotmentDateController,
          label: 'Court Allotment Date *',
          hint: 'dd-mm-yyyy',
          icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court allotment date is required';
            }
            return null;
          },
          onDateSelected: (DateTime selectedDate) {
            controller.updateCourtAllotmentDate(selectedDate);
          },
        ),
        Gap(16.h),

        // Claim Number and Year
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.claimNumberYearController,
          label: 'Claim Number and Year *',
          hint: 'Enter claim number and year',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Claim number and year is required';
            }
            if (value.trim().length < 4) {
              return 'Claim number and year must be at least 4 characters';
            }
            return null;
          },
        ),
        Gap(16.h),

        // Upload a copy of the court allocation order
        ImagePickerUtil.buildFileUploadField(
          label: 'Upload a copy of the court allocation order *',
          hint: 'Upload court allocation order document',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          uploadedFiles: controller.courtOrderFiles,
          onFilesSelected: (files) =>
              controller.courtOrderFiles.assignAll(files),
        ),
        Gap(16.h),

        // Special order/comments
        CourtAllocationCaseUIUtils.buildTextFormField(
          controller: controller.specialOrderCommentsController,
          label: 'If there is a special order of the court regarding the calculation of court allocation or if you have any comments on this matter, please mention it here *',
          hint: 'Enter special orders or comments',
          icon: PhosphorIcons.note(PhosphorIconsStyle.regular),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Special order or comments are required';
            }
            if (value.trim().length < 10) {
              return 'Comments must be at least 10 characters';
            }
            return null;
          },
        ),
        Gap(32.h),

        CourtAllocationCaseUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }
}
