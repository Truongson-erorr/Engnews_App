import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool allowNotification = true;
  bool dailyNews = true;
  bool breakingNews = true;
  bool savedArticleReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Cài đặt thông báo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFB42652),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Text(
            "Thông báo chung",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          SwitchListTile(
            title: Text(
              "Bật thông báo",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: allowNotification,
            onChanged: (value) {
              setState(() {
                allowNotification = value;
              });
            },
          ),

          const Divider(height: 30),

          Text(
            "Tùy chọn thông báo",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          SwitchListTile(
            title: Text("Tin tức hằng ngày",
                style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text(
              "Gửi gợi ý bài báo mỗi buổi sáng",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: dailyNews,
            onChanged: allowNotification
                ? (v) => setState(() => dailyNews = v)
                : null,
          ),

          SwitchListTile(
            title: Text("Tin nóng (Breaking News)",
                style: Theme.of(context).textTheme.bodyMedium),
            subtitle: Text(
              "Nhận thông báo khi có sự kiện quan trọng",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: breakingNews,
            onChanged: allowNotification
                ? (v) => setState(() => breakingNews = v)
                : null,
          ),

          const SizedBox(height: 25),

          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB42652),
                padding: const EdgeInsets.symmetric(
                    horizontal: 34, vertical: 14),
              ),
              child: const Text(
                "Lưu cài đặt",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
