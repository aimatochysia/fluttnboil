/// App-wide constants
library;

/// Route names used throughout the application
class RouteNames {
  RouteNames._();

  // Landing & Auth
  static const String landing = 'landing';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String verifyEmail = 'verify-email';
  static const String authCombined = 'auth';

  // Main App
  static const String dashboard = 'dashboard';
  static const String profile = 'profile';
  static const String settings = 'settings';

  // Subscription & Tiers
  static const String subscription = 'subscription';
  static const String upgrade = 'upgrade';
  static const String payment = 'payment';
  static const String paymentSuccess = 'payment-success';
  static const String paymentCancel = 'payment-cancel';

  // Error
  static const String notFound = 'not-found';
  static const String error = 'error';
}

/// Route paths
class RoutePaths {
  RoutePaths._();

  // Landing & Auth
  static const String landing = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String authCombined = '/auth';

  // Main App
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Subscription & Tiers
  static const String subscription = '/subscription';
  static const String upgrade = '/upgrade';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String paymentCancel = '/payment/cancel';

  // Error
  static const String notFound = '/404';
  static const String error = '/error';
}

/// Storage keys for local storage
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userTier = 'user_tier';
  static const String rememberMe = 'remember_me';
  static const String onboardingComplete = 'onboarding_complete';
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
}

/// API endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String socialAuth = '/auth/social';

  // User
  static const String user = '/user';
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String deleteAccount = '/user/delete';

  // Subscription
  static const String subscriptions = '/subscriptions';
  static const String createSubscription = '/subscriptions/create';
  static const String cancelSubscription = '/subscriptions/cancel';
  static const String updateSubscription = '/subscriptions/update';
  static const String subscriptionStatus = '/subscriptions/status';

  // Payment
  static const String createPaymentIntent = '/payments/intent';
  static const String confirmPayment = '/payments/confirm';
  static const String paymentHistory = '/payments/history';
}

/// UI Constants
class UIConstants {
  UIConstants._();

  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusRound = 50.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Max Widths
  static const double maxContentWidth = 1200.0;
  static const double maxFormWidth = 400.0;
  static const double maxCardWidth = 350.0;

  // Breakpoints
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;
}
