import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/features/quiz/data/repositories/category_repository.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/category.dart';
import 'package:doanlaptrinh/providers/shared_providers.dart';

part 'category_controller.g.dart';

/// Categories list provider
@riverpod
Future<List<Category>> categories(CategoriesRef ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getCategories();

  if (result.isSuccess) {
    return result.dataOrNull!;
  } else {
    throw result.exceptionOrNull ?? Exception('Failed to get categories');
  }
}

/// Category by ID provider
@riverpod
Future<Category?> categoryById(CategoryByIdRef ref, String categoryId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getCategoryById(categoryId);

  if (result.isSuccess) {
    return result.dataOrNull;
  } else {
    throw result.exceptionOrNull ?? Exception('Failed to get category');
  }
}
