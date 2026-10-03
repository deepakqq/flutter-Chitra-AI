import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_prompts/core/config/asset_paths.dart';

import '../controllers/home_controller.dart';
import '../controllers/app_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/prompt_card.dart';
import '../widgets/trending_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/ad_banner.dart';
import '../data/services/ad_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final app = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: Row(
            children: [
              const _LogoBadge(),
              const SizedBox(width: 12),
              Expanded(child: _SearchField(onChanged: controller.updateSearch)),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 220) {
                  controller.loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: controller.loadData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    if (app.config.value.homeTrendingEnabled) ...[
                      _SectionHeader(title: 'Trending'),
                      SizedBox(
                        height: 190,
                        child: Obx(() {
                          final trending = controller.prompts
                              .where((p) => p.isTrending)
                              .toList();
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final item = trending[index];
                              return TrendingCard(
                                prompt: item,
                                onTap: () => Get.toNamed(
                                  AppRoutes.detail,
                                  arguments: item,
                                ),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemCount: trending.length,
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _SectionHeader(title: 'Categories'),
                    SizedBox(
                      height: 48,
                      child: Obx(() {
                        final cats = controller.categories;
                        final all = CategoryChip(
                          label: 'All',
                          selected:
                              controller.selectedCategoryId.value == 'all',
                          onTap: () {
                            controller.selectCategory('all');
                          },
                        );

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index == 0) return all;
                            final cat = cats[index - 1];
                            return CategoryChip(
                              label: cat.name,
                              selected:
                                  controller.selectedCategoryId.value == cat.id,
                              onTap: () {
                                controller.selectCategory(cat.id);
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemCount: cats.length + 1,
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.loading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final items = controller.filtered;
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No prompts available',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return PromptCard(
                            prompt: item,
                            onTap: () =>
                                Get.toNamed(AppRoutes.detail, arguments: item),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (controller.isLoadingMore.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox(height: 12);
                    }),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (!controller.isLoadingCategoryAd.value) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withOpacity(0.25),
                  child: const Center(child: _AdLoadingCard()),
                ),
              );
            }),
          ],
        );
      }),
      bottomNavigationBar: AdBanner(enabled: AdService().hasBanner),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search prompts',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary.withOpacity(0.4)),
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,

      child: Center(
        child: Image.asset(
          AssetPaths.logo,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
