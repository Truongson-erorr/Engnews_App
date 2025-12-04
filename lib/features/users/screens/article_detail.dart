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

  void _showLoadingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => const Center(
        child: SizedBox(
          width: 70,
          height: 70,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
        ),
      ),
    );
  }

  void _hideLoadingOverlay() {
    Navigator.of(context).pop();
  }

  Future<void> _translateContent() async {
    _showLoadingOverlay(); 

    setState(() => _isTranslating = true);

    final content = widget.article.content.isNotEmpty
        ? widget.article.content
        : widget.article.description;

    final result = await _translateVM.translateParagraphs(content);

    setState(() {
      _translatedParagraphs = result;
      _isTranslating = false;
    });

    _hideLoadingOverlay(); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã dịch bài!")),
    );
  }

  Future<void> _saveArticle() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng đăng nhập để lưu bài.")),
      );
      return;
    }

    await _favoriteVM.saveFavorite(user.uid, widget.article.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã lưu bài viết!")),
    );
  }

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: _isTranslating
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.translate, color: Colors.black87),
              title: Text(
                _isTranslating ? "Đang dịch..." : "Dịch bài",
                style: const TextStyle(fontSize: 16),
              ),
              onTap: _isTranslating
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      await _translateContent();
                    },
            ),

            ListTile(
              leading: Icon(Icons.summarize, color: Colors.black87),
              title: const Text("Tóm tắt nội dung bằng AI"),
              onTap: () async {
                Navigator.pop(ctx);
                
              },
            ),

            ListTile(
              leading: Icon(Icons.analytics_outlined, color: Colors.black87),
              title: const Text("Phân tích cảm xúc bài viết"),
              onTap: () async {
                Navigator.pop(ctx);
                
              },
            ),

            ListTile(
              leading: Icon(Icons.copy_all, color: Colors.black87),
              title: const Text("Sao chép nội dung"),
              onTap: () async {
                Navigator.pop(ctx);
                
              },
            ),

            ListTile(
              leading: Icon(Icons.share, color: Colors.black87),
              title: const Text("Chia sẻ bài viết"),
              onTap: () async {
                Navigator.pop(ctx);
                
              },
            ),

            ListTile(
              leading: Icon(Icons.bookmark_add_outlined, color: Colors.black87),
              title: const Text("Lưu bài"),
              onTap: () async {
                Navigator.pop(ctx);
                await _saveArticle();
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showBottomMenu,
          )
        ],
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
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),

            Text("Published: ${article.date.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _translatedParagraphs != null
                  ? _translatedParagraphs!.map((p) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['en'] ?? '',
                              textAlign: TextAlign.justify,
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(p['vi'] ?? '',
                              textAlign: TextAlign.justify,
                              style:
                                  const TextStyle(color: Color.fromARGB(255, 151, 151, 151), fontSize: 16)),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList()
                  : [
                      Text(
                          article.content.isNotEmpty
                              ? article.content
                              : article.description,
                          textAlign: TextAlign.justify,
                          style:
                              const TextStyle(fontSize: 16, height: 1.6, color: Colors.white70)),
                    ],
            ),
            const SizedBox(height: 40),

            ArticleCommentsWidget(article: article),
            RelatedArticlesWidget(
              categoryId: widget.article.categoryId,
              currentArticleId: widget.article.id,
            ),
            RandomArticlesWidget(),
          ],
        ),
      ),
    );
  }
}
