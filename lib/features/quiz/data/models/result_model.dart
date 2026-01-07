import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';

/// Result model for Firestore
class ResultModel {
  ResultModel({
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
  final int timeSpent;
  final String grade;
  final List<Map<String, dynamic>> answersDetails;
  final DateTime completedAt;

  factory ResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ResultModel(
      id: doc.id,
      userId: data[FirebaseConstants.resultUserId] as String,
      quizId: data[FirebaseConstants.resultQuizId] as String,
      score: data[FirebaseConstants.resultScore] as int,
      accuracy: (data[FirebaseConstants.resultAccuracy] as num).toDouble(),
      timeSpent: data[FirebaseConstants.resultTimeSpent] as int,
      grade: data[FirebaseConstants.resultGrade] as String,
      answersDetails: List<Map<String, dynamic>>.from(
        data[FirebaseConstants.resultAnswersDetails] as List,
      ),
      completedAt: (data[FirebaseConstants.resultCompletedAt] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.resultUserId: userId,
      FirebaseConstants.resultQuizId: quizId,
      FirebaseConstants.resultScore: score,
      FirebaseConstants.resultAccuracy: accuracy,
      FirebaseConstants.resultTimeSpent: timeSpent,
      FirebaseConstants.resultGrade: grade,
      FirebaseConstants.resultAnswersDetails: answersDetails,
      FirebaseConstants.resultCompletedAt: Timestamp.fromDate(completedAt),
    };
  }

  QuizResult toEntity() {
    return QuizResult(
      id: id,
      userId: userId,
      quizId: quizId,
      score: score,
      accuracy: accuracy,
      timeSpent: timeSpent,
      grade: grade,
      answersDetails: answersDetails.map((detail) {
        return AnswerDetail(
          questionId: detail['questionId'] as String,
          selectedIndex: detail['selectedIndex'] as int,
          correctIndex: detail['correctIndex'] as int,
          isCorrect: detail['isCorrect'] as bool,
          timeSpent: detail['timeSpent'] as int,
        );
      }).toList(),
      completedAt: completedAt,
    );
  }

  factory ResultModel.fromEntity(QuizResult result) {
    return ResultModel(
      id: result.id,
      userId: result.userId,
      quizId: result.quizId,
      score: result.score,
      accuracy: result.accuracy,
      timeSpent: result.timeSpent,
      grade: result.grade,
      answersDetails: result.answersDetails.map((detail) {
        return {
          'questionId': detail.questionId,
          'selectedIndex': detail.selectedIndex,
          'correctIndex': detail.correctIndex,
          'isCorrect': detail.isCorrect,
          'timeSpent': detail.timeSpent,
        };
      }).toList(),
      completedAt: result.completedAt,
    );
  }
}














