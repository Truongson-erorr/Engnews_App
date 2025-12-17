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

  /// Add new category 
  Future<void> addCategory(String title, {String? description}) async {
    try {
      final newDoc = _firestore.collection('categories').doc();

      await newDoc.set({
        'id': newDoc.id,
        'title': title,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Lỗi khi thêm danh mục: $e");
      rethrow;
    }
  }

  /// Update category (title + description)
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
    } catch (e) {
      print('Lỗi khi cập nhật danh mục: $e');
      rethrow;
    }
  }

  /// Delete category by ID
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      print("Lỗi khi xoá danh mục: $e");
      rethrow;
    }
  }
}
