import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  const User({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.role = UserRole.user,
    this.subscriptionTier = SubscriptionTier.free,
    required this.createdAt,
    this.stats = const UserStats(),
  });

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final UserRole role;
  final SubscriptionTier subscriptionTier;
  final DateTime createdAt;
  final UserStats stats;

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    UserRole? role,
    SubscriptionTier? subscriptionTier,
    DateTime? createdAt,
    UserStats? stats,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt ?? this.createdAt,
      stats: stats ?? this.stats,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isPro => subscriptionTier == SubscriptionTier.pro;

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        photoUrl,
        role,
        subscriptionTier,
        createdAt,
        stats,
      ];
}

/// User role enum
enum UserRole {
  user,
  admin,
}

/// Subscription tier enum
enum SubscriptionTier {
  free,
  pro,
}

/// User statistics
class UserStats extends Equatable {
  const UserStats({
    this.quizzesCreated = 0,
    this.quizzesTaken = 0,
    this.totalScore = 0,
    this.level = 1,
  });

  final int quizzesCreated;
  final int quizzesTaken;
  final int totalScore;
  final int level;

  UserStats copyWith({
    int? quizzesCreated,
    int? quizzesTaken,
    int? totalScore,
    int? level,
  }) {
    return UserStats(
      quizzesCreated: quizzesCreated ?? this.quizzesCreated,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      totalScore: totalScore ?? this.totalScore,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [quizzesCreated, quizzesTaken, totalScore, level];
}













