import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../data/services/ad_service.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key, required this.enabled});

  final bool enabled;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AdBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      _disposeAd();
      _load();
    }
  }

  void _load() {
    final service = AdService();
    if (!widget.enabled || !service.hasBanner) return;

    _banner = service.createBannerAd(size: AdSize.banner)..load();
  }

  void _disposeAd() {
    _banner?.dispose();
    _banner = null;
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _banner == null) return const SizedBox.shrink();
    return SizedBox(
      height: _banner!.size.height.toDouble(),
      width: _banner!.size.width.toDouble(),
      child: AdWidget(ad: _banner!),
    );
  }
}
