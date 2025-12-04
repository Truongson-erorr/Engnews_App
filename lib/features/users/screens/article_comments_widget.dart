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

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bình luận",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<CommentModel>>(
            stream: _commentVM.getComments(article.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFD0021B)));
              }
              final comments = snapshot.data ?? [];
              if (comments.isEmpty) {
                return const Text("Chưa có bình luận nào.", style: TextStyle(color: Colors.grey));
              }
              return Column(
                children: comments.map((comment) {
                  final firstLetter = comment.user.isNotEmpty ? comment.user[0].toUpperCase() : '?';
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0), 
                    leading: CircleAvatar(
                      radius: 16, 
                      backgroundColor: Colors.grey[400],
                      child: Text(
                        firstLetter,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    title: Text(comment.user, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
                    subtitle: Text(comment.text, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                    trailing: Text(
                      _dateFormat.format(comment.date), 
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Nhập bình luận...",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15), 
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB42652), 
                  borderRadius: BorderRadius.circular(15),
                ),

                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
