import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reading_history_model.dart';

class ReadingHistoryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add an article to reading history (only if it does not exist)
  Future<void> addToHistoryOnce({
    required String userId,
    required String articleId,
    required String title,
    required String description,
    required String image,
  }) async {
    try {
      // Check if the article already exists in the user's history
      final query = await _firestore
          .collection('reading_history')
          .where('userId', isEqualTo: userId)
          .where('articleId', isEqualTo: articleId)
          .get();

      if (query.docs.isEmpty) {
        // Add the article to the reading history
        await _firestore.collection('reading_history').add({
          'userId': userId,
          'articleId': articleId,
          'title': title,
          'description': description,
          'image': image,
          'readAt': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error saving reading history: $e');
    }
  }

  /// Get all reading history, sorted in Dart
  Future<List<ReadingHistoryModel>> getHistoryOnce(String userId) async {
    try {
      final snap = await _firestore
          .collection('reading_history')
          .where('userId', isEqualTo: userId)
          .get();

      final list = snap.docs
          .map((doc) => ReadingHistoryModel.fromDocument(doc))
          .toList();

      // Sort by readAt descending
      list.sort((a, b) => b.readAt.compareTo(a.readAt));

      return list;
    } catch (e) {
      print('Error fetching reading history: $e');
      return [];
    }
  }
}
