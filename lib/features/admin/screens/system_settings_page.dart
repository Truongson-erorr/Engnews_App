import 'package:flutter/material.dart';

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Cài đặt hệ thống",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
