import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/providers/firebase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';

/// Analytics tab
class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return analyticsAsync.when(
      data: (analytics) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thống kê tổng quan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Stats grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    title: 'Tổng người dùng',
                    value: analytics['totalUsers'].toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: 'Tổng Quiz',
                    value: analytics['totalQuizzes'].toString(),
                    icon: Icons.quiz,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: 'Tổng lượt chơi',
                    value: analytics['totalPlays'].toString(),
                    icon: Icons.play_arrow,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: 'Tổng câu hỏi',
                    value: analytics['totalQuestions'].toString(),
                    icon: Icons.question_answer,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Recent activity
              const Text(
                'Hoạt động gần đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _ActivityItem(
                        icon: Icons.person_add,
                        title: 'Người dùng mới',
                        subtitle: '${analytics['newUsersToday']} người hôm nay',
                        color: Colors.blue,
                      ),
                      const Divider(),
                      _ActivityItem(
                        icon: Icons.add_circle,
                        title: 'Quiz mới',
                        subtitle: '${analytics['newQuizzesToday']} quiz hôm nay',
                        color: Colors.green,
                      ),
                      const Divider(),
                      _ActivityItem(
                        icon: Icons.play_circle,
                        title: 'Lượt chơi',
                        subtitle: '${analytics['playsToday']} lượt hôm nay',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, stack) => Center(
        child: Text('Lỗi: ${error.toString()}'),
      ),
    );
  }
}

/// Analytics provider
final analyticsProvider = FutureProvider<Map<String, int>>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  // Get all data
  final usersSnapshot = await firestore
      .collection(FirebaseConstants.usersCollection)
      .get();

  final quizzesSnapshot = await firestore
      .collection(FirebaseConstants.quizzesCollection)
      .get();

  final questionsSnapshot = await firestore
      .collection(FirebaseConstants.questionsCollection)
      .get();

  // Calculate totals
  int totalUsers = usersSnapshot.docs.length;
  int totalQuizzes = quizzesSnapshot.docs.length;
  int totalPlays = 0;
  int totalQuestions = questionsSnapshot.docs.length;

  // Calculate total plays
  for (final doc in quizzesSnapshot.docs) {
    final data = doc.data();
    final stats = data[FirebaseConstants.quizStats] as Map<String, dynamic>?;
    totalPlays += stats?['plays'] as int? ?? 0;
  }

  // Calculate today's stats
  int newUsersToday = 0;
  for (final doc in usersSnapshot.docs) {
    final data = doc.data();
    final createdAt = (data[FirebaseConstants.userCreatedAt] as Timestamp).toDate();
    if (createdAt.isAfter(todayStart)) {
      newUsersToday++;
    }
  }

  int newQuizzesToday = 0;
  for (final doc in quizzesSnapshot.docs) {
    final data = doc.data();
    final createdAt = (data[FirebaseConstants.quizCreatedAt] as Timestamp).toDate();
    if (createdAt.isAfter(todayStart)) {
      newQuizzesToday++;
    }
  }

  // For plays today, we'd need to track this separately
  // For now, estimate based on recent activity
  int playsToday = 0; // This would need a results collection to track

  return {
    'totalUsers': totalUsers,
    'totalQuizzes': totalQuizzes,
    'totalPlays': totalPlays,
    'totalQuestions': totalQuestions,
    'newUsersToday': newUsersToday,
    'newQuizzesToday': newQuizzesToday,
    'playsToday': playsToday,
  };
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
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Activity item widget
class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
