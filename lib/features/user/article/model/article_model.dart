import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String comment;
  final String categoryId;
  final DateTime date;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.comment,
    required this.categoryId,
    required this.date,
  });

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      comment: data['comment'] ?? '',
      categoryId: data['categoryId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
