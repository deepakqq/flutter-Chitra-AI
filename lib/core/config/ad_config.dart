class AdConfig {
  // Flutter-side ad control (not backend controlled)
  static const bool enableBannerAndroid = false;
  static const bool enableInterstitialAndroid = true;
  static const bool enableBannerIos = false;
  static const bool enableInterstitialIos = false;

  // If banner ID is empty, banner ad will not show.
  static const String bannerAdUnitIdAndroid = '';

  // client original id
  static const String interstitialAdUnitIdAndroid =
      'ca-app-pub-6116287084728301/2938156813';


  // testing id
  // static const String interstitialAdUnitIdAndroid =
  //   'ca-app-pub-3940256099942544/1033173712';


  static const String bannerAdUnitIdIos = '';
  static const String interstitialAdUnitIdIos = '';
}
