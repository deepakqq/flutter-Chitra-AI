import 'package:get/get.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/network_controller.dart';
import '../../data/services/ad_service.dart';

class AppBindings extends Bindings {
  AppBindings({required this.firebaseReady});

  final bool firebaseReady;

  @override
  void dependencies() {
    Get.put(AppController(firebaseReady: firebaseReady));
    Get.put(FavoritesController());
    Get.put(NetworkController());
    Get.put(AdService());
    final adService = AdService();
    if (adService.hasBanner || adService.interstitialEnabledByApp) {
      adService.initialize();
    }
  }
}
