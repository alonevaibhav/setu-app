import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../Constants/color_constant.dart';
import '../Controller/login_controller.dart';
import '../Controller/login_view_controller.dart';
import '../Route Manager/app_routes.dart';

class NewLoginView extends StatelessWidget {
  const NewLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginViewController>();
    return Scaffold(
      backgroundColor: SetuColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w * 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(10.h * 0.8),
                  _buildHeader()
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: -0.3, end: 0),
                  Gap(30.h * 0.8),
                  _buildLoginForm(controller)
                      .animate()
                      .fadeIn(duration: 1000.ms, delay: 300.ms)
                      .slideY(begin: 0.3, end: 0)
                      .scale(begin: const Offset(0.9, 0.9)),
                  Gap(10.h * 0.8),
                  _buildForgotPassword(controller)
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 600.ms),
                  Gap(20.h * 0.8),
                  _buildSiteLeadButton()
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 800.ms),
                  Gap(20.h * 0.8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100.w * 0.8,
          height: 100.w * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30 * 0.8),
            gradient: LinearGradient(
              colors: [
                SetuColors.lightGreen.withOpacity(0.2),
                SetuColors.accent.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: SetuColors.lightGreen.withOpacity(0.5),
              width: 2 * 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: SetuColors.lightGreen.withOpacity(0.15),
                blurRadius: 20 * 0.8,
                offset: const Offset(0, 10 * 0.8),
              ),
            ],
          ),
          child: Icon(
            PhosphorIcons.leaf(PhosphorIconsStyle.regular),
            size: 50.sp * 0.8,
            color: SetuColors.primaryGreen,
          ),
        ),
        Gap(20.h * 0.8),
        Text(
          'Setu-App',
          style: GoogleFonts.poppins(
            fontSize: 25.sp * 0.8,
            fontWeight: FontWeight.bold,
            color: SetuColors.primaryDark,
          ),
        ),
        Gap(8.h * 0.8),
        Text(
          'Rural Registration & Services',
          style: GoogleFonts.inter(
            fontSize: 16.sp * 0.8,
            color: SetuColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginViewController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24 * 0.8),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: SetuColors.lightGreen.withOpacity(0.3),
          width: 2 * 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: SetuColors.lightGreen.withOpacity(0.15),
            blurRadius: 20 * 0.8,
            offset: const Offset(0, 10 * 0.8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15 * 0.8,
            offset: const Offset(0, 5 * 0.8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w * 0.8),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp * 0.8,
                  fontWeight: FontWeight.bold,
                  color: SetuColors.primaryDark,
                ),
              ),
              Gap(8.h * 0.8),
              Text(
                'Sign in to access your rural services',
                style: GoogleFonts.inter(
                  fontSize: 16.sp * 0.8,
                  color: SetuColors.textSecondary,
                ),
              ),
              Gap(20.h * 0.8),
              _buildUsernameField(controller)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 100.ms)
                  .slideX(begin: -0.2, end: 0),
              Gap(16.h * 0.8),
              _buildPasswordField(controller)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideX(begin: -0.2, end: 0),
              Gap(24.h * 0.8),
              _buildLoginButton(controller)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(LoginViewController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: GoogleFonts.inter(
            fontSize: 16.sp * 0.8,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h * 0.8),
        TextFormField(
          controller: controller.usernameController,
          style: GoogleFonts.inter(
            fontSize: 18.sp * 0.8,
            color: SetuColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16 * 0.8),
              borderSide:
                  BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16 * 0.8),
              borderSide:
                  BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16 * 0.8),
              borderSide:
                  BorderSide(color: SetuColors.primaryGreen, width: 2 * 0.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16 * 0.8),
              borderSide: BorderSide(color: SetuColors.error),
            ),
            contentPadding: EdgeInsets.all(20.w * 0.8),
            hintText: 'Enter your username',
            hintStyle: GoogleFonts.inter(
              color: SetuColors.textSecondary,
              fontSize: 16.sp * 0.8,
            ),
            prefixIcon: Icon(
              PhosphorIcons.user(PhosphorIconsStyle.regular),
              color: SetuColors.primaryGreen,
              size: 24.sp * 0.8,
            ),
          ),
          validator: controller.validateUsername,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginViewController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.inter(
            fontSize: 16.sp * 0.8,
            fontWeight: FontWeight.w600,
            color: SetuColors.textPrimary,
          ),
        ),
        Gap(8.h * 0.8),
        Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              style: GoogleFonts.inter(
                fontSize: 18.sp * 0.8,
                color: SetuColors.textPrimary,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16 * 0.8),
                  borderSide:
                      BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16 * 0.8),
                  borderSide:
                      BorderSide(color: SetuColors.lightGreen.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16 * 0.8),
                  borderSide: BorderSide(
                      color: SetuColors.primaryGreen, width: 2 * 0.8),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16 * 0.8),
                  borderSide: BorderSide(color: SetuColors.error),
                ),
                contentPadding: EdgeInsets.all(20.w * 0.8),
                hintText: 'Enter your password',
                hintStyle: GoogleFonts.inter(
                  color: SetuColors.textSecondary,
                  fontSize: 16.sp * 0.8,
                ),
                prefixIcon: Icon(
                  PhosphorIcons.lock(PhosphorIconsStyle.regular),
                  color: SetuColors.primaryGreen,
                  size: 24.sp * 0.8,
                ),
                suffixIcon: GestureDetector(
                  onTap: controller.togglePasswordVisibility,
                  child: Icon(
                    controller.isPasswordVisible.value
                        ? PhosphorIcons.eyeSlash(PhosphorIconsStyle.regular)
                        : PhosphorIcons.eye(PhosphorIconsStyle.regular),
                    color: SetuColors.textSecondary,
                    size: 24.sp * 0.8,
                  ),
                ),
              ),
              validator: controller.validatePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => controller.login(),
            )),
      ],
    );
  }

  Widget _buildLoginButton(LoginViewController controller) {
    return SizedBox(
      width: double.infinity,
      height: 56.h * 0.8,
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.login,
            // onPressed: controller.isLoading.value ? null : controller.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: SetuColors.primaryGreen,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * 0.8),
              ),
              elevation: 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16 * 0.8),
                boxShadow: [
                  BoxShadow(
                    color: SetuColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 12 * 0.8,
                    offset: const Offset(0, 6 * 0.8),
                  ),
                ],
              ),
              child: Center(
                child: controller.isLoading.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.w * 0.8,
                            height: 20.w * 0.8,
                            child: CircularProgressIndicator(
                              strokeWidth: 2 * 0.8,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          Gap(12.w * 0.8),
                          Text(
                            'Signing In...',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp * 0.8,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PhosphorIcons.signIn(PhosphorIconsStyle.bold),
                            color: Colors.white,
                            size: 24.sp * 0.8,
                          ),
                          Gap(12.w * 0.8),
                          Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp * 0.8,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )),
    );
  }

  Widget _buildForgotPassword(LoginViewController controller) {
    return Center(
      child: TextButton(
        onPressed: () {
          // Implement forgot password functionality
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 16.sp * 0.8,
            color: SetuColors.primaryGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSiteLeadButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Get.toNamed(AppRoutes.jsidelead , arguments: {'isSiteLead': true}
          ); // Also requires slash
        },

        style: OutlinedButton.styleFrom(
          foregroundColor: SetuColors.primaryGreen,
          side: BorderSide(
            color: SetuColors.primaryGreen,
            width: 2 * 0.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * 0.8),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h * 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.users(PhosphorIconsStyle.regular),
              size: 24.sp * 0.8,
            ),
            Gap(12.w * 0.8),
            Text(
              'Join as Site Lead',
              style: GoogleFonts.inter(
                fontSize: 18.sp * 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
