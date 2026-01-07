import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/auth/domain/entities/user.dart';

/// Authentication repository interface
abstract class AuthRepositoryInterface {
  /// Get current user
  Stream<Result<User?>> getCurrentUser();

  /// Sign in with Google
  Future<Result<User>> signInWithGoogle();

  /// Sign in with email and password
  Future<Result<User>> signInWithEmailPassword(String email, String password);

  /// Sign up with email and password
  Future<Result<User>> signUpWithEmailPassword(String email, String password, String name);

  /// Sign out
  Future<Result<void>> signOut();

  /// Check if user is authenticated
  Future<Result<bool>> isAuthenticated();

  /// Get user by ID
  Future<Result<User>> getUserById(String uid);

  /// Update user
  Future<Result<User>> updateUser(User user);
}






