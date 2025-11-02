import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:caonientruongson/navigation/navigation.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "EngNews",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 30, 30, 255),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              "Chào mừng trở lại!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Đăng nhập để tiếp tục đọc báo nhé!",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
            ),
            const SizedBox(height: 16),

            TextField(
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(createSlideRoute(const ForgotPasswordScreen()));
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 30, 30, 255),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 74),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Giả lập đăng nhập thành công
                  Navigator.of(context).pushReplacement(createSlideRoute(const HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 42, 42, 252),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  print("Đăng nhập bằng Google");
                },
                icon: Image.network(
                  'https://developers.google.com/identity/images/g-logo.png',
                  height: 24,
                ),
                label: const Text(
                  "Đăng nhập bằng Google",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(createSlideRoute(const RegisterScreen()));
                },
                child: const Text(
                  "Chưa có tài khoản? Đăng ký ngay",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 30, 30, 255),
                    fontSize: 15,
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
