import 'package:flutter/material.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../../models/article_model.dart';
import 'article_detail.dart';
import '../../../core/animation';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationViewModel _vm = NotificationViewModel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF015E53),
        title: const Text(
          "Thông báo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.6,
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _vm.previousArticles(),
        builder: (context, previousSnapshot) {
          return StreamBuilder<List<ArticleModel>>(
            stream: _vm.todayArticlesStream(),
            builder: (context, todaySnapshot) {
              final todayArticles = todaySnapshot.data ?? [];
              final previousArticles = previousSnapshot.data ?? [];

              Map<String, List<ArticleModel>> groupedArticles = {};

              if (todayArticles.isNotEmpty) {
                groupedArticles["Hôm nay"] = todayArticles;
              }

              for (var article in previousArticles) {
                final daysAgo = DateTime.now().difference(article.date).inDays;
                final label = "$daysAgo ngày trước";
                groupedArticles.putIfAbsent(label, () => []).add(article);
              }

              final List<Widget> notificationWidgets = [];
              groupedArticles.forEach((label, articles) {
                notificationWidgets.add(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      label,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                );

                final isTodayGroup = (label == "Hôm nay");

                notificationWidgets.addAll(
                  articles.map((article) => _buildNotificationTile(
                        article,
                        theme,
                        context,
                        isTodayGroup,
                      )),
                );
              });

              if (notificationWidgets.isEmpty) {
                return Center(
                  child: Text("No notifications",
                      style: theme.textTheme.bodyMedium),
                );
              }

              return ListView.builder(
                itemCount: notificationWidgets.length,
                itemBuilder: (context, index) => notificationWidgets[index],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(
    ArticleModel article,
    ThemeData theme,
    BuildContext context,
    bool isTodayGroup,
  ) {
    final textColor = theme.colorScheme.onSurface;
    final isNew = DateTime.now().difference(article.date).inDays == 0;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: isTodayGroup ? 2 : 0,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: isTodayGroup ? 16 : 0,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: article.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        article.image,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.notifications,
                      color: Color(0xFF015E53), size: 48),
              title: Text(
                article.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                _formatTimeAgo(article.date),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  createSlideRoute(ArticleDetail(article: article)),
                );
              },
            ),
          ),
        ),

        if (isNew && isTodayGroup)
          const Positioned(
            top: 0,
            right: 16,
            child: Text(
              "Bài viết mới",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimeAgo(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
