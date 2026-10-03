class AppConfigModel {
  AppConfigModel({
    required this.bannerEnabled,
    required this.interstitialEnabled,
    required this.homeTrendingEnabled,
    required this.privacyPolicy,
  });

  final bool bannerEnabled;
  final bool interstitialEnabled;
  final bool homeTrendingEnabled;
  final String privacyPolicy;

  factory AppConfigModel.initial() => AppConfigModel(
    bannerEnabled: false,
    interstitialEnabled: false,
    homeTrendingEnabled: true,
    privacyPolicy: '',
  );

  factory AppConfigModel.fromMap(Map<String, dynamic> map) {
    final rawBanner = map['bannerEnabled'] ?? map['banner_enabled'];
    final rawInterstitial =
        map['interstitialEnabled'] ?? map['interstitial_enabled'];
    final rawTrending =
        map['homeTrendingEnabled'] ?? map['home_trending_enabled'];

    return AppConfigModel(
      bannerEnabled: rawBanner == true || rawBanner == 1,
      interstitialEnabled: rawInterstitial == true || rawInterstitial == 1,
      homeTrendingEnabled: rawTrending != false && rawTrending != 0,
      privacyPolicy: (map['privacyPolicy'] ?? map['privacy_policy'] ?? '')
          .toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bannerEnabled': bannerEnabled,
      'interstitialEnabled': interstitialEnabled,
      'homeTrendingEnabled': homeTrendingEnabled,
      'privacyPolicy': privacyPolicy,
    };
  }
}
