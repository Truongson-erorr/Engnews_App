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
      Navigator.push(
        context,
        createSlideRoute(const LoginScreen()), 
      );
      return;
    }
    _onMenuTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E0B12),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 19, 34),
        elevation: 0.8,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.list),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text("EngNews",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 1.2,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                createSlideRoute(const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF2C1A1F),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<AuthenViewModel>(
                builder: (context, userVM, _) {
                  final user = userVM.currentUser;
                  return UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xFF3B1322)),
                    currentAccountPicture: CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFF8C8C8C), // nền xám
                      backgroundImage: (user != null && user.image.isNotEmpty)
                          ? NetworkImage(user.image)
                          : null,
                      child: (user == null || user.image.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    accountName: Text(
                      user?.fullName ?? 'Chưa đăng nhập',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    accountEmail: Text(
                      user?.email ?? 'Đăng nhập để trải nghiệm nhiều hơn',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 0, 8),
                child: Text(
                  "Cài đặt & Hỗ trợ",
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.white70),
                title: const Text("Tuỳ chỉnh giao diện", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined, color: Colors.white70),
                title: const Text("Thông báo", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.translate, color: Colors.white70),
                title: const Text("Ngôn ngữ", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined, color: Colors.white70),
                title: const Text("Chế độ tối", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),
              const Divider(color: Colors.white38),
              ListTile(
                leading: const Icon(Icons.star_border, color: Colors.white70),
                title: const Text("Đánh giá ứng dụng", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined, color: Colors.white70),
                title: const Text("Góp ý & Hỗ trợ", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white70),
                title: const Text("Giới thiệu", style: TextStyle(color: Colors.white70)),
                onTap: () {},
              ),

              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Phiên bản 1.0.0",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
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
          color: const Color(0xFF2C1A1F),
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handlePrivateTab,
        backgroundColor: const Color(0xFF2C1A1F),
        selectedItemColor: const Color(0xFFD0021B),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: "Tin mới"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: "Chuyên mục"),
          BottomNavigationBarItem(icon: Icon(Icons.podcasts_outlined), label: "Podcast"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: "Đã lưu"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Tôi"),
        ],
      ),
    );
  }
}
