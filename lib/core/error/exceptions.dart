/// Custom exceptions for the application
library;

/// Base exception class for all app exceptions
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException($code): $message';
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory AuthException.invalidCredentials() => const AuthException(
        message: 'Invalid email or password',
        code: 'invalid_credentials',
      );

  factory AuthException.emailAlreadyExists() => const AuthException(
        message: 'An account with this email already exists',
        code: 'email_exists',
      );

  factory AuthException.weakPassword() => const AuthException(
        message: 'Password is too weak',
        code: 'weak_password',
      );

  factory AuthException.invalidToken() => const AuthException(
        message: 'Session expired. Please login again',
        code: 'invalid_token',
      );

  factory AuthException.emailNotVerified() => const AuthException(
        message: 'Please verify your email address',
        code: 'email_not_verified',
      );

  factory AuthException.userNotFound() => const AuthException(
        message: 'No account found with this email',
        code: 'user_not_found',
      );

  factory AuthException.socialAuthFailed(String provider) => AuthException(
        message: 'Failed to sign in with $provider',
        code: 'social_auth_failed',
      );
}

/// Network-related exceptions
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });

  factory NetworkException.noConnection() => const NetworkException(
        message: 'No internet connection',
        code: 'no_connection',
      );

  factory NetworkException.timeout() => const NetworkException(
        message: 'Request timed out',
        code: 'timeout',
      );

  factory NetworkException.serverError([String? details]) => NetworkException(
        message: details ?? 'Server error occurred',
        code: 'server_error',
        statusCode: 500,
      );

  factory NetworkException.notFound() => const NetworkException(
        message: 'Resource not found',
        code: 'not_found',
        statusCode: 404,
      );

  factory NetworkException.unauthorized() => const NetworkException(
        message: 'Unauthorized access',
        code: 'unauthorized',
        statusCode: 401,
      );

  factory NetworkException.forbidden() => const NetworkException(
        message: 'Access forbidden',
        code: 'forbidden',
        statusCode: 403,
      );

  factory NetworkException.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 401:
        return NetworkException.unauthorized();
      case 403:
        return NetworkException.forbidden();
      case 404:
        return NetworkException.notFound();
      case >= 500:
        return NetworkException.serverError(message);
      default:
        return NetworkException(
          message: message ?? 'Network error occurred',
          code: 'network_error',
          statusCode: statusCode,
        );
    }
  }
}

/// Subscription/Payment-related exceptions
class SubscriptionException extends AppException {
  const SubscriptionException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory SubscriptionException.paymentFailed() => const SubscriptionException(
        message: 'Payment failed. Please try again',
        code: 'payment_failed',
      );

  factory SubscriptionException.subscriptionNotFound() =>
      const SubscriptionException(
        message: 'Subscription not found',
        code: 'subscription_not_found',
      );

  factory SubscriptionException.alreadySubscribed() =>
      const SubscriptionException(
        message: 'You already have an active subscription',
        code: 'already_subscribed',
      );

  factory SubscriptionException.invalidPlan() => const SubscriptionException(
        message: 'Invalid subscription plan',
        code: 'invalid_plan',
      );
}

/// Permission/Tier-related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory PermissionException.insufficientTier(String requiredTier) =>
      PermissionException(
        message: 'This feature requires $requiredTier subscription',
        code: 'insufficient_tier',
      );

  factory PermissionException.accessDenied() => const PermissionException(
        message: 'You do not have permission to access this feature',
        code: 'access_denied',
      );

  factory PermissionException.limitReached(String limit) => PermissionException(
        message: 'You have reached your $limit limit. Upgrade to continue',
        code: 'limit_reached',
      );
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    this.fieldErrors,
  });

  factory ValidationException.invalidEmail() => const ValidationException(
        message: 'Please enter a valid email address',
        code: 'invalid_email',
      );

  factory ValidationException.invalidPassword() => const ValidationException(
        message: 'Password must be at least 8 characters',
        code: 'invalid_password',
      );

  factory ValidationException.passwordMismatch() => const ValidationException(
        message: 'Passwords do not match',
        code: 'password_mismatch',
      );

  factory ValidationException.requiredField(String field) =>
      ValidationException(
        message: '$field is required',
        code: 'required_field',
      );

  factory ValidationException.multipleErrors(Map<String, String> errors) =>
      ValidationException(
        message: 'Please fix the errors below',
        code: 'multiple_errors',
        fieldErrors: errors,
      );
}

/// Cache/Storage exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory StorageException.readError() => const StorageException(
        message: 'Failed to read from storage',
        code: 'read_error',
      );

  factory StorageException.writeError() => const StorageException(
        message: 'Failed to write to storage',
        code: 'write_error',
      );

  factory StorageException.notFound(String key) => StorageException(
        message: 'Key "$key" not found in storage',
        code: 'not_found',
      );
}
