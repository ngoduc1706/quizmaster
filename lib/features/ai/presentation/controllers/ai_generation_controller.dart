import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/constants/app_constants.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/ai/data/datasources/gemini_api_datasource.dart';
import 'package:doanlaptrinh/features/ai/data/repositories/gemini_repository.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:dio/dio.dart';

part 'ai_generation_controller.g.dart';

/// AI generation controller
@riverpod
class AIGeneration extends _$AIGeneration {
  @override
  AIGenerationState build() {
    return const AIGenerationState(
      topic: '',
      questionCount: 10,
      difficulty: 'medium',
      language: 'en',
      questionTypes: ['multipleChoice'],
    );
  }

  void updateTopic(String topic) {
    state = state.copyWith(topic: topic);
  }

  void updateQuestionCount(int count) {
    if (count >= AppConstants.minQuestionsPerQuiz &&
        count <= AppConstants.maxQuestionsPerQuiz) {
      state = state.copyWith(questionCount: count);
    }
  }

  void updateDifficulty(String difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
  }

  Future<Result<GeneratedQuizData>> generateQuiz() async {
    if (state.topic.trim().isEmpty) {
      return const Failure(ValidationException('Topic is required'));
    }

    // TODO: Check quota
    // final user = ref.read(currentUserProvider);
    // if (user != null && !_checkQuota(user)) {
    //   return const Failure(QuotaException.aiLimitReached());
    // }

    final repository = GeminiRepository(
      dataSource: GeminiApiDataSource(
        dio: Dio(),
        apiKey: 'key api ', // TODO: Get from environment
      ),
    );

    final result = await repository.generateQuiz(
      topic: state.topic,
      questionCount: state.questionCount,
      difficulty: state.difficulty,
      language: state.language,
      questionTypes: state.questionTypes,
    );

    return result;
  }
}

/// AI generation state
class AIGenerationState {
  const AIGenerationState({
    required this.topic,
    required this.questionCount,
    required this.difficulty,
    required this.language,
    required this.questionTypes,
  });

  final String topic;
  final int questionCount;
  final String difficulty;
  final String language;
  final List<String> questionTypes;

  AIGenerationState copyWith({
    String? topic,
    int? questionCount,
    String? difficulty,
    String? language,
    List<String>? questionTypes,
  }) {
    return AIGenerationState(
      topic: topic ?? this.topic,
      questionCount: questionCount ?? this.questionCount,
      difficulty: difficulty ?? this.difficulty,
      language: language ?? this.language,
      questionTypes: questionTypes ?? this.questionTypes,
    );
  }
}








