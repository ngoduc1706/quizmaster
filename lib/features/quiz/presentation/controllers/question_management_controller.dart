import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';

part 'question_management_controller.g.dart';

/// Questions for a quiz provider
@riverpod
Future<List<Question>> quizQuestions(QuizQuestionsRef ref, String quizId) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.getQuestions(quizId);

  return switch (result) {
    Success(data: final data) => data,
    Failure(exception: final exception) => throw exception,
  };
}

/// Create question provider
@riverpod
Future<Question> createQuestion(CreateQuestionRef ref, Question question) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.createQuestion(question);

  return switch (result) {
    Success(data: final data) => data,
    Failure(exception: final exception) => throw exception,
  };
}

/// Update question provider
@riverpod
Future<Question> updateQuestion(UpdateQuestionRef ref, Question question) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.updateQuestion(question);

  return switch (result) {
    Success(data: final data) => data,
    Failure(exception: final exception) => throw exception,
  };
}

/// Delete question provider
@riverpod
Future<void> deleteQuestion(DeleteQuestionRef ref, String questionId) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.deleteQuestion(questionId);

  return switch (result) {
    Success() => null,
    Failure(exception: final exception) => throw exception,
  };
}

