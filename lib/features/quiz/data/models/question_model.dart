import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';

/// Question model for Firestore
class QuestionModel {
  QuestionModel({
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
  final String type;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final int points;
  final int? timeLimit;
  final int order;

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      quizId: data[FirebaseConstants.questionQuizId] as String,
      question: data[FirebaseConstants.questionQuestion] as String,
      type: data[FirebaseConstants.questionType] as String? ?? 'multipleChoice',
      options: List<String>.from(data[FirebaseConstants.questionOptions] as List),
      correctAnswerIndex: data[FirebaseConstants.questionCorrectAnswerIndex] as int,
      explanation: data[FirebaseConstants.questionExplanation] as String?,
      points: data[FirebaseConstants.questionPoints] as int? ?? 10,
      timeLimit: data[FirebaseConstants.questionTimeLimit] as int?,
      order: data[FirebaseConstants.questionOrder] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.questionQuizId: quizId,
      FirebaseConstants.questionQuestion: question,
      FirebaseConstants.questionType: type,
      FirebaseConstants.questionOptions: options,
      FirebaseConstants.questionCorrectAnswerIndex: correctAnswerIndex,
      if (explanation != null) FirebaseConstants.questionExplanation: explanation,
      FirebaseConstants.questionPoints: points,
      if (timeLimit != null) FirebaseConstants.questionTimeLimit: timeLimit,
      FirebaseConstants.questionOrder: order,
    };
  }

  Question toEntity() {
    return Question(
      id: id,
      quizId: quizId,
      question: question,
      type: type == 'trueFalse' ? QuestionType.trueFalse : QuestionType.multipleChoice,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
      explanation: explanation,
      points: points,
      timeLimit: timeLimit,
      order: order,
    );
  }

  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      quizId: question.quizId,
      question: question.question,
      type: question.type == QuestionType.trueFalse ? 'trueFalse' : 'multipleChoice',
      options: question.options,
      correctAnswerIndex: question.correctAnswerIndex,
      explanation: question.explanation,
      points: question.points,
      timeLimit: question.timeLimit,
      order: question.order,
    );
  }
}














