import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/article_model.dart';
import '../../models/category_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import 'article_detail.dart';
import '../../../core/animation';
import 'dart:math';
import 'highlightBanner.dart'; 

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ArticleViewModel _articleVM = ArticleViewModel();
  final CategoryViewModel _categoryVM = CategoryViewModel();

  String? userId;

  List<CategoryModel> _categories = [];
  String? _selectedCategoryId;

  late PageController _categoryPageController;
  late ScrollController _menuScrollController;

  List<ArticleModel> _highlightArticles = [];

  @override
  void initState() {
    super.initState();
    _categoryPageController = PageController();
    _menuScrollController = ScrollController();

    userId = FirebaseAuth.instance.currentUser?.uid;

    _loadCategories();
    _loadHighlightArticles();
  }

  @override
  void dispose() {
    _categoryPageController.dispose();
    _menuScrollController.dispose();
    super.dispose();
  }

  void _loadCategories() async {
    final cats = await _categoryVM.fetchCategories();
    if (!mounted) return;
    setState(() {
      _categories = cats;
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id;
      }
    });
  }

  void _loadHighlightArticles() async {
    final articles = await _articleVM.fetchArticles();
    if (!mounted) return;
    if (articles.isNotEmpty) {
      final random = Random();
      _highlightArticles = List.generate(
        7,
        (_) => articles[random.nextInt(articles.length)],
      );
      setState(() {});
    }
  }

  void _scrollToCenter(int index) {
    const double itemWidth = 110, separator = 16;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset =
        (itemWidth + separator) * index - (screenWidth - itemWidth) / 2;

    _menuScrollController.animateTo(
      targetOffset.clamp(
        _menuScrollController.position.minScrollExtent,
        _menuScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onCategorySelected(String categoryId, int index) {
    setState(() => _selectedCategoryId = categoryId);
    _scrollToCenter(index);
    _categoryPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        HighlightBanner(articles: _highlightArticles),
        const SizedBox(height: 12),

        SizedBox(
          height: 40,
          child: ListView.separated(
            controller: _menuScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category.id == _selectedCategoryId;

              return GestureDetector(
                onTap: () => _onCategorySelected(category.id, index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFB42652) : const Color(0xFFECECEC), // đỏ đậm #b42652 khi chọn
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFB42652).withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),

        Expanded(
          child: PageView.builder(
            controller: _categoryPageController,
            onPageChanged: (index) {
              if (index < _categories.length) {
                setState(() => _selectedCategoryId = _categories[index].id);
                _scrollToCenter(index);
              }
            },
            itemCount: _categories.length,
            itemBuilder: (context, pageIndex) {
              final category = _categories[pageIndex];

              return FutureBuilder<List<ArticleModel>>(
                future: _categoryVM.fetchArticlesByCategory(category.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final articles = snapshot.data!;
                  if (articles.isEmpty) {
                    return const Center(
                      child: Text(
                        'Chưa có bài báo nào.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
                      final article = articles[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            createSlideRoute(ArticleDetail(article: article)),
                          );

                          if (userId != null) {
                            ReadingHistoryViewModel().addOrUpdateHistory(
                              userId: userId!,
                              articleId: article.id,
                              title: article.title,
                              description: article.description,
                              image: article.image,
                            );
                          }
                        },
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),                        
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      article.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article.description,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Ngày đăng: ${article.date}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              if (article.image.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    article.image,
                                    height: 90,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
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
