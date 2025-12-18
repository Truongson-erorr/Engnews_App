import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/article_model.dart';

class CategoryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, String> _categoryTitleCache = {};

  Future<void> preloadCategories() async {
    if (_categoryTitleCache.isNotEmpty) return;

    try {
      final snapshot = await _firestore.collection('categories').get();
      for (var doc in snapshot.docs) {
        _categoryTitleCache[doc.id] = doc['title'] ?? '';
      }
    } catch (e) {
      print('Lỗi preload category: $e');
    }
  }

  String getCategoryTitle(String categoryId) {
    return _categoryTitleCache[categoryId] ?? '';
  }

  /// get all category
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

  /// get articles by cateogry
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

  /// add cate
  Future<void> addCategory(String title, {String? description}) async {
    try {
      final newDoc = _firestore.collection('categories').doc();

      await newDoc.set({
        'id': newDoc.id,
        'title': title,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });

      /// update 
      _categoryTitleCache[newDoc.id] = title;
    } catch (e) {
      print("Lỗi khi thêm danh mục: $e");
      rethrow;
    }
  }

  /// update cate
  Future<void> updateCategory(
    String categoryId,
    String newTitle, {
    String? newDescription,
  }) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'title': newTitle,
        'description': newDescription ?? "",
      });

      /// update 
      _categoryTitleCache[categoryId] = newTitle;
    } catch (e) {
      print('Lỗi khi cập nhật danh mục: $e');
      rethrow;
    }
  }

  /// delete cate
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();

      _categoryTitleCache.remove(categoryId);
    } catch (e) {
      print("Lỗi khi xoá danh mục: $e");
      rethrow;
    }
  }
}
