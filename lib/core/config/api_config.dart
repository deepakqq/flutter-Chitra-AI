class ApiConfig {
  static const String baseUrl = 'http://195.35.20.118/chitra-backend/';

  static bool get isConfigured => baseUrl.trim().isNotEmpty;
}
