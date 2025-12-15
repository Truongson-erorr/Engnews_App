import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/authen_viewmodel.dart';
import '../screens/login_screen.dart';
import '../screens/reading_history_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../../../core/animation';
import '../screens/change_password_screen.dart';
import '../screens/setting_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<AuthenViewModel>(context);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (userVM.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colors.primary),
      );
    }

    final user = userVM.currentUser;
    if (user == null) {
      return Center(
        child: Text(
          "Không có thông tin người dùng",
          style: textTheme.bodyMedium?.copyWith(color: colors.onBackground),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
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
                      backgroundColor: colors.surfaceVariant,
                      backgroundImage:
                          user.image.isNotEmpty ? NetworkImage(user.image) : null,
                      child: user.image.isEmpty
                          ? Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.secondary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.schedule,
                            color: colors.onSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  user.fullName,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onBackground,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  user.email,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_outline,
                    title: 'Chỉnh sửa thông tin cá nhân',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.lock_outline,
                    title: 'Đổi mật khẩu',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.history,
                    title: 'Lịch sử đọc báo',
                    onTap: () {
                      final userId = user.uid;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReadingHistoryScreen(userId: userId),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.settings_outlined,
                    title: 'Cài đặt ứng dụng',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AppSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.help_outline,
                    title: 'Trợ giúp & Hỗ trợ',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    color: Colors.red,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) {
                          final dialogColors = Theme.of(ctx).colorScheme;
                          final dialogText = Theme.of(ctx).textTheme;

                          return AlertDialog(
                            backgroundColor: dialogColors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              "Xác nhận đăng xuất",
                              style: dialogText.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: dialogColors.onSurface,
                              ),
                            ),
                            content: Text(
                              "Bạn có chắc chắn muốn đăng xuất không?",
                              style: dialogText.bodyMedium?.copyWith(
                                color: dialogColors.onSurfaceVariant,
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.end,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(color: dialogColors.outline),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  "Đăng xuất",
                                  style: TextStyle(color: dialogColors.primary),
                                ),
                              )
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await userVM.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
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
    required BuildContext context,
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        leading: Icon(icon, color: color ?? colors.onSurface, size: 26),
        title: Text(
          title,
          style: textTheme.bodyLarge?.copyWith(
            color: color ?? colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colors.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
