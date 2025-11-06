import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/category_model.dart';

class CategoryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
