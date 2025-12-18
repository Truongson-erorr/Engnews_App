import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import '../../viewmodel/category_viewmodel.dart';
import 'article_detail.dart';
import '../screens/banner_article_.dart';
import '../../../core/color.dart';

enum ArticleSortType { newest, oldest }

class LatestArticlesScreen extends StatefulWidget {
  const LatestArticlesScreen({super.key});

  @override
  State<LatestArticlesScreen> createState() =>
      _LatestArticlesScreenState();
}

class _LatestArticlesScreenState
    extends State<LatestArticlesScreen> {
  final ArticleViewModel _viewModel = ArticleViewModel();
  final CategoryViewModel _categoryVM = CategoryViewModel();

  late Future<List<ArticleModel>> _futureArticles;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  ArticleSortType _sortType = ArticleSortType.newest;

  @override
  void initState() {
    super.initState();
    _futureArticles = _viewModel.fetchLatestArticles();
    _categoryVM.preloadCategories();
  }

  Color _getCategoryColor(String categoryId) {
    final index =
        categoryId.hashCode.abs() % categoryColors.length;
    return categoryColors[index];
  }

  List<ArticleModel> _sortArticles(List<ArticleModel> articles) {
    final sorted = List<ArticleModel>.from(articles);
    sorted.sort((a, b) => _sortType == ArticleSortType.newest
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));
    return sorted;
  }

  void _openDetail(ArticleModel article) {
    if (userId != null) {
      ReadingHistoryViewModel().addOrUpdateHistory(
        userId: userId!,
        articleId: article.id,
        title: article.title,
        description: article.description,
        image: article.image,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetail(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<ArticleSortType>(
                icon: Icon(
                  Icons.filter_list_alt,
                  size: 22,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                onSelected: (value) {
                  setState(() => _sortType = value);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: ArticleSortType.newest,
                    child: Text('Mới nhất'),
                  ),
                  PopupMenuItem(
                    value: ArticleSortType.oldest,
                    child: Text('Cũ nhất'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<List<ArticleModel>>(
                future: _futureArticles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final articles =
                      _sortArticles(snapshot.data ?? []);
                  final featured = articles.take(8).toList();
                  final rest = articles.skip(8).toList();

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      FeaturedArticleCarousel(
                        articles: featured,
                        onTap: _openDetail,
                      ),
                      const SizedBox(height: 24),

                      ...rest.map(
                        (article) =>
                            _buildCompactArticle(theme, article),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactArticle(
    ThemeData theme,
    ArticleModel article,
  ) {
    final categoryColor =
        _getCategoryColor(article.categoryId);

    return InkWell(
      onTap: () => _openDetail(article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.image,
                width: 120,
                height: 95,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        article.date
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 10),

                      FutureBuilder<int>(
                        future:
                            _viewModel.getCommentCount(article.id),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return Row(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 13,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const Spacer(),

                      /// ===== CATEGORY BADGE =====
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _categoryVM
                              .getCategoryTitle(article.categoryId),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
