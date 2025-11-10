import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import 'article_detail.dart';
import '../../viewmodel/category_viewmodel.dart';

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

  @override
  void initState() {
    super.initState();
    _futureArticles = _viewModel.fetchArticlesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        widget.categoryTitle, 
        style: const TextStyle(
          color: Colors.white,  
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 30, 30, 255),
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white, 
      ),
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return const Center(child: Text('No articles in this category.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetail(article: article),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 120, 
                    child: Row(
                      children: [
                        if (article.image.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                            child: Image.network(
                              article.image,
                              width: 110,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: 110,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                            ),
                            child: const Icon(Icons.article_outlined, color: Colors.white, size: 30),
                          ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    article.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Flexible(
                                  child: Text(
                                    article.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12, 
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Published: ${article.date.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
