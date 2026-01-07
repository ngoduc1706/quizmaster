import 'package:equatable/equatable.dart';

/// Category entity
class Category extends Equatable {
  const Category({
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

  Category copyWith({
    String? id,
    String? name,
    String? slug,
    String? color,
    String? icon,
    bool? isActive,
    int? order,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [id, name, slug, color, icon, isActive, order];
}
