import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../models/article_model.dart';
import '../../../core/animation';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import 'article_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ArticleViewModel _articleVM = ArticleViewModel();
  final TextEditingController _searchController = TextEditingController();

  String? userId;
  List<ArticleModel> _results = [];
  bool _isLoading = false;

  final List<String> _suggestions = [
    'Football',
    'Weather',
    'AI',
    'Economy',
    'Education',
    'Technology',
  ];

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _searchArticles() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;

    setState(() => _isLoading = true);
    final results = await _articleVM.searchArticlesByTitle(keyword);

    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  void _onSuggestionTap(String keyword) {
    _searchController.text = keyword;
    _searchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Tìm kiếm bài báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF015E53),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: cs.onBackground),
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa bài báo...',
                hintStyle: TextStyle(color: cs.onSurfaceVariant),
                filled: true,
                fillColor: cs.surface, 
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                suffixIcon: _searchController.text.isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF015E53)),
                        onPressed: _searchArticles,
                      )
                    : IconButton(
                        icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _results = []);
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF015E53), width: 1.5),
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _searchArticles(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildSuggestions(theme, cs)
                  : _isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: const Color(0xFF015E53)),
                        )
                      : _results.isEmpty
                          ? Center(
                              child: Text(
                                'Không có kết quả nào phù hợp',
                                style: TextStyle(
                                    color: cs.onSurfaceVariant, fontSize: 16),
                              ),
                            )
                          : _buildResultList(theme, cs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(ThemeData theme, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Có thể bạn sẽ thích',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: cs.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _suggestions.length,
            separatorBuilder: (_, __) =>
                Divider(height: 12, color: const Color.fromARGB(255, 174, 174, 174).withOpacity(0.2)),
            itemBuilder: (context, index) {
              final keyword = _suggestions[index];
              return ListTile(
                leading: const Icon(Icons.search, color: Color(0xFF015E53)),
                title: Text(
                  keyword,
                  style: TextStyle(fontSize: 15, color: cs.onBackground),
                ),
                onTap: () => _onSuggestionTap(keyword),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultList(ThemeData theme, ColorScheme cs) {
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, __) =>
          Divider(height: 24, color: const Color.fromARGB(255, 197, 197, 197).withOpacity(0.2)),
      itemBuilder: (context, index) {
        final article = _results[index];

        return InkWell(
          borderRadius: BorderRadius.circular(12),
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
              createSlideRoute(ArticleDetail(article: article)),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: article.image.isNotEmpty
                      ? Image.network(article.image,
                          width: 90, height: 70, fit: BoxFit.cover)
                      : Container(
                          width: 90,
                          height: 70,
                          color: cs.surfaceVariant,
                          child: const Icon(Icons.article_outlined,
                              color: Colors.white),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: cs.onBackground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 13,
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
  }
}
