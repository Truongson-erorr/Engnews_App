import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/article_model.dart';
import '../../viewmodel/favorite_viewmodel.dart';
import '../../viewmodel/article_viewmodel.dart';
import 'article_detail.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  final FavoriteViewModel _favoriteVM = FavoriteViewModel();
  final ArticleViewModel _articleVM = ArticleViewModel();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Vui lòng đăng nhập để xem bài đã lưu")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<String>>(
        stream: _favoriteVM.getFavorites(user.uid),
        builder: (context, favSnap) {
          if (favSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final favIds = favSnap.data ?? [];

          if (favIds.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có bài viết nào được lưu.",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return FutureBuilder<List<ArticleModel>>(
            future: _articleVM.fetchArticles(),
            builder: (context, articleSnap) {
              if (articleSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final savedArticles = articleSnap.data!
                  .where((a) => favIds.contains(a.id))
                  .toList();

              if (savedArticles.isEmpty) {
                return const Center(
                  child: Text(
                    "Không tìm thấy bài viết.",
                    style: TextStyle(color: Colors.black54),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: savedArticles.length,
                separatorBuilder: (_, __) => Divider(
                  height: 16,
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final article = savedArticles[index];

                  return Dismissible(
                    key: ValueKey(article.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {
                      await _favoriteVM.removeFavorite(user.uid, article.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã xóa bài viết')),
                      );
                    },
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleDetail(article: article),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.article_outlined,
                                          color: Colors.grey),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          article.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      PopupMenuTheme(
                                        data: const PopupMenuThemeData(
                                          color: Colors.white,
                                        ),
                                        child: PopupMenuButton<String>(
                                          icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.grey),
                                          onSelected: (value) async {
                                            if (value == 'delete') {
                                              await _favoriteVM.removeFavorite(
                                                  user.uid, article.id);
                                              
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Đã xóa bài viết')),
                                              );
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child:
                                                  Text('Xóa bài viết đã lưu'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    article.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 13),
                                  ),                               
                                ],
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
          );
        },
      ),
    );
  }
}
