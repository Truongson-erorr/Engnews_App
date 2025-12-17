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

  // Get up to 5 related posts in the same category, excluding the current post
  Future<List<ArticleModel>> fetchRelatedArticles(String categoryId, String excludeId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('articles')
      .where('categoryId', isEqualTo: categoryId)
      .limit(5)
      .get();

  return snapshot.docs
      .map((doc) => ArticleModel.fromFirestore(doc))
      .where((a) => a.id != excludeId)
      .toList();
  }

  // Get 10 random posts form firestore
  Future<List<ArticleModel>> fetchRandomArticles({int limit = 15}) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('articles')
        .get();

    final allArticles = snapshot.docs
        .map((doc) => ArticleModel.fromFirestore(doc))
        .toList();

    allArticles.shuffle(); 
    return allArticles.take(limit).toList();
  }

  // Listen in realtime when there are new posts
  Stream<List<ArticleModel>> listenArticlesFromToday() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day); 

    return _firestore
        .collection('articles')
        .where('date', isGreaterThanOrEqualTo: todayStart)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    });
  }

  // count the number of comments
  Future<int> getCommentCount(String articleId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .get();

    return snapshot.docs.length;
  }

  // Fetch ALL articles, ordered by newest first
  Future<List<ArticleModel>> fetchLatestArticles() async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching latest articles: $e');
      return [];
    }
  }

  // edit article for flow admin
  Future<void> updateArticle({
    required String articleId,
    required String title,
    required String description,
    required String image,
    required String contentImage,
    String? categoryId,
  }) async {
    await _firestore.collection('articles').doc(articleId).update({
      'title': title,
      'description': description,
      'image': image,
      'contentImage': contentImage,
      if (categoryId != null) 'categoryId': categoryId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

}
