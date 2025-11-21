import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save an article (create a new document in favorites collection)
  Future<void> saveFavorite(String userId, String articleId) async {
    await _firestore.collection("favorites").add({
      "userId": userId,
      "articleId": articleId,
      "savedAt": DateTime.now(),
    });
  }

  /// Remove a saved article
  Future<void> removeFavorite(String userId, String articleId) async {
    final snapshot = await _firestore
        .collection("favorites")
        .where("userId", isEqualTo: userId)
        .where("articleId", isEqualTo: articleId)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Check if an article is saved by the user
  Stream<bool> isFavorite(String userId, String articleId) {
    return _firestore
        .collection("favorites")
        .where("userId", isEqualTo: userId)
        .where("articleId", isEqualTo: articleId)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty);
  }

  /// Get a list of article IDs saved by the user
  Stream<List<String>> getFavorites(String userId) {
    return _firestore
        .collection("favorites")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc["articleId"] as String).toList());
  }
}
