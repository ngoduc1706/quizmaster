import 'package:equatable/equatable.dart';

/// Question entity
class Question extends Equatable {
  const Question({
    required this.id,
    required this.quizId,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.points = 10,
    this.timeLimit,
    this.order = 0,
  });

  final String id;
  final String quizId;
  final String question;
  final QuestionType type;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final int points;
  final int? timeLimit;
  final int order;

  Question copyWith({
    String? id,
    String? quizId,
    String? question,
    QuestionType? type,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    int? points,
    int? timeLimit,
    int? order,
  }) {
    return Question(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      type: type ?? this.type,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      points: points ?? this.points,
      timeLimit: timeLimit ?? this.timeLimit,
      order: order ?? this.order,
    );
  }

  bool get isValid {
    if (question.isEmpty) return false;
    if (options.length < 2) return false;
    if (correctAnswerIndex < 0 || correctAnswerIndex >= options.length) {
      return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [
        id,
        quizId,
        question,
        type,
        options,
        correctAnswerIndex,
        explanation,
        points,
        timeLimit,
        order,
      ];
}

/// Question type enum
enum QuestionType {
  multipleChoice,
  trueFalse,
}

/// Answer entity (for quiz attempts)
class Answer extends Equatable {
  const Answer({
    required this.questionId,
    required this.selectedIndex,
    this.timeSpent,
    this.isCorrect,
  });

  final String questionId;
  final int selectedIndex;
  final int? timeSpent;
  final bool? isCorrect;

  Answer copyWith({
    String? questionId,
    int? selectedIndex,
    int? timeSpent,
    bool? isCorrect,
  }) {
    return Answer(
      questionId: questionId ?? this.questionId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      timeSpent: timeSpent ?? this.timeSpent,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [questionId, selectedIndex, timeSpent, isCorrect];
}

/// Quiz result entity
class QuizResult extends Equatable {
  const QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    required this.accuracy,
    required this.timeSpent,
    required this.grade,
    required this.answersDetails,
    required this.completedAt,
  });

  final String id;
  final String userId;
  final String quizId;
  final int score;
  final double accuracy;
  final int timeSpent; // in seconds
  final String grade;
  final List<AnswerDetail> answersDetails;
  final DateTime completedAt;

  QuizResult copyWith({
    String? id,
    String? userId,
    String? quizId,
    int? score,
    double? accuracy,
    int? timeSpent,
    String? grade,
    List<AnswerDetail>? answersDetails,
    DateTime? completedAt,
  }) {
    return QuizResult(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      quizId: quizId ?? this.quizId,
      score: score ?? this.score,
      accuracy: accuracy ?? this.accuracy,
      timeSpent: timeSpent ?? this.timeSpent,
      grade: grade ?? this.grade,
      answersDetails: answersDetails ?? this.answersDetails,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        quizId,
        score,
        accuracy,
        timeSpent,
        grade,
        answersDetails,
        completedAt,
      ];
}

/// Answer detail for results
class AnswerDetail extends Equatable {
  const AnswerDetail({
    required this.questionId,
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
    required this.timeSpent,
  });

  final String questionId;
  final int selectedIndex;
  final int correctIndex;
  final bool isCorrect;
  final int timeSpent;

  @override
  List<Object?> get props => [
        questionId,
        selectedIndex,
        correctIndex,
        isCorrect,
        timeSpent,
      ];
}













