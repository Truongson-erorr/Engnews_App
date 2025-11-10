import 'package:flutter/material.dart';
import '../../models/article_model.dart';

class ArticleDetail extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Article Detail",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
                child: Image.network(
                  article.contentImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            Text(
              article.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Published: ${article.date.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(
              article.content.isNotEmpty
                  ? article.content
                  : article.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 29, 36, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Article saved to favorites!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white),
                label: const Text(
                  "Save Article",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
