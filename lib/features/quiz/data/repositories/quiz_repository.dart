import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/quiz/data/models/question_model.dart';
import 'package:doanlaptrinh/features/quiz/data/models/quiz_model.dart';
import 'package:doanlaptrinh/features/quiz/data/models/result_model.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/domain/repositories/quiz_repository_interface.dart';
import 'package:uuid/uuid.dart';

/// Quiz repository implementation
class QuizRepository implements QuizRepositoryInterface {
  QuizRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  @override
  Future<Result<Quiz>> getQuizById(String quizId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .doc(quizId)
          .get();

      if (!doc.exists) {
        return const Failure(AppFirebaseException('Quiz not found'));
      }

      final model = QuizModel.fromFirestore(doc);
      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Get quiz by ID error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get quiz: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Quiz>>> getQuizzes({
    int limit = 20,
    String? startAfter,
    String? categoryId,
    String? difficulty,
    String? searchQuery,
    bool? isPublic,
  }) async {
    try {
      Query query = _firestore.collection(FirebaseConstants.quizzesCollection);

      // Apply filters
      if (isPublic != null) {
        query = query.where(FirebaseConstants.quizIsPublic, isEqualTo: isPublic);
      }
      if (categoryId != null) {
        query = query.where(FirebaseConstants.quizCategoryId, isEqualTo: categoryId);
      }
      if (difficulty != null) {
        query = query.where(FirebaseConstants.quizDifficulty, isEqualTo: difficulty);
      }

      // Order by createdAt descending
      query = query.orderBy(FirebaseConstants.quizCreatedAt, descending: true);

      // Pagination
      if (startAfter != null) {
        final startAfterDoc = await _firestore
            .collection(FirebaseConstants.quizzesCollection)
            .doc(startAfter)
            .get();
        if (startAfterDoc.exists) {
          query = query.startAfterDocument(startAfterDoc);
        }
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final quizzes = snapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc).toEntity())
          .toList();

      // Apply search filter in memory if needed
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        return Success(quizzes.where((quiz) {
          return quiz.title.toLowerCase().contains(lowerQuery) ||
              (quiz.description?.toLowerCase().contains(lowerQuery) ?? false) ||
              quiz.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        }).toList());
      }

      return Success(quizzes);
    } catch (e, stackTrace) {
      AppLogger.error('Get quizzes error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get quizzes: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Quiz>>> getUserQuizzes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .where(FirebaseConstants.quizOwnerId, isEqualTo: userId)
          .orderBy(FirebaseConstants.quizCreatedAt, descending: true)
          .get();

      final quizzes = snapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc).toEntity())
          .toList();

      return Success(quizzes);
    } catch (e, stackTrace) {
      AppLogger.error('Get user quizzes error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get user quizzes: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Quiz>> createQuiz(Quiz quiz) async {
    try {
      final model = QuizModel.fromEntity(quiz.copyWith(id: _uuid.v4()));
      await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .doc(model.id)
          .set(model.toFirestore());

      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Create quiz error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to create quiz: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Quiz>> updateQuiz(Quiz quiz) async {
    try {
      final model = QuizModel.fromEntity(
        quiz.copyWith(updatedAt: DateTime.now()),
      );
      await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .doc(quiz.id)
          .update(model.toFirestore());

      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Update quiz error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to update quiz: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteQuiz(String quizId) async {
    try {
      // Delete quiz
      await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .doc(quizId)
          .delete();

      // Delete all questions
      final questionsSnapshot = await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .where(FirebaseConstants.questionQuizId, isEqualTo: quizId)
          .get();

      final batch = _firestore.batch();
      for (final doc in questionsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Delete quiz error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to delete quiz: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Question>>> getQuestions(String quizId) async {
    try {
      // Query without orderBy to avoid index requirement
      final snapshot = await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .where(FirebaseConstants.questionQuizId, isEqualTo: quizId)
          .get();

      final questions = snapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc).toEntity())
          .toList();

      // Sort in memory by order field
      questions.sort((a, b) => a.order.compareTo(b.order));

      return Success(questions);
    } catch (e, stackTrace) {
      AppLogger.error('Get questions error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get questions: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Question>> createQuestion(Question question) async {
    try {
      final model = QuestionModel.fromEntity(question.copyWith(id: _uuid.v4()));
      await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .doc(model.id)
          .set(model.toFirestore());

      // Update quiz question count
      await _updateQuizQuestionCount(question.quizId);

      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Create question error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to create question: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Question>> updateQuestion(Question question) async {
    try {
      final model = QuestionModel.fromEntity(question);
      await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .doc(question.id)
          .update(model.toFirestore());

      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Update question error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to update question: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteQuestion(String questionId) async {
    try {
      final questionDoc = await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .doc(questionId)
          .get();

      if (!questionDoc.exists) {
        return const Failure(AppFirebaseException('Question not found'));
      }

      final quizId = questionDoc.data()![FirebaseConstants.questionQuizId] as String;

      await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .doc(questionId)
          .delete();

      // Update quiz question count
      await _updateQuizQuestionCount(quizId);

      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error('Delete question error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to delete question: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Question>>> batchCreateQuestions(List<Question> questions) async {
    try {
      final batch = _firestore.batch();
      String? quizId;

      for (var question in questions) {
        final model = QuestionModel.fromEntity(question.copyWith(id: _uuid.v4()));
        quizId = model.quizId;
        final docRef = _firestore
            .collection(FirebaseConstants.questionsCollection)
            .doc(model.id);
        batch.set(docRef, model.toFirestore());
      }

      await batch.commit();

      // Update quiz question count
      if (quizId != null) {
        await _updateQuizQuestionCount(quizId);
      }

      final createdQuestions = questions.map((q) => q.copyWith(id: _uuid.v4())).toList();
      return Success(createdQuestions);
    } catch (e, stackTrace) {
      AppLogger.error('Batch create questions error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to create questions: ${e.toString()}'));
    }
  }

  @override
  Future<Result<QuizResult>> submitQuizResult(QuizResult result) async {
    try {
      final model = ResultModel.fromEntity(result.copyWith(id: _uuid.v4()));
      await _firestore
          .collection(FirebaseConstants.resultsCollection)
          .doc(model.id)
          .set(model.toFirestore());

      // Update quiz stats in background (don't wait for it)
      _updateQuizStats(result.quizId, result.score, result.accuracy).catchError((e) {
        AppLogger.error('Update quiz stats error (background)', e);
      });

      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Submit quiz result error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to submit result: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<QuizResult>>> getUserResults(String userId) async {
    try {
      // Query without orderBy to avoid index requirement
      final snapshot = await _firestore
          .collection(FirebaseConstants.resultsCollection)
          .where(FirebaseConstants.resultUserId, isEqualTo: userId)
          .get();

      final results = snapshot.docs
          .map((doc) => ResultModel.fromFirestore(doc).toEntity())
          .toList();

      // Sort in memory by completedAt descending
      results.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      return Success(results);
    } catch (e, stackTrace) {
      AppLogger.error('Get user results error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get user results: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<QuizResult>>> getQuizResults(String quizId) async {
    try {
      // Query without orderBy to avoid index requirement
      final snapshot = await _firestore
          .collection(FirebaseConstants.resultsCollection)
          .where(FirebaseConstants.resultQuizId, isEqualTo: quizId)
          .get();

      final results = snapshot.docs
          .map((doc) => ResultModel.fromFirestore(doc).toEntity())
          .toList();

      // Sort in memory by completedAt descending
      results.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      return Success(results);
    } catch (e, stackTrace) {
      AppLogger.error('Get quiz results error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get quiz results: ${e.toString()}'));
    }
  }

  @override
  Future<Result<QuizResult?>> getLatestUserQuizResult(String userId, String quizId) async {
    try {
      // Query results for this user and quiz
      final snapshot = await _firestore
          .collection(FirebaseConstants.resultsCollection)
          .where(FirebaseConstants.resultUserId, isEqualTo: userId)
          .where(FirebaseConstants.resultQuizId, isEqualTo: quizId)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Success(null);
      }

      final results = snapshot.docs
          .map((doc) => ResultModel.fromFirestore(doc).toEntity())
          .toList();

      // Sort in memory by completedAt descending and get the latest
      results.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      return Success(results.isNotEmpty ? results.first : null);
    } catch (e, stackTrace) {
      AppLogger.error('Get latest user quiz result error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get latest result: ${e.toString()}'));
    }
  }

  /// Update quiz question count
  Future<void> _updateQuizQuestionCount(String quizId) async {
    try {
      final questionsSnapshot = await _firestore
          .collection(FirebaseConstants.questionsCollection)
          .where(FirebaseConstants.questionQuizId, isEqualTo: quizId)
          .get();

      await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .doc(quizId)
          .update({
        FirebaseConstants.quizQuestionCount: questionsSnapshot.docs.length,
      });
    } catch (e) {
      AppLogger.error('Update quiz question count error', e);
    }
  }

  /// Update quiz stats
  Future<void> _updateQuizStats(String quizId, int score, double accuracy) async {
    try {
      final resultsSnapshot = await _firestore
          .collection(FirebaseConstants.resultsCollection)
          .where(FirebaseConstants.resultQuizId, isEqualTo: quizId)
          .get();

      final results = resultsSnapshot.docs
          .map((doc) => ResultModel.fromFirestore(doc))
          .toList();

      final totalPlays = results.length;
      final avgScore = results.isEmpty
          ? 0.0
          : results.map((r) => r.score).reduce((a, b) => a + b) / totalPlays;
      final completionRate = results.isEmpty
          ? 0.0
          : results.where((r) => r.accuracy > 0).length / totalPlays;

      await _firestore
          .collection(FirebaseConstants.quizzesCollection)
          .doc(quizId)
          .update({
        FirebaseConstants.quizStats: {
          'plays': totalPlays,
          'avgScore': avgScore,
          'completionRate': completionRate,
        },
      });
    } catch (e) {
      AppLogger.error('Update quiz stats error', e);
    }
  }
}


