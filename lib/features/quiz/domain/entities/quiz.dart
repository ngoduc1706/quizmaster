import 'package:equatable/equatable.dart';

/// Quiz entity
class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.title,
    this.description,
    required this.ownerId,
    required this.ownerName,
    this.categoryId,
    this.difficulty = Difficulty.medium,
    this.isPublic = true,
    this.tags = const [],
    required this.questionCount,
    this.stats = const QuizStats(),
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String ownerId;
  final String ownerName;
  final String? categoryId;
  final Difficulty difficulty;
  final bool isPublic;
  final List<String> tags;
  final int questionCount;
  final QuizStats stats;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? ownerId,
    String? ownerName,
    String? categoryId,
    Difficulty? difficulty,
    bool? isPublic,
    List<String>? tags,
    int? questionCount,
    QuizStats? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      questionCount: questionCount ?? this.questionCount,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        ownerId,
        ownerName,
        categoryId,
        difficulty,
        isPublic,
        tags,
        questionCount,
        stats,
        createdAt,
        updatedAt,
      ];
}

/// Difficulty enum
enum Difficulty {
  easy,
  medium,
  hard,
}

/// Quiz statistics
class QuizStats extends Equatable {
  const QuizStats({
    this.plays = 0,
    this.avgScore = 0.0,
    this.completionRate = 0.0,
  });

  final int plays;
  final double avgScore;
  final double completionRate;

  QuizStats copyWith({
    int? plays,
    double? avgScore,
    double? completionRate,
  }) {
    return QuizStats(
      plays: plays ?? this.plays,
      avgScore: avgScore ?? this.avgScore,
      completionRate: completionRate ?? this.completionRate,
    );
  }

  @override
  List<Object?> get props => [plays, avgScore, completionRate];
}













