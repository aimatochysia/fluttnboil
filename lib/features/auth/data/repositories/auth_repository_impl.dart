/// Implementation of AuthRepository
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/dummy_auth_datasource.dart';

/// Implementation of [AuthRepository] using dummy data source
class AuthRepositoryImpl implements AuthRepository {
  final DummyAuthDataSource _dataSource;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl({
    DummyAuthDataSource? dataSource,
    FlutterSecureStorage? storage,
  })  : _dataSource = dataSource ?? DummyAuthDataSource(),
        _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<Result<AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await _dataSource.login(email, password);
      await storeTokens(tokens);
      return Result.success(tokens);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<AuthTokens>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final tokens = await _dataSource.register(email, password, name);
      await storeTokens(tokens);
      return Result.success(tokens);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<AuthTokens>> socialLogin(SocialAuthProvider provider) async {
    try {
      final tokens = await _dataSource.socialLogin(provider);
      await storeTokens(tokens);
      return Result.success(tokens);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        AuthException.socialAuthFailed(provider.name),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dataSource.logout();
      await clearStoredTokens();
      return Result.success(null);
    } catch (e) {
      // Still clear tokens even if server logout fails
      await clearStoredTokens();
      return Result.success(null);
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final user = await _dataSource.getCurrentUser();
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<AuthTokens>> refreshToken(String refreshToken) async {
    try {
      final tokens = await _dataSource.refreshToken(refreshToken);
      await storeTokens(tokens);
      return Result.success(tokens);
    } on AuthException catch (e) {
      await clearStoredTokens();
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _dataSource.forgotPassword(email);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dataSource.resetPassword(token, newPassword);
      return Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    try {
      await _dataSource.verifyEmail(token);
      return Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> resendVerificationEmail(String email) async {
    // In dummy implementation, just simulate success
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(null);
  }

  @override
  Future<Result<bool>> isEmailAvailable(String email) async {
    try {
      final isAvailable = await _dataSource.isEmailAvailable(email);
      return Result.success(isAvailable);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final user = await _dataSource.updateProfile(name, avatarUrl);
      return Result.success(user);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.changePassword(currentPassword, newPassword);
      return Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _dataSource.deleteAccount();
      await clearStoredTokens();
      return Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        NetworkException.serverError(e.toString()),
      );
    }
  }

  @override
  Future<AuthTokens?> getStoredTokens() async {
    try {
      final tokensJson = await _storage.read(key: StorageKeys.accessToken);
      if (tokensJson == null) return null;

      final Map<String, dynamic> data = json.decode(tokensJson);
      return AuthTokens.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> storeTokens(AuthTokens tokens) async {
    await _storage.write(
      key: StorageKeys.accessToken,
      value: json.encode(tokens.toJson()),
    );
  }

  @override
  Future<void> clearStoredTokens() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.userId),
      _storage.delete(key: StorageKeys.userEmail),
    ]);
  }
}
