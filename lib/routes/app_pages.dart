import 'package:get/get.dart';

import '../screens/splash_screen.dart';
import '../screens/home_shell.dart';
import '../screens/home_screen.dart';
import '../screens/prompt_detail_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../controllers/prompt_detail_controller.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeShell(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const PromptDetailScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PromptDetailController>(() => PromptDetailController());
      }),
    ),
    GetPage(
      name: AppRoutes.privacy,
      page: () => const PrivacyPolicyScreen(),
    ),
  ];
}
