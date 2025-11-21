import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../models/article_model.dart';
import '../../../core/animation';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ArticleViewModel _articleVM = ArticleViewModel();
  final TextEditingController _searchController = TextEditingController();

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
    return Scaffold(
      backgroundColor: const Color(0xFF2C1A1F), 
      appBar: AppBar(
        title: const Text(
          "Tìm kiếm",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 59, 19, 34), 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập từ khóa bài báo...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color.fromARGB(255, 73, 49, 55),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                suffixIcon: _searchController.text.isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFFD0021B)),
                        onPressed: _searchArticles,
                      )
                    : IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _results = [];
                          });
                        },
                      ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: (_) => _searchArticles(),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _searchController.text.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Có thể bạn sẽ thích',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _suggestions.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 12,
                              color: Colors.grey[700],
                            ),
                            itemBuilder: (context, index) {
                              final keyword = _suggestions[index];
                              return ListTile(
                                
                                leading: const Icon(Icons.search, color: Colors.grey),
                                title: Text(
                                  keyword,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () => _onSuggestionTap(keyword),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : _results.isEmpty
                          ? const Center(
                              child: Text(
                                'Không có kết quả nào phù hợp',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            )
                          : ListView.separated(
                              itemCount: _results.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 24,
                                color: Colors.grey[700],
                              ),
                              itemBuilder: (context, index) {
                                final article = _results[index];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    // TODO: mở chi tiết bài viết
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: article.image.isNotEmpty
                                              ? Image.network(
                                                  article.image,
                                                  width: 90,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: 90,
                                                  height: 70,
                                                  color: Colors.grey[700],
                                                  child: const Icon(
                                                    Icons.article_outlined,
                                                    color: Colors.grey,
                                                  ),
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
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                article.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey[300],
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
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
