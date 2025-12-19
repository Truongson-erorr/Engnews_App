import 'package:flutter/material.dart';
import '../../models/article_model.dart';
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
  String? userId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    userId = FirebaseAuth.instance.currentUser?.uid; // null-safe
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
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.articles.length,
        itemBuilder: (context, index) {
          final article = widget.articles[index];
          return GestureDetector(
            onTap: () {
              if (userId != null) {
                ReadingHistoryViewModel().addOrUpdateHistory(
                  userId: userId!,
                  articleId: article.id,
                  title: article.title,
                  description: article.description,
                  image: article.image,
                );
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArticleDetail(article: article),
                ),
              );

            },
            child: Stack(
              children: [
                if (article.image.isNotEmpty)
                  Image.network(
                    article.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    color: Colors.grey[800],
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, color: Colors.white54, size: 48),
                  ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 58, 58),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Tin mới",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                ),
              ],
            ),

          );
        },
      ),
    );
  }
}
