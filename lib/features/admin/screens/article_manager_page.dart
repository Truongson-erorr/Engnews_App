import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../models/article_model.dart';

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
            .where((a) => a.title.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      });
    }
  }

  void _deleteArticle(String articleId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã xoá bài viết!")),
    );
    _loadArticles();
  }

  void _editArticle(ArticleModel article) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm bài viết...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
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
                                          child: const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () => _editArticle(article),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue.shade50,
                                            foregroundColor: Colors.blue.shade800,
                                            minimumSize: const Size(60, 32),
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                          ),
                                          child: const Text("Sửa"),
                                        ),
                                        const SizedBox(height: 4),

                                        TextButton(
                                          onPressed: () => _deleteArticle(article.id),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red.shade50,
                                            foregroundColor: Colors.red.shade800,
                                            minimumSize: const Size(60, 32),
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
