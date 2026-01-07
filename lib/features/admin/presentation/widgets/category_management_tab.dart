import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doanlaptrinh/core/widgets/empty_state.dart';
import 'package:doanlaptrinh/core/widgets/error_view.dart';
import 'package:doanlaptrinh/core/widgets/loading_indicator.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/category.dart';
import 'package:doanlaptrinh/providers/firebase_providers.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/quiz/data/models/category_model.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:uuid/uuid.dart';

/// Category management tab
class CategoryManagementTab extends ConsumerWidget {
  const CategoryManagementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesStream = ref.watch(allCategoriesStreamProvider);

    return Column(
      children: [
        // Header with add button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quản lý Danh mục',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCategoryDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Thêm danh mục'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Categories list
        Expanded(
          child: categoriesStream.when(
            data: (categories) {
              if (categories.isEmpty) {
                return const EmptyState(
                  message: 'Chưa có danh mục nào',
                  icon: Icons.category_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryCard(
                    category: category,
                    onEdit: () => _showEditCategoryDialog(context, ref, category),
                    onDelete: () => _deleteCategory(context, ref, category.id),
                    onToggleActive: () => _toggleCategoryActive(context, ref, category),
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

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final orderController = TextEditingController(text: '0');
    final colorController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Thêm danh mục mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên danh mục',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: orderController,
                  decoration: const InputDecoration(
                    labelText: 'Thứ tự',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(
                    labelText: 'Màu sắc (hex, ví dụ: #FF5722)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Kích hoạt'),
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập tên danh mục')),
                  );
                  return;
                }

                await _createCategory(
                  context,
                  ref,
                  nameController.text,
                  int.tryParse(orderController.text) ?? 0,
                  colorController.text.isEmpty ? null : colorController.text,
                  isActive,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) {
    final nameController = TextEditingController(text: category.name);
    final orderController = TextEditingController(text: category.order.toString());
    final colorController = TextEditingController(text: category.color ?? '');
    bool isActive = category.isActive;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Chỉnh sửa danh mục'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên danh mục',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: orderController,
                  decoration: const InputDecoration(
                    labelText: 'Thứ tự',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(
                    labelText: 'Màu sắc (hex, ví dụ: #FF5722)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Kích hoạt'),
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập tên danh mục')),
                  );
                  return;
                }

                await _updateCategory(
                  context,
                  ref,
                  category.id,
                  nameController.text,
                  int.tryParse(orderController.text) ?? 0,
                  colorController.text.isEmpty ? null : colorController.text,
                  isActive,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createCategory(
    BuildContext context,
    WidgetRef ref,
    String name,
    int order,
    String? color,
    bool isActive,
  ) async {
    try {
      final firestore = ref.read(firestoreProvider);
      final categoryId = const Uuid().v4();

      final categoryModel = CategoryModel(
        id: categoryId,
        name: name,
        order: order,
        color: color,
        isActive: isActive,
      );

      await firestore
          .collection(FirebaseConstants.categoriesCollection)
          .doc(categoryId)
          .set(categoryModel.toFirestore());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm danh mục thành công')),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Create category error', e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _updateCategory(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
    String name,
    int order,
    String? color,
    bool isActive,
  ) async {
    try {
      final firestore = ref.read(firestoreProvider);

      await firestore
          .collection(FirebaseConstants.categoriesCollection)
          .doc(categoryId)
          .update({
        FirebaseConstants.categoryName: name,
        FirebaseConstants.categoryOrder: order,
        if (color != null) FirebaseConstants.categoryColor: color,
        FirebaseConstants.categoryIsActive: isActive,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật danh mục thành công')),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Update category error', e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
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
            .collection(FirebaseConstants.categoriesCollection)
            .doc(categoryId)
            .delete();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa danh mục thành công')),
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Delete category error', e, stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _toggleCategoryActive(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    try {
      final firestore = ref.read(firestoreProvider);
      await firestore
          .collection(FirebaseConstants.categoriesCollection)
          .doc(category.id)
          .update({
        FirebaseConstants.categoryIsActive: !category.isActive,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              category.isActive
                  ? 'Đã vô hiệu hóa danh mục'
                  : 'Đã kích hoạt danh mục',
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Toggle category active error', e, stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }
}

/// All categories stream provider (including inactive)
final allCategoriesStreamProvider = StreamProvider<List<Category>>((ref) async* {
  final firestore = ref.watch(firestoreProvider);

  yield* firestore
      .collection(FirebaseConstants.categoriesCollection)
      .orderBy(FirebaseConstants.categoryOrder)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc).toEntity())
        .toList();
  });
});

/// Category card widget
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color ?? Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.category,
            color: Colors.white,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Thứ tự: ${category.order}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(category.isActive ? 'Hoạt động' : 'Vô hiệu'),
              backgroundColor: category.isActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              labelStyle: TextStyle(
                color: category.isActive ? Colors.green : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                category.isActive ? Icons.visibility_off : Icons.visibility,
                color: Colors.orange,
              ),
              onPressed: onToggleActive,
              tooltip: category.isActive ? 'Vô hiệu hóa' : 'Kích hoạt',
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Chỉnh sửa',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Xóa',
            ),
          ],
        ),
      ),
    );
  }
}
