import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lưu bài viết (tạo document mới trong collection favorites)
  Future<void> saveFavorite(String userId, String articleId) async {
    await _firestore.collection("favorites").add({
      "userId": userId,
      "articleId": articleId,
      "savedAt": DateTime.now(),
    });
  }

  /// Xoá bài viết đã lưu 
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

  /// Kiểm tra xem bài viết này đã được lưu chưa
  Stream<bool> isFavorite(String userId, String articleId) {
    return _firestore
        .collection("favorites")
        .where("userId", isEqualTo: userId)
        .where("articleId", isEqualTo: articleId)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty);
  }

  /// Lấy danh sách ID bài viết mà user đã lưu
  Stream<List<String>> getFavorites(String userId) {
    return _firestore
        .collection("favorites")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc["articleId"] as String).toList());
  }
}
