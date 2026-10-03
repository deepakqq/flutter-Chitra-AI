import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/config/ad_config.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    // await MobileAds.instance.updateRequestConfiguration(
    //   RequestConfiguration(
    //     testDeviceIds: const ['769F56EF91B1675715C14EC69DB5851C'],
    //   ),
    // );
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  String get _interstitialId {
    if (Platform.isIOS) return AdConfig.interstitialAdUnitIdIos;
    return AdConfig.interstitialAdUnitIdAndroid;
  }

  String get _bannerId {
    if (Platform.isIOS) return AdConfig.bannerAdUnitIdIos;
    return AdConfig.bannerAdUnitIdAndroid;
  }

  bool get hasInterstitial => _interstitialId.isNotEmpty;
  bool get hasBanner {
    if (Platform.isIOS) {
      return AdConfig.enableBannerIos && _bannerId.isNotEmpty;
    }
    return AdConfig.enableBannerAndroid && _bannerId.isNotEmpty;
  }

  bool get interstitialEnabledByApp {
    if (Platform.isIOS) {
      return AdConfig.enableInterstitialIos && _interstitialId.isNotEmpty;
    }
    return AdConfig.enableInterstitialAndroid && _interstitialId.isNotEmpty;
  }

  Future<void> showInterstitialThen(VoidCallback onComplete) async {
    if (!interstitialEnabledByApp) {
      onComplete();
      return;
    }

    InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onComplete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onComplete();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          onComplete();
        },
      ),
    );
  }

  BannerAd createBannerAd({required AdSize size}) {
    return BannerAd(
      adUnitId: _bannerId,
      size: size,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
  }
}
