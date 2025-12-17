import 'package:caonientruongson/features/users/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'category_tab.dart';
import 'profile_tab.dart';
import 'latest_articles_screen.dart';
import 'notification_screen.dart';
import 'saved_articles_screen.dart';
import '../../../core/animation';
import '../../viewmodel/authen_viewmodel.dart';
import 'notification_settings_screen.dart';
import '../../../core/theme/theme_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const LatestArticlesScreen(key: ValueKey('latest')), // Tab mới
    const HomeTab(key: ValueKey('home')),
    const CategoryTab(key: ValueKey('category')),
    const SavedArticlesScreen(key: ValueKey('saved')),
    const ProfileTab(key: ValueKey('profile')),
  ];

  void _onMenuTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void _handlePrivateTab(int index) {
    final user =
        Provider.of<AuthenViewModel>(context, listen: false).currentUser;

    if (user == null && (index == 3 || index == 4)) {
      Navigator.push(context, createSlideRoute(const LoginScreen()));
      return;
    }

    _onMenuTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const primaryColor = Color(0xFF015E53);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: theme.drawerTheme.backgroundColor ??
            theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<AuthenViewModel>(
                builder: (context, userVM, _) {
                  final user = userVM.currentUser;
                  return UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: primaryColor),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.secondaryContainer,
                      backgroundImage:
                          (user != null && user.image.isNotEmpty)
                              ? NetworkImage(user.image)
                              : null,
                      child: (user == null || user.image.isEmpty)
                          ? Icon(Icons.person,
                              color: theme
                                  .colorScheme.onSecondaryContainer)
                          : null,
                    ),
                    accountName: Text(
                      user?.fullName ?? 'Chưa đăng nhập',
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      user?.email ?? 'Đăng nhập để trải nghiệm nhiều hơn',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
                child: Text(
                  "Cài đặt & Hỗ trợ",
                  style: TextStyle(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              ListTile(
                leading: Icon(
                  Icons.notifications_outlined,
                  color: colorScheme.onBackground,
                ),
                title: Text(
                  "Thông báo",
                  style: TextStyle(color: colorScheme.onBackground),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationSettingsScreen(),
                    ),
                  );
                },
              ),

              SwitchListTile(
                title: Text(
                  "Chế độ tối",
                  style:
                      TextStyle(color: colorScheme.onBackground),
                ),
                secondary: Icon(Icons.dark_mode_outlined,
                    color: colorScheme.onBackground),
                value:
                    context.watch<ThemeViewModel>().isDarkMode,
                onChanged: (value) => context
                    .read<ThemeViewModel>()
                    .toggleTheme(value),
              ),

              Divider(color: theme.dividerColor),

              _drawerItem(Icons.star_border, "Đánh giá ứng dụng"),
              _drawerItem(Icons.feedback_outlined, "Góp ý & Hỗ trợ"),
              _drawerItem(Icons.info_outline, "Giới thiệu"),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Phiên bản 1.0.0",
                  style:
                      TextStyle(color: theme.hintColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Container(
          key: ValueKey(_selectedIndex),
          color: theme.scaffoldBackgroundColor,
          child: _pages[_selectedIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handlePrivateTab,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: theme.unselectedWidgetColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_outlined),
            activeIcon: Icon(Icons.home_work_rounded),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: "Tin tức",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_outlined),
            activeIcon: Icon(Icons.view_list),
            label: "Chuyên mục",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: "Đã lưu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Tôi",
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onBackground;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {},
    );
  }
}
