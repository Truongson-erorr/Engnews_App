import 'package:cloud_firestore/cloud_firestore.dart';

/// Model đại diện cho một danh mục bài viết (Category)
class CategoryModel {
  final String id;
  final String title;
  final String description;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Chuyển dữ liệu từ Firestore thành CategoryModel
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
