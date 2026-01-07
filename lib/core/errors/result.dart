/// Result type for handling success/failure
sealed class Result<T> {
  const Result();
}

/// Success result
final class Success<T> extends Result<T> {
  const Success(this.data);
  
  final T data;
}

/// Failure result
final class Failure<T> extends Result<T> {
  const Failure(this.exception);
  
  final Exception exception;
}

/// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };
  
  Exception? get exceptionOrNull => switch (this) {
    Success() => null,
    Failure(exception: final exception) => exception,
  };
  
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Exception exception) onFailure,
  }) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Failure(exception: final exception) => onFailure(exception),
    };
  }
  
  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => Success(mapper(data)),
      Failure(exception: final exception) => Failure(exception),
    };
  }
  
  Result<T> mapFailure(Exception Function(Exception exception) mapper) {
    return switch (this) {
      Success() => this,
      Failure(exception: final exception) => Failure(mapper(exception)),
    };
  }
}













