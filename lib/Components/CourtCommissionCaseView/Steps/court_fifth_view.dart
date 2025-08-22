import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/main_controller.dart';
import '../Controller/court_fifth_controller.dart';
import 'ZLandAcquisitionUIUtils.dart';

class CourtFifthView extends StatelessWidget {
  final int currentSubStep;
  final CourtCommissionCaseController mainController;

  const CourtFifthView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps =
        mainController.stepConfigurations[4] ?? ['plaintiff_defendant'];

    if (currentSubStep >= subSteps.length) {
      return _buildPlaintiffDefendantInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'plaintiff_defendant':
        return _buildPlaintiffDefendantInput();
      default:
        return _buildPlaintiffDefendantInput();
    }
  }

  Widget _buildPlaintiffDefendantInput() {
    final courtFifthController = Get.put(CourtFifthController(), tag: 'court_fifth');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtCommissionCaseUIUtils.buildStepHeader(
          'Plaintiff and Defendant Information',
          'Enter name and address details for plaintiffs and defendants',
        ),
        Gap(24.h * CourtCommissionCaseUIUtils.sizeFactor),

        // Plaintiff/Defendant Entries Section
        _buildPlaintiffDefendantEntries(courtFifthController),

        Gap(32.h * CourtCommissionCaseUIUtils.sizeFactor),
        CourtCommissionCaseUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildPlaintiffDefendantEntries(
      CourtFifthController courtFifthController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CourtCommissionCaseUIUtils.buildTranslatableText(
          text: 'Plaintiff and Defendant Details',
          style: TextStyle(
            fontSize: 18.sp * CourtCommissionCaseUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * CourtCommissionCaseUIUtils.sizeFactor),

        // Plaintiff/Defendant Entries List
        Obx(() => Column(
              children: [
                for (int i = 0;
                    i < courtFifthController.plaintiffDefendantEntries.length;
                    i++)
                  _buildPlaintiffDefendantEntryCard(courtFifthController, i),
              ],
            )),

        Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: courtFifthController.addPlaintiffDefendantEntry,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w * CourtCommissionCaseUIUtils.sizeFactor,
              vertical: 16.h * CourtCommissionCaseUIUtils.sizeFactor,
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
                  size: 24.sp * CourtCommissionCaseUIUtils.sizeFactor,
                ),
                Gap(12.w * CourtCommissionCaseUIUtils.sizeFactor),
                CourtCommissionCaseUIUtils.buildTranslatableText(
                  text: 'Add Another Entry',
                  style: TextStyle(
                    fontSize: 16.sp * CourtCommissionCaseUIUtils.sizeFactor,
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

  Widget _buildPlaintiffDefendantEntryCard(
      CourtFifthController courtFifthController, int index) {
    final entry = courtFifthController.plaintiffDefendantEntries[index];

    return Container(
      margin:
          EdgeInsets.only(bottom: 20.h * CourtCommissionCaseUIUtils.sizeFactor),
      padding: EdgeInsets.all(20.w * CourtCommissionCaseUIUtils.sizeFactor),
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
                  horizontal: 12.w * CourtCommissionCaseUIUtils.sizeFactor,
                  vertical: 8.h * CourtCommissionCaseUIUtils.sizeFactor,
                ),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Entry ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * CourtCommissionCaseUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (courtFifthController.plaintiffDefendantEntries.length > 1)
                InkWell(
                  onTap: () =>
                      courtFifthController.removePlaintiffDefendantEntry(index),
                  child: Container(
                    padding: EdgeInsets.all(
                        8.w * CourtCommissionCaseUIUtils.sizeFactor),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.regular),
                      color: Colors.red,
                      size: 18.sp * CourtCommissionCaseUIUtils.sizeFactor,
                    ),
                  ),
                ),
            ],
          ),
          Gap(20.h * CourtCommissionCaseUIUtils.sizeFactor),

          // Type Dropdown (Plaintiff/Defendant)
          Obx(() => CourtCommissionCaseUIUtils.buildDropdownField(
                label: 'Select Type *',
                value: entry['selectedType'].value.isEmpty
                    ? ''
                    : entry['selectedType'].value,
                items: courtFifthController.typeOptions,
                onChanged: (value) {
                  courtFifthController.updateSelectedType(index, value ?? '');
                },
                icon: PhosphorIcons.userCheck(PhosphorIconsStyle.regular),
              )),

          Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),

          // Name Input
          CourtCommissionCaseUIUtils.buildTextFormField(
            controller: entry['nameController'],
            label: 'Full Name *',
            hint: 'Enter full name',
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            onChanged: (value) => courtFifthController
                .updatePlaintiffDefendantEntry(index, 'name', value),
          ),

          Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),

          // Enhanced Address Input with Popup
          _buildAddressFieldWithPopup(courtFifthController, entry, index),

          Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),

          // Mobile Number Input
          CourtCommissionCaseUIUtils.buildTextFormField(
            controller: entry['mobileController'],
            label: 'Mobile Number *',
            hint: 'Enter 10-digit mobile number',
            icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.phone,
            onChanged: (value) => courtFifthController
                .updatePlaintiffDefendantEntry(index, 'mobile', value),
          ),

          Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),

          // Survey Number/Group Number Input
          CourtCommissionCaseUIUtils.buildTextFormField(
            controller: entry['surveyNumberController'],
            label: 'Survey Number/Group Number *',
            hint: 'Enter survey or group number',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) => courtFifthController
                .updatePlaintiffDefendantEntry(index, 'surveyNumber', value),
          ),

          Gap(16.h * CourtCommissionCaseUIUtils.sizeFactor),

          // Summary Row
          Container(
            padding:
                EdgeInsets.all(12.w * CourtCommissionCaseUIUtils.sizeFactor),
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
                  size: 16.sp * CourtCommissionCaseUIUtils.sizeFactor,
                ),
                Gap(8.w * CourtCommissionCaseUIUtils.sizeFactor),
                Expanded(
                  child: Obx(() => Text(
                        'Entry ${index + 1} - ${entry['selectedType'].value.isEmpty ? 'Type not selected' : entry['selectedType'].value}: ${entry['nameController']?.text?.isEmpty ?? true ? 'Name not entered' : entry['nameController']?.text}',
                        style: TextStyle(
                          fontSize:
                              12.sp * CourtCommissionCaseUIUtils.sizeFactor,
                          color: SetuColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressFieldWithPopup(CourtFifthController courtFifthController,
      Map<String, dynamic> entry, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => courtFifthController.openAddressPopup(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w * CourtCommissionCaseUIUtils.sizeFactor,
                    vertical: 12.h * CourtCommissionCaseUIUtils.sizeFactor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: SetuColors.primaryGreen.withOpacity(0.5),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    color: SetuColors.primaryGreen.withOpacity(0.03),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
                        color: SetuColors.primaryGreen,
                        size: 18.sp * CourtCommissionCaseUIUtils.sizeFactor,
                      ),
                      Gap(8.w * CourtCommissionCaseUIUtils.sizeFactor),
                      Text(
                        'Detailed Address',
                        style: TextStyle(
                          fontSize:
                              14.sp * CourtCommissionCaseUIUtils.sizeFactor,
                          color: SetuColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(12.w * CourtCommissionCaseUIUtils.sizeFactor),
            // Status indicator
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w * CourtCommissionCaseUIUtils.sizeFactor,
                    vertical: 6.h * CourtCommissionCaseUIUtils.sizeFactor,
                  ),
                  decoration: BoxDecoration(
                    color: courtFifthController.hasDetailedAddress(index)
                        ? SetuColors.primaryGreen.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    courtFifthController.hasDetailedAddress(index)
                        ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill)
                        : PhosphorIcons.circle(PhosphorIconsStyle.regular),
                    color: courtFifthController.hasDetailedAddress(index)
                        ? SetuColors.primaryGreen
                        : Colors.grey,
                    size: 16.sp * CourtCommissionCaseUIUtils.sizeFactor,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
