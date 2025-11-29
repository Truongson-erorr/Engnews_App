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

  final String userId = FirebaseAuth.instance.currentUser!.uid;

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
    setState(() {
      _categories = cats;
      if (_categories.isNotEmpty) _selectedCategoryId = _categories.first.id;
    });
  }

  void _loadHighlightArticles() async {
    final articles = await _articleVM.fetchArticles();
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
    const double itemWidth = 80, separator = 16;
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
    return Column(
      children: [
        HighlightBanner(articles: _highlightArticles),
        const SizedBox(height: 8),

        SizedBox(
          height: 50,
          child: _categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  controller: _menuScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category.id == _selectedCategoryId;

                    return GestureDetector(
                      onTap: () => _onCategorySelected(category.id, index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFFD0021B)
                                  : const Color.fromARGB(221, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 3,
                            width: isSelected ? 24 : 0,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD0021B) : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: PageView.builder(
            controller: _categoryPageController,
            onPageChanged: (index) {
              setState(() => _selectedCategoryId = _categories[index].id);
              _scrollToCenter(index);
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
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: Color(0xFF4A3A3F),
                      thickness: 1,
                      height: 16,
                    ),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            createSlideRoute(ArticleDetail(article: article)),
                          );
                          ReadingHistoryViewModel().addOrUpdateHistory(
                            userId: userId,
                            articleId: article.id,
                            title: article.title,
                            description: article.description,
                            image: article.image,
                          );
                        },
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C1A1F),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[300],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Ngày đăng: ${article.date}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: const Color.fromARGB(255, 110, 110, 110),
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
