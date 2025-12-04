import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/authen_viewmodel.dart';
import '../../users/screens/login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenViewModel>(context);
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Hồ sơ cá nhân",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: user == null
          ? const Center(child: Text("Không có dữ liệu người dùng"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: (user.image.isNotEmpty)
                        ? NetworkImage(user.image)
                        : const NetworkImage("https://i.pravatar.cc/150?img=10"),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      child: Column(
                        children: [
                          _infoItem(Icons.email, "Email", user.email),
                          const SizedBox(height: 12),

                          _infoItem(Icons.phone, "Số điện thoại", user.phone),
                          const SizedBox(height: 12),

                          _infoItem(Icons.verified_user, "Quyền hạn", user.role),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            "Xác nhận đăng xuất",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          content: const Text(
                            "Bạn có chắc chắn muốn đăng xuất không?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          actionsAlignment: MainAxisAlignment.end,
                          actions: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(221, 126, 126, 126),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                side: BorderSide.none,
                              ),
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text("Hủy"),
                            ),

                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                side: BorderSide.none,
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text("Đăng xuất"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await auth.signOut();

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Đăng xuất"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 183, 38, 38),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color.fromARGB(255, 198, 23, 23)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  )),
              Text(value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        )
      ],
    );
  }
}
