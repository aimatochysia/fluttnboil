/// Result type for handling success/failure states
library;

import 'exceptions.dart';

/// A Result type that can be either Success or Failure
sealed class Result<T> {
  const Result();

  /// Create a success result
  factory Result.success(T value) = Success<T>;

  /// Create a failure result
  factory Result.failure(AppException exception) = Failure<T>;

  /// Check if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the value if success, throws if failure
  T get value => switch (this) {
        Success(:final value) => value,
        Failure(:final exception) => throw exception,
      };

  /// Get the exception if failure, null if success
  AppException? get exception => switch (this) {
        Success() => null,
        Failure(:final exception) => exception,
      };

  /// Map the success value to a new value
  Result<R> map<R>(R Function(T value) mapper) => switch (this) {
        Success(:final value) => Result.success(mapper(value)),
        Failure(:final exception) => Result.failure(exception),
      };

  /// Flat map the success value to a new Result
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) => switch (this) {
        Success(:final value) => mapper(value),
        Failure(:final exception) => Result.failure(exception),
      };

  /// Execute a function if success
  void ifSuccess(void Function(T value) action) {
    if (this is Success<T>) {
      action((this as Success<T>).value);
    }
  }

  /// Execute a function if failure
  void ifFailure(void Function(AppException exception) action) {
    if (this is Failure<T>) {
      action((this as Failure<T>).exception);
    }
  }

  /// Handle both success and failure cases
  R when<R>({
    required R Function(T value) success,
    required R Function(AppException exception) failure,
  }) =>
      switch (this) {
        Success(:final value) => success(value),
        Failure(:final exception) => failure(exception),
      };

  /// Get the value or a default if failure
  T getOrElse(T defaultValue) => switch (this) {
        Success(:final value) => value,
        Failure() => defaultValue,
      };

  /// Get the value or compute a default if failure
  T getOrElseCompute(T Function(AppException exception) compute) =>
      switch (this) {
        Success(:final value) => value,
        Failure(:final exception) => compute(exception),
      };
}

/// Success result containing a value
final class Success<T> extends Result<T> {
  @override
  final T value;

  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failure result containing an exception
final class Failure<T> extends Result<T> {
  @override
  final AppException exception;

  const Failure(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Failure($exception)';
}
