import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import 'article_detail.dart';
import '../../viewmodel/category_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import '../../../core/animation';

class ArticlesByCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const ArticlesByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<ArticlesByCategoryScreen> createState() =>
      _ArticlesByCategoryScreenState();
}

class _ArticlesByCategoryScreenState extends State<ArticlesByCategoryScreen> {
  final CategoryViewModel _viewModel = CategoryViewModel();
  late Future<List<ArticleModel>> _futureArticles;

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _futureArticles = _viewModel.fetchArticlesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: const Color(0xFFB42652), 
        elevation: 1,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<ArticleModel>>(
        future: _futureArticles,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return Center(
              child: Text(
                'Không có bài viết nào trong danh mục này.',
                style: TextStyle(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
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
                    createSlideRoute(ArticleDetail(article: article)),
                  );
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.cardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: article.image.isNotEmpty
                            ? Image.network(
                                article.image,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                height: 180,
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                                child: Icon(
                                  Icons.article_outlined,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey,
                                  size: 50,
                                ),
                              ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              article.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              article.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Ngày đăng: ${article.date.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                              ),
                            ),
                          ],
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
    );
  }
}
