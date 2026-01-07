import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/quiz_repository.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';

part 'quiz_edit_controller.g.dart';

/// Update quiz provider
@riverpod
Future<Result<Quiz>> updateQuiz(
  UpdateQuizRef ref,
  Quiz quiz,
) async {
  final repository = ref.read(quizRepositoryProvider);
  return await repository.updateQuiz(quiz);
}

/// Delete quiz provider
@riverpod
Future<Result<void>> deleteQuiz(
  DeleteQuizRef ref,
  String quizId,
) async {
  final repository = ref.read(quizRepositoryProvider);
  return await repository.deleteQuiz(quizId);
}
