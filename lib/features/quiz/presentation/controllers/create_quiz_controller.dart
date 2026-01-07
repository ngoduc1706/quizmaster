import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/constants/app_constants.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/quiz_repository.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';
import 'package:uuid/uuid.dart';

part 'create_quiz_controller.g.dart';

/// Create quiz controller
@riverpod
class CreateQuiz extends _$CreateQuiz {
  final _uuid = const Uuid();

  @override
  CreateQuizState build() {
    return CreateQuizState(
      title: '',
      description: '',
      categoryId: null,
      difficulty: Difficulty.medium,
      isPublic: true,
      tags: [],
      questions: [],
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void updateDifficulty(Difficulty difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void updateIsPublic(bool isPublic) {
    state = state.copyWith(isPublic: isPublic);
  }

  void addTag(String tag) {
    if (!state.tags.contains(tag)) {
      state = state.copyWith(tags: [...state.tags, tag]);
    }
  }

  void removeTag(String tag) {
    state = state.copyWith(tags: state.tags.where((t) => t != tag).toList());
  }

  void addQuestion(Question question) {
    final newQuestion = question.copyWith(
      id: _uuid.v4(),
      quizId: '', // Will be set when quiz is created
      order: state.questions.length,
    );
    state = state.copyWith(questions: [...state.questions, newQuestion]);
  }

  void updateQuestion(int index, Question question) {
    final updated = List<Question>.from(state.questions);
    updated[index] = question;
    state = state.copyWith(questions: updated);
  }

  void removeQuestion(int index) {
    final updated = List<Question>.from(state.questions);
    updated.removeAt(index);
    // Reorder questions
    for (var i = 0; i < updated.length; i++) {
      updated[i] = updated[i].copyWith(order: i);
    }
    state = state.copyWith(questions: updated);
  }

  void reorderQuestions(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final updated = List<Question>.from(state.questions);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    // Reorder
    for (var i = 0; i < updated.length; i++) {
      updated[i] = updated[i].copyWith(order: i);
    }
    state = state.copyWith(questions: updated);
  }

  Future<Result<Quiz>> saveQuiz() async {
    // Validate
    if (state.title.trim().isEmpty) {
      return const Failure(ValidationException('Title is required'));
    }
    if (state.title.length > AppConstants.maxTitleLength) {
      return Failure(ValidationException(
        'Title must not exceed ${AppConstants.maxTitleLength} characters',
      ));
    }
    if (state.questions.length < AppConstants.minQuestionsPerQuiz) {
      return Failure(ValidationException(
        'Quiz must have at least ${AppConstants.minQuestionsPerQuiz} question',
      ));
    }
    if (state.questions.length > AppConstants.maxQuestionsPerQuiz) {
      return Failure(ValidationException(
        'Quiz cannot have more than ${AppConstants.maxQuestionsPerQuiz} questions',
      ));
    }

    // Validate all questions
    for (var question in state.questions) {
      if (!question.isValid) {
        return const Failure(ValidationException('All questions must be valid'));
      }
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      return const Failure(AuthException('User not authenticated'));
    }

    final repository = ref.read(quizRepositoryProvider);

    // Create quiz
    final quiz = Quiz(
      id: _uuid.v4(),
      title: state.title.trim(),
      description: state.description.trim().isEmpty ? null : state.description.trim(),
      ownerId: user.uid,
      ownerName: user.name,
      categoryId: state.categoryId,
      difficulty: state.difficulty,
      isPublic: state.isPublic,
      tags: state.tags,
      questionCount: state.questions.length,
      createdAt: DateTime.now(),
    );

    final quizResult = await repository.createQuiz(quiz);
    if (quizResult.isFailure) {
      return Failure(quizResult.exceptionOrNull as Exception);
    }

    final createdQuiz = (quizResult as Success<Quiz>).data;

    // Create questions
    final questionsWithQuizId = state.questions
        .map((q) => q.copyWith(quizId: createdQuiz.id))
        .toList();

    final questionsResult = await repository.batchCreateQuestions(questionsWithQuizId);
    if (questionsResult.isFailure) {
      // Rollback: delete quiz
      await repository.deleteQuiz(createdQuiz.id);
      return Failure(questionsResult.exceptionOrNull as Exception);
    }

    // Reset state
    state = build();

    return Success(createdQuiz);
  }
}

/// Create quiz state
class CreateQuizState {
  const CreateQuizState({
    required this.title,
    required this.description,
    this.categoryId,
    this.difficulty = Difficulty.medium,
    this.isPublic = true,
    this.tags = const [],
    this.questions = const [],
  });

  final String title;
  final String description;
  final String? categoryId;
  final Difficulty difficulty;
  final bool isPublic;
  final List<String> tags;
  final List<Question> questions;

  CreateQuizState copyWith({
    String? title,
    String? description,
    String? categoryId,
    Difficulty? difficulty,
    bool? isPublic,
    List<String>? tags,
    List<Question>? questions,
  }) {
    return CreateQuizState(
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      difficulty: difficulty ?? this.difficulty,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      questions: questions ?? this.questions,
    );
  }
}








