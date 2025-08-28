// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:setuapp/Route%20Manager/app_routes.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../API Service/api_service.dart';
// import '../Constants/color_constant.dart';
//
// class LoginViewController extends GetxController {
//   // Form controllers
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   // Site Lead Application controllers
//   final siteLeadFormKey = GlobalKey<FormState>();
//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final locationController = TextEditingController();
//   final villageController = TextEditingController();
//   final tahsilController = TextEditingController();
//   final districtController = TextEditingController();
//   final stateController = TextEditingController();
//
//   // Reactive variables
//   final isLoading = false.obs;
//   final isPasswordVisible = false.obs;
//   final loginData = Rxn<Map<String, dynamic>>();
//   final errorMessage = ''.obs;
//   final isOffline = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkConnectivity();
//     loadSavedCredentials();
//   }
//
//   void clearControllers() {
//     usernameController.clear();
//     passwordController.clear();
//     fullNameController.clear();
//     emailController.clear();
//     phoneController.clear();
//     locationController.clear();
//     villageController.clear();
//     tahsilController.clear();
//     districtController.clear();
//     stateController.clear();
//   }
//
//   @override
//   void onClose() {
//     clearControllers(); // Optional, if you want to clear before dispose
//
//     usernameController.dispose();
//     passwordController.dispose();
//     fullNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     locationController.dispose();
//     villageController.dispose();
//     tahsilController.dispose();
//     districtController.dispose();
//     stateController.dispose();
//
//     super.onClose();
//   }
//
//   // Submit Site Lead application
//   Future<void> submitSiteLeadApplication() async {
//     if (!siteLeadFormKey.currentState!.validate()) {
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Mock API call
//       await Future.delayed(Duration(seconds: 2));
//
//       Get.snackbar(
//         'Application Submitted',
//         'Your Site Lead application has been received. We will contact you soon.',
//         backgroundColor: SetuColors.success,
//         colorText: Colors.white,
//       );
//
//       // Reset form and hide it
//       fullNameController.clear();
//       emailController.clear();
//       phoneController.clear();
//       locationController.clear();
//       villageController.clear();
//       tahsilController.clear();
//       districtController.clear();
//       stateController.clear();
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to submit application. Please try again.',
//         backgroundColor: SetuColors.error,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Toggle password visibility
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   // Check network connectivity
//   void checkConnectivity() async {
//     // Mock connectivity check - replace with actual connectivity_plus implementation
//     await Future.delayed(Duration(milliseconds: 500));
//     isOffline.value = false; // Set to true to test offline mode
//   }
//
//   // Load saved credentials for rural users convenience
//   void loadSavedCredentials() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedUsername = prefs.getString('saved_username');
//       if (savedUsername != null && savedUsername.isNotEmpty) {
//         usernameController.text = savedUsername;
//       }
//     } catch (e) {
//       print('Error loading saved credentials: $e');
//     }
//   }
//
//   // Save username for future logins
//   void saveUsername() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('saved_username', usernameController.text);
//     } catch (e) {
//       print('Error saving username: $e');
//     }
//   }
//
//   // Login function - No validation required
//   // Future<void> login() async {
//   //   try {
//   //     isLoading.value = true;
//   //     errorMessage.value = '';
//   //
//   //     // Mock API call for rural authentication
//   //     await Future.delayed(Duration(seconds: 2));
//   //
//   //     // Get username and password (no validation)
//   //     final username = usernameController.text.trim();
//   //     final password = passwordController.text;
//   //
//   //     // Always succeed - Store user data
//   //     final response = {
//   //       'userId': 'SETU${DateTime.now().millisecondsSinceEpoch}',
//   //       'username': username.isEmpty ? 'Guest' : username,
//   //       'loginTime': DateTime.now().toIso8601String(),
//   //       'userType': 'farmer',
//   //       'village': 'Sample Village',
//   //       'district': 'Sample District',
//   //       'status': 'active',
//   //     };
//   //
//   //     loginData.value = response;
//   //
//   //     // Success message
//   //     Get.snackbar(
//   //       'Welcome!',
//   //       'Login successful. Welcome to Setu-App',
//   //       backgroundColor: SetuColors.success,
//   //       colorText: Colors.white,
//   //       duration: Duration(seconds: 3),
//   //       snackPosition: SnackPosition.TOP,
//   //       margin: EdgeInsets.all(16),
//   //     );
//   //
//   //     // Navigate to dashboard
//   //     Get.toNamed(AppRoutes.mainDashboard); // Navigate to dashboard
//   //   } catch (e) {
//   //     // Error handling
//   //     errorMessage.value = 'Login failed. Please try again';
//   //     Get.snackbar(
//   //       'Error',
//   //       'Something went wrong. Please check your connection',
//   //       backgroundColor: SetuColors.error,
//   //       colorText: Colors.white,
//   //       duration: Duration(seconds: 3),
//   //       snackPosition: SnackPosition.TOP,
//   //       margin: EdgeInsets.all(16),
//   //     );
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//
//   Future<void> login() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Get username and password
//       final username = usernameController.text.trim();
//       final password = passwordController.text;
//
//       // Validate input (optional - you can remove if not needed)
//       if (username.isEmpty || password.isEmpty) {
//         errorMessage.value = 'Please enter both username and password';
//         Get.snackbar(
//           'Error',
//           'Please enter both username and password',
//           backgroundColor: SetuColors.error,
//           colorText: Colors.white,
//           duration: Duration(seconds: 3),
//           snackPosition: SnackPosition.TOP,
//           margin: EdgeInsets.all(16),
//         );
//         return;
//       }
//
//       // Make API call using ApiService
//       ApiResponse<Map<String, dynamic>> response = await ApiService.post<Map<String, dynamic>>(
//         endpoint: 'api/user/login',
//         body: {
//           'username': username,
//           'password': password,
//         },
//         fromJson: (json) => json,
//         includeToken: false, // No token needed for login
//       );
//
//       if (response.success && response.data != null) {
//         final responseData = response.data!;
//
//         // Check if login was successful
//         if (responseData['success'] == true && responseData['data'] != null) {
//           final data = responseData['data'];
//           final token = data['token'] as String?;
//           final user = data['user'] as Map<String, dynamic>?;
//
//           if (token != null && user != null) {
//             // Save token and user ID
//             await ApiService.setToken(token);
//             await ApiService.setUid(user['id'].toString());
//
//             // Store additional user data if needed
//             loginData.value = {
//               'userId': user['id'].toString(),
//               'username': user['username'],
//               'email': user['email'],
//               'role': user['role'],
//               'status': user['status'],
//               'isEmailVerified': user['is_email_verified'],
//               'loginTime': DateTime.now().toIso8601String(),
//             };
//
//             // Success message
//             Get.snackbar(
//               'Welcome!',
//               responseData['message'] ?? 'Login successful. Welcome to Setu-App',
//               backgroundColor: SetuColors.success,
//               colorText: Colors.white,
//               duration: Duration(seconds: 3),
//               snackPosition: SnackPosition.TOP,
//               margin: EdgeInsets.all(16),
//             );
//
//             // Navigate to dashboard
//             Get.toNamed(AppRoutes.mainDashboard);
//           } else {
//             throw Exception('Invalid response format: Missing token or user data');
//           }
//         } else {
//           // Handle unsuccessful login
//           final message = responseData['message'] ?? 'Login failed';
//           final errors = responseData['errors'] as List?;
//           String errorMsg = message;
//
//           if (errors != null && errors.isNotEmpty) {
//             errorMsg += ': ${errors.join(', ')}';
//           }
//
//           throw Exception(errorMsg);
//         }
//       } else {
//         // Handle API error response
//         throw Exception(response.errorMessage ?? 'Login failed. Please try again.');
//       }
//
//     } catch (e) {
//       // Error handling
//       errorMessage.value = e.toString().replaceFirst('Exception: ', '');
//
//       Get.snackbar(
//         'Login Failed',
//         errorMessage.value,
//         backgroundColor: SetuColors.error,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//         snackPosition: SnackPosition.TOP,
//         margin: EdgeInsets.all(16),
//       );
//
//
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   // Forgot password function
//   Future<void> forgotPassword() async {
//     if (usernameController.text.isEmpty) {
//       Get.snackbar(
//         'Username Required',
//         'Please enter your username first',
//         backgroundColor: SetuColors.warning,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // Mock forgot password API call
//       await Future.delayed(Duration(seconds: 2));
//
//       Get.snackbar(
//         'Password Reset',
//         'Password reset instructions sent to your registered mobile number',
//         backgroundColor: SetuColors.info,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to send reset instructions. Please try again',
//         backgroundColor: SetuColors.error,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Optional: Add logout method
//   Future<void> logout() async {
//     try {
//       // Clear stored auth data
//       await ApiService.clearAuthData();
//
//       // Clear local data
//       loginData.value = {};
//       usernameController.clear();
//       passwordController.clear();
//       errorMessage.value = '';
//
//       // Navigate to login page
//       Get.offAllNamed(AppRoutes.login); // or whatever your login route is
//
//       Get.snackbar(
//         'Logged Out',
//         'You have been successfully logged out',
//         backgroundColor: SetuColors.primaryDark,
//         colorText: Colors.white,
//         duration: Duration(seconds: 2),
//         snackPosition: SnackPosition.TOP,
//         margin: EdgeInsets.all(16),
//       );
//     } catch (e) {
//
//     }
//   }
//
//   // Clear error message
//   void clearError() {
//     errorMessage.value = '';
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:setuapp/Auth/token_manager.dart';
import 'package:setuapp/Route%20Manager/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API Service/api_service.dart';
import '../Constants/color_constant.dart';
import '../Models/login_model.dart'; // Add your model imports

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
  final loginData = Rxn<LoginData>();
  final userProfile = Rxn<UserProfile>();
  final currentUser = Rxn<UserModel>();
  final errorMessage = ''.obs;
  final isOffline = false.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    loadSavedCredentials();
    checkExistingSession();
    // Start token expiration monitoring
    TokenManager.startTokenExpirationTimer();
  }

  @override
  void onClose() {
    clearControllers();
    TokenManager.stopTokenExpirationTimer();

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

  // Check for existing session on app startup
  Future<void> checkExistingSession() async {
    try {
      if (await TokenManager.hasToken() && !await TokenManager.isTokenExpired()) {
        // Valid session exists
        await loadUserSession();
        isLoggedIn.value = true;

        // Navigate to dashboard
        Get.offAllNamed(AppRoutes.mainDashboard);

        Get.snackbar(
          'Welcome Back!',
          'Session restored successfully',
          backgroundColor: SetuColors.success,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
        );
      } else {
        // No valid session, stay on login page
        isLoggedIn.value = false;
        await TokenManager.clearToken();
        await UserSession.clearSession();
      }
    } catch (e) {
      print('Error checking existing session: $e');
      isLoggedIn.value = false;
    }
  }

  // Load user session data
  Future<void> loadUserSession() async {
    try {
      final token = await TokenManager.getToken();
      final role = await UserSession.getRole();
      final email = await UserSession.getEmail();
      final userName = await UserSession.getUserName();
      final username = await UserSession.getUsername();
      final userId = await UserSession.getUserId();

      if (token != null && role != null) {
        // Create user model from session data
        currentUser.value = UserModel(
          id: userId?.toString() ?? '',
          email: email ?? '',
          name: userName ?? '',
          role: UserRole.fromString(role),
          token: token,
        );

        // Update API service with token
        await ApiService.setToken(token);
        if (userId != null) {
          await ApiService.setUid(userId.toString());
        }
      }
    } catch (e) {
      print('Error loading user session: $e');
    }
  }

  // Enhanced login function with session management
  Future<void> login() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final username = usernameController.text.trim();
      final password = passwordController.text;

      // Basic validation
      if (username.isEmpty || password.isEmpty) {
        errorMessage.value = 'Please enter both username and password';
        _showErrorSnackbar('Please enter both username and password');
        return;
      }

      // Make API call
      ApiResponse<Map<String, dynamic>> response = await ApiService.post<Map<String, dynamic>>(
        endpoint: 'api/user/login',
        body: {
          'username': username,
          'password': password,
        },
        fromJson: (json) => json,
        includeToken: false,
      );

      if (response.success && response.data != null) {
        final responseData = response.data!;

        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          // Parse the login response
          final loginApiResponse = LoginApiResponse.fromJson(responseData);

          if (loginApiResponse.success && loginApiResponse.data != null) {
            final loginData = loginApiResponse.data!;

            // Save session data
            await _saveUserSession(loginData);

            // Update reactive variables
            this.loginData.value = loginData;
            userProfile.value = loginData.profile;
            currentUser.value = UserModel(
              id: loginData.userId.toString(),
              email: loginData.profile.username,
              name: loginData.userName,
              role: UserRole.fromString(loginData.role),
              token: loginData.token,
              profile: loginData.profile,
            );

            isLoggedIn.value = true;

            // Save username for future convenience
            // await saveUsername();

            // Success message
            Get.snackbar(
              'Welcome ${loginData.userName}!',
              responseData['message'] ?? 'Login successful. Welcome to Setu-App',
              backgroundColor: SetuColors.success,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              snackPosition: SnackPosition.TOP,
              margin: EdgeInsets.all(16),
            );

            // Navigate to dashboard
            Get.offAllNamed(AppRoutes.mainDashboard);

            // Start monitoring token expiration
            TokenManager.startTokenExpirationTimer();
          } else {
            throw Exception('Invalid login response format');
          }
        } else {
          final message = responseData['message'] ?? 'Login failed';
          final errors = responseData['errors'] as List?;
          String errorMsg = message;

          if (errors != null && errors.isNotEmpty) {
            errorMsg += ': ${errors.join(', ')}';
          }
          throw Exception(errorMsg);
        }
      } else {
        throw Exception(response.errorMessage ?? 'Login failed. Please try again.');
      }

    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      _showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Save user session data
  Future<void> _saveUserSession(LoginData loginData) async {
    try {
      // Save token with TokenManager
      await TokenManager.saveToken(
        loginData.token,
        expirationTime: loginData.expirationTime,
      );

      // Save user session data
      await UserSession.saveSession(
        token: loginData.token,
        role: loginData.role,
        email: loginData.profile.username,
        profile: loginData.profile,
      );

      // Update API service
      await ApiService.setToken(loginData.token);
      await ApiService.setUid(loginData.userId.toString());

    } catch (e) {
      print('Error saving user session: $e');
      throw Exception('Failed to save session data');
    }
  }

  // Enhanced logout function
  Future<void> logout({bool sessionExpired = false}) async {
    try {
      isLoading.value = true;

      // Clear all session data
      await TokenManager.clearToken();
      await UserSession.clearSession();
      await ApiService.clearAuthData();

      // Reset reactive variables
      loginData.value = null;
      userProfile.value = null;
      currentUser.value = null;
      isLoggedIn.value = false;
      errorMessage.value = '';

      // Clear form data
      usernameController.clear();
      passwordController.clear();

      // Stop token monitoring
      TokenManager.stopTokenExpirationTimer();

      // Show appropriate message
      final message = sessionExpired
          ? 'Session expired. Please login again.'
          : 'You have been successfully logged out';

      final bgColor = sessionExpired ? SetuColors.warning : SetuColors.primaryDark;

      Get.snackbar(
        sessionExpired ? 'Session Expired' : 'Logged Out',
        message,
        backgroundColor: bgColor,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(16),
      );

      // Navigate to login page
      Get.offAllNamed(AppRoutes.login);

    } catch (e) {
      print('Error during logout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh token expiration
  Future<void> refreshSession() async {
    try {
      if (await TokenManager.hasToken()) {
        await TokenManager.refreshTokenExpiration();

        Get.snackbar(
          'Session Refreshed',
          'Your session has been extended',
          backgroundColor: SetuColors.success,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error refreshing session: $e');
    }
  }

  // Check if user is currently logged in
  bool get isUserLoggedIn => isLoggedIn.value && currentUser.value != null;

  // Get current user role
  UserRole? get userRole => currentUser.value?.role;

  // Get current user name
  String get currentUserName => currentUser.value?.name ?? '';

  // Helper method to show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Login Failed',
      message,
      backgroundColor: SetuColors.error,
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(16),
    );
  }

  // Submit Site Lead application (unchanged)
  Future<void> submitSiteLeadApplication() async {
    if (!siteLeadFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Application Submitted',
        'Your Site Lead application has been received. We will contact you soon.',
        backgroundColor: SetuColors.success,
        colorText: Colors.white,
      );

      // Reset form
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

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Check network connectivity
  void checkConnectivity() async {
    await Future.delayed(Duration(milliseconds: 500));
    isOffline.value = false;
  }

  // Load saved credentials
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
