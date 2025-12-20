import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String contentImage;
  final String content;
  final String comment;
  final String categoryId;
  final DateTime date;
  final bool isVisible; 
  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.contentImage,
    required this.content,
    required this.comment,
    required this.categoryId,
    required this.date,
    required this.isVisible, 
  });

  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      contentImage: data['contentImage'] ?? '',
      content: data['content'] ?? '',
      comment: data['comment'] ?? '',
      categoryId: data['categoryId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      isVisible: data['isVisible'] ?? true, 
    );
  }
}
