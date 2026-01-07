import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:doanlaptrinh/core/extensions/context_extensions.dart';
import 'package:doanlaptrinh/core/theme/app_colors.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/features/auth/domain/entities/user.dart';
import 'package:doanlaptrinh/features/auth/presentation/pages/settings_page.dart';
import 'package:doanlaptrinh/features/quiz/presentation/controllers/quiz_list_controller.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/quiz.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/question.dart';
import 'package:doanlaptrinh/core/utils/formatters.dart' as formatters;

/// Profile page with tabs and statistics
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Calculate XP and level
  int _calculateXP(int quizzesTaken, int quizzesCreated, int totalScore) {
    // XP = quizzesTaken * 10 + quizzesCreated * 20 + totalScore
    return quizzesTaken * 10 + quizzesCreated * 20 + totalScore;
  }

  int _calculateLevel(int xp) {
    // Level = 1 + (XP / 100).floor()
    return 1 + (xp / 100).floor();
  }

  int _getXPForNextLevel(int currentLevel) {
    return currentLevel * 100;
  }

  int _getCurrentLevelXP(int xp, int level) {
    return xp - ((level - 1) * 100);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hồ sơ')),
        body: const Center(child: Text('Chưa đăng nhập')),
      );
    }

    return _ProfileContent(user: user);
  }
}

class _ProfileContent extends ConsumerStatefulWidget {
  const _ProfileContent({required this.user});

  final User user;

  @override
  ConsumerState<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<_ProfileContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizzesAsync = ref.watch(userQuizzesProvider(widget.user.uid));
    final resultsAsync = ref.watch(userResultsProvider(widget.user.uid));

    // Calculate from actual data
    final quizzesCreated = quizzesAsync.valueOrNull?.length ?? 0;
    final quizzesTaken = resultsAsync.valueOrNull
            ?.map((r) => r.quizId)
            .toSet()
            .length ??
        0;
    final totalScore = resultsAsync.valueOrNull
            ?.fold<int>(0, (sum, result) => sum + result.score) ??
        0;

    // Calculate XP and level
    final xp = quizzesTaken * 10 + quizzesCreated * 20 + totalScore;
    final level = 1 + (xp / 100).floor();
    final xpForNextLevel = level * 100;
    final currentLevelXP = xp - ((level - 1) * 100);
    final progress = (currentLevelXP / xpForNextLevel).clamp(0.0, 1.0);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
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
              actions: [
                // Admin Dashboard button (only for admin)
                if (widget.user.isAdmin)
                  IconButton(
                    icon: const Icon(Icons.admin_panel_settings),
                    onPressed: () {
                      context.push(RouteConstants.adminDashboard);
                    },
                    tooltip: 'Admin Dashboard',
                  ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Get current user before navigating
                    final currentUser = ref.read(currentUserProvider);
                    if (currentUser == null) {
                      context.showErrorSnackBar('Vui lòng đăng nhập');
                      return;
                    }
                    
                    // Navigate using Navigator, completely bypass GoRouter
                    // This prevents GoRouter from intercepting and redirecting
                    Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(user: currentUser),
                        settings: const RouteSettings(name: 'settings'),
                      ),
                    );
                  },
                ),
              ],
              expandedHeight: 280,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightPrimary,
                        AppColors.lightPrimary.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Avatar with edit button
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 47,
                                  backgroundImage: widget.user.photoUrl != null
                                      ? CachedNetworkImageProvider(widget.user.photoUrl!)
                                      : null,
                                  child: widget.user.photoUrl == null
                                      ? Text(
                                          widget.user.name[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                  backgroundColor: AppColors.lightPrimary,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.lightPrimary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: AppColors.lightPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Email
                          Text(
                            widget.user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Cấp độ $level',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (widget.user.isPro)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Pro Member',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Progress Bar
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$currentLevelXP / $xpForNextLevel XP đến cấp tiếp theo',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.lightPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Statistics Cards
            _StatisticsCards(userId: widget.user.uid),
            // Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.lightPrimary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.lightPrimary,
                tabs: const [
                  Tab(text: 'Quiz của tôi'),
                  Tab(text: 'Yêu thích'),
                  Tab(text: 'Hoạt động'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MyQuizzesTab(userId: widget.user.uid),
                  _FavoritesTab(),
                  _ActivityTab(userId: widget.user.uid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsCards extends ConsumerWidget {
  const _StatisticsCards({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzesAsync = ref.watch(userQuizzesProvider(userId));
    final resultsAsync = ref.watch(userResultsProvider(userId));
    final user = ref.watch(currentUserProvider);

    // Calculate from actual data
    final quizzesCreated = quizzesAsync.valueOrNull?.length ?? 0;
    // Count unique quiz IDs from results
    final quizzesTaken = resultsAsync.valueOrNull
            ?.map((r) => r.quizId)
            .toSet()
            .length ??
        0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.menu_book,
              iconColor: AppColors.lightPrimary,
              value: quizzesTaken.toString(),
              label: 'Đã làm',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.emoji_events,
              iconColor: AppColors.success,
              value: quizzesCreated.toString(),
              label: 'Đã tạo',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.favorite_border,
              iconColor: Colors.pink,
              value: '0', // TODO: Add favorites count
              label: 'Yêu thích',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.leaderboard,
              iconColor: Colors.amber,
              value: '#${user?.stats.level ?? 1}',
              label: 'Hạng',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyQuizzesTab extends ConsumerWidget {
  const _MyQuizzesTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzesAsync = ref.watch(userQuizzesProvider(userId));

    return quizzesAsync.when(
      data: (quizzes) {
        if (quizzes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Chưa có quiz nào',
                  style: TextStyle(color: Colors.grey[600]),
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
              return _QuizListItem(quiz: quiz);
            },
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(userQuizzesProvider(userId)),
      ),
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Chưa có quiz yêu thích',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _ActivityTab extends ConsumerWidget {
  const _ActivityTab({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(userResultsProvider(userId));

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Chưa có lịch sử bài làm',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userResultsProvider(userId));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _ActivityItem(result: result);
            },
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(userResultsProvider(userId)),
      ),
    );
  }
}

class _QuizListItem extends ConsumerWidget {
  const _QuizListItem({required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              ElevatedButton(
                onPressed: () {
                  context.push(RouteConstants.quizDetailPath(quiz.id));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Chỉnh sửa'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${quiz.stats.plays} lượt chơi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                quiz.stats.avgScore > 0
                    ? (quiz.stats.avgScore / 20).toStringAsFixed(1)
                    : '0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends ConsumerWidget {
  const _ActivityItem({required this.result});

  final QuizResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(result.quizId));

    return quizAsync.when(
      data: (quiz) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              context.push(
                RouteConstants.quizResultPath(result.quizId),
                extra: result,
              );
            },
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getGradeColor(result.grade).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        result.grade,
                        style: TextStyle(
                          color: _getGradeColor(result.grade),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.score, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${result.score}/${result.answersDetails.length * 20} điểm',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      formatters.Formatters.formatDuration(
                        Duration(seconds: result.timeSpent),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatters.Formatters.formatDateTime(result.completedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Lỗi tải quiz: ${error.toString()}',
          style: TextStyle(color: Colors.red[600]),
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
      case 'EXCELLENT':
        return AppColors.success;
      case 'B':
      case 'GOOD':
        return AppColors.info;
      case 'C':
      case 'FAIR':
        return AppColors.warning;
      default:
        return AppColors.lightError;
    }
  }
}
