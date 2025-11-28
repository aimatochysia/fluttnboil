/// User entity representing an authenticated user
library;

import '../../../../core/config/app_config.dart';

/// User model representing the authenticated user
class User {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final UserTier tier;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.tier,
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.metadata,
  });

  /// Create a user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      tier: UserTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => UserTier.free,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'tier': tier.name,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'metadata': metadata,
    };
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    UserTier? tier,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tier: tier ?? this.tier,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get display name (name or email)
  String get displayName => name ?? email.split('@').first;

  /// Get initials for avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  /// Check if user has a specific tier or higher
  bool hasTierOrHigher(UserTier requiredTier) {
    return tier.index >= requiredTier.index;
  }

  /// Check if user is on free tier
  bool get isFree => tier == UserTier.free;

  /// Check if user is on pro tier
  bool get isPro => tier == UserTier.pro;

  /// Check if user is on enterprise tier
  bool get isEnterprise => tier == UserTier.enterprise;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, tier: $tier)';
}

/// Authentication tokens
class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// Authentication state
sealed class AuthState {
  const AuthState();
}

/// Initial/unknown authentication state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Authentication loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state
class Authenticated extends AuthState {
  final User user;
  final AuthTokens tokens;

  const Authenticated({
    required this.user,
    required this.tokens,
  });
}

/// Unauthenticated state
class Unauthenticated extends AuthState {
  final String? message;

  const Unauthenticated({this.message});
}

/// Authentication error state
class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({
    required this.message,
    this.code,
  });
}
