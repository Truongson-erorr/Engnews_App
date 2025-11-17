import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

class ArticleViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all articles
  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final snapshot = await _firestore.collection('articles').get();
      return snapshot.docs.map((doc) => ArticleModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  // Fetch article by ID
  Future<ArticleModel?> getArticleById(String articleId) async {
    try {
      final doc = await _firestore.collection('articles').doc(articleId).get();
      if (doc.exists) {
        return ArticleModel.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching article by ID: $e');
      return null;
    }
  }

  // Search articles by title (case-insensitive)
  Future<List<ArticleModel>> searchArticlesByTitle(String keyword) async {
    try {
      final lowerKeyword = keyword.toLowerCase();
      final snapshot = await _firestore.collection('articles').get();
      final allArticles = snapshot.docs.map((doc) => ArticleModel.fromFirestore(doc)).toList();
      return allArticles.where((article) => article.title.toLowerCase().contains(lowerKeyword)).toList();
    } catch (e) {
      print('Error searching articles: $e');
      return [];
    }
  }
}
