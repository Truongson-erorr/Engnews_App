import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../models/category_model.dart';
import 'article_detail.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ArticleViewModel _articleVM = ArticleViewModel();
  final CategoryViewModel _categoryVM = CategoryViewModel();

  List<CategoryModel> _categories = [];
  String? _selectedCategoryId;

  late Future<List<ArticleModel>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = _articleVM.fetchArticles();
    _loadCategories();
  }

  void _loadCategories() async {
    final cats = await _categoryVM.fetchCategories();
    setState(() {
      _categories = cats;
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id;
      }
      _futureArticles = _fetchArticles();
    });
  }

  Future<List<ArticleModel>> _fetchArticles() {
    if (_selectedCategoryId == null) {
      return _articleVM.fetchArticles();
    } else {
      return _categoryVM.fetchArticlesByCategory(_selectedCategoryId!);
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _futureArticles = _fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 50, 
          child: _categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category.id == _selectedCategoryId;

                    return GestureDetector(
                      onTap: () => _onCategorySelected(category.id),
                      child: Center(
                        child: Text(
                          category.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color.fromARGB(255, 41, 48, 255) : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),

        Expanded(
          child: FutureBuilder<List<ArticleModel>>(
            future: _futureArticles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              }

              final articles = snapshot.data ?? [];
              if (articles.isEmpty) {
                return const Center(child: Text('Chưa có bài báo nào.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: articles.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 20,
                  thickness: 1,
                  color: Color.fromARGB(255, 199, 199, 199),
                ),
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetail(article: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.image.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              article.image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.description,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ngày đăng: ${article.date.toLocal()}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
