import 'package:flutter/material.dart';
import '../../models/article_model.dart';
import '../../models/comment_model.dart';
import '../../viewmodel/comment_viewmodel.dart';
import '../../viewmodel/reading_history_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/favorite_viewmodel.dart';

class ArticleDetail extends StatefulWidget {
  final ArticleModel article;
  const ArticleDetail({super.key, required this.article});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final CommentViewModel _commentVM = CommentViewModel();
  final TextEditingController _commentController = TextEditingController();
  final FavoriteViewModel _favoriteVM = FavoriteViewModel();
  
  @override
  void initState() {
    super.initState();
    _saveReadingHistory();
  }

  // Hàm lưu lịch sử đọc
  void _saveReadingHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await ReadingHistoryViewModel().addToHistoryOnce(
        userId: user.uid,
        articleId: widget.article.id,
        title: widget.article.title,
        description: widget.article.description,
        image: widget.article.image,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor:  const Color(0xFFD0021B),
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
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text("Published: ${article.date.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            Text(article.content.isNotEmpty ? article.content : article.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 163, 163, 163),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Hiển thị bản dịch bài viết")),
                    );
                  },
                  icon: const Icon(Icons.translate, color: Colors.white),
                  label: const Text(
                    "Xem bản dịch",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12), 
                
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD0021B),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
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
                ),
              ],
            ),
            const SizedBox(height: 40),

            const Text(
              "Bình luận",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            StreamBuilder<List<CommentModel>>(
              stream: _commentVM.getComments(article.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Text("Chưa có bình luận nào.",
                      style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: comments.map((comment) {
                    final firstLetter = comment.user.isNotEmpty
                        ? comment.user[0].toUpperCase()
                        : '?';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          firstLetter,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        comment.user,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(comment.text),
                      trailing: Text(
                        "${comment.date.hour.toString().padLeft(2, '0')}:${comment.date.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Nhập bình luận...",
                      filled: true,
                      fillColor: Colors.grey[200], 
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none, 
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color.fromARGB(255, 71, 71, 71)),
                  onPressed: () async {
                    final text = _commentController.text.trim();
                    if (text.isEmpty) return;

                    final user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vui lòng đăng nhập để bình luận.")),
                      );
                      return;
                    }

                    await _commentVM.addComment(
                      article.id,
                      CommentModel(
                        id: '',
                        user: user.displayName ?? user.email ?? user.uid, // tên hiển thị
                        text: text,
                        date: DateTime.now(),
                      ),
                    );

                    _commentController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
