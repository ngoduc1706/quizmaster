
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';

/// Quiz repository interface
abstract class QuizRepositoryInterface {
  /// Get quiz by ID
  Future<Result<Quiz>> getQuizById(String quizId);

  /// Get quizzes with pagination and filters
  Future<Result<List<Quiz>>> getQuizzes({
    int limit = 20,
    String? startAfter,
    String? categoryId,
    String? difficulty,
    String? searchQuery,
    bool? isPublic,
  });

  /// Get user's quizzes
  Future<Result<List<Quiz>>> getUserQuizzes(String userId);

  /// Create quiz
  Future<Result<Quiz>> createQuiz(Quiz quiz);

  /// Update quiz
  Future<Result<Quiz>> updateQuiz(Quiz quiz);

  /// Delete quiz
  Future<Result<void>> deleteQuiz(String quizId);

  /// Get questions for a quiz
  Future<Result<List<Question>>> getQuestions(String quizId);

  /// Create question
  Future<Result<Question>> createQuestion(Question question);

  /// Update question
  Future<Result<Question>> updateQuestion(Question question);

  /// Delete question
  Future<Result<void>> deleteQuestion(String questionId);

  /// Batch create questions
  Future<Result<List<Question>>> batchCreateQuestions(List<Question> questions);

  /// Submit quiz result
  Future<Result<QuizResult>> submitQuizResult(QuizResult result);

  /// Get user's quiz results
  Future<Result<List<QuizResult>>> getUserResults(String userId);

  /// Get quiz results
  Future<Result<List<QuizResult>>> getQuizResults(String quizId);

  /// Get latest quiz result for a user and quiz
  Future<Result<QuizResult?>> getLatestUserQuizResult(String userId, String quizId);
}








