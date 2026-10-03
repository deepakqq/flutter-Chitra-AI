import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/prompt_detail_controller.dart';
import '../controllers/favorites_controller.dart';
import '../data/models/prompt_model.dart';
import '../core/utils/secure_screen.dart';
import '../core/utils/ai_app_launcher.dart';

class PromptDetailScreen extends StatefulWidget {
  const PromptDetailScreen({super.key});

  @override
  State<PromptDetailScreen> createState() => _PromptDetailScreenState();
}

class _PromptDetailScreenState extends State<PromptDetailScreen> {
  @override
  void initState() {
    super.initState();
    _secureScreen();
  }

  Future<void> _secureScreen() async {
    await SecureScreen.enable();
  }

  @override
  void dispose() {
    _clearSecure();
    super.dispose();
  }

  Future<void> _clearSecure() async {
    await SecureScreen.disable();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromptDetailController>();
    final favorites = Get.find<FavoritesController>();
    final PromptModel prompt = controller.prompt;

    return Scaffold(
      appBar: AppBar(
        title: Text(prompt.title),
        actions: [
          Obx(() {
            final fav = favorites.isFavorite(prompt.id);
            return IconButton(
              onPressed: () async {
                await favorites.toggleFavorite(prompt.id);
              },
              icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewPadding.bottom + 20,
            ),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: CachedNetworkImage(
                    imageUrl: prompt.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.08),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.08),
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final unlocked = controller.unlocked.value;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prompt',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      if (!unlocked)
                        const Text('Tap to unlock this prompt')
                      else
                        Text(prompt.promptText),
                      const SizedBox(height: 12),
                      if (!unlocked)
                        ElevatedButton(
                          onPressed: controller.unlockPrompt,
                          child: const Text('Unlock Prompt'),
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: controller.copyPrompt,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy Prompt'),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.check_circle, size: 18),
                            const SizedBox(width: 6),
                            const Text('Ready'),
                          ],
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                if (!controller.unlocked.value) return const SizedBox.shrink();
                return const _Instructions();
              }),
            ],
          ),
          Obx(() {
            if (!controller.isLoadingAd.value) return const SizedBox.shrink();
            return Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withOpacity(0.25),
                child: const Center(child: _AdLoadingCard()),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AdLoadingCard extends StatelessWidget {
  const _AdLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
          SizedBox(width: 10),
          Text('Loading ad...'),
        ],
      ),
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 34),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to use',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _StepTile(index: 1, text: 'Copy Prompt'),
          const SizedBox(height: 8),
          const _StepTile(
            index: 2,
            text: 'Open any ai app (Gemini, ChatGpt, GrokAi...etc.)',
          ),
          const SizedBox(height: 8),
          const _StepTile(
            index: 3,
            text: 'Select image and paste the prompt with this image',
          ),
          const SizedBox(height: 8),
          const _StepTile(index: 4, text: 'Tap on generate button'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final buttonWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _OpenAppButton(
                    width: buttonWidth,
                    label: 'Open Gemini',
                    color: const Color(0xFF4A7CFF),
                    onTap: () => AiAppLauncher.open('gemini'),
                  ),
                  _OpenAppButton(
                    width: buttonWidth,
                    label: 'Open ChatGPT',
                    color: const Color(0xFF10A37F),
                    onTap: () => AiAppLauncher.open('chatgpt'),
                  ),
                  _OpenAppButton(
                    width: buttonWidth,
                    label: 'Open Grok',
                    color: const Color(0xFF1D1D1F),
                    onTap: () => AiAppLauncher.open('grok'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OpenAppButton extends StatelessWidget {
  const _OpenAppButton({
    required this.width,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final double width;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: width,
      child: ElevatedButton.icon(
        onPressed: onTap,

        icon: const Icon(Icons.open_in_new, size: 16),
        label: Text(label, style: TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.index, required this.text});
  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$index',
            style: TextStyle(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
