import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/core/errors/app_exceptions.dart';
import 'package:doanlaptrinh/core/errors/result.dart';
import 'package:doanlaptrinh/core/utils/logger.dart';
import 'package:doanlaptrinh/features/quiz/data/models/category_model.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/category.dart';

/// Category repository
class CategoryRepository {
  CategoryRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// Get all active categories
  Future<Result<List<Category>>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseConstants.categoriesCollection)
          .where(FirebaseConstants.categoryIsActive, isEqualTo: true)
          .get();

      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc).toEntity())
          .toList();

      // Sort by order
      categories.sort((a, b) => a.order.compareTo(b.order));

      return Success(categories);
    } catch (e, stackTrace) {
      AppLogger.error('Get categories error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get categories: ${e.toString()}'));
    }
  }

  /// Get category by ID
  Future<Result<Category?>> getCategoryById(String categoryId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.categoriesCollection)
          .doc(categoryId)
          .get();

      if (!doc.exists) {
        return const Success(null);
      }

      final model = CategoryModel.fromFirestore(doc);
      return Success(model.toEntity());
    } catch (e, stackTrace) {
      AppLogger.error('Get category by ID error', e, stackTrace);
      return Failure(AppFirebaseException('Failed to get category: ${e.toString()}'));
    }
  }
}
