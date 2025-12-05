import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'category_manager_page.dart'; 
import 'article_manager_page.dart';
import 'user_manager_page.dart';
import 'system_settings_page.dart';
import 'notifications_page.dart'; 
import 'profile_screen.dart';
import '../../viewmodel/authen_viewmodel.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(), 
    CategoryManagerPage(), 
    ArticleManagerPage(), 
    UserManagerPage(), 
    NotificationsPage(), 
    SystemSettingsPage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text(
          "Admin Panel",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<AuthenViewModel>(
            builder: (context, auth, child) {
              final photo = auth.currentUser?.image;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (photo != null && photo.isNotEmpty)
                        ? NetworkImage(photo)
                        : const NetworkImage("https://i.pravatar.cc/150?img=10"),
                  ),
                ),
              );
            },
          )
        ],
      ),

      drawer: _buildDrawer(context),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _pages[_selectedIndex],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "MENU QUẢN LÝ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _drawerItem(Icons.dashboard, "Dashboard", 0),
            _drawerItem(Icons.grid_view, "Quản lý danh mục", 1),
            _drawerItem(Icons.article, "Quản lý bài viết", 2),
            _drawerItem(Icons.person, "Quản lý người dùng", 3),
            _drawerItem(Icons.notifications, "Thông báo hệ thống", 4),
            _drawerItem(Icons.settings, "Cài đặt hệ thống", 5),

            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Phiên bản 1.0.0",
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    bool selected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.withOpacity(0.12) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.blue : Colors.black87, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.blue : Colors.black87,
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
