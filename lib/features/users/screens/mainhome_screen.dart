import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import 'article_detail.dart';
import '../../../core/animation';
import 'package:firebase_auth/firebase_auth.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final ArticleViewModel _articleVM = ArticleViewModel();
  List<ArticleModel> _articles = [];
  bool _isLoading = true;

  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    final articles = await _articleVM.fetchArticles();
    setState(() {
      _articles = articles;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C1A1F),
      appBar: AppBar(
        title: const Text('Trang chủ', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3B1322),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _articles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final article = _articles[index];
                return GestureDetector(
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B1322),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        if (article.image.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              article.image,
                              width: 90,
                              height: 70,
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
                                  fontSize: 16,
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
                                  fontSize: 14,
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
            ),
    );
  }
}
