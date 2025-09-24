import 'package:get/get.dart';
import '../Auth/login_page.dart';
import '../Auth/login_view.dart';
import '../Components/CourtAllocationCaseView/main_view.dart';
import '../Components/CourtCommissionCaseView/main_view.dart';
import '../Components/GovernmentCensusView/main_view.dart';
import '../Components/LandAcquisitionView/main_view.dart';
import '../Components/LandSurveyView/land_survey_view.dart';
import '../Components/join_as_site_lead.dart';
import '../View/MyApplication/my_application.dart';
import '../View/bottum_nevigation_bar.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login = '/login';

  static const siteLeadApplication = '/siteLeadApplication';
  static const mainDashboard = '/mainDashboard';
  static const newCalculationApplication = '/newCalculationApplication';
  static const landAcquisitionCalculationApplication = '/LandAcquisitionCalculationApplication';
  static const courtCommissionCase = '/CourtCommissionCase';
  static const courtAllocationCase = '/courtAllocationCase';
  static const governmentCensus = '/governmentCensus';


  static const dashboardMyApplication = '/dashboardMyApplication';

  static const cleaner = '/cleaner/dashboard';
  static const inspector = '/inspector/dashboard';

  static final routes = <GetPage>[
    GetPage(
      name: login,
      page: () => const NewLoginView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: siteLeadApplication,
      page: () => SiteLeadApplication(),
      binding: AppBindings(),
    ),
    GetPage(
      name: mainDashboard,
      page: () => MainNavigationView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: newCalculationApplication,
      page: () => SurveyView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: landAcquisitionCalculationApplication,
      page: () => LandAcquisitionView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: courtCommissionCase,
      page: () => CourtCommissionCaseView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: courtAllocationCase,
      page: () => CourtAllocationCaseView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: governmentCensus,
      page: () => GovernmentCensusView(),
      binding: AppBindings(),
    ),

    GetPage(
      name: dashboardMyApplication,
      page: () => MyApplication(),
      binding: AppBindings(),
    ),
  ];
}
