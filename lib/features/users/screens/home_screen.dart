import 'package:caonientruongson/features/users/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'category_tab.dart';
import 'podcast_tab.dart';
import 'profile_tab.dart';
import 'saved_articles_screen.dart';
import '../../../core/animation';
import '../../viewmodel/authen_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(key: ValueKey('home')),
    const CategoryTab(key: ValueKey('category')),
    PodcastTab(key: ValueKey('podcast')),
    const SavedArticlesScreen(key: ValueKey('saved')),
    const ProfileTab(key: ValueKey('profile')),
  ];

  void _onMenuTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _handlePrivateTab(int index) {
    final user = Provider.of<AuthenViewModel>(context, listen: false).currentUser;

    if (user == null && (index == 3 || index == 4)) {
      Navigator.push(context, createSlideRoute(const LoginScreen()));
      return;
    }
    _onMenuTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB42652), 
        elevation: 0.6,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text(
          "EngNews",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white), 
            onPressed: () => Navigator.push(
              context,
              createSlideRoute(const SearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white), 
            onPressed: () {},
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<AuthenViewModel>(
                builder: (context, userVM, _) {
                  final user = userVM.currentUser;
                  return UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.white),
                    currentAccountPicture: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (user != null && user.image.isNotEmpty)
                          ? NetworkImage(user.image)
                          : null,
                      child: (user == null || user.image.isEmpty)
                          ? const Icon(Icons.person, size: 32, color: Color(0xFFB42652))
                          : null,
                    ),
                    accountName: Text(
                      user?.fullName ?? 'Chưa đăng nhập',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      user?.email ?? 'Đăng nhập để trải nghiệm nhiều hơn',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 0, 8),
                child: Text(
                  "Cài đặt & Hỗ trợ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              _drawerItem(Icons.settings_outlined, "Tuỳ chỉnh giao diện"),
              _drawerItem(Icons.notifications_outlined, "Thông báo"),
              _drawerItem(Icons.translate, "Ngôn ngữ"),
              _drawerItem(Icons.dark_mode_outlined, "Chế độ tối"),
              const Divider(color: Colors.black26),
              _drawerItem(Icons.star_border, "Đánh giá ứng dụng"),
              _drawerItem(Icons.feedback_outlined, "Góp ý & Hỗ trợ"),
              _drawerItem(Icons.info_outline, "Giới thiệu"),

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
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Container(
          key: ValueKey(_selectedIndex),
          color: Colors.white,
          child: _pages[_selectedIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handlePrivateTab,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFB42652),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: "Chuyên mục"),
          BottomNavigationBarItem(icon: Icon(Icons.podcasts_outlined), label: "Podcast"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: "Đã lưu"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Tôi"),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(title, style: const TextStyle(color: Color.fromARGB(255, 38, 38, 38))),
      onTap: () {},
    );
  }
}
