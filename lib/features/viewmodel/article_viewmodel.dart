import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

class ArticleViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy danh sách tất cả bài viết từ Firestore
  Future<List<ArticleModel>> fetchArticles() async {
    try {
      // Lấy toàn bộ tài liệu trong collection 'articles'
      final snapshot = await _firestore.collection('articles').get();

      // Chuyển dữ liệu Firestore thành danh sách ArticleModel
      return snapshot.docs.map((doc) => ArticleModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Lỗi khi lấy bài báo: $e');
      return [];
    }
  }
}
