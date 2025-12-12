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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      color: theme.colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bình luận",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),

          StreamBuilder<List<CommentModel>>(
            stream: _commentVM.getComments(widget.article.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFB42652),
                  ),
                );
              }

              final comments = snapshot.data ?? [];
              if (comments.isEmpty) {
                return Text(
                  "Chưa có bình luận nào.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                );
              }

              return Column(
                children: comments.map((comment) {
                  return FutureBuilder<String?>(
                    future: _commentVM.getUserImage(comment.user),
                    builder: (context, snapshot) {
                      final image = snapshot.data;
                      final firstLetter = comment.user.isNotEmpty
                          ? comment.user[0].toUpperCase()
                          : '?';
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: const Color(0xFFB42652),
                                  backgroundImage: 
                                    (image != null && image.isNotEmpty)
                                        ? NetworkImage(image)
                                        : null,
                                  child: (image == null || image.isEmpty)
                                      ? Text(
                                          firstLetter,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.user,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comment.text,
                                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),

                                Text(
                                  _dateFormat.format(comment.date),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (comments.last != comment)
                            Divider(
                              color: const Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                              thickness: 1,
                              height: 10,
                            ),
                        ],
                      );
                    },
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
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "Nhập bình luận...",
                    filled: true,
                    fillColor: theme.colorScheme.surface, 
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
                        const SnackBar(
                          content:
                              Text("Vui lòng đăng nhập để bình luận."),
                        ),
                      );
                      return;
                    }

                    await _commentVM.addComment(
                      widget.article.id,
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
