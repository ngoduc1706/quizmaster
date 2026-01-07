import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';

/// Firebase authentication data source
class FirebaseAuthDataSource {
  FirebaseAuthDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Get current Firebase user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Get auth state stream
  Stream<User?> getAuthStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  /// Sign in with Google
  Future<Result<AuthCredential>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return const Failure(AuthException('Sign in cancelled'));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return Success(credential);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error', e);
      return Failure(_mapFirebaseAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Google sign in error', e, stackTrace);
      return Failure(AuthException('Failed to sign in with Google: ${e.toString()}'));
    }
  }

  /// Sign in with credential
  Future<Result<UserCredential>> signInWithCredential(AuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return Success(userCredential);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error', e);
      return Failure(_mapFirebaseAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Sign in with credential error', e, stackTrace);
      return Failure(AuthException('Failed to sign in: ${e.toString()}'));
    }
  }

  /// Sign in with email and password
  Future<Result<UserCredential>> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FirebaseAuthException(
            code: 'network-request-failed',
            message: 'Network timeout. Please check your internet connection.',
          );
        },
      );
      return Success(userCredential);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error', e);
      // Map network errors to user-friendly messages
      if (e.code == 'network-request-failed') {
        return Failure(AuthException(
          'Không thể kết nối đến server. Vui lòng kiểm tra kết nối internet của bạn.',
          e.code,
        ));
      }
      return Failure(_mapFirebaseAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Sign in with email/password error', e, stackTrace);
      if (e.toString().contains('network') || 
          e.toString().contains('timeout') ||
          e.toString().contains('unreachable')) {
        return Failure(AuthException(
          'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.',
          'network-error',
        ));
      }
      return Failure(AuthException('Failed to sign in: ${e.toString()}'));
    }
  }

  /// Sign up with email and password
  Future<Result<UserCredential>> signUpWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw FirebaseAuthException(
            code: 'network-request-failed',
            message: 'Network timeout. Please check your internet connection.',
          );
        },
      );
      return Success(userCredential);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error', e);
      // Map network errors to user-friendly messages
      if (e.code == 'network-request-failed') {
        return Failure(AuthException(
          'Không thể kết nối đến server. Vui lòng kiểm tra kết nối internet của bạn.',
          e.code,
        ));
      }
      return Failure(_mapFirebaseAuthException(e));
    } catch (e, stackTrace) {
      AppLogger.error('Sign up with email/password error', e, stackTrace);
      if (e.toString().contains('network') || 
          e.toString().contains('timeout') ||
          e.toString().contains('unreachable')) {
        return Failure(AuthException(
          'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.',
          'network-error',
        ));
      }
      return Failure(AuthException('Failed to sign up: ${e.toString()}'));
    }
  }

  /// Sign out
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Sign out error', e, stackTrace);
      return Failure(AuthException('Failed to sign out: ${e.toString()}'));
    }
  }

  /// Map Firebase auth exception to app exception
  AuthException _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'wrong-password':
        return AuthException.wrongPassword();
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'invalid-email':
        return AuthException.invalidEmail();
      case 'user-disabled':
        return AuthException.userDisabled();
      case 'too-many-requests':
        return AuthException.tooManyRequests();
      case 'operation-not-allowed':
        return AuthException.operationNotAllowed();
      case 'network-request-failed':
        return AuthException(
          'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.',
          e.code,
        );
      default:
        return AuthException(e.message ?? 'Authentication failed', e.code);
    }
  }
}






