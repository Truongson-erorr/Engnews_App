import 'package:flutter/material.dart';
import '../../viewmodel/article_viewmodel.dart';
import '../../models/article_model.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nhập từ khóa bài báo...',
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              suffixIcon: _searchController.text.isEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.search, 
                        color: Color(0xFFD0021B)), 
                      onPressed: _searchArticles,
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.close, 
                        color: Colors.grey),
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
          if (_searchController.text.isEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Có thể bạn sẽ thích',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  
                  Expanded(
                    child: ListView.separated(
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, __) => const Divider(height: 12),
                      itemBuilder: (context, index) {
                        final keyword = _suggestions[index];
                        return ListTile(
                          title: Text(
                            keyword,
                              style: const TextStyle(
                              fontSize: 15,      
                              color: Color.fromARGB(221, 39, 39, 39),
                            ),
                            ),
                          leading: const Icon(Icons.search, color: Colors.grey),
                          onTap: () => _onSuggestionTap(keyword),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            'Không có kết quả nào phù hợp',
                            style:
                                const TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _results.length,
                          separatorBuilder: (_, __) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final article = _results[index];
                            return Row(
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
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.article_outlined,
                                              color: Colors.grey),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          
                                        },
                                        child: Text(
                                          article.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        article.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black54, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ),
        ],
      ),
    );
  }
}
