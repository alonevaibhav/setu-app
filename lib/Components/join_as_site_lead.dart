import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../Constants/color_constant.dart';
import '../Controller/login_view_controller.dart';

class SiteLeadApplication extends StatelessWidget {
  const SiteLeadApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewController controller = Get.find<LoginViewController>();
    final arguments = Get.arguments as Map<String, dynamic>?;



    return Scaffold(
      backgroundColor: SetuColors.background,
      appBar: AppBar(
        title: const Text('Site Lead Application'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w * 0.85),
          child: Column(
            children: [
              _buildSiteLeadForm(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSiteLeadForm(LoginViewController controller) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.h * 0.85),
      padding: EdgeInsets.all(20.w * 0.85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * 0.85),
        border: Border.all(
          color: SetuColors.lightGreen.withOpacity(0.3),
          width: 1 * 0.85,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10 * 0.85,
            offset: Offset(0, 5 * 0.85),
          ),
        ],
      ),
      child: Form(
        key: controller.siteLeadFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Site Lead Application',
              style: GoogleFonts.poppins(
                fontSize: 20.sp * 0.85,
                fontWeight: FontWeight.bold,
                color: SetuColors.primaryDark,
              ),
            ),
            Gap(16.h * 0.85),
            _buildFormField(
              controller: controller.fullNameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: PhosphorIcons.user(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.emailController,
              label: 'Email',
              hint: 'Enter your email address',
              icon: PhosphorIcons.envelope(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              icon: PhosphorIcons.phone(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10) {
                  return 'Phone number must be at least 10 digits';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.locationController,
              label: 'Your Location',
              hint: 'Enter your location',
              icon: PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.villageController,
              label: 'Village',
              hint: 'Enter your village name',
              icon: PhosphorIcons.house(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your village';
                }
                return null;
              },
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.tahsilController,
              label: 'Tahsil',
              hint: 'Enter your tahsil',
              icon: PhosphorIcons.mapTrifold(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your tahsil';
                }
                return null;
              },
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.districtController,
              label: 'District',
              hint: 'Enter your district',
              icon: PhosphorIcons.buildings(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your district';
                }
                return null;
              },
            ),
            Gap(12.h * 0.85),
            _buildFormField(
              controller: controller.stateController,
              label: 'State',
              hint: 'Enter your state',
              icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your state';
                }
                return null;
              },
            ),
            Gap(24.h * 0.85),
            SizedBox(
              width: double.infinity,
              height: 56.h * 0.85,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitSiteLeadApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SetuColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16 * 0.85),
                  ),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                  strokeWidth: 2 * 0.85,
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  'Submit Application',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp * 0.85,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16.sp * 0.85,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h * 0.85),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 16.sp * 0.85,
            color: SetuColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * 0.85),
              borderSide:
              BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * 0.85),
              borderSide:
              BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * 0.85),
              borderSide:
              BorderSide(color: SetuColors.primaryGreen, width: 1.5 * 0.85),
            ),
            contentPadding: EdgeInsets.all(16.w * 0.85),
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: SetuColors.textSecondary,
              fontSize: 14.sp * 0.85,
            ),
            prefixIcon: Icon(
              icon,
              color: SetuColors.primaryGreen,
              size: 20.sp * 0.85,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
