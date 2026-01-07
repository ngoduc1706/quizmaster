import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/auth/data/models/user_model.dart';

/// Service to setup default admin user
class AdminSetupService {
  AdminSetupService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Create default admin user
  /// Email: a@gmail.com
  /// Password: 12345vh
  Future<bool> createDefaultAdmin() async {
    try {
      const adminEmail = 'a@gmail.com';
      const adminPassword = '12345vh';
      const adminName = 'Admin';

      // Check if admin already exists
      try {
        await _auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Network timeout');
          },
        );
        
        // Admin exists, check if role is admin
        final user = _auth.currentUser;
        if (user != null) {
          final userDoc = await _firestore
              .collection(FirebaseConstants.usersCollection)
              .doc(user.uid)
              .get();
          
          if (userDoc.exists) {
            final data = userDoc.data()!;
            if (data[FirebaseConstants.userRole] == 'admin') {
              AppLogger.info('Admin user already exists');
              await _auth.signOut();
              return true;
            }
          }
          
          // Update to admin role
          await _firestore
              .collection(FirebaseConstants.usersCollection)
              .doc(user.uid)
              .update({
            FirebaseConstants.userRole: 'admin',
            FirebaseConstants.userName: adminName,
          });
          
          AppLogger.info('Updated user to admin role');
          await _auth.signOut();
          return true;
        }
      } catch (e) {
        // Check if it's a network error
        if (e.toString().contains('network') || 
            e.toString().contains('timeout') ||
            e.toString().contains('unreachable')) {
          AppLogger.info('Network error during admin setup, skipping...');
          return false; // Don't create admin if network is unavailable
        }
        // User doesn't exist, create new
        AppLogger.info('Creating new admin user...');
      }

      // Create new admin user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Network timeout');
        },
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Create user document with admin role
      final userModel = UserModel(
        uid: user.uid,
        name: adminName,
        email: adminEmail,
        role: 'admin',
        subscriptionTier: 'pro',
        createdAt: DateTime.now(),
        stats: {
          'quizzesCreated': 0,
          'quizzesTaken': 0,
          'totalScore': 0,
          'level': 1,
        },
      );

      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toFirestore());

      AppLogger.info('Admin user created successfully');
      await _auth.signOut();
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create admin user', e, stackTrace);
      return false;
    }
  }

  /// Check if default admin exists
  Future<bool> adminExists() async {
    try {
      const adminEmail = 'a@gmail.com';
      final users = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FirebaseConstants.userEmail, isEqualTo: adminEmail)
          .where(FirebaseConstants.userRole, isEqualTo: 'admin')
          .limit(1)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Network timeout');
            },
          );
      
      return users.docs.isNotEmpty;
    } catch (e) {
      // Return false on network errors to allow retry later
      if (e.toString().contains('network') || 
          e.toString().contains('timeout') ||
          e.toString().contains('unreachable')) {
        AppLogger.info('Network error checking admin, will retry later');
      }
      return false;
    }
  }
}

