/// FluttnBoil Configuration File
/// 
/// This file contains all configuration options for your SaaS application.
/// Modify these values to customize your app's behavior.
library;

/// Application configuration settings
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// App Information
  static const String appName = 'FluttnBoil';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your SaaS Boilerplate';

  /// Environment Configuration
  static const Environment environment = Environment.development;

  /// API Configuration
  static String get baseUrl => _getBaseUrl();
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  /// Authentication Configuration
  static const AuthConfig auth = AuthConfig();

  /// Stripe Configuration
  static const StripeConfig stripe = StripeConfig();

  /// Tier Configuration
  static const TierConfig tiers = TierConfig();

  /// Feature Flags
  static const FeatureFlags features = FeatureFlags();

  static String _getBaseUrl() {
    switch (environment) {
      case Environment.development:
        return 'https://api-dev.fluttnboil.com/v1';
      case Environment.staging:
        return 'https://api-staging.fluttnboil.com/v1';
      case Environment.production:
        return 'https://api.fluttnboil.com/v1';
    }
  }
}

/// Environment types
enum Environment {
  development,
  staging,
  production,
}

/// Authentication configuration
class AuthConfig {
  const AuthConfig();

  /// Enable email/password authentication
  final bool enableEmailAuth = true;

  /// Enable social authentication providers
  final bool enableSocialAuth = true;

  /// Social auth providers to enable
  final List<SocialAuthProvider> socialProviders = const [
    SocialAuthProvider.google,
    SocialAuthProvider.apple,
    SocialAuthProvider.github,
  ];

  /// Use combined login/signup screen or separate screens
  final AuthScreenMode screenMode = AuthScreenMode.separate;

  /// Enable "Remember Me" functionality
  final bool enableRememberMe = true;

  /// Enable biometric authentication
  final bool enableBiometricAuth = false;

  /// Session timeout in minutes (0 = never expire)
  final int sessionTimeoutMinutes = 60;

  /// Minimum password length
  final int minPasswordLength = 8;

  /// Require email verification
  final bool requireEmailVerification = true;
}

/// Social auth provider options
enum SocialAuthProvider {
  google,
  apple,
  facebook,
  twitter,
  github,
}

/// Auth screen mode - combined or separate login/signup
enum AuthScreenMode {
  combined,
  separate,
}

/// Stripe payment configuration
class StripeConfig {
  const StripeConfig();

  /// Stripe publishable key (replace with your key)
  String get publishableKey => _getPublishableKey();

  /// Enable test mode
  final bool testMode = true;

  /// Available currencies
  final List<String> currencies = const ['USD', 'EUR', 'GBP'];

  /// Default currency
  final String defaultCurrency = 'USD';

  String _getPublishableKey() {
    if (testMode) {
      return 'pk_test_your_test_key_here';
    }
    return 'pk_live_your_live_key_here';
  }
}

/// Tier/Subscription configuration
class TierConfig {
  const TierConfig();

  /// Default tier for new users
  final UserTier defaultTier = UserTier.free;

  /// Show upgrade prompts
  final bool showUpgradePrompts = true;

  /// Free tier limits
  final FreeTierLimits freeLimits = const FreeTierLimits();

  /// Pro tier limits
  final ProTierLimits proLimits = const ProTierLimits();

  /// Enterprise tier limits
  final EnterpriseTierLimits enterpriseLimits = const EnterpriseTierLimits();
}

/// User tier levels
enum UserTier {
  free,
  pro,
  enterprise,
}

/// Free tier limits
class FreeTierLimits {
  const FreeTierLimits();

  final int maxProjects = 3;
  final int maxTeamMembers = 1;
  final int storageGB = 1;
  final bool apiAccess = false;
  final bool prioritySupport = false;
  final bool customBranding = false;
}

/// Pro tier limits
class ProTierLimits {
  const ProTierLimits();

  final int maxProjects = 25;
  final int maxTeamMembers = 10;
  final int storageGB = 50;
  final bool apiAccess = true;
  final bool prioritySupport = true;
  final bool customBranding = false;
}

/// Enterprise tier limits
class EnterpriseTierLimits {
  const EnterpriseTierLimits();

  final int maxProjects = -1; // Unlimited
  final int maxTeamMembers = -1; // Unlimited
  final int storageGB = -1; // Unlimited
  final bool apiAccess = true;
  final bool prioritySupport = true;
  final bool customBranding = true;
}

/// Feature flags for enabling/disabling features
class FeatureFlags {
  const FeatureFlags();

  /// Enable dark mode
  final bool darkMode = true;

  /// Enable analytics tracking
  final bool analytics = true;

  /// Enable push notifications
  final bool pushNotifications = true;

  /// Enable crash reporting
  final bool crashReporting = true;

  /// Show onboarding for new users
  final bool showOnboarding = true;

  /// Enable in-app feedback
  final bool inAppFeedback = true;
}
