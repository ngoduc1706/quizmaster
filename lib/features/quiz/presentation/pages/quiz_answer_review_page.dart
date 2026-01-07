import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';

/// Page to review quiz answers with detailed explanations
class QuizAnswerReviewPage extends ConsumerWidget {
  const QuizAnswerReviewPage({
    super.key,
    required this.quiz,
    required this.result,
    required this.questions,
  });

  final Quiz quiz;
  final QuizResult result;
  final List<Question> questions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correctCount = result.answersDetails.where((a) => a.isCorrect).length;
    final totalQuestions = result.answersDetails.length;
    final percentage = ((correctCount / totalQuestions) * 100).round();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Xem đáp án',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getColorByPercentage(percentage).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getColorByPercentage(percentage),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getColorByPercentage(percentage),
                  _getColorByPercentage(percentage).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _getColorByPercentage(percentage).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kết quả: $correctCount/$totalQuestions câu đúng',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getEmojiByPercentage(percentage),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Questions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: result.answersDetails.length,
              itemBuilder: (context, index) {
                final detail = result.answersDetails[index];
                // Find the question from questions list
                Question? question;
                try {
                  question = questions.firstWhere(
                    (q) => q.id == detail.questionId,
                  );
                } catch (e) {
                  question = questions.isNotEmpty ? questions.first : null;
                }
                
                return _QuestionCard(
                  questionNumber: index + 1,
                  detail: detail,
                  question: question,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorByPercentage(int percentage) {
    if (percentage >= 80) return const Color(0xFF4CAF50);
    if (percentage >= 60) return const Color(0xFFFFA726);
    if (percentage >= 40) return const Color(0xFFFF7043);
    return const Color(0xFFEF5350);
  }

  String _getEmojiByPercentage(int percentage) {
    if (percentage >= 80) return '🎉';
    if (percentage >= 60) return '😊';
    if (percentage >= 40) return '😐';
    return '😢';
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.questionNumber,
    required this.detail,
    required this.question,
  });

  final int questionNumber;
  final AnswerDetail detail;
  final Question? question;

  @override
  Widget build(BuildContext context) {
    if (question == null) {
      return const SizedBox.shrink();
    }
    
    final isCorrect = detail.isCorrect;
    final color = isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFEF5350);
    final points = question!.points ?? 20;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                // Question number badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$questionNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Status
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: color,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? 'Câu trả lời đúng' : 'Câu trả lời sai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                // Points
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isCorrect ? '$points' : '0',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Question text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              question!.question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),

          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: question!.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final optionText = entry.value;
                final isUserAnswer = optionIndex == detail.selectedIndex;
                final isCorrectAnswer = optionIndex == detail.correctIndex;

                Color? optionColor;
                IconData? optionIcon;
                
                if (isCorrectAnswer) {
                  optionColor = const Color(0xFF4CAF50);
                  optionIcon = Icons.check_circle;
                } else if (isUserAnswer && !isCorrect) {
                  optionColor = const Color(0xFFEF5350);
                  optionIcon = Icons.cancel;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: optionColor?.withOpacity(0.1) ?? Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: optionColor?.withOpacity(0.5) ?? Colors.grey[300]!,
                      width: optionColor != null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Option letter
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: optionColor ?? Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + optionIndex.toInt()), // A, B, C, D
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Option text
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: optionColor != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: optionColor ?? Colors.black87,
                          ),
                        ),
                      ),
                      // Icon
                      if (optionIcon != null)
                        Icon(
                          optionIcon,
                          color: optionColor,
                          size: 24,
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Explanation
          if (question!.explanation != null && question!.explanation!.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giải thích',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          question!.explanation!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

