import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/utils/formatters.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_list_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_edit_controller.dart';

/// Quiz detail page
class QuizDetailPage extends ConsumerWidget {
  const QuizDetailPage({
    super.key,
    required this.quizId,
  });

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(quizId));
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteConstants.home);
            }
          },
        ),
        title: const Text('Quiz Details'),
      ),
      body: quizAsync.when(
        data: (quiz) {
          final isOwner = user?.uid == quiz.ownerId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  quiz.title,
                  style: context.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),

                // Meta info
                Row(
                  children: [
                    _DifficultyBadge(difficulty: quiz.difficulty),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.quiz,
                      size: 16,
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${quiz.questionCount} questions',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (quiz.description != null) ...[
                  Text(
                    quiz.description!,
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                ],

                // Stats
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.people,
                          label: 'Plays',
                          value: quiz.stats.plays.toString(),
                        ),
                        _StatItem(
                          icon: Icons.star,
                          label: 'Avg Score',
                          value: quiz.stats.avgScore.toStringAsFixed(1),
                        ),
                        _StatItem(
                          icon: Icons.check_circle,
                          label: 'Completion',
                          value: Formatters.formatPercentage(quiz.stats.completionRate),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tags
                if (quiz.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: quiz.tags.map((tag) {
                      return Chip(label: Text(tag));
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Owner info
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(quiz.ownerName[0].toUpperCase()),
                    ),
                    title: Text(quiz.ownerName),
                    subtitle: Text(
                      'Created ${Formatters.formatRelativeTime(quiz.createdAt)}',
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                if (isOwner) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push(
                              RouteConstants.editQuizPath(quiz.id),
                              extra: quiz,
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDeleteConfirmation(context, ref, quiz),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.error,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Manage Questions Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.push(
                          RouteConstants.manageQuestions,
                          extra: quiz.id,
                        );
                      },
                      icon: const Icon(Icons.quiz),
                      label: const Text('Quản lý câu hỏi'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Play button - Navigate to pre-start page
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(RouteConstants.quizPreStartPath(quiz.id));
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Bắt đầu Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(quizByIdProvider(quizId));
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Quiz quiz,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa quiz "${quiz.title}"?\n\nHành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              // Show loading
              if (!context.mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              final result = await ref.read(deleteQuizProvider(quiz.id).future);
              
              if (!context.mounted) return;
              Navigator.pop(context);

              switch (result) {
                case Success():
                  if (context.mounted) {
                    context.showSuccessSnackBar('Đã xóa quiz thành công');
                    context.pop(); // Go back to previous page
                  }
                case Failure(exception: final exception):
                  if (context.mounted) {
                    context.showErrorSnackBar('Lỗi: ${exception.toString()}');
                  }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (difficulty) {
      case Difficulty.easy:
        color = AppColors.easy;
        label = 'Easy';
        break;
      case Difficulty.hard:
        color = AppColors.hard;
        label = 'Hard';
        break;
      default:
        color = AppColors.medium;
        label = 'Medium';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}
