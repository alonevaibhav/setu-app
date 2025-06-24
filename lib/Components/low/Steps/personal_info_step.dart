import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:get/get.dart';
import 'package:setuapp/Components/LandServayView/Steps/survey_ui_utils.dart';
import '../../../Controller/land_survey_controller.dart';

class PersonalInfoStep extends StatelessWidget {
  final int currentSubStep;
  final SurveyController controller;

  const PersonalInfoStep({
    Key? key,
    required this.currentSubStep,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the substeps from controller configuration
    final subSteps = controller.stepConfigurations[0] ?? ['name'];

    // Ensure currentSubStep is within bounds
    if (currentSubStep >= subSteps.length) {
      return _buildNameInput(); // Fallback
    }

    final currentField = subSteps[currentSubStep];

    switch (currentField) {
      case 'name':
        return _buildNameInput();
      case 'phone':
        return _buildPhoneInput();
      case 'email':
        return _buildEmailInput();
      case 'gender':
        return _buildGenderInput();
      case 'category':
        return _buildCategoryInput();
      default:
        return _buildNameInput();
    }
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Personal Information',
        ),
        Gap(24.h),
        SurveyUIUtils.buildTextFormField(
          controller: controller.nameController,
          label: 'Full Name',
          hint: 'Enter your complete name',
          icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        Gap(32.h),
        SurveyUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Contact Information',
          'What is your mobile number?',
        ),
        Gap(24.h),
        SurveyUIUtils.buildTextFormField(
          controller: controller.phoneController,
          label: 'Mobile Number',
          hint: 'Enter 10-digit mobile number',
          icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.phone,
          maxLength: 10,
          validator: (value) {
            if (value == null ||
                value.length != 10 ||
                !RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Phone must be exactly 10 digits';
            }
            return null;
          },
        ),
        Gap(32.h),
        SurveyUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Contact Information',
          'What is your email address?',
        ),
        Gap(24.h),
        SurveyUIUtils.buildTextFormField(
          controller: controller.emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: PhosphorIcons.envelope(PhosphorIconsStyle.regular),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null ||
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        Gap(32.h),
        SurveyUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildGenderInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Personal Information',
          'What is your gender?',
        ),
        Gap(24.h),
        Obx(() => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.selectedGender.value.isEmpty ? null : controller.selectedGender.value,
            decoration: InputDecoration(
              labelText: 'Gender',
              hintText: 'Select your gender',
              prefixIcon: Icon(PhosphorIcons.genderIntersex(PhosphorIconsStyle.regular)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: ['Male', 'Female', 'Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: controller.updateGender,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your gender';
              }
              return null;
            },
          ),
        )),
        Gap(32.h),
        SurveyUIUtils.buildNavigationButtons(controller),
      ],
    );
  }

  Widget _buildCategoryInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyUIUtils.buildStepHeader(
          'Personal Information',
          'What is your category?',
        ),
        Gap(24.h),
        Obx(() => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
            decoration: InputDecoration(
              labelText: 'Category',
              hintText: 'Select your category',
              prefixIcon: Icon(PhosphorIcons.tag(PhosphorIconsStyle.regular)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: ['General', 'OBC', 'SC', 'ST', 'EWS'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: controller.updateCategory,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your category';
              }
              return null;
            },
          ),
        )),
        Gap(32.h),
        SurveyUIUtils.buildNavigationButtons(controller),
      ],
    );
  }
}