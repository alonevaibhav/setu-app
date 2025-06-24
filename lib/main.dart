import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'API Service/api_service.dart';
import 'Controller/get_translation_controller/get_translation_controller.dart';
import 'Route Manager/app_bindings.dart';
import 'Route Manager/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiService.init();
  Get.lazyPut(() => TranslationController());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set a default initial route
  const String initialRoute = AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute));
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
