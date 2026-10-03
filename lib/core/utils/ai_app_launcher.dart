import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AiAppInfo {
  const AiAppInfo({
    required this.type,
    required this.label,
    this.androidPackage,
    this.androidStoreUrl,
    this.iosUrl,
    this.webUrl,
  });

  final String type;
  final String label;
  final String? androidPackage;
  final String? androidStoreUrl;
  final String? iosUrl;
  final String? webUrl;
}

class AiAppLauncher {
  static const List<AiAppInfo> apps = [
    AiAppInfo(
      type: 'gemini',
      label: 'Gemini',
      androidPackage: 'com.google.android.apps.bard',
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.google.android.apps.bard',
      iosUrl: 'https://apps.apple.com/app/google-gemini/id6477489728',
      webUrl: 'https://gemini.google.com/',
    ),
    AiAppInfo(
      type: 'chatgpt',
      label: 'ChatGPT',
      androidPackage: 'com.openai.chatgpt',
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.openai.chatgpt',
      iosUrl: 'https://apps.apple.com/app/chatgpt/id6448311069',
      webUrl: 'https://chat.openai.com/',
    ),
    AiAppInfo(
      type: 'grok',
      label: 'Grok',
      androidPackage: 'ai.x.grok',
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=ai.x.grok',
      iosUrl: 'https://apps.apple.com/us/app/grok/id6670324846',
      webUrl: 'https://x.com/i/grok',
    ),
    AiAppInfo(
      type: 'copilot',
      label: 'Microsoft Copilot',
      androidPackage: 'com.microsoft.copilot',
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.microsoft.copilot',
      iosUrl: 'https://apps.apple.com/app/microsoft-copilot/id6472538445',
      webUrl: 'https://copilot.microsoft.com/',
    ),
    AiAppInfo(
      type: 'discord',
      label: 'Discord',
      androidPackage: 'com.discord',
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.discord',
      iosUrl:
          'https://apps.apple.com/app/discord-chat-talk-hangout/id985746746',
      webUrl: 'https://discord.com/',
    ),
    AiAppInfo(
      type: 'leonardo',
      label: 'Leonardo AI',
      androidStoreUrl:
          'https://play.google.com/store/search?q=Leonardo%20AI&c=apps',
      iosUrl: 'https://apps.apple.com/app/leonardo-ai/id6475578337',
      webUrl: 'https://app.leonardo.ai/',
    ),
    AiAppInfo(
      type: 'ideogram',
      label: 'Ideogram',
      androidStoreUrl: 'https://play.google.com/store/search?q=Ideogram&c=apps',
      iosUrl: 'https://apps.apple.com/app/ideogram/id6450925384',
      webUrl: 'https://ideogram.ai/',
    ),
    AiAppInfo(
      type: 'firefly',
      label: 'Adobe Firefly',
      androidStoreUrl:
          'https://play.google.com/store/search?q=Adobe%20Firefly&c=apps',
      iosUrl: 'https://apps.apple.com/app/adobe-firefly/id6471132346',
      webUrl: 'https://firefly.adobe.com/',
    ),
    AiAppInfo(
      type: 'wombo',
      label: 'Dream by Wombo',
      androidPackage: 'com.womboai.wombo',
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.womboai.wombo',
      iosUrl: 'https://apps.apple.com/app/dream-by-wombo/id1586366816',
      webUrl: 'https://dream.ai/',
    ),
    AiAppInfo(
      type: 'pixai',
      label: 'PixAI',
      androidStoreUrl: 'https://play.google.com/store/search?q=PixAI&c=apps',
      iosUrl: 'https://apps.apple.com/app/pixai/id6444377380',
      webUrl: 'https://pixai.art/',
    ),
  ];

  static AiAppInfo? byType(String type) {
    return apps.firstWhereOrNull((a) => a.type == type);
  }

  static Future<void> open(String type) async {
    final app = byType(type);
    if (app == null) return;

    if (Platform.isAndroid) {
      if (app.androidPackage != null) {
        final launched = await _launchAndroidApp(app.androidPackage!);
        if (launched) return;
        _showInstallDialog(app);
        return;
      }

      if (app.androidStoreUrl != null) {
        _showInstallDialog(app);
        return;
      }
    }

    if (Platform.isIOS && app.iosUrl != null) {
      await _launchUrl(app.iosUrl!);
      return;
    }

    if (app.webUrl != null) {
      await _launchUrl(app.webUrl!);
    }
  }

  static Future<bool> _launchAndroidApp(String package) async {
    final uri = Uri.parse('android-app://$package');
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static void _showInstallDialog(AiAppInfo app) {
    Get.dialog(
      AlertDialog(
        title: Text('${app.label} not installed'),
        content: const Text('Please install the app and come back.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              if (Platform.isAndroid && app.androidStoreUrl != null) {
                await _launchUrl(app.androidStoreUrl!);
              } else if (Platform.isIOS && app.iosUrl != null) {
                await _launchUrl(app.iosUrl!);
              } else if (app.webUrl != null) {
                await _launchUrl(app.webUrl!);
              }
            },
            child: const Text('Install'),
          ),
        ],
      ),
    );
  }
}
