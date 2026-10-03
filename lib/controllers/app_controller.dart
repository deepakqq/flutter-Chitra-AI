import 'package:get/get.dart';

import '../data/models/app_config_model.dart';
import '../data/services/app_config_service.dart';

class AppController extends GetxController {
  AppController({required this.firebaseReady});

  final bool firebaseReady;

  final Rx<AppConfigModel> config = AppConfigModel.initial().obs;

  @override
  void onInit() {
    super.onInit();
    loadConfig();
  }

  Future<void> loadConfig() async {
    final service = AppConfigService();
    final result = await service.fetchConfig();
    config.value = result;
  }
}
