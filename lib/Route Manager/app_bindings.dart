import 'package:get/get.dart';
import '../Controller/get_translation_controller/get_translation_controller.dart';
import '../Controller/login_controller.dart';
import '../Controller/login_view_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {


    // Register all controllers here
    Get.lazyPut(() => TranslationController());


    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<LoginViewController>(() => LoginViewController(), fenix: true);

  }
}
