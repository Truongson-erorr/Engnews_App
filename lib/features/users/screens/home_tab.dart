import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/article_model.dart';
import '../../models/category_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import 'article_detail.dart';

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

  @override
  void initState() {
    super.initState();
    _categoryPageController = PageController();
    _menuScrollController = ScrollController();
    userId = FirebaseAuth.instance.currentUser?.uid;

    _loadCategories();
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
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.separated(
            controller: _menuScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category.id == _selectedCategoryId;

              return GestureDetector(
                onTap: () => _onCategorySelected(category.id, index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF015E53)
                            : cs.onSurfaceVariant,
                      ),
                      child: Text(category.title),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: isSelected ? 30 : 0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF015E53),
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
          child: PageView.builder(
            controller: _categoryPageController,
            onPageChanged: (index) {
              if (index < _categories.length) {
                setState(() =>
                    _selectedCategoryId = _categories[index].id);
                _scrollToCenter(index);
              }
            },
            itemCount: _categories.length,
            itemBuilder: (context, pageIndex) {
              final category = _categories[pageIndex];

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: FutureBuilder<List<ArticleModel>>(
                  future:
                      _categoryVM.fetchArticlesByCategory(category.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final articles = snapshot.data!;
                    if (articles.isEmpty) {
                      return ListView(
                        physics:
                            const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(child: Text('Chưa có bài báo nào')),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: articles.length,
                      separatorBuilder: (_, __) => Divider(
                        color: cs.outlineVariant,
                        thickness: 1,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final article = articles[index];

                        return FutureBuilder<int>(
                          future: _articleVM
                              .getCommentCount(article.id),
                          builder: (context, snapshot) {
                            final commentCount =
                                snapshot.data ?? 0;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArticleDetail(article: article),
                                  ),
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
                                height: 120,
                                padding:
                                    const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  color: cs.surface,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        children: [
                                          Text(
                                            article.title,
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style: textTheme
                                                .titleMedium!
                                                .copyWith(
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            article.description,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                textTheme.bodySmall,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.comment,
                                                  size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                '$commentCount bình luận',
                                                style: textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (article.image.isNotEmpty)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8),
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
              );
            },
          ),
        ),
      ],
    );
  }
}
