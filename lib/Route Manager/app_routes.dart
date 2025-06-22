import 'package:get/get.dart';
import '../Auth/login_page.dart';
import '../Auth/login_view.dart';
import '../Components/join_as_site_lead.dart';
import '../View/bottum_nevigation_bar.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login = '/login';

  static const jsidelead = '/jSidelead';
  static const mainDashboard = '/mainDashboard';
  static const cleaner = '/cleaner/dashboard';
  static const inspector = '/inspector/dashboard';

  static final routes = <GetPage>[

    GetPage(
      name: login,
      page: () => const NewLoginView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: jsidelead,
      page: () =>  SiteLeadApplication(),
      binding: AppBindings(),
    ),
    GetPage(
      name: mainDashboard,
      page: () =>  MainNavigationView(),
      binding: AppBindings(),
    ),


  ];
}
