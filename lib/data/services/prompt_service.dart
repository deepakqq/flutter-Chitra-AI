import 'package:hive/hive.dart';

import '../../core/config/app_constants.dart';
import '../../core/config/api_config.dart';
import '../models/category_model.dart';
import '../models/prompt_model.dart';
import 'api_client.dart';
import 'mock_data.dart';

class PromptPayload {
  PromptPayload({required this.categories, required this.prompts});
  final List<CategoryModel> categories;
  final List<PromptModel> prompts;
}

class PromptService {
  final _apiClient = ApiClient();

  Future<PromptPayload> fetchInitialData({int limit = 30}) async {
    if (AppConstants.forceMockData || !ApiConfig.isConfigured) {
      return _fromCacheOrMock();
    }

    try {
      
      final categories = await fetchCategories();
      
      final prompts = await fetchPromptsPage(limit: limit, offset: 0);
   
      await _cache(categories, prompts);
      return PromptPayload(categories: categories, prompts: prompts);
    } catch (_) {
      return _fromCacheOrMock();
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    if (AppConstants.forceMockData || !ApiConfig.isConfigured) {
      return _categoriesFromCacheOrMock();
    }

    try {
   
      final categoryJson = await _apiClient.getJson('/api/categories.php');

      final categoryRaw = categoryJson['data'] as List<dynamic>? ?? const [];
      final categories = categoryRaw
          .whereType<Map>()
          .map((d) => Map<String, dynamic>.from(d))
          .map((d) => CategoryModel.fromMap((d['id'] ?? '').toString(), d))
          .where((c) => c.isActive)
          .toList();

      final catBox = Hive.box(AppConstants.boxCategories);
      await catBox.put(
        'list',
        categories.map((e) => {...e.toMap(), 'id': e.id}).toList(),
      );
      return categories;
    } catch (_) {
      return _categoriesFromCacheOrMock();
    }
  }

  Future<List<PromptModel>> fetchPromptsPage({
    required int limit,
    required int offset,
    String query = '',
    String? categoryId,
  }) async {
    if (AppConstants.forceMockData || !ApiConfig.isConfigured) {
      return _promptsFromCacheOrMock(offset: offset, limit: limit);
    }

    try {
      final params = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      final cleanedQuery = query.trim();
      if (cleanedQuery.isNotEmpty) {
        params['q'] = cleanedQuery;
      } else if (categoryId != null && categoryId != 'all') {
        final numericId = int.tryParse(categoryId);
        if (numericId != null && numericId > 0) {
          params['category_id'] = numericId.toString();
        }
      }

      final promptJson = await _apiClient.getJson(
        '/api/prompts.php',
        queryParams: params,
      );
     
      final promptRaw = promptJson['data'] as List<dynamic>? ?? const [];
     

      final prompts = promptRaw
          .whereType<Map>()
          .map((d) => Map<String, dynamic>.from(d))
          .map((d) => PromptModel.fromMap((d['id'] ?? '').toString(), d))
          .map(
            (p) => PromptModel(
              id: p.id,
              title: p.title,
              imageUrl: _apiClient.resolveAssetUrl(p.imageUrl),
              promptText: p.promptText,
              categoryId: p.categoryId,
              aiType: p.aiType,
              isTrending: p.isTrending,
              isActive: p.isActive,
            ),
          )
          .where((p) => p.isActive)
          .toList();

      return prompts;
    } catch (_) {
      return _promptsFromCacheOrMock(offset: offset, limit: limit);
    }
  }

  Future<void> _cache(
    List<CategoryModel> categories,
    List<PromptModel> prompts,
  ) async {
    final catBox = Hive.box(AppConstants.boxCategories);
    final promptBox = Hive.box(AppConstants.boxPrompts);

    await catBox.put(
      'list',
      categories.map((e) => {...e.toMap(), 'id': e.id}).toList(),
    );
    await promptBox.put(
      'list',
      prompts.map((e) => {...e.toMap(), 'id': e.id}).toList(),
    );
  }

  PromptPayload _fromCacheOrMock() {
    return PromptPayload(
      categories: _categoriesFromCacheOrMock(),
      prompts: _promptsFromCacheOrMock(
        offset: 0,
        limit: AppConstants.initialPromptLimit,
      ),
    );
  }

  List<CategoryModel> _categoriesFromCacheOrMock() {
    final catBox = Hive.box(AppConstants.boxCategories);
    final cachedCats = catBox.get('list');
    if (cachedCats is List && cachedCats.isNotEmpty) {
      return cachedCats
          .map(
            (e) => CategoryModel.fromMap(
              (e['id'] ?? e['name'] ?? '').toString(),
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    }
    return MockData.categories;
  }

  List<PromptModel> _promptsFromCacheOrMock({
    required int offset,
    required int limit,
  }) {
    final promptBox = Hive.box(AppConstants.boxPrompts);
    final cachedPrompts = promptBox.get('list');
    if (cachedPrompts is List && cachedPrompts.isNotEmpty) {
      final all = cachedPrompts
          .map(
            (e) => PromptModel.fromMap(
              (e['id'] ?? e['title'] ?? '').toString(),
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
      if (offset >= all.length) return <PromptModel>[];
      final end = (offset + limit) > all.length ? all.length : (offset + limit);
      return all.sublist(offset, end);
    }

    if (offset >= MockData.prompts.length) return <PromptModel>[];
    final end = (offset + limit) > MockData.prompts.length
        ? MockData.prompts.length
        : (offset + limit);
    return MockData.prompts.sublist(offset, end);
  }
}
