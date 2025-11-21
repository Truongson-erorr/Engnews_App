import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../models/article_model.dart';
import '../../models/comment_model.dart';
import '../../viewmodel/comment_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArticleCommentsWidget extends StatefulWidget {
  final ArticleModel article;
  const ArticleCommentsWidget({super.key, required this.article});

  @override
  State<ArticleCommentsWidget> createState() => _ArticleCommentsWidgetState();
}

class _ArticleCommentsWidgetState extends State<ArticleCommentsWidget> {
  final CommentViewModel _commentVM = CommentViewModel();
  final TextEditingController _commentController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm'); 

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bình luận",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        StreamBuilder<List<CommentModel>>(
          stream: _commentVM.getComments(article.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            final comments = snapshot.data ?? [];
            if (comments.isEmpty) {
              return const Text("Chưa có bình luận nào.", style: TextStyle(color: Colors.grey));
            }
            return Column(
              children: comments.map((comment) {
                final firstLetter = comment.user.isNotEmpty ? comment.user[0].toUpperCase() : '?';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      firstLetter,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(comment.user, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text(comment.text, style: const TextStyle(color: Colors.white70)),
                  trailing: Text(
                    _dateFormat.format(comment.date), 
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
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Nhập bình luận...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 74, 44, 53),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
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
                    user: user.displayName ?? user.email ?? user.uid,
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
    );
  }
}
