/// Base exception class
sealed class AppException implements Exception {
  const AppException(this.message, [this.code]);
  
  final String message;
  final String? code;
  
  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
  
  factory NetworkException.noInternet() {
    return const NetworkException('No internet connection');
  }
  
  factory NetworkException.timeout() {
    return const NetworkException('Request timeout');
  }
  
  factory NetworkException.serverError([String? message]) {
    return NetworkException(message ?? 'Server error occurred');
  }
}

/// Firebase-related exceptions
class AppFirebaseException extends AppException {
  const AppFirebaseException(super.message, [super.code]);
  
  factory AppFirebaseException.fromCode(String code) {
    switch (code) {
      case 'permission-denied':
        return const AppFirebaseException('Permission denied');
      case 'not-found':
        return const AppFirebaseException('Resource not found');
      case 'already-exists':
        return const AppFirebaseException('Resource already exists');
      case 'unavailable':
        return const AppFirebaseException('Service unavailable');
      default:
        return AppFirebaseException('Firebase error: $code', code);
    }
  }
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, [super.code]);
  
  factory AuthException.userNotFound() {
    return const AuthException('User not found');
  }
  
  factory AuthException.wrongPassword() {
    return const AuthException('Wrong password');
  }
  
  factory AuthException.emailAlreadyInUse() {
    return const AuthException('Email already in use');
  }
  
  factory AuthException.weakPassword() {
    return const AuthException('Password is too weak');
  }
  
  factory AuthException.invalidEmail() {
    return const AuthException('Invalid email address');
  }
  
  factory AuthException.userDisabled() {
    return const AuthException('User account has been disabled');
  }
  
  factory AuthException.tooManyRequests() {
    return const AuthException('Too many requests. Please try again later');
  }
  
  factory AuthException.operationNotAllowed() {
    return const AuthException('Operation not allowed');
  }
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

/// Quota exceptions
class QuotaException extends AppException {
  const QuotaException(super.message, [super.code]);
  
  factory QuotaException.quizzesLimitReached() {
    return const QuotaException(
      'Daily quiz creation limit reached. Upgrade to Pro for unlimited quizzes.',
    );
  }
  
  factory QuotaException.aiLimitReached() {
    return const QuotaException(
      'Daily AI generation limit reached. Upgrade to Pro for unlimited generations.',
    );
  }
}

/// AI/API exceptions
class AIException extends AppException {
  const AIException(super.message, [super.code]);
  
  factory AIException.apiError([String? message]) {
    return AIException(message ?? 'AI service error occurred');
  }
  
  factory AIException.timeout() {
    return const AIException('AI request timeout');
  }
  
  factory AIException.invalidResponse() {
    return const AIException('Invalid response from AI service');
  }
}


