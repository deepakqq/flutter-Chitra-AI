import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';

class ApiClient {
  static final Uri _baseUri = Uri.parse(ApiConfig.baseUrl.trim());

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final uri = _resolveUri(path, queryParams: queryParams);
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid response');
    }

    return decoded;
  }

  String resolveAssetUrl(String rawUrl) {
    final value = rawUrl.trim();
    if (value.isEmpty) return value;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final normalized = value.startsWith('/') ? value.substring(1) : value;
    return _baseUri.resolve(normalized).toString();
  }

  Uri _resolveUri(String path, {Map<String, String>? queryParams}) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final base = _baseUri.resolve(normalizedPath);
    if (queryParams == null || queryParams.isEmpty) return base;
    return base.replace(
      queryParameters: {...base.queryParameters, ...queryParams},
    );
  }
}
