import 'package:flutter/material.dart';
import 'home_screen.dart'; // import màn hình Home để điều hướng sau khi đăng nhập

/// Widget chính cho màn hình đăng nhập
/// Vì có trạng thái (loading, nhập email, mật khẩu), nên dùng StatefulWidget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// State của LoginScreen chứa logic và giao diện
class _LoginScreenState extends State<LoginScreen> {
  /// Controller để lấy giá trị từ TextField (Email và Mật khẩu)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Biến dùng để hiển thị vòng tròn loading khi đang đăng nhập
  bool _isLoading = false;

  /// Hàm xử lý khi người dùng nhấn nút "Đăng nhập"
  void _login() async {
    // Bật trạng thái loading
    setState(() => _isLoading = true);

    // Giả lập quá trình đăng nhập (ví dụ gọi API thật sẽ mất vài giây)
    await Future.delayed(const Duration(seconds: 2));

    // Sau khi xong thì tắt loading
    setState(() => _isLoading = false);

    // Hiển thị thông báo snack bar (thanh nhỏ ở dưới màn hình)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng nhập thành công!')),
    );

    // Điều hướng sang trang Home, thay thế Login (pushReplacement)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  /// Hàm build() hiển thị giao diện của màn hình
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền trắng
      body: Center(
        child: SingleChildScrollView(
          // Cho phép cuộn nếu bàn phím che khuất nội dung
          padding: const EdgeInsets.symmetric(horizontal: 24), // khoảng cách hai bên
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // căn giữa nội dung theo chiều dọc
            children: [
              // Tiêu đề ứng dụng
              const Text(
                "EngNews",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 24), // khoảng cách giữa tiêu đề và ô nhập

              // Ô nhập Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email", // nhãn gợi ý
                  prefixIcon: const Icon(Icons.email_outlined), // icon ở đầu ô
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // bo góc
                  ),
                ),
              ),

              const SizedBox(height: 16), // khoảng cách giữa 2 ô nhập

              // Ô nhập mật khẩu
              TextField(
                controller: _passwordController,
                obscureText: true, // ẩn ký tự mật khẩu
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Nút chuyển sang đăng ký (chưa xử lý)
              TextButton(
                onPressed: () {
                  // TODO: sẽ điều hướng sang RegisterScreen sau
                },
                child: const Text("Chưa có tài khoản? Đăng ký"),
              ),

              const SizedBox(height: 150),
              // Nút "Đăng nhập"
              SizedBox(
                width: double.infinity, // chiếm toàn chiều ngang
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login, // nếu đang loading thì tắt nút
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Đăng nhập",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
