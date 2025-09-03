// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'API Service/api_service.dart';
// import 'Controller/get_translation_controller/get_translation_controller.dart';
// import 'Route Manager/app_bindings.dart';
// import 'Route Manager/app_routes.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await ApiService.init();
//   Get.lazyPut(() => TranslationController());
//
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ),
//   );
//
//   // Set a default initial route
//   const String initialRoute = AppRoutes.login;
//
//   runApp(MyApp(initialRoute: initialRoute));
// }
//
// class MyApp extends StatelessWidget {
//   final String initialRoute;
//
//   const MyApp({super.key, required this.initialRoute});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           theme: ThemeData(
//             scaffoldBackgroundColor: Colors.white,
//             appBarTheme: const AppBarTheme(
//               backgroundColor: Colors.white,
//               elevation: 0,
//               iconTheme: IconThemeData(color: Colors.black),
//             ),
//             textTheme: GoogleFonts.interTextTheme(
//               Theme.of(context).textTheme,
//             ),
//           ),
//           debugShowCheckedModeBanner: false,
//           title: 'Setu-App',
//           initialRoute: initialRoute,
//           getPages: AppRoutes.routes,
//           initialBinding: AppBindings(),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'API Service/api_service.dart';
import 'Auth/login_view_controller.dart';
import 'Auth/token_manager.dart';
import 'Components/LandSurveyView/Controller/step_three_controller.dart';
import 'Controller/get_translation_controller/get_translation_controller.dart';
import 'Route Manager/app_bindings.dart';
import 'Route Manager/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Service
  await ApiService.init();

  // Initialize controllers
  // Get.lazyPut(() => TranslationController());
  Get.put(TranslationController());
  Get.put(LoginViewController()); // Initialize LoginViewController
  Get.put(CalculationController());

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Determine initial route based on session
  String initialRoute = await _determineInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

// Function to determine initial route based on session status
Future<String> _determineInitialRoute() async {
  try {
    // Check if user has a valid token and session
    if (await TokenManager.hasToken() && !await TokenManager.isTokenExpired()) {
      print('Valid session found, navigating to dashboard');
      return AppRoutes.mainDashboard;
    } else {
      print('No valid session, navigating to login');
      // Clear any invalid session data
      await TokenManager.clearToken();
      return AppRoutes.login;
    }
  } catch (e) {
    print('Error determining initial route: $e');
    // Default to login on error
    return AppRoutes.login;
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Setu-App',
          initialRoute: initialRoute,
          getPages: AppRoutes.routes,
          initialBinding: AppBindings(),
        );
      },
    );
  }
}
