import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/translateViewModel.dart';
import '../../viewmodel/favorite_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/article_comments_widget.dart';
import '../screens/related_articles_widget.dart';
import '../screens/ramdom_article.dart';

class ArticleDetail extends StatefulWidget {
  final ArticleModel article;
  const ArticleDetail({super.key, required this.article});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final FavoriteViewModel _favoriteVM = FavoriteViewModel();
  final TranslateViewModel _translateVM = TranslateViewModel();
  
  List<Map<String, String>>? _translatedParagraphs;
  bool _isTranslating = false;

  void _translateContent() async {
    setState(() {
      _isTranslating = true;
    });

    final content = widget.article.content.isNotEmpty
        ? widget.article.content
        : widget.article.description;

    final result = await _translateVM.translateParagraphs(content);

    setState(() {
      _translatedParagraphs = result;
      _isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: const Color(0xFF2C1A1F),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 19, 34),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "EngNews",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.contentImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(article.contentImage,
                    width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),
            Text(article.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text("Published: ${article.date.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isTranslating ? null : _translateContent,
                  icon: _isTranslating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.translate, color: Colors.white),
                  label: Text(
                    _isTranslating ? "Đang dịch..." : "Dịch bài",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 163, 163, 163),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vui lòng đăng nhập để lưu bài.")),
                      );
                      return;
                    }

                    await _favoriteVM.saveFavorite(user.uid, article.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã lưu bài viết!")),
                    );
                  },
                  icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white),
                  label: const Text(
                    "Lưu bài",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD0021B),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _translatedParagraphs != null
                  ? _translatedParagraphs!.map((p) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['en'] ?? '', textAlign: TextAlign.justify,
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(p['vi'] ?? '', textAlign: TextAlign.justify,
                              style: const TextStyle(color: Color.fromARGB(255, 151, 151, 151), fontSize: 16)),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList()
                  : [
                      Text(article.content.isNotEmpty ? article.content : article.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.white70)),
                    ],
            ),
            const SizedBox(height: 40),
            ArticleCommentsWidget(article: article),

            RelatedArticlesWidget(
              categoryId: widget.article.categoryId,
              currentArticleId: widget.article.id,
            ),

            RandomArticlesWidget()
          ],
        ),
      ),
    );
  }
}
