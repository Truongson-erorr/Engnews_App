import 'package:flutter/material.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../models/category_model.dart';
import 'edit_categorypage.dart';

class CategoryManagerPage extends StatefulWidget {
  const CategoryManagerPage({super.key});

  @override
  State<CategoryManagerPage> createState() => _CategoryManagerPageState();
}

class _CategoryManagerPageState extends State<CategoryManagerPage> {
  final CategoryViewModel _categoryVM = CategoryViewModel();
  List<CategoryModel> _categories = [];
  List<CategoryModel> _filteredCategories = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final fetched = await _categoryVM.fetchCategories();
    setState(() {
      _categories = fetched;
      _filteredCategories = fetched;
      _isLoading = false;
    });
  }

  void _searchCategories(String keyword) {
    if (keyword.isEmpty) {
      setState(() => _filteredCategories = _categories);
    } else {
      setState(() {
        _filteredCategories = _categories
            .where((c) => c.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      });
    }
  }

  void _deleteCategory(String categoryId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xoá danh mục!")),
    );
    _loadCategories();
  }

  void _editCategory(CategoryModel category) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryPage(
          category: category,
          categoryVM: _categoryVM,
        ),
      ),
    );

    if (result == true) {
      _loadCategories(); 
    }
  }

  void _addCategory() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quản lý danh mục",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: _addCategory, 
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade100, 
                    foregroundColor: Colors.green.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text(
                    "+ Thêm danh mục mới",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCategories.isEmpty
                    ? const Center(child: Text("Không có danh mục nào"))
                    : RefreshIndicator(
                        onRefresh: _loadCategories,
                        child: ListView.builder(
                          itemCount: _filteredCategories.length,
                          itemBuilder: (context, index) {
                            final category = _filteredCategories[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              color: Colors.white,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  category.title,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "ID: ${category.id}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () => _editCategory(category),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue.shade50,
                                      ),
                                      child: const Text(
                                        "Sửa",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () => _deleteCategory(category.id),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red.shade50,
                                      ),
                                      child: const Text(
                                        "Xóa",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
