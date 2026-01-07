import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/auth/domain/entities/user.dart';

/// User model for Firestore
class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.role = 'user',
    this.subscriptionTier = 'free',
    required this.createdAt,
    this.stats,
  });

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String role;
  final String subscriptionTier;
  final DateTime createdAt;
  final Map<String, dynamic>? stats;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final role = data[FirebaseConstants.userRole] as String? ?? 'user';
    final subscriptionTier = data[FirebaseConstants.userSubscriptionTier] as String? ?? 'free';
    
    // Debug logging
    print('🔍 Loading user from Firestore:');
    print('  UID: ${doc.id}');
    print('  Email: ${data[FirebaseConstants.userEmail]}');
    print('  Role from Firestore: $role');
    print('  SubscriptionTier from Firestore: $subscriptionTier');
    
    return UserModel(
      uid: doc.id,
      name: data[FirebaseConstants.userName] as String,
      email: data[FirebaseConstants.userEmail] as String,
      photoUrl: data[FirebaseConstants.userPhotoUrl] as String?,
      role: role,
      subscriptionTier: subscriptionTier,
      createdAt: (data[FirebaseConstants.userCreatedAt] as Timestamp).toDate(),
      stats: data[FirebaseConstants.userStats] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.userName: name,
      FirebaseConstants.userEmail: email,
      if (photoUrl != null) FirebaseConstants.userPhotoUrl: photoUrl,
      FirebaseConstants.userRole: role,
      FirebaseConstants.userSubscriptionTier: subscriptionTier,
      FirebaseConstants.userCreatedAt: Timestamp.fromDate(createdAt),
      if (stats != null) FirebaseConstants.userStats: stats,
    };
  }

  User toEntity() {
    final userRole = role == 'admin' ? UserRole.admin : UserRole.user;
    final userSubscriptionTier = subscriptionTier == 'pro' ? SubscriptionTier.pro : SubscriptionTier.free;
    
    // Debug logging
    print('🔍 Converting UserModel to Entity:');
    print('  Role string: $role → UserRole: $userRole');
    print('  SubscriptionTier string: $subscriptionTier → SubscriptionTier: $userSubscriptionTier');
    
    return User(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      role: userRole,
      subscriptionTier: userSubscriptionTier,
      createdAt: createdAt,
      stats: stats != null
          ? UserStats(
              quizzesCreated: stats!['quizzesCreated'] as int? ?? 0,
              quizzesTaken: stats!['quizzesTaken'] as int? ?? 0,
              totalScore: stats!['totalScore'] as int? ?? 0,
              level: stats!['level'] as int? ?? 1,
            )
          : const UserStats(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      role: user.role == UserRole.admin ? 'admin' : 'user',
      subscriptionTier: user.subscriptionTier == SubscriptionTier.pro ? 'pro' : 'free',
      createdAt: user.createdAt,
      stats: {
        'quizzesCreated': user.stats.quizzesCreated,
        'quizzesTaken': user.stats.quizzesTaken,
        'totalScore': user.stats.totalScore,
        'level': user.stats.level,
      },
    );
  }
}













