import 'package:flutter/material.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/presentation/widgets/quiz_card.dart';

/// Discover quiz card widget (alias for QuizCard)
class DiscoverQuizCard extends StatelessWidget {
  const DiscoverQuizCard({
    super.key,
    required this.quiz,
    this.onTap,
  });

  final Quiz quiz;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return QuizCard(
      quiz: quiz,
      onTap: onTap,
    );
  }
}

