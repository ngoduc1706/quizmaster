import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_list_controller.dart';
import 'package:doanlaptrinh/features/quiz/presentation/widgets/discover_quiz_card.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';

/// My Quizzes Page
class MyQuizzesPage extends ConsumerStatefulWidget {
  const MyQuizzesPage({super.key});

  @override
  ConsumerState<MyQuizzesPage> createState() => _MyQuizzesPageState();
}

class _MyQuizzesPageState extends ConsumerState<MyQuizzesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Của Tôi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đã tạo'),
            Tab(text: 'Đã làm'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Created Quizzes Tab
          _CreatedQuizzesTab(userId: userId),
          // Completed Quizzes Tab
          _CompletedQuizzesTab(userId: userId),
        ],
      ),
    );
  }
}

/// Created Quizzes Tab
class _CreatedQuizzesTab extends ConsumerWidget {
  const _CreatedQuizzesTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userQuizzesAsync = ref.watch(userQuizzesProvider(userId));

    return userQuizzesAsync.when(
      data: (quizzes) {
        if (quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Chưa có quiz nào',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tạo quiz đầu tiên của bạn ngay!',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('${RouteConstants.createQuiz}/form');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo Quiz Mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userQuizzesProvider(userId));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DiscoverQuizCard(
                  quiz: quiz,
                  onTap: () {
                    context.push(RouteConstants.quizDetailPath(quiz.id));
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () {
          ref.invalidate(userQuizzesProvider(userId));
        },
      ),
    );
  }
}

/// Completed Quizzes Tab
class _CompletedQuizzesTab extends ConsumerWidget {
  const _CompletedQuizzesTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userResultsProvider = FutureProvider.autoDispose<List<QuizResult>>((ref) async {
      final repository = ref.read(quizRepositoryProvider);
      final result = await repository.getUserResults(userId);
      return switch (result) {
        Success(data: final data) => data,
        Failure() => <QuizResult>[],
      };
    });
    
    final userResultsAsync = ref.watch(userResultsProvider);

    return userResultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Chưa làm quiz nào',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bắt đầu làm quiz ngay!',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go(RouteConstants.discover);
                  },
                  icon: const Icon(Icons.explore),
                  label: const Text('Khám phá Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Get unique quiz IDs from results
        final quizIds = results.map((r) => r.quizId).toSet().toList();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userResultsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quizIds.length,
            itemBuilder: (context, index) {
              final quizId = quizIds[index];
              final quizResults = results
                  .where((r) => r.quizId == quizId)
                  .toList()
                ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
              final latestResult = quizResults.first;

              return FutureBuilder<Quiz>(
                future: ref.read(quizByIdProvider(quizId).future),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  final quiz = snapshot.data!;
                  final bestScore = quizResults.isNotEmpty
                      ? quizResults.map((r) => r.score).reduce((a, b) => a > b ? a : b)
                      : 0;
                  final bestAccuracy = quizResults.isNotEmpty
                      ? quizResults.map((r) => r.accuracy).reduce((a, b) => a > b ? a : b)
                      : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          context.push(RouteConstants.quizResultPath(quizId));
                        },
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
                                      style: context.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getGradeColor(latestResult.grade, context)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      latestResult.grade,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: _getGradeColor(latestResult.grade, context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (quiz.description != null)
                                Text(
                                  quiz.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _StatChip(
                                    icon: Icons.star,
                                    label: 'Điểm cao nhất',
                                    value: '$bestScore',
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 12),
                                  _StatChip(
                                    icon: Icons.check_circle,
                                    label: 'Độ chính xác',
                                    value: '${(bestAccuracy * 100).round()}%',
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 12),
                                  _StatChip(
                                    icon: Icons.repeat,
                                    label: 'Đã làm',
                                    value: '${quizResults.length} lần',
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () {
          ref.invalidate(userResultsProvider);
        },
      ),
    );
  }

  Color _getGradeColor(String grade, BuildContext context) {
    switch (grade) {
      case 'A+':
      case 'A':
        return AppColors.success;
      case 'B':
        return AppColors.info;
      case 'C':
        return AppColors.warning;
      default:
        return context.colorScheme.error;
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

