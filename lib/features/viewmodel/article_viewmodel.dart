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

  Future<List<ArticleModel>> searchArticlesByTitle(String keyword) async {
    try {
      // Chuyển từ khóa về chữ thường để tìm chính xác hơn
      final lowerKeyword = keyword.toLowerCase();

      // Lấy tất cả bài viết trước rồi lọc bằng Dart (client-side)
      final snapshot = await _firestore.collection('articles').get();

      final allArticles = snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();

      // Lọc theo tiêu đề có chứa từ khóa (không phân biệt hoa thường)
      final results = allArticles.where((article) {
        return article.title.toLowerCase().contains(lowerKeyword);
      }).toList();

      return results;
    } catch (e) {
      print('Lỗi khi tìm bài viết: $e');
      return [];
    }
  }

}
