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
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bình luận",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
                  final firstLetter = comment.user.isNotEmpty
                      ? comment.user[0].toUpperCase()
                      : '?';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFB42652),
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      comment.user,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      comment.text,
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _dateFormat.format(comment.date),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 6),

                        if (FirebaseAuth.instance.currentUser != null &&
                            (FirebaseAuth.instance.currentUser!.displayName == comment.user ||
                            FirebaseAuth.instance.currentUser!.email == comment.user))
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20),
                            onSelected: (value) async {
                              if (value == 'delete') {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Xóa bình luận?"),
                                    content: const Text("Bạn có chắc muốn xóa bình luận này?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Hủy"),
                                        onPressed: () => Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                                        onPressed: () => Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await _commentVM.deleteComment(
                                    widget.article.id,
                                    comment.id,
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Text("Xóa bình luận"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
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
