import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Utils/custimize_image_picker.dart';
import '../../CourtCommissionCaseView/Controller/personal_info_controller.dart';
import '../Controller/main_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final CourtCommissionCaseController mainController;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  // Get the CourtCommissionController
  PersonalInfoController get controller => Get.find<PersonalInfoController>(tag: 'personal_info');

  @override
  Widget build(BuildContext context) {
    // Get the substeps from main controller configuration
    final subSteps = mainController.stepConfigurations[0] ?? ['court_commission_details'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildCourtCommissionDetails(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'court_commission_details':
        return _buildCourtCommissionDetails();
      default:
        return _buildCourtCommissionDetails();
    }
  }

  Widget _buildCourtCommissionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtCommissionCaseUIUtils.buildStepHeader(
          'Court Commission Details',
          'Please provide court commission information',
        ),
        Gap(24.h),

        // Name of the court that issued the court commission order
        Obx(() => CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.courtNameController,
          label: 'Name of the court that issued the court commission order *',
          hint: 'Enter court name',
          icon: PhosphorIcons.scales(PhosphorIconsStyle.regular),
          errorText: controller.getFieldValidationError('court_name'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court name is required';
            }
            if (value.trim().length < 3) {
              return 'Court name must be at least 3 characters';
            }
            return null;
          },
        )),
        Gap(16.h),

        // Address of the court issuing the court commission order
        Obx(() => CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.courtAddressController,
          label: 'Address of the court issuing the court commission order *',
          hint: 'Enter court address',
          icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
          maxLines: 3,
          errorText: controller.getFieldValidationError('court_address'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Court address is required';
            }
            if (value.trim().length < 10) {
              return 'Address must be at least 10 characters';
            }
            return null;
          },
        )),
        Gap(16.h),

        // Court Commission Order No.
        Obx(() => CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.commissionOrderNoController,
          label: 'Court Commission Order No. *',
          hint: 'Enter commission order number',
          icon: PhosphorIcons.hash(PhosphorIconsStyle.regular),
          errorText: controller.getFieldValidationError('commission_order_no'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Commission order number is required';
            }
            if (value.trim().length < 3) {
              return 'Order number must be at least 3 characters';
            }
            return null;
          },
        )),
        Gap(16.h),

        // Court Commission dated
        Obx(() => CourtCommissionCaseUIUtils.buildDatePickerField(
          controller: controller.commissionDateController,
          label: 'Court Commission dated *',
          hint: 'dd-mm-yyyy',
          icon: PhosphorIcons.calendar(PhosphorIconsStyle.regular),
          errorText: controller.getFieldValidationError('commission_date'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Commission date is required';
            }
            return null;
          },
          onDateSelected: (DateTime selectedDate) {
            controller.updateCommissionDate(selectedDate);
          },
        )),
        Gap(16.h),

        // Civil claim in the Court Commission case Re. D. M. No. Serial No.
        Obx(() => CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.civilClaimController,
          label: 'Civil claim in the Court Commission case Re. D. M. No. Serial No. *',
          hint: 'Enter civil claim details with reference numbers',
          icon: PhosphorIcons.fileText(PhosphorIconsStyle.regular),
          maxLines: 3,
          errorText: controller.getFieldValidationError('civil_claim'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Civil claim details are required';
            }
            if (value.trim().length < 5) {
              return 'Civil claim must be at least 5 characters';
            }
            return null;
          },
        )),
        Gap(16.h),

        // Name and address of the office issuing the court commission order
        Obx(() => CourtCommissionCaseUIUtils.buildTextFormField(
          controller: controller.issuingOfficeController,
          label: 'Name and address of the office issuing the court commission order *',
          hint: 'Enter issuing office name and address',
          icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
          maxLines: 3,
          errorText: controller.getFieldValidationError('issuing_office'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Issuing office details are required';
            }
            if (value.trim().length < 5) {
              return 'Office details must be at least 5 characters';
            }
            return null;
          },
        )),
        Gap(16.h),

        // Upload Court Commission Order
        ImagePickerUtil.buildFileUploadField(
          label: 'Upload Court Commission Order *',
          hint: 'Upload court commission order document',
          icon: PhosphorIcons.fileArrowUp(PhosphorIconsStyle.regular),
          uploadedFiles: controller.commissionOrderFiles,
          onFilesSelected: (files) =>
              controller.commissionOrderFiles.assignAll(files),
        ),
        Gap(32.h),

        // Navigation buttons
        CourtCommissionCaseUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
//
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
//   final CourtCommissionCaseController mainController;
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
//     final subSteps =
//         mainController.stepConfigurations[0] ?? ['holder_verification'];
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
//             CourtCommissionCaseUIUtils.buildStepHeader(
//               'Holder Verification',
//               'Please confirm your status as the holder',
//             ),
//             Gap(24.h),
//
//             // Question 1: Are you the holder yourself?
//             CourtCommissionCaseUIUtils.buildQuestionCard(
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
//               CourtCommissionCaseUIUtils.buildQuestionCard(
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
//             CourtCommissionCaseUIUtils.buildNavigationButtons(mainController),
//           ],
//         ));
//   }
//
//   Widget _buildEnumerationCheck() {
//     return Obx(() => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CourtCommissionCaseUIUtils.buildStepHeader(
//               'Enumeration Status',
//               'Has this property been enumerated before?',
//             ),
//             Gap(24.h),
//             CourtCommissionCaseUIUtils.buildQuestionCard(
//               question: 'Note: Has this been counted before?',
//               selectedValue: controller.hasBeenCountedBefore.value,
//               onChanged: (value) {
//                 controller.updateEnumerationCheck(value);
//               },
//             ),
//             Gap(32.h),
//             CourtCommissionCaseUIUtils.buildNavigationButtons(mainController),
//           ],
//         ));
//   }
//
//   Widget _buildAdditionalFields() {
//     return Container(
//       padding: EdgeInsets.all(16.w * CourtCommissionCaseUIUtils.sizeFactor),
//       decoration: BoxDecoration(
//         color: SetuColors.primaryGreen.withOpacity(0.05),
//         borderRadius:
//             BorderRadius.circular(12.r * CourtCommissionCaseUIUtils.sizeFactor),
//         border: Border.all(color: SetuColors.primaryGreen.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CourtCommissionCaseUIUtils.buildTranslatableText(
//             text: 'Power of Attorney Details',
//             style: GoogleFonts.poppins(
//               fontSize: 18.sp * CourtCommissionCaseUIUtils.sizeFactor,
//               fontWeight: FontWeight.w700,
//               color: SetuColors.primaryGreen,
//             ),
//           ),
//           Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),
//
//           // Power of Attorney Registration Number
//           CourtCommissionCaseUIUtils.buildTextFormField(
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
//           Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),
//
//           // Power of Attorney Registration Date
//           CourtCommissionCaseUIUtils.buildTextFormField(
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
//           Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),
//
//           // Name of the holder issuing the power of attorney
//           CourtCommissionCaseUIUtils.buildTextFormField(
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
//           Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),
//
//           // Name of the holder of the Power of Attorney
//           CourtCommissionCaseUIUtils.buildTextFormField(
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
//           Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),
//
//           // Address holding Power of Attorney
//           CourtCommissionCaseUIUtils.buildTextFormField(
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
//     await CourtCommissionCaseUIUtils.showTranslatableDialog(
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
