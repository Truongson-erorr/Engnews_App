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
    final historyVM = ReadingHistoryViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Bài báo đã đọc gần đây',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFB42652),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: FutureBuilder<List<ReadingHistoryModel>>(
        future: historyVM.getHistoryOnce(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD0021B)));
          }

          final historyList = snapshot.data!;
          if (historyList.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có bài báo nào.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            separatorBuilder: (_, __) => const Divider(
              color: Color(0xFFE0E0E0),
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
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  
                  child: Row(
                    children: [
                      if (item.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.article_outlined, color: Colors.grey),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Đã đọc ${timeAgo(item.readAt)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
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
