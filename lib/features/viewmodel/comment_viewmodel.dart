import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy tất cả comment của 1 bài viết
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

  // Thêm comment mới
  Future<void> addComment(String articleId, CommentModel comment) async {
    await _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .add(comment.toMap());
  }
}
