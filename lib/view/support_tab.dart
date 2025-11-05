import 'package:flutter/material.dart';

class SupportTab extends StatelessWidget {
  const SupportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Trung tâm hỗ trợ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            "📞 Hotline: 1900 6868\n✉️ Email: support@engnews.vn\n💬 Chat trực tuyến: 8:00 - 22:00 mỗi ngày",
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
          ),
          SizedBox(height: 20),
          Text(
            "Chúng tôi luôn sẵn sàng hỗ trợ bạn!",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
