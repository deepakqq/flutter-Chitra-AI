class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.order,
    required this.isActive,
  });

  final String id;
  final String name;
  final String slug;
  final int order;
  final bool isActive;

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    final orderValue = map['order'] ?? map['sort_order'];
    final order = orderValue is int
        ? orderValue
        : (orderValue as num?)?.toInt() ?? 0;
    final rawActive = map['isActive'] ?? map['is_active'];
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      slug: map['slug'] ?? '',
      order: order,
      isActive: rawActive != false && rawActive != 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'slug': slug, 'order': order, 'isActive': isActive};
  }
}
