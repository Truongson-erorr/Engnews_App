import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../screens/article_detail.dart';

class RelatedArticlesWidget extends StatelessWidget {
  final String categoryId;
  final String currentArticleId;

  const RelatedArticlesWidget({
    super.key,
    required this.categoryId,
    required this.currentArticleId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Bài viết liên quan",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),

        FutureBuilder<List<ArticleModel>>(
          future: ArticleViewModel().fetchRelatedArticles(
            categoryId,
            currentArticleId,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final related = snapshot.data!;
            if (related.isEmpty) {
              return const Text(
                "Không có bài viết liên quan.",
                style: TextStyle(color: Colors.grey),
              );
            }

            return SizedBox(
              height: 140, 
              child: ListView.separated(
                scrollDirection: Axis.horizontal, 
                itemCount: related.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12), 
                itemBuilder: (context, index) {
                  final article = related[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetail(article: article),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 220, 
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              article.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  article.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Ngày: ${article.date.toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 10),
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
          },
        ),
      ],
    );
  }
}
