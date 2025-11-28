/// Environment-specific configuration
/// 
/// Use this file to manage different configurations for
/// development, staging, and production environments.
library;

import 'app_config.dart';

/// Environment configuration manager
class EnvironmentConfig {
  EnvironmentConfig._();

  static final EnvironmentConfig _instance = EnvironmentConfig._();
  static EnvironmentConfig get instance => _instance;

  late Environment _environment;
  late String _apiBaseUrl;
  late String _stripeKey;
  late bool _enableLogging;
  late bool _useMockData;

  Environment get environment => _environment;
  String get apiBaseUrl => _apiBaseUrl;
  String get stripeKey => _stripeKey;
  bool get enableLogging => _enableLogging;
  bool get useMockData => _useMockData;

  /// Initialize environment configuration
  void initialize(Environment env) {
    _environment = env;
    _loadConfiguration();
  }

  void _loadConfiguration() {
    switch (_environment) {
      case Environment.development:
        _apiBaseUrl = 'https://api-dev.fluttnboil.com/v1';
        _stripeKey = 'pk_test_development_key';
        _enableLogging = true;
        _useMockData = true;
      case Environment.staging:
        _apiBaseUrl = 'https://api-staging.fluttnboil.com/v1';
        _stripeKey = 'pk_test_staging_key';
        _enableLogging = true;
        _useMockData = false;
      case Environment.production:
        _apiBaseUrl = 'https://api.fluttnboil.com/v1';
        _stripeKey = 'pk_live_production_key';
        _enableLogging = false;
        _useMockData = false;
    }
  }

  /// Check if running in debug/development mode
  bool get isDevelopment => _environment == Environment.development;

  /// Check if running in staging mode
  bool get isStaging => _environment == Environment.staging;

  /// Check if running in production mode
  bool get isProduction => _environment == Environment.production;
}
