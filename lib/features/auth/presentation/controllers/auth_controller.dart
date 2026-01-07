
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:doanlaptrinh/features/auth/data/repositories/auth_repository.dart';
import 'package:doanlaptrinh/features/auth/domain/entities/user.dart' as app_user;
import 'package:doanlaptrinh/providers/firebase_providers.dart';

part 'auth_controller.g.dart';

/// Auth state provider
@riverpod
Stream<app_user.User?> authState(AuthStateRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  
  return authRepository.getCurrentUser().asyncMap((result) {
    return result.fold(
      onSuccess: (user) => user,
      onFailure: (exception) {
        AppLogger.error('Auth state error', exception);
        return null;
      },
    );
  });
}

/// Auth repository provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  final firestore = ref.watch(firestoreProvider);
  
  return AuthRepository(
    authDataSource: authDataSource,
    firestore: firestore,
  );
}

/// Firebase auth data source provider
@riverpod
FirebaseAuthDataSource firebaseAuthDataSource(FirebaseAuthDataSourceRef ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  
  return FirebaseAuthDataSource(
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
  );
}

/// Sign in with Google provider
@riverpod
Future<void> signInWithGoogle(SignInWithGoogleRef ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  final result = await authRepository.signInWithGoogle();
  
  switch (result) {
    case Success():
      // Refresh auth state
      ref.invalidate(authStateProvider);
    case Failure(exception: final exception):
      AppLogger.error('Sign in failed', exception);
      throw exception;
  }
}

/// Sign in with email and password provider
@riverpod
Future<void> signInWithEmailPassword(
  SignInWithEmailPasswordRef ref,
  String email,
  String password,
) async {
  final authRepository = ref.read(authRepositoryProvider);
  final result = await authRepository.signInWithEmailPassword(email, password);
  
  switch (result) {
    case Success():
      // Refresh auth state
      ref.invalidate(authStateProvider);
    case Failure(exception: final exception):
      AppLogger.error('Sign in failed', exception);
      throw exception;
  }
}

/// Sign up with email and password provider  
@riverpod
Future<void> signUpWithEmailPassword(
  SignUpWithEmailPasswordRef ref,
  String email,
  String password,
  String userName,
) async {
  final authRepository = ref.read(authRepositoryProvider);
  final result = await authRepository.signUpWithEmailPassword(email, password, userName);
  
  switch (result) {
    case Success():
      // Refresh auth state
      ref.invalidate(authStateProvider);
    case Failure(exception: final exception):
      AppLogger.error('Sign up failed', exception);
      throw exception;
  }
}

/// Sign out provider
@riverpod
Future<void> signOut(SignOutRef ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  final result = await authRepository.signOut();
  
  switch (result) {
    case Success():
      // Refresh auth state
      ref.invalidate(authStateProvider);
    case Failure(exception: final exception):
      AppLogger.error('Sign out failed', exception);
      throw exception;
  }
}

/// Current user provider (convenience)
@riverpod
app_user.User? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
}

/// Is authenticated provider
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
}

/// Is admin provider
@riverpod
bool isAdmin(IsAdminRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAdmin ?? false;
}

/// Is pro provider
@riverpod
bool isPro(IsProRef ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isPro ?? false;
}


