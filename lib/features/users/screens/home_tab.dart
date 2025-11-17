import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../models/category_model.dart';
import 'article_detail.dart';
import '../../../core/animation';
import 'dart:math';

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

  // Tin nổi bật (banner)
  List<ArticleModel> _highlightArticles = [];
  int _currentBannerIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _futureArticles = _articleVM.fetchArticles();
    _loadCategories();
    _loadHighlightArticles();

    _pageController = PageController();
    _startBannerAutoScroll();
  }

  void _loadHighlightArticles() async {
    final articles = await _articleVM.fetchArticles();
    if (articles.isNotEmpty) {
      final random = Random();
      // chọn ngẫu nhiên 3 bài làm tin nổi bật
      _highlightArticles = List.generate(
        3,
        (_) => articles[random.nextInt(articles.length)],
      );
      setState(() {});
    }
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients && _highlightArticles.isNotEmpty) {
        _currentBannerIndex = (_currentBannerIndex + 1) % _highlightArticles.length;
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startBannerAutoScroll();
      }
    });
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
        SizedBox(
          height: 230,
          child: _highlightArticles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : PageView.builder(
                  controller: _pageController,
                  itemCount: _highlightArticles.length,
                  itemBuilder: (context, index) {
                    final article = _highlightArticles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createSlideRoute(ArticleDetail(article: article)),
                        );
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            article.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(12),
                            color: Colors.black38,
                            child: Text(
                              article.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? const Color(0xFFD0021B) : Colors.black87,
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
                  color: Color.fromARGB(255, 224, 224, 224), 
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
                    },
                    child: Container(
                      height: 110, 
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
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
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  article.description,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Ngày đăng: ${article.date.toLocal().day}/${article.date.toLocal().month}/${article.date.toLocal().year}',
                                  style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 109, 109, 109)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (article.image.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8), // bo tròn 8
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
          ),
        ),
      ],
    );
  }
}
