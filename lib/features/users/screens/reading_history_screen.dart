import 'package:flutter/material.dart';
import '../../models/reading_history_model.dart';
import '../../models/article_model.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import '../../../core/animation';
import '../screens/article_detail.dart';

class ReadingHistoryScreen extends StatelessWidget {
  final String userId;
  const ReadingHistoryScreen({super.key, required this.userId});

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return '${diff.inSeconds} giây trước';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyVM = ReadingHistoryViewModel();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Đã xem gần đây',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF015E53),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<ReadingHistoryModel>>(
        future: historyVM.getHistoryOnce(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          final historyList = snapshot.data!;
          if (historyList.isEmpty) {
            return Center(
              child: Text(
                'Chưa có bài báo nào.',
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(.6)),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            separatorBuilder: (_, __) => Divider(
              color: theme.dividerColor,
              thickness: 1,
              height: 16,
            ),
            itemBuilder: (context, index) {
              final item = historyList[index];

              final article = ArticleModel(
                id: item.articleId,
                title: item.title,
                description: item.description,
                image: item.image,
                contentImage: '',
                content: '',
                comment: '',
                categoryId: '',
                date: item.readAt,
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    createSlideRoute(ArticleDetail(article: article)),
                  );

                  Future.microtask(() {
                    ReadingHistoryViewModel().addOrUpdateHistory(
                      userId: userId,
                      articleId: article.id,
                      title: article.title,
                      description: article.description,
                      image: article.image,
                    );
                  });
                },

                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.07),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),

                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.image.isNotEmpty
                            ? Image.network(
                                item.image,
                                width: 100,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 100,
                                height: 80,
                                color: theme.dividerColor.withOpacity(.2),
                                child: Icon(
                                  Icons.article_outlined,
                                  color: theme.iconTheme.color,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall!.color!.withOpacity(.8),
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'Đã đọc ${timeAgo(item.readAt)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.textTheme.bodySmall!.color!.withOpacity(.6),
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
