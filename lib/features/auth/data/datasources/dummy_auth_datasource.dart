/// Dummy auth data source for development/demo
library;

import 'package:uuid/uuid.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';

/// Simulates API/Firebase authentication
class DummyAuthDataSource {
  DummyAuthDataSource();

  // Simulated database of users
  final Map<String, _StoredUser> _users = {};
  final Map<String, String> _resetTokens = {};
  final Map<String, String> _verificationTokens = {};

  // Current logged in user
  String? _currentUserId;

  /// Simulate login
  Future<AuthTokens> login(String email, String password) async {
    await _simulateDelay();

    // Check for demo credentials
    if (email == 'demo@fluttnboil.com' && password == 'demo1234') {
      return _createDemoUserAndTokens();
    }

    final user = _users.values.where((u) => u.email == email).firstOrNull;

    if (user == null) {
      throw AuthException.userNotFound();
    }

    if (user.password != password) {
      throw AuthException.invalidCredentials();
    }

    if (!user.isEmailVerified && AppConfig.auth.requireEmailVerification) {
      throw AuthException.emailNotVerified();
    }

    _currentUserId = user.id;
    return _generateTokens(user.id);
  }

  /// Simulate registration
  Future<AuthTokens> register(String email, String password, String? name) async {
    await _simulateDelay();

    if (_users.values.any((u) => u.email == email)) {
      throw AuthException.emailAlreadyExists();
    }

    if (password.length < AppConfig.auth.minPasswordLength) {
      throw AuthException.weakPassword();
    }

    final id = const Uuid().v4();
    final user = _StoredUser(
      id: id,
      email: email,
      password: password,
      name: name,
      tier: AppConfig.tiers.defaultTier,
      createdAt: DateTime.now(),
      isEmailVerified: !AppConfig.auth.requireEmailVerification,
    );

    _users[id] = user;
    _currentUserId = id;

    // Generate verification token
    if (AppConfig.auth.requireEmailVerification) {
      _verificationTokens[const Uuid().v4()] = id;
    }

    return _generateTokens(id);
  }

  /// Simulate social login
  Future<AuthTokens> socialLogin(SocialAuthProvider provider) async {
    await _simulateDelay();

    // Simulate social auth - in real app, this would interact with the provider
    final email = 'social_user_${provider.name}@fluttnboil.com';

    var user = _users.values.where((u) => u.email == email).firstOrNull;

    if (user == null) {
      final id = const Uuid().v4();
      user = _StoredUser(
        id: id,
        email: email,
        password: '', // No password for social auth
        name: '${provider.name.capitalize()} User',
        tier: AppConfig.tiers.defaultTier,
        createdAt: DateTime.now(),
        isEmailVerified: true, // Social auth emails are pre-verified
      );
      _users[id] = user;
    }

    _currentUserId = user.id;
    return _generateTokens(user.id);
  }

  /// Simulate logout
  Future<void> logout() async {
    await _simulateDelay(milliseconds: 200);
    _currentUserId = null;
  }

  /// Get current user
  Future<User> getCurrentUser() async {
    await _simulateDelay();

    if (_currentUserId == null) {
      throw AuthException.invalidToken();
    }

    final storedUser = _users[_currentUserId];
    if (storedUser == null) {
      throw AuthException.userNotFound();
    }

    return storedUser.toUser();
  }

  /// Refresh tokens
  Future<AuthTokens> refreshToken(String refreshToken) async {
    await _simulateDelay();

    // In real implementation, validate the refresh token
    if (_currentUserId == null) {
      throw AuthException.invalidToken();
    }

    return _generateTokens(_currentUserId!);
  }

  /// Simulate forgot password
  Future<void> forgotPassword(String email) async {
    await _simulateDelay();

    final user = _users.values.where((u) => u.email == email).firstOrNull;
    if (user == null) {
      // Don't reveal if email exists
      return;
    }

    final token = const Uuid().v4();
    _resetTokens[token] = user.id;

    // In real app, send email with reset link
    // ignore: avoid_print
    print('Password reset token for $email: $token');
  }

  /// Simulate reset password
  Future<void> resetPassword(String token, String newPassword) async {
    await _simulateDelay();

    final userId = _resetTokens[token];
    if (userId == null) {
      throw AuthException.invalidToken();
    }

    if (newPassword.length < AppConfig.auth.minPasswordLength) {
      throw AuthException.weakPassword();
    }

    final user = _users[userId];
    if (user != null) {
      _users[userId] = user.copyWith(password: newPassword);
    }

    _resetTokens.remove(token);
  }

  /// Simulate verify email
  Future<void> verifyEmail(String token) async {
    await _simulateDelay();

    final userId = _verificationTokens[token];
    if (userId == null) {
      throw AuthException.invalidToken();
    }

    final user = _users[userId];
    if (user != null) {
      _users[userId] = user.copyWith(isEmailVerified: true);
    }

    _verificationTokens.remove(token);
  }

  /// Check if email is available
  Future<bool> isEmailAvailable(String email) async {
    await _simulateDelay(milliseconds: 300);
    return !_users.values.any((u) => u.email == email);
  }

  /// Update profile
  Future<User> updateProfile(String? name, String? avatarUrl) async {
    await _simulateDelay();

    if (_currentUserId == null) {
      throw AuthException.invalidToken();
    }

    final user = _users[_currentUserId];
    if (user == null) {
      throw AuthException.userNotFound();
    }

    final updatedUser = user.copyWith(
      name: name ?? user.name,
      avatarUrl: avatarUrl ?? user.avatarUrl,
    );
    _users[_currentUserId!] = updatedUser;

    return updatedUser.toUser();
  }

  /// Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _simulateDelay();

    if (_currentUserId == null) {
      throw AuthException.invalidToken();
    }

    final user = _users[_currentUserId];
    if (user == null) {
      throw AuthException.userNotFound();
    }

    if (user.password != currentPassword) {
      throw AuthException.invalidCredentials();
    }

    if (newPassword.length < AppConfig.auth.minPasswordLength) {
      throw AuthException.weakPassword();
    }

    _users[_currentUserId!] = user.copyWith(password: newPassword);
  }

  /// Delete account
  Future<void> deleteAccount() async {
    await _simulateDelay();

    if (_currentUserId == null) {
      throw AuthException.invalidToken();
    }

    _users.remove(_currentUserId);
    _currentUserId = null;
  }

  // Helper to create demo user
  AuthTokens _createDemoUserAndTokens() {
    const demoId = 'demo-user-id';

    if (!_users.containsKey(demoId)) {
      _users[demoId] = _StoredUser(
        id: demoId,
        email: 'demo@fluttnboil.com',
        password: 'demo1234',
        name: 'Demo User',
        tier: UserTier.pro,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isEmailVerified: true,
      );
    }

    _currentUserId = demoId;
    return _generateTokens(demoId);
  }

  // Generate mock tokens
  AuthTokens _generateTokens(String userId) {
    return AuthTokens(
      accessToken: 'mock_access_token_$userId',
      refreshToken: 'mock_refresh_token_$userId',
      expiresAt: DateTime.now().add(
        Duration(minutes: AppConfig.auth.sessionTimeoutMinutes),
      ),
    );
  }

  // Simulate network delay
  Future<void> _simulateDelay({int milliseconds = 500}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}

/// Internal user storage model
class _StoredUser {
  final String id;
  final String email;
  final String password;
  final String? name;
  final String? avatarUrl;
  final UserTier tier;
  final DateTime createdAt;
  final bool isEmailVerified;

  _StoredUser({
    required this.id,
    required this.email,
    required this.password,
    this.name,
    this.avatarUrl,
    required this.tier,
    required this.createdAt,
    required this.isEmailVerified,
  });

  _StoredUser copyWith({
    String? password,
    String? name,
    String? avatarUrl,
    UserTier? tier,
    bool? isEmailVerified,
  }) {
    return _StoredUser(
      id: id,
      email: email,
      password: password ?? this.password,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tier: tier ?? this.tier,
      createdAt: createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  User toUser() {
    return User(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      tier: tier,
      createdAt: createdAt,
      isEmailVerified: isEmailVerified,
    );
  }
}

/// Extension to capitalize string
extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
