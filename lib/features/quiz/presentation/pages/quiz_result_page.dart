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
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_list_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/pages/quiz_answer_review_page.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';

/// Quiz result page
class QuizResultPage extends ConsumerWidget {
  const QuizResultPage({
    super.key,
    required this.quizId,
    this.result,
  });

  final String quizId;
  final QuizResult? result; // Pass result directly to avoid query

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(quizId));
    
    // If result is passed directly, use it immediately (no async delay)
    // Otherwise query from Firestore
    final userResultAsync = result != null
        ? AsyncValue.data(result!)
        : ref.watch(
            FutureProvider<QuizResult?>((ref) async {
              final repository = ref.read(quizRepositoryProvider);
              final userId = ref.read(currentUserProvider)?.uid ?? '';
              if (userId.isEmpty) return null;
              
              final queryResult = await repository.getLatestUserQuizResult(userId, quizId);
              return switch (queryResult) {
                Success(data: final data) => data,
                Failure() => null,
              };
            }),
          );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kết quả Quiz'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: userResultAsync.when(
        data: (latestResult) {
          if (latestResult == null) {
            return const Center(
              child: Text('No results found'),
            );
          }
          final correctCount = latestResult.answersDetails.where((a) => a.isCorrect).length;
          final totalQuestions = latestResult.answersDetails.length;
          final accuracy = latestResult.accuracy;
          final percentage = (accuracy * 100).round();
          
          // Show result immediately, quiz info can load separately
          return quizAsync.when(
            data: (quiz) {
              return _buildResultContent(
                context: context,
                ref: ref,
                quiz: quiz,
                result: latestResult,
                correctCount: correctCount,
                totalQuestions: totalQuestions,
                accuracy: accuracy,
                percentage: percentage,
              );
            },
            loading: () => _buildResultContent(
              context: context,
              ref: ref,
              quiz: null,
              result: latestResult,
              correctCount: correctCount,
              totalQuestions: totalQuestions,
              accuracy: accuracy,
              percentage: percentage,
            ),
            error: (error, stack) => _buildResultContent(
              context: context,
              ref: ref,
              quiz: null,
              result: latestResult,
              correctCount: correctCount,
              totalQuestions: totalQuestions,
              accuracy: accuracy,
              percentage: percentage,
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => context.pop(),
        ),
      ),
    );
  }

  Widget _buildResultContent({
    required BuildContext context,
    required WidgetRef ref,
    required QuizResult result,
    required int correctCount,
    required int totalQuestions,
    required double accuracy,
    required int percentage,
    Quiz? quiz,
  }) {
    // Determine color and message based on percentage
    final Color resultColor;
    final String emoji;
    final String title;
    final String subtitle;
    
    if (percentage >= 80) {
      resultColor = const Color(0xFF4CAF50); // Green
      emoji = '🎉';
      title = 'Xuất sắc!';
      subtitle = 'Bạn đã làm rất tốt!';
    } else if (percentage >= 60) {
      resultColor = const Color(0xFFFFA726); // Orange
      emoji = '😊';
      title = 'Tốt lắm!';
      subtitle = 'Tiếp tục phát huy nhé!';
    } else if (percentage >= 40) {
      resultColor = const Color(0xFFFF7043); // Deep Orange
      emoji = '😐';
      title = 'Cần cố gắng hơn!';
      subtitle = 'Đừng nản lòng, hãy thử lại!';
    } else {
      resultColor = const Color(0xFFEF5350); // Red
      emoji = '😢';
      title = 'Cần cố gắng hơn!';
      subtitle = 'Đừng nản lòng, hãy thử lại nhé!';
    }
    
    return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Emoji
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 80),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    title,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    subtitle,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Large circle with percentage
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              resultColor,
                              resultColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: resultColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(percentage * value).round()}%',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$correctCount/$totalQuestions đúng',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.timer,
                          iconColor: Colors.blue,
                          value: Formatters.formatDuration(
                            Duration(seconds: result.timeSpent),
                          ),
                          label: 'Thời gian',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.star,
                          iconColor: Colors.amber,
                          value: '${result.score}',
                          label: 'Điểm số',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle,
                          iconColor: AppColors.success,
                          value: '$percentage%',
                          label: 'Độ chính xác',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Phân tích kết quả
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phân tích kết quả',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Câu trả lời đúng',
                                style: context.textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Text(
                                '$correctCount',
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Câu trả lời sai',
                                style: context.textTheme.bodyLarge,
                              ),
                              const Spacer(),
                              Text(
                                '${totalQuestions - correctCount}',
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.push(RouteConstants.quizPlayPath(quizId));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Làm lại'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (quiz != null) {
                              // Load questions
                              final repository = ref.read(quizRepositoryProvider);
                              final questionsResult = await repository.getQuestions(quiz!.id);
                              
                              if (context.mounted) {
                                switch (questionsResult) {
                                  case Success(data: final questions):
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => QuizAnswerReviewPage(
                                          quiz: quiz!,
                                          result: result,
                                          questions: questions,
                                        ),
                                      ),
                                    );
                                  case Failure():
                                    context.showErrorSnackBar('Không thể tải câu hỏi');
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Xem đáp án'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Share functionality
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Chia sẻ'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.go(RouteConstants.home);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Về trang chủ'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Chi tiết câu trả lời
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chi tiết câu trả lời',
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Show all answers
                              },
                              child: Text(
                                'Xem tất cả',
                                style: TextStyle(
                                  color: AppColors.lightPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...result.answersDetails.asMap().entries.map((entry) {
                          final index = entry.key;
                          final detail = entry.value;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: detail.isCorrect
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: detail.isCorrect
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFEF5350),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Number badge
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: detail.isCorrect
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFEF5350),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Icon
                                Icon(
                                  detail.isCorrect
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: detail.isCorrect
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFEF5350),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                // Text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail.isCorrect
                                            ? 'Câu trả lời đúng'
                                            : 'Câu trả lời sai',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: detail.isCorrect
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFC62828),
                                        ),
                                      ),
                                      if (!detail.isCorrect) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Xem giải thích →',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Arrow icon
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
