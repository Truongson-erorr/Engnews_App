import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';

class CommentViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get username from firestore 
  Future<String> getUserName(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return "Người dùng";
    return doc.data()?['fullName'] ?? "Người dùng";
  }

  // get all comments for an article
  Stream<List<CommentModel>> getComments(String articleId) {
    return _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList());
  }

  // add a new comment
  Future<void> addComment(String articleId, CommentModel comment) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .add(comment.toMap());
  }

  // allows users to delete comments
  Future<void> deleteComment(String articleId, String commentId) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  // get user image by uid
  Future<String?> getUserImage(String userIdentifier) async {
    try {
      final q1 = await _firestore
          .collection('users')
          .where('email', isEqualTo: userIdentifier)
          .get();

      if (q1.docs.isNotEmpty) {
        return q1.docs.first['image'] ?? '';
      }

      final q2 = await _firestore
          .collection('users')
          .where('fullName', isEqualTo: userIdentifier)
          .get();

      if (q2.docs.isNotEmpty) {
        return q2.docs.first['image'] ?? '';
      }

      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
  
}
