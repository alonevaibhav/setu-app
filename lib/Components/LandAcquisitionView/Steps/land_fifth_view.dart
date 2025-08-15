import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandAcquisitionView/Steps/ZLandAcquisitionUIUtils.dart';
import '../../../Constants/color_constant.dart';
import '../Controller/main_controller.dart';
import '../Controller/land_fifth_controller.dart';

class LandFifthView extends StatelessWidget {
  final int currentSubStep;
  final MainLandAcquisitionController mainController;

  const LandFifthView({
    Key? key,
    required this.currentSubStep,
    required this.mainController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subSteps = mainController.stepConfigurations[4] ?? ['holder_information'];

    if (currentSubStep >= subSteps.length) {
      return _buildHolderInformationInput();
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'holder_information':
        return _buildHolderInformationInput();
      default:
        return _buildHolderInformationInput();
    }
  }

  Widget _buildHolderInformationInput() {
    final holderController = Get.put(LandFifthController(), tag: 'land_fifth');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildStepHeader(
          'Holder Information',
          'Enter details for all holders of the land acquisition',
        ),
        Gap(24.h * LandAcquisitionUIUtils.sizeFactor),

        // Holder Entries Section
        _buildHolderEntries(holderController),

        Gap(32.h * LandAcquisitionUIUtils.sizeFactor),
        LandAcquisitionUIUtils.buildNavigationButtons(mainController),
      ],
    );
  }

  Widget _buildHolderEntries(LandFifthController holderController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LandAcquisitionUIUtils.buildTranslatableText(
          text: 'Holder Entries',
          style: TextStyle(
            fontSize: 18.sp * LandAcquisitionUIUtils.sizeFactor,
            fontWeight: FontWeight.w600,
            color: SetuColors.primaryGreen,
          ),
        ),

        Gap(20.h * LandAcquisitionUIUtils.sizeFactor),

        // Holder Entries List
        Obx(() => Column(
          children: [
            for (int i = 0; i < holderController.holderEntries.length; i++)
              _buildHolderEntryCard(holderController, i),
          ],
        )),

        Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

        // Add Another Entry Button
        InkWell(
          onTap: holderController.addHolderEntry,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w * LandAcquisitionUIUtils.sizeFactor,
              vertical: 16.h * LandAcquisitionUIUtils.sizeFactor,
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
                  size: 24.sp * LandAcquisitionUIUtils.sizeFactor,
                ),
                Gap(12.w * LandAcquisitionUIUtils.sizeFactor),
                LandAcquisitionUIUtils.buildTranslatableText(
                  text: 'Add Another Holder',
                  style: TextStyle(
                    fontSize: 16.sp * LandAcquisitionUIUtils.sizeFactor,
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

  Widget _buildHolderEntryCard(
      LandFifthController holderController, int index) {
    final entry = holderController.holderEntries[index];

    return Container(
      margin: EdgeInsets.only(bottom: 20.h * LandAcquisitionUIUtils.sizeFactor),
      padding: EdgeInsets.all(20.w * LandAcquisitionUIUtils.sizeFactor),
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
                  horizontal: 12.w * LandAcquisitionUIUtils.sizeFactor,
                  vertical: 8.h * LandAcquisitionUIUtils.sizeFactor,
                ),
                decoration: BoxDecoration(
                  color: SetuColors.primaryGreen,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Holder ${index + 1}',
                  style: TextStyle(
                    fontSize: 14.sp * LandAcquisitionUIUtils.sizeFactor,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (holderController.holderEntries.length > 1)
                InkWell(
                  onTap: () => holderController.removeHolderEntry(index),
                  child: Container(
                    padding:
                    EdgeInsets.all(8.w * LandAcquisitionUIUtils.sizeFactor),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      PhosphorIcons.trash(PhosphorIconsStyle.regular),
                      color: Colors.red,
                      size: 18.sp * LandAcquisitionUIUtils.sizeFactor,
                    ),
                  ),
                ),
            ],
          ),
          Gap(20.h * LandAcquisitionUIUtils.sizeFactor),

          // Holder's Name Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['holderNameController'],
            label: "Holder's Name *",
            hint: "Enter holder's full name",
            icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'holderName', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Address of the Holder Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['addressController'],
            label: 'Address of the Holder *',
            hint: 'Enter complete address',
            icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
            maxLines: 3,
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'address', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Account Number Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['accountNumberController'],
            label: 'Account Number *',
            hint: 'Enter account number',
            icon: PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'accountNumber', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Mobile Number Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['mobileNumberController'],
            label: 'Mobile Number *',
            hint: 'Enter 10-digit mobile number',
            icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'mobileNumber', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Server Number Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['serverNumberController'],
            label: 'Server Number *',
            hint: 'Enter server number',
            icon: PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'serverNumber', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Area Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['areaController'],
            label: 'Area *',
            hint: 'Enter area measurement',
            icon: PhosphorIcons.square(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'area', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Pot Kharaba Area Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['potKharabaAreaController'],
            label: 'Pot Kharaba Area *',
            hint: 'Enter pot kharaba area',
            icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'potKharabaArea', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Total Area Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['totalAreaController'],
            label: 'Total Area *',
            hint: 'Enter total area',
            icon: PhosphorIcons.resize(PhosphorIconsStyle.regular),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) =>
                holderController.updateHolderEntry(index, 'totalArea', value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Village Input
          LandAcquisitionUIUtils.buildTextFormField(
            controller: entry['villageController'],
            label: 'Village *',
            hint: 'Enter village name',
            icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
            onChanged: (value) =>
                holderController.updateSelectedVillage(index, value),
          ),

          Gap(16.h * LandAcquisitionUIUtils.sizeFactor),

          // Summary Row
          Container(
            padding: EdgeInsets.all(12.w * LandAcquisitionUIUtils.sizeFactor),
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
                  size: 16.sp * LandAcquisitionUIUtils.sizeFactor,
                ),
                Gap(8.w * LandAcquisitionUIUtils.sizeFactor),
                Expanded(
                  child: Text(
                    'Holder ${index + 1} - ${entry['holderName'] ?? 'Name not entered'}',
                    style: TextStyle(
                      fontSize: 12.sp * LandAcquisitionUIUtils.sizeFactor,
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