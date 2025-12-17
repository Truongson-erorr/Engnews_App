import 'dart:async';
import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../viewmodel/article_viewmodel.dart';

class FeaturedArticleCarousel extends StatefulWidget {
  final List<ArticleModel> articles;
  final Function(ArticleModel) onTap;

  const FeaturedArticleCarousel({
    super.key,
    required this.articles,
    required this.onTap,
  });

  @override
  State<FeaturedArticleCarousel> createState() =>
      _FeaturedArticleCarouselState();
}

class _FeaturedArticleCarouselState
    extends State<FeaturedArticleCarousel> {
  final PageController _pageController = PageController();
  final ArticleViewModel _viewModel = ArticleViewModel();

  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    if (widget.articles.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _currentPage =
            (_currentPage + 1) % widget.articles.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.articles.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final article = widget.articles[index];

              return InkWell(
                onTap: () => widget.onTap(article),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        article.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          article.date
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FutureBuilder<int>(
                          future: _viewModel
                              .getCommentCount(article.id),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Row(
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  size: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.articles.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == index
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
