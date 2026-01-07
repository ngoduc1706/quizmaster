import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/core/widgets/empty_state.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/providers/firebase_providers.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/quiz/data/models/quiz_model.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';

/// Quiz management tab
class QuizManagementTab extends ConsumerWidget {
  const QuizManagementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzesStream = ref.watch(allQuizzesStreamProvider);

    return quizzesStream.when(
      data: (quizzes) {
        if (quizzes.isEmpty) {
          return const EmptyState(
            message: 'Chưa có quiz nào',
            icon: Icons.quiz_outlined,
          );
        }

        return Column(
          children: [
            // Stats cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Tổng Quiz',
                      value: quizzes.length.toString(),
                      icon: Icons.quiz,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Quiz Công khai',
                      value: quizzes.where((q) => q.isPublic).length.toString(),
                      icon: Icons.public,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Quiz Riêng tư',
                      value: quizzes.where((q) => !q.isPublic).length.toString(),
                      icon: Icons.lock,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            // Quiz list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return _QuizCard(
                    quiz: quiz,
                    onDelete: () => _deleteQuiz(context, ref, quiz.id),
                    onView: () => context.push(
                      RouteConstants.quizDetailPath(quiz.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => ErrorView(message: error.toString()),
    );
  }

  Future<void> _deleteQuiz(
    BuildContext context,
    WidgetRef ref,
    String quizId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa quiz này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final firestore = ref.read(firestoreProvider);
        await firestore
            .collection(FirebaseConstants.quizzesCollection)
            .doc(quizId)
            .delete();

        // Delete questions
        final questionsSnapshot = await firestore
            .collection(FirebaseConstants.questionsCollection)
            .where(FirebaseConstants.questionQuizId, isEqualTo: quizId)
            .get();

        final batch = firestore.batch();
        for (final doc in questionsSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa quiz thành công')),
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Delete quiz error', e, stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}')),
          );
        }
      }
    }
  }
}

/// All quizzes stream provider
final allQuizzesStreamProvider = StreamProvider<List<Quiz>>((ref) async* {
  final firestore = ref.watch(firestoreProvider);

  yield* firestore
      .collection(FirebaseConstants.quizzesCollection)
      .orderBy(FirebaseConstants.quizCreatedAt, descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => QuizModel.fromFirestore(doc).toEntity())
        .toList();
  });
});

/// Stat card widget
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quiz card widget
class _QuizCard extends StatelessWidget {
  const _QuizCard({
    required this.quiz,
    required this.onDelete,
    required this.onView,
  });

  final Quiz quiz;
  final VoidCallback onDelete;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(quiz.isPublic ? 'Công khai' : 'Riêng tư'),
                    backgroundColor: quiz.isPublic
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: quiz.isPublic ? Colors.green : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (quiz.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  quiz.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.stats.plays} lượt chơi',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.question_answer, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.questionCount} câu hỏi',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Xóa quiz',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

