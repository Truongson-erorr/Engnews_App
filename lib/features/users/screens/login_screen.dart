import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:caonientruongson/core/animation';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
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
      final user = authVM.currentUser;

      if (user != null && user.role == "admin") {
        Navigator.of(context).pushReplacement(
          createSlideRoute(const AdminDashboardScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          createSlideRoute(const HomeScreen()),
        );
      }
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
    const Color primaryRed = Color(0xFF015E53);
    const Color lightGrey = Color(0xFFF4F4F4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "EngNews",
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: primaryRed, 
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              "Chào mừng trở lại!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Đăng nhập để tiếp tục đọc báo nhé!",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 18),

            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Mật khẩu",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(createSlideRoute(const ForgotPasswordScreen()));
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: primaryRed, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black38,
                  elevation: 3,
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
                    color: Colors.black,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: lightGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(createSlideRoute(const RegisterScreen()));
                },
                child: const Text(
                  "Chưa có tài khoản? Đăng ký ngay",
                  style: TextStyle(
                    color: primaryRed, 
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
