import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String title;
  final String description;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
