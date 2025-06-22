// lib/features/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:setuapp/Route%20Manager/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/color_constant.dart';

class LoginViewController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Site Lead Application controllers
  final siteLeadFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final villageController = TextEditingController();
  final tahsilController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();

  // Reactive variables
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final loginData = Rxn<Map<String, dynamic>>();
  final errorMessage = ''.obs;
  final isOffline = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    loadSavedCredentials();
  }

  void clearControllers() {
    usernameController.clear();
    passwordController.clear();
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
    villageController.clear();
    tahsilController.clear();
    districtController.clear();
    stateController.clear();
  }

  @override
  void onClose() {
    clearControllers(); // Optional, if you want to clear before dispose

    usernameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    villageController.dispose();
    tahsilController.dispose();
    districtController.dispose();
    stateController.dispose();

    super.onClose();
  }




  // Submit Site Lead application
  Future<void> submitSiteLeadApplication() async {
    if (!siteLeadFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Mock API call
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Application Submitted',
        'Your Site Lead application has been received. We will contact you soon.',
        backgroundColor: SetuColors.success,
        colorText: Colors.white,
      );

      // Reset form and hide it
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      locationController.clear();
      villageController.clear();
      tahsilController.clear();
      districtController.clear();
      stateController.clear();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application. Please try again.',
        backgroundColor: SetuColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Rest of your existing methods...
  // (keep all your existing login methods as they were)
  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Check network connectivity
  void checkConnectivity() async {
    // Mock connectivity check - replace with actual connectivity_plus implementation
    await Future.delayed(Duration(milliseconds: 500));
    isOffline.value = false; // Set to true to test offline mode
  }

  // Load saved credentials for rural users convenience
  void loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('saved_username');
      if (savedUsername != null && savedUsername.isNotEmpty) {
        usernameController.text = savedUsername;
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  // Save username for future logins
  void saveUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_username', usernameController.text);
    } catch (e) {
      print('Error saving username: $e');
    }
  }

  // Username validation
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter username';
    }
    if (value.trim().length < 3) {
      return 'Username should be at least 3 characters';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  // Login function with rural-friendly handling
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock API call for rural authentication
      await Future.delayed(Duration(seconds: 2));

      // Mock authentication logic
      final username = usernameController.text.trim();
      final password = passwordController.text;

      // Simple mock validation - replace with actual API
        // Success - Store user data
        final response = {
          'userId': 'SETU${DateTime.now().millisecondsSinceEpoch}',
          'username': username,
          'loginTime': DateTime.now().toIso8601String(),
          'userType': 'farmer',
          'village': 'Sample Village',
          'district': 'Sample District',
          'status': 'active',
        };

        Get.toNamed(AppRoutes.mainDashboard); // Navigate to dashboard

        loginData.value = response;

        // Success message
        Get.snackbar(
          'Welcome!',
          'Login successful. Welcome to Setu-App',
          backgroundColor: SetuColors.success,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
        );

        // Navigate to dashboard
        Get.offAllNamed('/dashboard');

    } catch (e) {
      // Error handling
      errorMessage.value = 'Login failed. Please try again';
      Get.snackbar(
        'Error',
        'Something went wrong. Please check your connection',
        backgroundColor: SetuColors.error,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password function
  Future<void> forgotPassword() async {
    if (usernameController.text.isEmpty) {
      Get.snackbar(
        'Username Required',
        'Please enter your username first',
        backgroundColor: SetuColors.warning,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Mock forgot password API call
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Password Reset',
        'Password reset instructions sent to your registered mobile number',
        backgroundColor: SetuColors.info,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset instructions. Please try again',
        backgroundColor: SetuColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}