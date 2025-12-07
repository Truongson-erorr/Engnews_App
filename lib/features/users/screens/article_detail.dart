import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../viewmodel/translateViewModel.dart';
import '../../viewmodel/favorite_viewmodel.dart';
import '../../viewmodel/ai_viewmodel.dart';
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
  final AiViewModel _aiVM = AiViewModel();

  List<Map<String, String>>? _translatedParagraphs;
  bool _isTranslating = false;

  String? _summary;
  bool _isSummarizing = false;

  Future<void> _translateContent() async {
    setState(() => _isTranslating = true);

    final content = widget.article.content.isNotEmpty
        ? widget.article.content
        : widget.article.description;

    final result = await _translateVM.translateParagraphs(content);

    setState(() {
      _translatedParagraphs = result;
      _isTranslating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã dịch bài!")),
    );
  }

  void _showSummaryOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String selectedLang = "vi";

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tùy chọn tóm tắt",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge!.color)),

                  const SizedBox(height: 16),
                  Text("Ngôn ngữ tóm tắt:",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color)),

                  DropdownButton<String>(
                    value: selectedLang,
                    items: const [
                      DropdownMenuItem(value: "vi", child: Text("Tiếng Việt")),
                      DropdownMenuItem(value: "en", child: Text("Tiếng Anh")),
                    ],
                    onChanged: (v) => setModalState(() => selectedLang = v!),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: const Color(0xFFB42652), 
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _summarizeArticle(selectedLang);
                    },
                    child: const Text(
                      "Tóm tắt ngay",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _summarizeArticle(String lang) async {
    setState(() => _isSummarizing = true);

    final content = widget.article.content.isNotEmpty
        ? widget.article.content
        : widget.article.description;

    try {
      final result = await _aiVM.summarizeContent(content, lang);

      setState(() {
        _summary = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã tóm tắt bài viết!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Có lỗi xảy ra khi tóm tắt: $e")),
      );
    } finally {
      setState(() => _isSummarizing = false);
    }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                      ),
                    )
                  : Icon(Icons.translate, color: Theme.of(context).iconTheme.color),
              title: Text(
                _isTranslating ? "Đang dịch..." : "Dịch bài",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              onTap: _isTranslating
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      await _translateContent();
                    },
            ),

            ListTile(
              leading: Icon(Icons.summarize, color: Theme.of(context).iconTheme.color),
              title: Text(
                "Tóm tắt nội dung bằng AI",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                _showSummaryOptions();
              },
            ),

            ListTile(
              leading: Icon(Icons.analytics_outlined, color: Theme.of(context).iconTheme.color),
              title: Text(
                "Phân tích cảm xúc (AI)",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.copy_all, color: Theme.of(context).iconTheme.color),
              title: Text(
                "Sao chép nội dung",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),

            ListTile(
              leading: Icon(Icons.share, color: Theme.of(context).iconTheme.color),
              title: Text(
                "Chia sẻ bài viết",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),

            ListTile(
              leading: Icon(Icons.bookmark_add_outlined, color: Theme.of(context).iconTheme.color),
              title: Text(
                "Lưu bài",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                await _saveArticle();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB42652),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "EngNews",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showBottomMenu,
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        color: Color(0xFFB42652))), 
                const SizedBox(height: 8),

                Text("Published: ${article.date.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(
                        fontSize: 13, color: Theme.of(context).textTheme.bodySmall!.color)),
                const SizedBox(height: 20),

                if (_summary != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? const Color(0xFFFFF3F6)
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB42652), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tóm tắt nội dung:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFB42652)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _summary!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).textTheme.bodyMedium!.color),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                _translatedParagraphs != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _translatedParagraphs!.map((p) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['en'] ?? '',
                              textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).textTheme.bodyMedium!.color)),
                              const SizedBox(height: 4),
                              Text(p['vi'] ?? '',
                              textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFB42652))), 
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      )
                    : Text(
                        article.content.isNotEmpty
                            ? article.content
                            : article.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Theme.of(context).textTheme.bodyMedium!.color),
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

          if (_isSummarizing)
            Container(
              color: Colors.black.withOpacity(0.45),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFFB42652)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "AI đang tóm tắt...",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),

          if (_isTranslating)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFFB42652)),
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Đang dịch bài...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
