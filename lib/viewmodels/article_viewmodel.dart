import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/article_model.dart';

class ArticleViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final snapshot = await _firestore.collection('articles').get();
      return snapshot.docs.map((doc) => ArticleModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Lỗi khi lấy bài báo: $e');
      return [];
    }
  }
}
