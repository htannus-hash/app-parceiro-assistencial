enum AppEnvironment { development, production }

class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool useMocks;

  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.useMocks = false,
  });

  static AppConfig? _instance;

  static void setConfig(AppConfig config) {
    _instance = config;
  }

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig must be initialized with setConfig');
    }
    return _instance!;
  }

  bool get isProduction => environment == AppEnvironment.production;
  bool get isDevelopment => environment == AppEnvironment.development;
}
