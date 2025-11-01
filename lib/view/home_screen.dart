import 'package:flutter/material.dart';

/// Màn hình Home sau khi đăng nhập
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chủ"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "chào cao niên trường sơn nhé",
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
    );
  }
}