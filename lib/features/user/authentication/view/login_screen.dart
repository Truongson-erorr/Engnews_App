import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'package:caonientruongson/core/animation.dart';
import 'forgot_password_screen.dart';
import '../../article/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // đăng nhập thành công → vào Home
      Navigator.of(context).pushReplacement(createSlideRoute(const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      String message = "Đăng nhập thất bại";
      if (e.code == 'user-not-found') {
        message = "Không tìm thấy người dùng với email này.";
      } else if (e.code == 'wrong-password') {
        message = "Sai mật khẩu. Vui lòng thử lại.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

            // EMAIL
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            // PASSWORD
            TextField(
              controller: _passwordController,
              obscureText: true,
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
            const SizedBox(height: 60),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 42, 42, 252),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                    color: Color.fromARGB(255, 30, 30, 255),
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
