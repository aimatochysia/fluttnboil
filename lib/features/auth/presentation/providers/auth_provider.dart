/// Auth state providers using Riverpod
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provider for current auth state
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

/// Provider for current user (convenience)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState is Authenticated) {
    return authState.user;
  }
  return null;
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider) is Authenticated;
});

/// Provider for user's current tier
final userTierProvider = Provider<UserTier>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.tier ?? AppConfig.tiers.defaultTier;
});

/// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthStateNotifier(this._repository) : super(const AuthInitial()) {
    _checkAuthStatus();
  }

  /// Check initial auth status from stored tokens
  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();

    final tokens = await _repository.getStoredTokens();
    if (tokens == null || tokens.isExpired) {
      state = const Unauthenticated();
      return;
    }

    final result = await _repository.getCurrentUser();
    result.when(
      success: (user) {
        state = Authenticated(user: user, tokens: tokens);
      },
      failure: (exception) {
        state = Unauthenticated(message: exception.message);
      },
    );
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final tokensResult = await _repository.login(
      email: email,
      password: password,
    );

    await tokensResult.when(
      success: (tokens) async {
        final userResult = await _repository.getCurrentUser();
        userResult.when(
          success: (user) {
            state = Authenticated(user: user, tokens: tokens);
          },
          failure: (exception) {
            state = AuthError(message: exception.message, code: exception.code);
          },
        );
      },
      failure: (exception) {
        state = AuthError(message: exception.message, code: exception.code);
      },
    );
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AuthLoading();

    final tokensResult = await _repository.register(
      email: email,
      password: password,
      name: name,
    );

    await tokensResult.when(
      success: (tokens) async {
        final userResult = await _repository.getCurrentUser();
        userResult.when(
          success: (user) {
            state = Authenticated(user: user, tokens: tokens);
          },
          failure: (exception) {
            state = AuthError(message: exception.message, code: exception.code);
          },
        );
      },
      failure: (exception) {
        state = AuthError(message: exception.message, code: exception.code);
      },
    );
  }

  /// Social login
  Future<void> socialLogin(SocialAuthProvider provider) async {
    state = const AuthLoading();

    final tokensResult = await _repository.socialLogin(provider);

    await tokensResult.when(
      success: (tokens) async {
        final userResult = await _repository.getCurrentUser();
        userResult.when(
          success: (user) {
            state = Authenticated(user: user, tokens: tokens);
          },
          failure: (exception) {
            state = AuthError(message: exception.message, code: exception.code);
          },
        );
      },
      failure: (exception) {
        state = AuthError(message: exception.message, code: exception.code);
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    await _repository.logout();
    state = const Unauthenticated();
  }

  /// Forgot password
  Future<bool> forgotPassword(String email) async {
    final result = await _repository.forgotPassword(email);
    return result.isSuccess;
  }

  /// Reset password
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final result = await _repository.resetPassword(
      token: token,
      newPassword: newPassword,
    );
    return result.isSuccess;
  }

  /// Update profile
  Future<void> updateProfile({String? name, String? avatarUrl}) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    final result = await _repository.updateProfile(
      name: name,
      avatarUrl: avatarUrl,
    );

    result.when(
      success: (user) {
        state = Authenticated(user: user, tokens: currentState.tokens);
      },
      failure: (exception) {
        // Keep current state, but could show error
      },
    );
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      state = const Unauthenticated();
    }
  }
}
