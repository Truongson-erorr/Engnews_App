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
  State<ArticlesByCategoryScreen> createState() => _ArticlesByCategoryScreenState();
}

class _ArticlesByCategoryScreenState extends State<ArticlesByCategoryScreen> {
  final CategoryViewModel _viewModel = CategoryViewModel();
  late Future<List<ArticleModel>> _futureArticles;

  // userId có thể null nếu chưa đăng nhập
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _futureArticles = _viewModel.fetchArticlesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C1A1F), 
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 59, 19, 34),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return const Center(
              child: Text(
                'Không có bài viết nào trong danh mục này.',
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
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () async {
                  // Chỉ thêm vào lịch sử nếu user đã đăng nhập
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C1A1F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: article.image.isNotEmpty
                            ? Image.network(
                                article.image,
                                width: 100,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 100,
                                height: 80,
                                color: Colors.grey[700],
                                child: const Icon(Icons.article_outlined, color: Colors.grey),
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
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              article.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ngày đăng: ${article.date.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
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
