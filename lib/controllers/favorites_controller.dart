import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../core/config/app_constants.dart';

class FavoritesController extends GetxController {
  final RxSet<String> favorites = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final box = Hive.box(AppConstants.boxFavorites);
    for (final value in box.values) {
      favorites.add(value.toString());
    }
  }

  bool isFavorite(String id) => favorites.contains(id);

  Future<void> toggleFavorite(String id) async {
    final box = Hive.box(AppConstants.boxFavorites);
    if (favorites.contains(id)) {
      favorites.remove(id);
      dynamic targetKey;
      for (final key in box.keys) {
        if (box.get(key) == id) {
          targetKey = key;
          break;
        }
      }
      if (targetKey != null) await box.delete(targetKey);
    } else {
      favorites.add(id);
      await box.add(id);
    }
  }
}
