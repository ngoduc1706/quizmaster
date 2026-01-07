import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:doanlaptrinh/features/auth/data/models/user_model.dart';
import 'package:doanlaptrinh/features/auth/domain/entities/user.dart';
import 'package:doanlaptrinh/features/auth/domain/repositories/auth_repository_interface.dart';

/// Authentication repository implementation
class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({
    required FirebaseAuthDataSource authDataSource,
    required FirebaseFirestore firestore,
  })  : _authDataSource = authDataSource,
        _firestore = firestore;

  final FirebaseAuthDataSource _authDataSource;
  final FirebaseFirestore _firestore;

  @override
  Stream<Result<User?>> getCurrentUser() {
    return _authDataSource.getAuthStateChanges().asyncExpand((firebaseUser) async* {
      if (firebaseUser == null) {
        yield const Success<User?>(null);
        return;
      }

      // Listen to Firestore document changes to auto-refresh when role changes
      yield* _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(firebaseUser.uid)
          .snapshots()
          .asyncMap((userDoc) async {
        try {
          AppLogger.info('🔍 getCurrentUser - Firebase UID: ${firebaseUser.uid}');
          AppLogger.info('🔍 getCurrentUser - Email: ${firebaseUser.email}');

          if (!userDoc.exists) {
            AppLogger.info('⚠️ User document NOT found, creating new one');
            // Create user document if it doesn't exist
            final newUser = User(
              uid: firebaseUser.uid,
              name: firebaseUser.displayName ?? 'User',
              email: firebaseUser.email ?? '',
              photoUrl: firebaseUser.photoURL,
              createdAt: DateTime.now(),
            );
            await createUserDocument(newUser);
            AppLogger.info('✅ New user created with default role: ${newUser.role}');
            return Success<User?>(newUser);
          }

          AppLogger.info('✅ User document exists, loading...');
          final userModel = UserModel.fromFirestore(userDoc);
          final user = userModel.toEntity();
          AppLogger.info('✅ User loaded - Role: ${user.role}, isAdmin: ${user.isAdmin}');
          return Success<User?>(user);
        } catch (e, stackTrace) {
          AppLogger.error('Error getting current user', e, stackTrace);
          return Failure<User?>(AppFirebaseException('Failed to get user: ${e.toString()}'));
        }
      });
    });
  }

  @override
  Future<Result<User>> signInWithGoogle() async {
    try {
      // Get Google credential
      final credentialResult = await _authDataSource.signInWithGoogle();
      if (credentialResult.isFailure) {
        return Failure(credentialResult.exceptionOrNull as Exception);
      }

      final credential = (credentialResult as Success<dynamic>).data as firebase_auth.AuthCredential;

      // Sign in with credential
      final signInResult = await _authDataSource.signInWithCredential(credential);
      if (signInResult.isFailure) {
        return Failure(signInResult.exceptionOrNull as Exception);
      }

      final userCredential = (signInResult as Success<firebase_auth.UserCredential>).data;
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return const Failure(AuthException('User is null after sign in'));
      }

      // Check if user document exists
      final userDoc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      User user;

      if (userDoc.exists) {
        // Update existing user
        final userModel = UserModel.fromFirestore(userDoc);
        final existingUser = userModel.toEntity();
        user = existingUser.copyWith(
              name: firebaseUser.displayName ?? existingUser.name,
              email: firebaseUser.email ?? existingUser.email,
              photoUrl: firebaseUser.photoURL ?? existingUser.photoUrl,
            );
        await updateUserDocument(user);
      } else {
        // Create new user
        user = User(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
        );
        await createUserDocument(user);
      }

      return Success(user);
    } catch (e, stackTrace) {
      AppLogger.error('Sign in with Google error', e, stackTrace);
      return Failure(AuthException('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User>> signInWithEmailPassword(String email, String password) async {
    try {
      final signInResult = await _authDataSource.signInWithEmailPassword(email, password);
      if (signInResult.isFailure) {
        return Failure(signInResult.exceptionOrNull as Exception);
      }

      final userCredential = (signInResult as Success<firebase_auth.UserCredential>).data;
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return const Failure(AuthException('User is null after sign in'));
      }

      // Check if user document exists
      AppLogger.info('🔍 Sign in - Firebase UID: ${firebaseUser.uid}');
      AppLogger.info('🔍 Sign in - Email: ${firebaseUser.email}');
      
      final userDoc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      User user;

      if (userDoc.exists) {
        AppLogger.info('✅ User document exists in Firestore');
        final userModel = UserModel.fromFirestore(userDoc);
        user = userModel.toEntity();
        AppLogger.info('✅ User loaded - Role: ${user.role}, isAdmin: ${user.isAdmin}');
      } else {
        AppLogger.info('⚠️ User document NOT found, creating new one');
        // Create new user document
        user = User(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? email,
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
        );
        await createUserDocument(user);
        AppLogger.info('✅ New user document created with default role: ${user.role}');
      }

      return Success(user);
    } catch (e, stackTrace) {
      AppLogger.error('Sign in with email/password error', e, stackTrace);
      return Failure(AuthException('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User>> signUpWithEmailPassword(String email, String password, String name) async {
    try {
      final signUpResult = await _authDataSource.signUpWithEmailPassword(email, password);
      if (signUpResult.isFailure) {
        return Failure(signUpResult.exceptionOrNull as Exception);
      }

      final userCredential = (signUpResult as Success<firebase_auth.UserCredential>).data;
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return const Failure(AuthException('User is null after sign up'));
      }

      // Update display name
      await firebaseUser.updateDisplayName(name).catchError((e) {
        AppLogger.error('Failed to update display name', e);
      });

      // Create user document
      final user = User(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        photoUrl: null,
        createdAt: DateTime.now(),
      );
      await createUserDocument(user);

      return Success(user);
    } catch (e, stackTrace) {
      AppLogger.error('Sign up with email/password error', e, stackTrace);
      return Failure(AuthException('Failed to sign up: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    return await _authDataSource.signOut();
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      final user = _authDataSource.getCurrentUser();
      return Success(user != null);
    } catch (e, stackTrace) {
      AppLogger.error('Check authentication error', e, stackTrace);
      return Failure(AuthException('Failed to check authentication: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User>> getUserById(String uid) async {
    try {
      final userDoc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        return const Failure(AppFirebaseException('User not found'));
      }

      final userModel = UserModel.fromFirestore(userDoc);
      return Success(userModel.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Get user by ID error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<Result<User>> updateUser(User user) async {
    try {
      await updateUserDocument(user);
      return Success(user);
    } catch (e, stackTrace) {
      AppLogger.error('Update user error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to update user: ${e.toString()}'));
    }
  }

  /// Create user document in Firestore
  Future<void> createUserDocument(User user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toFirestore());
  }

  /// Update user document in Firestore
  Future<void> updateUserDocument(User user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .update(userModel.toFirestore());
  }
}


