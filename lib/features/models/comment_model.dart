import 'package:cloud_firestore/cloud_firestore.dart';

/// Model represents a comment (Comment)
class CommentModel {
  final String id;
  final String user;
  final String text;
  final DateTime date;

  CommentModel({
    required this.id,
    required this.user,
    required this.text,
    required this.date,
  });

  /// Convert data from Firestore to CommentModel
  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      user: data['user'] ?? 'Anonymous',
      text: data['text'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  /// Convert CommentModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'text': text,
      'date': Timestamp.fromDate(date),
    };
  }
}
