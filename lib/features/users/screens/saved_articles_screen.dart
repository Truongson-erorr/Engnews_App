import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/article_model.dart';
import '../../viewmodel/favorite_viewmodel.dart';
import '../../viewmodel/article_viewmodel.dart';
import 'article_detail.dart';
import '../../../core/animation';

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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (user == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Text(
            "Vui lòng đăng nhập để xem bài đã lưu",
            style: textTheme.bodyMedium?.copyWith(color: colors.onBackground),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: StreamBuilder<List<String>>(
        stream: _favoriteVM.getFavorites(user.uid),
        builder: (context, favSnap) {
          if (favSnap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          final favIds = favSnap.data ?? [];

          if (favIds.isEmpty) {
            return Center(
              child: Text(
                "Chưa có bài viết nào được lưu.",
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
              ),
            );
          }

          return FutureBuilder<List<ArticleModel>>(
            future: _articleVM.fetchArticles(),
            builder: (context, articleSnap) {
              if (articleSnap.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: colors.primary),
                );
              }

              final savedArticles =
                  articleSnap.data!.where((a) => favIds.contains(a.id)).toList();

              if (savedArticles.isEmpty) {
                return Center(
                  child: Text(
                    "Không tìm thấy bài viết.",
                    style:
                        textTheme.bodyMedium?.copyWith(color: colors.onSurface),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: savedArticles.length,
                separatorBuilder: (_, __) => Divider(
                  color: colors.outline.withOpacity(0.3),
                  thickness: 1,
                  height: 16,
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
                      color: colors.error,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          createSlideRoute(ArticleDetail(article: article)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
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
                                      color: colors.surfaceVariant,
                                      child: Icon(
                                        Icons.article_outlined,
                                        color: colors.onSurfaceVariant,
                                      ),
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
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                  color: colors.onBackground,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: Icon(Icons.more_vert,
                                            color: colors.primary),
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
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    article.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
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
