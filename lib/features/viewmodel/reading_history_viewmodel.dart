import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reading_history_model.dart';

class ReadingHistoryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add or update reading history 
  Future<void> addOrUpdateHistory({
    required String userId,
    required String articleId,
    required String title,
    required String description,
    required String image,
  }) async {
    try {
      final query = await _firestore
          .collection('reading_history')
          .where('userId', isEqualTo: userId)
          .where('articleId', isEqualTo: articleId)
          .get();

      if (query.docs.isEmpty) {
        // Add new record
        await _firestore.collection('reading_history').add({
          'userId': userId,
          'articleId': articleId,
          'title': title,
          'description': description,
          'image': image,
          'readAt': DateTime.now(),
        });
      } else {
        // Update existing record → push it to top
        final docId = query.docs.first.id;
        await _firestore.collection('reading_history').doc(docId).update({
          'readAt': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error updating reading history: $e');
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
