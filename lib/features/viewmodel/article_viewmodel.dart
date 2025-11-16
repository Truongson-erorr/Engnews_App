import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

class ArticleViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all articles from Firestore
  Future<List<ArticleModel>> fetchArticles() async {
    try {
      // Get all documents from 'articles' collection
      final snapshot = await _firestore.collection('articles').get();

      // Convert Firestore documents to a list of ArticleModel
      return snapshot.docs.map((doc) => ArticleModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

  /// Search articles by title (case-insensitive)
  Future<List<ArticleModel>> searchArticlesByTitle(String keyword) async {
    try {
      // Convert keyword to lowercase for more accurate search
      final lowerKeyword = keyword.toLowerCase();

      // Get all articles from Firestore first (client-side filtering)
      final snapshot = await _firestore.collection('articles').get();

      final allArticles = snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();

      // Filter articles whose title contains the keyword
      final results = allArticles.where((article) {
        return article.title.toLowerCase().contains(lowerKeyword);
      }).toList();

      return results;
    } catch (e) {
      print('Error searching articles: $e');
      return [];
    }
  }
}
