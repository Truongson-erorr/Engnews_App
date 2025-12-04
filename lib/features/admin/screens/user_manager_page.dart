import 'package:flutter/material.dart';

class UserManagerPage extends StatelessWidget {
  const UserManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Quản lý người dùng",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
