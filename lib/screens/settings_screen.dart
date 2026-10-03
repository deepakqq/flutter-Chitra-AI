import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const androidPackage = 'com.ai.prompts.photoshoot';
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=$androidPackage';
    const privacyUrl =
        'https://doc-hosting.flycricket.io/chitra-ai-ai-photos-prompts-privacy-policy/df621c8f-0582-41ce-8988-022b9ca587f8/privacy';
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsTile(
            title: 'Rate App',
            subtitle: 'Leave a review on Play Store',
            icon: Icons.star_rate_rounded,
            onTap: () => _launchUrl(playStoreUrl),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            title: 'Share App',
            subtitle: 'Send app link to friends',
            icon: Icons.share,
            onTap: () => _shareApp(playStoreUrl),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            title: 'Privacy Policy',
            subtitle: 'Open privacy policy website',
            icon: Icons.privacy_tip_outlined,
            onTap: () => _launchUrl(privacyUrl),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            title: 'App Version',
            subtitle: '1.0.0',
            icon: Icons.info_outline,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp(String url) async {
    await Share.share(
      'Chitra AI — create stunning AI images with ready-to-use prompts. '
      'Download here: $url',
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
