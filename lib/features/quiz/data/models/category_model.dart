import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doanlaptrinh/core/constants/firebase_constants.dart';
import 'package:doanlaptrinh/features/quiz/domain/entities/category.dart';

/// Category model for Firestore
class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.color,
    this.icon,
    this.isActive = true,
    this.order = 0,
  });

  final String id;
  final String name;
  final String? slug;
  final String? color;
  final String? icon;
  final bool isActive;
  final int order;

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data[FirebaseConstants.categoryName] as String? ?? 'Unnamed',
      slug: data[FirebaseConstants.categorySlug] as String?,
      color: data[FirebaseConstants.categoryColor] as String?,
      icon: data[FirebaseConstants.categoryIcon] as String?,
      isActive: data[FirebaseConstants.categoryIsActive] as bool? ?? true,
      order: data[FirebaseConstants.categoryOrder] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.categoryName: name,
      if (slug != null) FirebaseConstants.categorySlug: slug,
      if (color != null) FirebaseConstants.categoryColor: color,
      if (icon != null) FirebaseConstants.categoryIcon: icon,
      FirebaseConstants.categoryIsActive: isActive,
      FirebaseConstants.categoryOrder: order,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      slug: slug,
      color: color,
      icon: icon,
      isActive: isActive,
      order: order,
    );
  }

  static CategoryModel fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      slug: category.slug,
      color: category.color,
      icon: category.icon,
      isActive: category.isActive,
      order: category.order,
    );
  }
}
