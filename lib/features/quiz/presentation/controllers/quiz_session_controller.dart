import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/formatters.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/quiz_repository.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';
import 'package:uuid/uuid.dart';

part 'quiz_session_controller.g.dart';

/// Quiz session controller
@riverpod
class QuizSession extends _$QuizSession {
  final _uuid = const Uuid();

  @override
  QuizSessionState build(String quizId) {
    return const QuizSessionState(
      quizId: '',
      currentIndex: 0,
      answers: [],
      startedAt: null,
      isCompleted: false,
    );
  }

  Future<void> initialize(String quizId) async {
    final repository = ref.read(quizRepositoryProvider);
    final quizResult = await repository.getQuizById(quizId);
    final questionsResult = await repository.getQuestions(quizId);

    if (quizResult.isFailure || questionsResult.isFailure) {
      final exception = quizResult.exceptionOrNull ?? questionsResult.exceptionOrNull;
      throw exception ?? Exception('Failed to initialize quiz');
    }

    final quiz = (quizResult as Success<Quiz>).data;
    final questions = (questionsResult as Success<List<Question>>).data;

    state = QuizSessionState(
      quizId: quizId,
      currentIndex: 0,
      answers: [],
      startedAt: DateTime.now(),
      isCompleted: false,
      quiz: quiz,
      questions: questions,
    );
  }

  void selectAnswer(int selectedIndex) {
    if (state.isCompleted || state.questions == null) return;

    final currentQuestion = state.questions![state.currentIndex];
    final existingAnswerIndex = state.answers
        .indexWhere((a) => a.questionId == currentQuestion.id);

    final answer = Answer(
      questionId: currentQuestion.id,
      selectedIndex: selectedIndex,
      isCorrect: selectedIndex == currentQuestion.correctAnswerIndex,
    );

    if (existingAnswerIndex >= 0) {
      final updated = List<Answer>.from(state.answers);
      updated[existingAnswerIndex] = answer;
      state = state.copyWith(answers: updated);
    } else {
      state = state.copyWith(answers: [...state.answers, answer]);
    }
  }

  void nextQuestion() {
    if (state.questions == null) return;
    if (state.currentIndex < state.questions!.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void goToQuestion(int index) {
    if (state.questions == null) return;
    if (index >= 0 && index < state.questions!.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  Future<Result<QuizResult>> submitQuiz() async {
    if (state.questions == null || state.startedAt == null) {
      return Failure(Exception('Quiz not initialized'));
    }

    final completedAt = DateTime.now();
    final timeSpent = completedAt.difference(state.startedAt!).inSeconds;

    // Calculate score and accuracy
    int totalScore = 0;
    int correctAnswers = 0;
    final answersDetails = <AnswerDetail>[];

    for (var i = 0; i < state.questions!.length; i++) {
      final question = state.questions![i];
      final answer = state.answers.firstWhere(
        (a) => a.questionId == question.id,
        orElse: () => Answer(
          questionId: question.id,
          selectedIndex: -1,
          isCorrect: false,
        ),
      );

      final isCorrect = answer.selectedIndex == question.correctAnswerIndex;
      if (isCorrect) {
        totalScore += question.points;
        correctAnswers++;
      }

      answersDetails.add(AnswerDetail(
        questionId: question.id,
        selectedIndex: answer.selectedIndex,
        correctIndex: question.correctAnswerIndex,
        isCorrect: isCorrect,
        timeSpent: answer.timeSpent ?? 0,
      ));
    }

    final accuracy = state.questions!.isEmpty
        ? 0.0
        : correctAnswers / state.questions!.length.toDouble();

    final grade = _calculateGrade(accuracy);

    final user = ref.read(currentUserProvider);
    if (user == null) {
      return Failure(Exception('User not authenticated'));
    }

    final result = QuizResult(
      id: _uuid.v4(),
      userId: user.uid,
      quizId: state.quizId,
      score: totalScore,
      accuracy: accuracy,
      timeSpent: timeSpent,
      grade: grade,
      answersDetails: answersDetails,
      completedAt: completedAt,
    );

    // Mark as completed immediately
    state = state.copyWith(isCompleted: true);

    // Save to Firestore in background (don't wait for it)
    final repository = ref.read(quizRepositoryProvider);
    repository.submitQuizResult(result).then((submitResult) {
      if (submitResult.isFailure) {
        // Log error but don't block UI
        AppLogger.error('Failed to save quiz result to Firestore', submitResult.exceptionOrNull);
      }
    }).catchError((e) {
      AppLogger.error('Error saving quiz result', e);
    });

    // Return result immediately without waiting for Firestore
    return Success(result);
  }

  String _calculateGrade(double accuracy) {
    if (accuracy >= 0.9) return 'A+';
    if (accuracy >= 0.8) return 'A';
    if (accuracy >= 0.7) return 'B';
    if (accuracy >= 0.6) return 'C';
    if (accuracy >= 0.5) return 'D';
    return 'F';
  }
}

/// Quiz session state
class QuizSessionState {
  const QuizSessionState({
    required this.quizId,
    required this.currentIndex,
    required this.answers,
    this.startedAt,
    this.isCompleted = false,
    this.quiz,
    this.questions,
  });

  final String quizId;
  final int currentIndex;
  final List<Answer> answers;
  final DateTime? startedAt;
  final bool isCompleted;
  final Quiz? quiz;
  final List<Question>? questions;

  QuizSessionState copyWith({
    String? quizId,
    int? currentIndex,
    List<Answer>? answers,
    DateTime? startedAt,
    bool? isCompleted,
    Quiz? quiz,
    List<Question>? questions,
  }) {
    return QuizSessionState(
      quizId: quizId ?? this.quizId,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      quiz: quiz ?? this.quiz,
      questions: questions ?? this.questions,
    );
  }

  Question? get currentQuestion {
    if (questions == null || currentIndex >= questions!.length) return null;
    return questions![currentIndex];
  }

  Answer? get currentAnswer {
    if (currentQuestion == null) return null;
    return answers.firstWhere(
      (a) => a.questionId == currentQuestion!.id,
      orElse: () => Answer(
        questionId: currentQuestion!.id,
        selectedIndex: -1,
      ),
    );
  }

  int get progress {
    if (questions == null || questions!.isEmpty) return 0;
    return ((currentIndex + 1) / questions!.length * 100).round();
  }

  bool get canGoNext => currentIndex < (questions?.length ?? 0) - 1;
  bool get canGoPrevious => currentIndex > 0;
  bool get isLastQuestion => currentIndex == (questions?.length ?? 0) - 1;
}


