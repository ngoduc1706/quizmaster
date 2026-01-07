import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/core/widgets/empty_state.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/features/auth/domain/entities/user.dart';
import 'package:doanlaptrinh/providers/firebase_providers.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/auth/data/models/user_model.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';

/// User management tab
class UserManagementTab extends ConsumerWidget {
  const UserManagementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersStream = ref.watch(usersStreamProvider);

    return Column(
      children: [
        // Stats cards
        Padding(
          padding: const EdgeInsets.all(16),
          child: usersStream.when(
            data: (users) {
              final totalUsers = users.length;
              final adminUsers = users.where((u) => u.isAdmin).length;
              final proUsers = users.where((u) => u.isPro).length;

              return Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Tổng người dùng',
                      value: totalUsers.toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Admin',
                      value: adminUsers.toString(),
                      icon: Icons.admin_panel_settings,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Pro',
                      value: proUsers.toString(),
                      icon: Icons.star,
                      color: Colors.orange,
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(height: 100, child: LoadingIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
        // Users list
        Expanded(
          child: usersStream.when(
            data: (users) {
              if (users.isEmpty) {
                return const EmptyState(
                  message: 'Chưa có người dùng nào',
                  icon: Icons.people_outline,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _UserCard(
                    user: user,
                    onToggleRole: () => _toggleUserRole(context, ref, user),
                    onToggleTier: () => _toggleUserTier(context, ref, user),
                  );
                },
              );
            },
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, stack) => ErrorView(message: error.toString()),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleUserRole(
    BuildContext context,
    WidgetRef ref,
    User user,
  ) async {
    final newRole = user.isAdmin ? 'user' : 'admin';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thay đổi'),
        content: Text(
          user.isAdmin
              ? 'Bạn có chắc chắn muốn bỏ quyền admin của ${user.name}?'
              : 'Bạn có chắc chắn muốn cấp quyền admin cho ${user.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final firestore = ref.read(firestoreProvider);
        await firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(user.uid)
            .update({
          FirebaseConstants.userRole: newRole,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                user.isAdmin
                    ? 'Đã bỏ quyền admin'
                    : 'Đã cấp quyền admin',
              ),
            ),
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Toggle user role error', e, stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _toggleUserTier(
    BuildContext context,
    WidgetRef ref,
    User user,
  ) async {
    final newTier = user.isPro ? 'free' : 'pro';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thay đổi'),
        content: Text(
          user.isPro
              ? 'Bạn có chắc chắn muốn chuyển ${user.name} về gói miễn phí?'
              : 'Bạn có chắc chắn muốn nâng cấp ${user.name} lên gói Pro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final firestore = ref.read(firestoreProvider);
        await firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(user.uid)
            .update({
          FirebaseConstants.userSubscriptionTier: newTier,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                user.isPro
                    ? 'Đã chuyển về gói miễn phí'
                    : 'Đã nâng cấp lên gói Pro',
              ),
            ),
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Toggle user tier error', e, stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}')),
          );
        }
      }
    }
  }
}

/// Users stream provider
final usersStreamProvider = StreamProvider<List<User>>((ref) async* {
  final firestore = ref.watch(firestoreProvider);

  yield* firestore
      .collection(FirebaseConstants.usersCollection)
      .orderBy(FirebaseConstants.userCreatedAt, descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc).toEntity())
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

/// User card widget
class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.user,
    required this.onToggleRole,
    required this.onToggleTier,
  });

  final User user;
  final VoidCallback onToggleRole;
  final VoidCallback onToggleTier;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isAdmin
              ? Colors.purple
              : user.isPro
                  ? Colors.orange
                  : Colors.blue,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(user.role.name),
                  backgroundColor: user.isAdmin
                      ? Colors.purple.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: user.isAdmin ? Colors.purple : Colors.grey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(user.subscriptionTier.name),
                  backgroundColor: user.isPro
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: user.isPro ? Colors.orange : Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                color: user.isAdmin ? Colors.purple : Colors.grey,
              ),
              onPressed: onToggleRole,
              tooltip: user.isAdmin ? 'Bỏ quyền admin' : 'Cấp quyền admin',
            ),
            IconButton(
              icon: Icon(
                user.isPro ? Icons.star : Icons.star_border,
                color: user.isPro ? Colors.orange : Colors.grey,
              ),
              onPressed: onToggleTier,
              tooltip: user.isPro ? 'Chuyển về free' : 'Nâng cấp Pro',
            ),
          ],
        ),
      ),
    );
  }
}
