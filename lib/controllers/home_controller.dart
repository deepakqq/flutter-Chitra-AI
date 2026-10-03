import 'dart:async';

import 'package:get/get.dart';

import '../data/models/category_model.dart';
import '../data/models/prompt_model.dart';
import '../data/services/ad_service.dart';
import '../data/services/prompt_service.dart';

class HomeController extends GetxController {
  HomeController({PromptService? service})
    : _service = service ?? PromptService();

  final PromptService _service;
  static const int _pageSize = 30;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<PromptModel> prompts = <PromptModel>[].obs;
  final RxList<PromptModel> filtered =
      <PromptModel>[].obs; // kept for UI binding
  final RxString selectedCategoryId = 'all'.obs;
  final RxString searchText = ''.obs;
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLoadingCategoryAd = false.obs;
  final RxBool hasMore = true.obs;

  Timer? _searchDebounce;
  int _offset = 0;
  int _categoryTapCount = 0;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    loading.value = true;
    _offset = 0;
    hasMore.value = true;
    try {
      final data = await _service.fetchInitialData(limit: _pageSize);
      categories.assignAll(data.categories);
      prompts.assignAll(data.prompts);
      filtered.assignAll(prompts);
      _offset = prompts.length;
      hasMore.value = data.prompts.length >= _pageSize;
    } catch (_) {
      prompts.clear();
      filtered.clear();
      hasMore.value = false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (loading.value || isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await _service.fetchPromptsPage(
        limit: _pageSize,
        offset: _offset,
        query: searchText.value.trim(),
        categoryId: _effectiveCategoryId(),
      );

      if (result.isEmpty) {
        hasMore.value = false;
        return;
      }

      prompts.addAll(result);
      filtered.assignAll(prompts);
      _offset += result.length;
      if (result.length < _pageSize) {
        hasMore.value = false;
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> selectCategory(String id) async {
    if (selectedCategoryId.value == id) return;
    _categoryTapCount++;
    final shouldShowAd = _categoryTapCount % 3 == 0;
    if (shouldShowAd && AdService().interstitialEnabledByApp) {
      isLoadingCategoryAd.value = true;
      try {
        final completer = Completer<void>();
        await AdService().showInterstitialThen(() {
          if (!completer.isCompleted) {
            completer.complete();
          }
        });
        await completer.future;
      } finally {
        isLoadingCategoryAd.value = false;
      }
    }

    selectedCategoryId.value = id;
    await _reloadForActiveFilters();
  }

  void updateSearch(String value) {
    searchText.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      await _reloadForActiveFilters();
    });
  }

  Future<void> _reloadForActiveFilters() async {
    loading.value = true;
    _offset = 0;
    hasMore.value = true;
    try {
      final result = await _service.fetchPromptsPage(
        limit: _pageSize,
        offset: 0,
        query: searchText.value.trim(),
        categoryId: _effectiveCategoryId(),
      );
      prompts.assignAll(result);
      filtered.assignAll(prompts);
      _offset = prompts.length;
      hasMore.value = result.length >= _pageSize;
    } finally {
      loading.value = false;
    }
  }

  String? _effectiveCategoryId() {
    if (searchText.value.trim().isNotEmpty) {
      // Search is global in current UX.
      return null;
    }
    final id = selectedCategoryId.value;
    return id == 'all' ? null : id;
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}
