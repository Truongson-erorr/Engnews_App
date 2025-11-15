import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:caonientruongson/core/animation';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/authen_viewmodel.dart';

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
    setState(() => _isLoading = true);
    final authVM = Provider.of<AuthenViewModel>(context, listen: false);

    final success = await authVM.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (success) {
      Navigator.of(context).pushReplacement(createSlideRoute(const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authVM.errorMessage ?? "Đăng nhập thất bại")),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _signInWithGoogle() async {
    final authVM = Provider.of<AuthenViewModel>(context, listen: false);
    bool success = await authVM.signInWithGoogle();
    if (success) {
      Navigator.of(context).pushReplacement(createSlideRoute(const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập Google thất bại")),
      );
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
                  color: Color(0xFFD0021B),
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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

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
                    color: Color(0xFFD0021B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD0021B),
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
            const SizedBox(height: 20),

            Center(
              child: TextButton.icon(
                onPressed: _signInWithGoogle,
                icon: Image.network(
                  'https://developers.google.com/identity/images/g-logo.png',
                  height: 24,
                ),
                label: const Text(
                  "Đăng nhập bằng Google",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black87,
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
                    color: Color(0xFFD0021B),
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
