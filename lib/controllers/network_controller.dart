import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final RxBool isOnline = true.obs;

  StreamSubscription<dynamic>? _subscription;

  @override
  void onInit() {
    super.onInit();
    refreshStatus();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _setOnlineFromResult(result);
    });
  }

  Future<void> refreshStatus() async {
    final result = await Connectivity().checkConnectivity();
    _setOnlineFromResult(result);
  }

  void _setOnlineFromResult(dynamic result) {
    bool online = false;
    if (result is ConnectivityResult) {
      online = result != ConnectivityResult.none;
    } else if (result is List<ConnectivityResult>) {
      online = result.any((item) => item != ConnectivityResult.none);
    }
    isOnline.value = online;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
