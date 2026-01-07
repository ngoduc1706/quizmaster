import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/features/admin/presentation/widgets/analytics_tab.dart';
import 'package:doanlaptrinh/features/admin/presentation/widgets/category_management_tab.dart';
import 'package:doanlaptrinh/features/admin/presentation/widgets/user_management_tab.dart';
import 'package:doanlaptrinh/features/admin/presentation/widgets/quiz_management_tab.dart';
import 'package:doanlaptrinh/features/auth/presentation/controllers/auth_controller.dart';
import 'package:doanlaptrinh/core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';

/// Admin dashboard page
class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isAdmin = user?.isAdmin ?? false;

    // Redirect if not admin
    if (!isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteConstants.home);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(
                  icon: Icon(Icons.people),
                  text: 'Người dùng',
                ),
                Tab(
                  icon: Icon(Icons.category),
                  text: 'Danh mục',
                ),
                Tab(
                  icon: Icon(Icons.quiz),
                  text: 'Quiz',
                ),
                Tab(
                  icon: Icon(Icons.analytics),
                  text: 'Thống kê',
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go(RouteConstants.home),
            tooltip: 'Về trang chủ',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: const [
            UserManagementTab(),
            CategoryManagementTab(),
            QuizManagementTab(),
            AnalyticsTab(),
          ],
        ),
      ),
    );
  }
}
