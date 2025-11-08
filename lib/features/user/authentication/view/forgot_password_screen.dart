import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quên mật khẩu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Khôi phục mật khẩu",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Nhập địa chỉ email của bạn để nhận hướng dẫn đặt lại mật khẩu.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),

            /// 📧 Ô nhập email
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.grey[200],
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),

            /// 🔘 Nút gửi liên kết
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Liên kết đặt lại mật khẩu đã được gửi!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 42, 42, 252),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: const Text(
                  "Gửi liên kết đặt lại mật khẩu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
