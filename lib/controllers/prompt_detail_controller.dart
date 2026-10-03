import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../data/models/prompt_model.dart';
import '../data/services/ad_service.dart';

class PromptDetailController extends GetxController {
  final RxBool unlocked = false.obs;
  final RxBool isLoadingAd = false.obs;

  PromptModel get prompt => Get.arguments as PromptModel;

  Future<void> unlockPrompt() async {
    if (unlocked.value || isLoadingAd.value) return;

    final adService = AdService();
    if (!adService.interstitialEnabledByApp) {
      unlocked.value = true;
      return;
    }

    isLoadingAd.value = true;
    try {
      final completer = Completer<void>();
      await adService.showInterstitialThen(() {
        unlocked.value = true;
        if (!completer.isCompleted) {
          completer.complete();
        }
      });
      await completer.future;
    } finally {
      isLoadingAd.value = false;
    }
  }

  Future<void> copyPrompt() async {
    await Clipboard.setData(ClipboardData(text: prompt.promptText));
  }
}
