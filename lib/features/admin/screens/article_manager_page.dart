import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../models/article_model.dart';
import 'edit_article_page.dart';
import '../../admin/screens/add_article_page.dart';

class ArticleManagerPage extends StatefulWidget {
  const ArticleManagerPage({super.key});

  @override
  State<ArticleManagerPage> createState() => _ArticleManagerPageState();
}

class _ArticleManagerPageState extends State<ArticleManagerPage> {
  final ArticleViewModel _articleVM = ArticleViewModel();
  List<ArticleModel> _articles = [];
  List<ArticleModel> _filteredArticles = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    final fetched = await _articleVM.fetchArticles();
    setState(() {
      _articles = fetched;
      _filteredArticles = fetched;
      _isLoading = false;
    });
  }

  void _searchArticles(String keyword) {
    if (keyword.isEmpty) {
      setState(() => _filteredArticles = _articles);
    } else {
      setState(() {
        _filteredArticles = _articles
            .where(
                (a) => a.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      });
    }
  }

  void _deleteArticle(String articleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xoá"),
        content: const Text(
          "Bạn có chắc chắn muốn xoá bài viết này không?\nHành động này không thể hoàn tác.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Huỷ"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Xoá"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await _articleVM.deleteArticle(articleId);
    _loadArticles();
  }

  void _editArticle(ArticleModel article) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditArticlePage(article: article),
      ),
    );

    if (updated == true) _loadArticles();
  }

  void _addNewArticle() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddArticlePage(),
      ),
    );

    if (created == true) _loadArticles();
  }

  void _showVisibilityBottomSheet(ArticleModel article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(
                  article.isVisible ? Icons.visibility_off : Icons.visibility,
                  color: article.isVisible
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                ),
                title: Text(
                  article.isVisible ? "Ẩn bài viết" : "Hiển thị bài viết",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: article.isVisible
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _articleVM.updateVisibility(
                      article.id, !article.isVisible);
                  _loadArticles();
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _addNewArticle,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: Colors.green.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                ),
                child: const Text(
                  "+ Thêm bài viết mới",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm bài viết...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _searchArticles,
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredArticles.isEmpty
                    ? const Center(child: Text("Không có bài viết nào"))
                    : RefreshIndicator(
                        onRefresh: _loadArticles,
                        child: ListView.builder(
                          itemCount: _filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = _filteredArticles[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        article.image,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 70,
                                          height: 70,
                                          color: Colors.grey[300],
                                          child:
                                              const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            article.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                          const SizedBox(height: 6),

                                          Row(
                                            children: [
                                              const Text(
                                                "Trạng thái:",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(width: 6),

                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onTap: () =>
                                                    _showVisibilityBottomSheet(
                                                        article),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        article.isVisible
                                                            ? "Hiển thị"
                                                            : "Ẩn",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Column(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              _editArticle(article),
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade50,
                                            foregroundColor:
                                                Colors.blue.shade800,
                                            minimumSize:
                                                const Size(60, 32),
                                          ),
                                          child: const Text("Sửa"),
                                        ),
                                        const SizedBox(height: 4),
                                        TextButton(
                                          onPressed: () =>
                                              _deleteArticle(article.id),
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade50,
                                            foregroundColor:
                                                Colors.red.shade800,
                                            minimumSize:
                                                const Size(60, 32),
                                          ),
                                          child: const Text("Xóa"),
                                        ),
                                      ],
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
