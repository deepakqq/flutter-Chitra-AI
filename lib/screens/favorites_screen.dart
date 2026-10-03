import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controllers/favorites_controller.dart';
import '../controllers/home_controller.dart';
import '../data/models/prompt_model.dart';
import '../core/config/app_constants.dart';
import '../data/services/mock_data.dart';
import '../widgets/prompt_card.dart';
import '../routes/app_routes.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  List<PromptModel> _loadPromptsFromCache() {
    final box = Hive.box(AppConstants.boxPrompts);
    final cached = box.get('list');
    if (cached is! List) {
      // Fallback to mock data if cache is empty.
      return MockData.prompts;
    }

    final list = cached
        .map((e) => PromptModel.fromMap(
              (e['id'] ?? e['title'] ?? '').toString(),
              Map<String, dynamic>.from(e),
            ))
        .toList();

    if (list.isEmpty) return MockData.prompts;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();
    HomeController? home;
    if (Get.isRegistered<HomeController>()) {
      home = Get.find<HomeController>();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Obx(() {
        final favIds = favorites.favorites.toSet();
        final allPrompts = home?.prompts.toList() ?? _loadPromptsFromCache();
        final items = allPrompts.where((p) => favIds.contains(p.id)).toList();

        if (items.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Stack(
              children: [
                Positioned.fill(
                  child: PromptCard(
                    prompt: item,
                    onTap: () => Get.toNamed(AppRoutes.detail, arguments: item),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => favorites.toggleFavorite(item.id),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
