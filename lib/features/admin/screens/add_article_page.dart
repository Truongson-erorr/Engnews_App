import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../models/category_model.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _articleVM = ArticleViewModel();
  final _categoryVM = CategoryViewModel();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _contentImageCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  List<CategoryModel> _categories = [];
  String? _selectedCategoryId;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await _categoryVM.fetchCategories();
    setState(() {
      _categories = data;
      if (data.isNotEmpty) {
        _selectedCategoryId = data.first.id;
      }
    });
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty ||
        _descCtrl.text.isEmpty ||
        _imageCtrl.text.isEmpty ||
        _contentCtrl.text.isEmpty ||
        _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    setState(() => _loading = true);

    await _articleVM.addArticle(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      image: _imageCtrl.text,
      contentImage: _contentImageCtrl.text,
      content: _contentCtrl.text,
      categoryId: _selectedCategoryId!,
    );

    setState(() => _loading = false);
    Navigator.pop(context, true);
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Thêm bài viết mới"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field("Tiêu đề", _titleCtrl),
            _field("Mô tả ngắn", _descCtrl),
            _field("Link ảnh thumbnail", _imageCtrl),
            _field("Link ảnh nội dung", _contentImageCtrl),

            /// ===== CATEGORY DROPDOWN =====
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.title),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategoryId = value);
                },
                decoration: InputDecoration(
                  labelText: "Danh mục",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            _field("Nội dung bài viết", _contentCtrl, maxLines: 6),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _loading ? null : _submit,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: Colors.green.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "+ Thêm bài viết",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
