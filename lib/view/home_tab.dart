import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final List<Map<String, String>> _articles = const [
    {
      "title": "Cập nhật: Không khí lạnh tăng cường tràn về miền Bắc",
      "description":
          "Nhiệt độ giảm mạnh, nhiều nơi xuống dưới 18°C. Người dân nên giữ ấm khi ra ngoài vào buổi sáng và tối.",
      "image":
          "https://vnn-imgs-f.vgcloud.vn/2023/10/13/08/tuyen-viet-nam-thang-indonesia.jpg",
    },
    {
      "title": "Việt Nam thắng Indonesia 2-0 tại vòng loại World Cup",
      "description":
          "Đội tuyển Việt Nam giành chiến thắng thuyết phục, thể hiện chiến thuật linh hoạt và tinh thần chiến đấu cao.",
      "image":
          "https://vnn-imgs-f.vgcloud.vn/2023/10/13/08/tuyen-viet-nam-thang-indonesia.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  article["image"]!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article["title"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article["description"]!,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
