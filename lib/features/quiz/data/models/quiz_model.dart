import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';

/// Quiz model for Firestore
class QuizModel {
  QuizModel({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    required this.ownerName,
    this.categoryId,
    this.difficulty = 'medium',
    this.isPublic = true,
    this.tags = const [],
    required this.questionCount,
    this.stats,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String ownerId;
  final String ownerName;
  final String? categoryId;
  final String difficulty;
  final bool isPublic;
  final List<String> tags;
  final int questionCount;
  final Map<String, dynamic>? stats;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      id: doc.id,
      title: data[FirebaseConstants.quizTitle] as String,
      description: data[FirebaseConstants.quizDescription] as String?,
      ownerId: data[FirebaseConstants.quizOwnerId] as String,
      ownerName: data[FirebaseConstants.quizOwnerName] as String,
      categoryId: data[FirebaseConstants.quizCategoryId] as String?,
      difficulty: data[FirebaseConstants.quizDifficulty] as String? ?? 'medium',
      isPublic: data[FirebaseConstants.quizIsPublic] as bool? ?? true,
      tags: List<String>.from(data[FirebaseConstants.quizTags] as List? ?? []),
      questionCount: data[FirebaseConstants.quizQuestionCount] as int? ?? 0,
      stats: data[FirebaseConstants.quizStats] as Map<String, dynamic>?,
      createdAt: (data[FirebaseConstants.quizCreatedAt] as Timestamp).toDate(),
      updatedAt: data[FirebaseConstants.quizUpdatedAt] != null
          ? (data[FirebaseConstants.quizUpdatedAt] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.quizTitle: title,
      if (description != null) FirebaseConstants.quizDescription: description,
      FirebaseConstants.quizOwnerId: ownerId,
      FirebaseConstants.quizOwnerName: ownerName,
      if (categoryId != null) FirebaseConstants.quizCategoryId: categoryId,
      FirebaseConstants.quizDifficulty: difficulty,
      FirebaseConstants.quizIsPublic: isPublic,
      FirebaseConstants.quizTags: tags,
      FirebaseConstants.quizQuestionCount: questionCount,
      if (stats != null) FirebaseConstants.quizStats: stats,
      FirebaseConstants.quizCreatedAt: Timestamp.fromDate(createdAt),
      if (updatedAt != null) FirebaseConstants.quizUpdatedAt: Timestamp.fromDate(updatedAt!),
    };
  }

  Quiz toEntity() {
    return Quiz(
      id: id,
      title: title,
      description: description,
      ownerId: ownerId,
      ownerName: ownerName,
      categoryId: categoryId,
      difficulty: _parseDifficulty(difficulty),
      isPublic: isPublic,
      tags: tags,
      questionCount: questionCount,
      stats: stats != null
          ? QuizStats(
              plays: stats!['plays'] as int? ?? 0,
              avgScore: (stats!['avgScore'] as num?)?.toDouble() ?? 0.0,
              completionRate: (stats!['completionRate'] as num?)?.toDouble() ?? 0.0,
            )
          : const QuizStats(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory QuizModel.fromEntity(Quiz quiz) {
    return QuizModel(
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      ownerId: quiz.ownerId,
      ownerName: quiz.ownerName,
      categoryId: quiz.categoryId,
      difficulty: quiz.difficulty.name,
      isPublic: quiz.isPublic,
      tags: quiz.tags,
      questionCount: quiz.questionCount,
      stats: {
        'plays': quiz.stats.plays,
        'avgScore': quiz.stats.avgScore,
        'completionRate': quiz.stats.completionRate,
      },
      createdAt: quiz.createdAt,
      updatedAt: quiz.updatedAt,
    );
  }

  Difficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.medium;
    }
  }
}














