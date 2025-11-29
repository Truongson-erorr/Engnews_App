import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../../core/animation';
import '../../viewmodel/reading_history_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/article_detail.dart';

class HighlightBanner extends StatefulWidget {
  final List<ArticleModel> articles;
  const HighlightBanner({super.key, required this.articles});

  @override
  State<HighlightBanner> createState() => _HighlightBannerState();
}

class _HighlightBannerState extends State<HighlightBanner> {
  late PageController _pageController;
  int _currentIndex = 0;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients && widget.articles.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % widget.articles.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.articles.length,
        itemBuilder: (context, index) {
          final article = widget.articles[index];
          return GestureDetector(
            onTap: () {
              ReadingHistoryViewModel().addOrUpdateHistory(
                userId: userId,
                articleId: article.id,
                title: article.title,
                description: article.description,
                image: article.image,
              );
              Navigator.push(
                context,
                createSlideRoute(ArticleDetail(article: article)),
              );
            },
            child: Stack(
              children: [
                Image.network(
                  article.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  color: Colors.black38,
                  child: Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
