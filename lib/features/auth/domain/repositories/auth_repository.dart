/// Auth repository interface
library;

import '../../../../core/config/app_config.dart';
import '../../../../core/error/result.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Result<AuthTokens>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Result<AuthTokens>> register({
    required String email,
    required String password,
    String? name,
  });

  /// Login with social provider
  Future<Result<AuthTokens>> socialLogin(SocialAuthProvider provider);

  /// Logout current user
  Future<Result<void>> logout();

  /// Get current user profile
  Future<Result<User>> getCurrentUser();

  /// Refresh authentication tokens
  Future<Result<AuthTokens>> refreshToken(String refreshToken);

  /// Send password reset email
  Future<Result<void>> forgotPassword(String email);

  /// Reset password with token
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with token
  Future<Result<void>> verifyEmail(String token);

  /// Resend verification email
  Future<Result<void>> resendVerificationEmail(String email);

  /// Check if email is available
  Future<Result<bool>> isEmailAvailable(String email);

  /// Update user profile
  Future<Result<User>> updateProfile({
    String? name,
    String? avatarUrl,
  });

  /// Change password
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account
  Future<Result<void>> deleteAccount();

  /// Get stored auth tokens
  Future<AuthTokens?> getStoredTokens();

  /// Store auth tokens
  Future<void> storeTokens(AuthTokens tokens);

  /// Clear stored tokens
  Future<void> clearStoredTokens();
}
