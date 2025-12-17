import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';

class EditArticlePage extends StatefulWidget {
  final ArticleModel article;

  const EditArticlePage({
    super.key,
    required this.article,
  });

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final ArticleViewModel _viewModel = ArticleViewModel();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _contentImageCtrl;
  late TextEditingController _contentCtrl;
  late TextEditingController _categoryCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.article;

    _titleCtrl = TextEditingController(text: a.title);
    _descCtrl = TextEditingController(text: a.description);
    _imageCtrl = TextEditingController(text: a.image);
    _contentImageCtrl = TextEditingController(text: a.contentImage);
    _contentCtrl = TextEditingController(text: a.content);
    _categoryCtrl = TextEditingController(text: a.categoryId);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    _contentImageCtrl.dispose();
    _contentCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      await _viewModel.updateArticle(
        articleId: widget.article.id,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        image: _imageCtrl.text.trim(),
        categoryId: _categoryCtrl.text.trim(),
        contentImage: _contentImageCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thành công')),
        );
        Navigator.pop(context, true);
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi cập nhật')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black, 
        title: const Text(
          'Sửa bài viết',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(
              title: 'Thông tin cơ bản',
              children: [
                _input(_titleCtrl, 'Tiêu đề', minLines: 3),
                _input(_descCtrl, 'Chi tiết bài viết',
                    minLines: 3, maxLines: 10),
              ],
            ),

            _section(
              title: 'Hình ảnh',
              children: [
                _input(_imageCtrl, 'Ảnh đại diện (URL)'),
                if (_imageCtrl.text.isNotEmpty)
                  _imagePreview(_imageCtrl.text),
                const SizedBox(height: 12),
                _input(_contentImageCtrl, 'Ảnh nội dung (URL)'),
                if (_contentImageCtrl.text.isNotEmpty)
                  _imagePreview(_contentImageCtrl.text),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                elevation: 0,

                side: BorderSide(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController ctrl,
    String label, {
    int minLines = 1,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        minLines: minLines,
        maxLines: maxLines ?? minLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (v) =>
            v == null || v.isEmpty ? 'Không được để trống' : null,
      ),
    );
  }

  Widget _imagePreview(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 160,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}
