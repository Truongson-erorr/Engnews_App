import 'package:flutter/material.dart';
import '../../models/reading_history_model.dart';
import '../../models/article_model.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../../core/animation';
import '../screens/article_detail.dart';

class ReadingHistoryScreen extends StatelessWidget {
  final String userId;
  const ReadingHistoryScreen({super.key, required this.userId});

  // Hàm tính thời gian đọc gần đây
  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
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
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD0021B),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<ReadingHistoryModel>>(
        future: historyVM.getHistoryOnce(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyList = snapshot.data!;
          if (historyList.isEmpty) {
            return const Center(child: Text('Chưa có bài báo nào.'));
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
                onTap: () async {
                  final articleVM = ArticleViewModel();
                  final fullArticle = await articleVM.getArticleById(item.articleId);

                  if (fullArticle != null) {
                    Navigator.push(
                      context,
                      createSlideRoute(ArticleDetail(article: fullArticle)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không tìm thấy bài báo.')),
                    );
                  }
                },
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
                      ),
                    const SizedBox(width: 8),
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
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Đã đọc ${timeAgo(item.readAt)}',
                            style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 127, 127, 127)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
