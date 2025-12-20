import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String title;
  final String description;
  final bool isVisible;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isVisible,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isVisible: data['isVisible'] ?? true,
    );
  }
}
