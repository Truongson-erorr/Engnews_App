import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingHistoryModel {
  final String id;
  final String articleId;
  final String title;
  final String description;
  final String image;
  final DateTime readAt;

  ReadingHistoryModel({
    required this.id,
    required this.articleId,
    required this.title,
    required this.description,
    required this.image,
    required this.readAt,
  });

  /// Create ReadingHistoryModel from Firestore document
  factory ReadingHistoryModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ReadingHistoryModel(
      id: doc.id,
      articleId: data['articleId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      readAt: data['readAt'] != null
          ? (data['readAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Convert ReadingHistoryModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'title': title,
      'description': description,
      'image': image,
      'readAt': readAt,
    };
  }
}
