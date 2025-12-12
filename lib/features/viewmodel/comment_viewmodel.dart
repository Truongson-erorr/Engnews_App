import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
