import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/ai/data/datasources/gemini_api_datasource.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';

/// Gemini repository
class GeminiRepository {
  GeminiRepository({
    required GeminiApiDataSource dataSource,
  }) : _dataSource = dataSource;

  final GeminiApiDataSource _dataSource;

  /// Generate quiz from topic
  Future<Result<GeneratedQuizData>> generateQuiz({
    required String topic,
    required int questionCount,
    String difficulty = 'medium',
    String language = 'en',
    List<String> questionTypes = const ['multipleChoice'],
  }) async {
    final result = await _dataSource.generateQuiz(
      topic: topic,
      questionCount: questionCount,
      difficulty: difficulty,
      language: language,
      questionTypes: questionTypes,
    );

    if (result.isFailure) {
      return Failure(result.exceptionOrNull as Exception);
    }

    try {
      final data = (result as Success<Map<String, dynamic>>).data;
      final generatedQuiz = _parseQuizData(data);
      return Success(generatedQuiz);
    } catch (e, stackTrace) {
      AppLogger.error('Parse generated quiz error', e, stackTrace);
      return Failure(Exception('Failed to parse generated quiz: ${e.toString()}'));
    }
  }

  GeneratedQuizData _parseQuizData(Map<String, dynamic> data) {
    final questions = <Question>[];
    final questionsData = data['questions'] as List;

    for (var i = 0; i < questionsData.length; i++) {
      final qData = questionsData[i] as Map<String, dynamic>;
      questions.add(Question(
        id: '', // Will be set when creating quiz
        quizId: '', // Will be set when creating quiz
        question: qData['question'] as String,
        type: qData['type'] == 'trueFalse'
            ? QuestionType.trueFalse
            : QuestionType.multipleChoice,
        options: List<String>.from(qData['options'] as List),
        correctAnswerIndex: qData['correctAnswerIndex'] as int,
        explanation: qData['explanation'] as String?,
        points: qData['points'] as int? ?? 10,
        timeLimit: qData['timeLimit'] as int?,
        order: i,
      ));
    }

    return GeneratedQuizData(
      title: data['title'] as String,
      description: data['description'] as String?,
      difficulty: _parseDifficulty(data['difficulty'] as String? ?? 'medium'),
      questions: questions,
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

/// Generated quiz data
class GeneratedQuizData {
  GeneratedQuizData({
    required this.title,
    this.description,
    required this.difficulty,
    required this.questions,
  });

  final String title;
  final String? description;
  final Difficulty difficulty;
  final List<Question> questions;
}















