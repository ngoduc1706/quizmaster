import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/quiz_repository.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';

part 'quiz_list_controller.g.dart';

/// Quiz list state
@riverpod
class QuizList extends _$QuizList {
  @override
  FutureOr<List<Quiz>> build({
    String? categoryId,
    String? difficulty,
    String? searchQuery,
    bool? isPublic,
  }) async {
    final repository = ref.watch(quizRepositoryProvider);
    final result = await repository.getQuizzes(
      categoryId: categoryId,
      difficulty: difficulty,
      searchQuery: searchQuery,
      isPublic: isPublic ?? true,
    );

    return switch (result) {
      Success(data: final data) => data,
      Failure(exception: final exception) => throw exception,
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(quizRepositoryProvider);
      final result = await repository.getQuizzes(
        categoryId: ref.read(quizListCategoryIdProvider),
        difficulty: ref.read(quizListDifficultyProvider),
        searchQuery: ref.read(quizListSearchQueryProvider),
        isPublic: ref.read(quizListIsPublicProvider) ?? true,
      );

      return switch (result) {
        Success(data: final data) => data,
        Failure(exception: final exception) => throw exception,
      };
    });
  }
}

/// Filters providers
@riverpod
String? quizListCategoryId(QuizListCategoryIdRef ref) => null;

@riverpod
String? quizListDifficulty(QuizListDifficultyRef ref) => null;

@riverpod
String? quizListSearchQuery(QuizListSearchQueryRef ref) => null;

@riverpod
bool? quizListIsPublic(QuizListIsPublicRef ref) => true;

/// User quizzes provider
@riverpod
Future<List<Quiz>> userQuizzes(UserQuizzesRef ref, String userId) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.getUserQuizzes(userId);

  return switch (result) {
    Success(data: final data) => data,
    Failure(exception: final exception) => throw exception,
  };
}

/// Quiz by ID provider
@riverpod
Future<Quiz> quizById(QuizByIdRef ref, String quizId) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.getQuizById(quizId);

  return result.fold(
    onSuccess: (quiz) => quiz,
    onFailure: (exception) => throw exception,
  );
}

/// User quiz results provider
@riverpod
Future<List<QuizResult>> userResults(UserResultsRef ref, String userId) async {
  final repository = ref.watch(quizRepositoryProvider);
  final result = await repository.getUserResults(userId);

  return switch (result) {
    Success(data: final data) => data,
    Failure(exception: final exception) => throw exception,
  };
}


