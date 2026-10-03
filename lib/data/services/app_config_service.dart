import 'package:hive/hive.dart';

import '../../core/config/app_constants.dart';
import '../../core/config/api_config.dart';
import '../models/app_config_model.dart';
import 'api_client.dart';

class AppConfigService {
  final _apiClient = ApiClient();

  Future<AppConfigModel> fetchConfig() async {
    final box = Hive.box(AppConstants.boxConfig);

    if (!ApiConfig.isConfigured || AppConstants.forceMockData) {
      final cached = box.get('main');
      if (cached is Map) {
        return AppConfigModel.fromMap(Map<String, dynamic>.from(cached));
      }
      return AppConfigModel.initial();
    }

    try {
      final response = await _apiClient.getJson('/api/config.php');
      final data = response['data'];
      if (data is Map) {
        await box.put('main', data);
        return AppConfigModel.fromMap(Map<String, dynamic>.from(data));
      }
    } catch (_) {}

    final cached = box.get('main');
    if (cached is Map) {
      return AppConfigModel.fromMap(Map<String, dynamic>.from(cached));
    }

    return AppConfigModel.initial();
  }
}
