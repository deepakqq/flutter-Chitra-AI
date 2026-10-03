import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Obx(() {
        final policy = app.config.value.privacyPolicy.trim();
        if (policy.isNotEmpty) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Privacy Policy',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(policy),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'This app shows image prompts and stores your favorites locally on your device. '
              'We do not collect personal information. If ads are enabled, AdMob may collect '
              'device identifiers for ad delivery and analytics as per Google policies.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Data We Store\n'
              '- Favorites are stored locally using Hive.\n'
              '- Prompt images and text are read-only for users.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Third-Party Services\n'
              '- Google AdMob (optional)',
            ),
            const SizedBox(height: 12),
            const Text('For any questions, contact the app publisher.'),
          ],
        );
      }),
    );
  }
}
