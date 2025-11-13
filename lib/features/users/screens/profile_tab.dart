import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/authen_viewmodel.dart';
import '../screens/login_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../../../core/animation.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<AuthenViewModel>(context);

    if (userVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = userVM.currentUser;
    if (user == null) {
      return const Center(child: Text("Không có thông tin người dùng"));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFDDE1FF),
                      backgroundImage: user.image.isNotEmpty
                          ? NetworkImage(user.image)
                          : null,
                      child: user.image.isEmpty
                          ? Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B3AFF),
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 121, 121, 121),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 10),
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Chỉnh sửa thông tin cá nhân',
                    onTap: () {
                      Navigator.push(
                        context,
                        createSlideRoute(const EditProfileScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Đổi mật khẩu',
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.bookmark_outline,
                    title: 'Bài viết đã lưu',
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Lịch sử đọc báo',
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Cài đặt ứng dụng',
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Trợ giúp & Hỗ trợ',
                    onTap: () {
                      
                    },
                  ),
                  
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    color: Colors.red,
                    onTap: () async {
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
                                foregroundColor: const Color.fromARGB(221, 126, 126, 126),
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
                        await userVM.signOut();

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: color, size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
