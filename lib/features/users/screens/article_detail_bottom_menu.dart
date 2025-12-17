import 'package:flutter/material.dart';

class ArticleDetailBottomMenu extends StatelessWidget {
  final bool isTranslating;
  final VoidCallback onTranslate;
  final VoidCallback onSummary;
  final VoidCallback onSentiment;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const ArticleDetailBottomMenu({
    super.key,
    required this.isTranslating,
    required this.onTranslate,
    required this.onSummary,
    required this.onSentiment,
    required this.onCopy,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            leading: isTranslating
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : Icon(Icons.translate, color: Theme.of(context).iconTheme.color),
            title: Text(
              isTranslating ? "Đang dịch..." : "Dịch bài",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            onTap: isTranslating ? null : onTranslate,
          ),

          ListTile(
            leading: Icon(Icons.summarize, color: Theme.of(context).iconTheme.color),
            title: Text(
              "Tóm tắt nội dung bằng AI",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            onTap: onSummary,
          ),

          ListTile(
            leading:
                Icon(Icons.analytics_outlined, color: Theme.of(context).iconTheme.color),
            title: Text(
              "Phân tích cảm xúc (AI)",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            onTap: onSentiment,
          ),

          ListTile(
            leading: Icon(Icons.copy_all, color: Theme.of(context).iconTheme.color),
            title: Text(
              "Sao chép nội dung",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            onTap: onCopy,
          ),

          ListTile(
            leading: Icon(Icons.share, color: Theme.of(context).iconTheme.color),
            title: Text(
              "Chia sẻ bài viết",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            onTap: onShare,
          ),

          ListTile(
            leading:
                Icon(Icons.bookmark_add_outlined, color: Theme.of(context).iconTheme.color),
            title: Text(
              "Lưu bài",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            onTap: onSave,
          ),
        ],
      ),
    );
  }
}
