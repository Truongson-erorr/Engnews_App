import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../models/article_model.dart';
import 'package:intl/intl.dart';
import 'article_detail.dart'; 
import '../../../core/animation';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final articleVM = ArticleViewModel();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB42652),
        title: const Text(
          "Thông báo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.6,
      ),
      body: StreamBuilder<List<ArticleModel>>(
        stream: articleVM.listenArticlesFromToday(), // lấy tất cả bài
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No notifications",
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          final articles = snapshot.data!;

          final todayStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          final todayArticles = articles.where((a) => a.date.isAfter(todayStart)).toList();
          final previousArticles = articles.where((a) => a.date.isBefore(todayStart)).toList();

          final List<Widget> notificationWidgets = [];

          if (todayArticles.isNotEmpty) {
            notificationWidgets.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Hôm nay",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
            notificationWidgets.addAll(todayArticles.map(
              (article) => _buildNotificationTile(article, theme, context)
            ));
          }

          if (previousArticles.isNotEmpty) {
            notificationWidgets.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ngày trước đó",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
            notificationWidgets.addAll(previousArticles.map(
              (article) => _buildNotificationTile(article, theme, context)
            ));
          }

          return ListView.separated(
            itemCount: notificationWidgets.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: const Color.fromARGB(255, 192, 192, 192).withOpacity(0.2),
            ),
            itemBuilder: (context, index) => notificationWidgets[index],
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(ArticleModel article, ThemeData theme, BuildContext context) {
    final textColor = theme.colorScheme.onSurface;
    final timeAgo = _formatTimeAgo(article.date);

    return ListTile(
      leading: article.image != null && article.image!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                article.image!,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(
              Icons.notifications,
              color: Color(0xFFB42652),
            ),
      title: Text(
        "Bài viết mới: ${article.title}",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(timeAgo, style: theme.textTheme.bodySmall),
      onTap: () {
        Navigator.push(
          context,
          createSlideRoute(ArticleDetail(article: article)),
        );
      },
      tileColor: theme.cardColor,
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return "Vừa xong";
    if (diff.inHours < 1) return "${diff.inMinutes} phút trước";
    if (diff.inDays < 1) return "${diff.inHours} giờ trước";
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
