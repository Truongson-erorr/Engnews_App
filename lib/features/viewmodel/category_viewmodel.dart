import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/article_model.dart';

class CategoryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all categories from Firestore
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Lỗi khi lấy danh mục: $e'); 
      return [];
    }
  }

  /// Fetch articles by categoryId
  Future<List<ArticleModel>> fetchArticlesByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('articles')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return snapshot.docs
          .map((doc) => ArticleModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Lỗi khi lấy bài viết theo danh mục: $e');
      return [];
    }
  }
}
