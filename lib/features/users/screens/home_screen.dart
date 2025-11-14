import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'category_tab.dart';
import 'support_tab.dart';
import 'profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    SearchTab(),
    CategoryTab(),
    SupportTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFFD0021B),
        elevation: 0.8,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "EngNews",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,

        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD0021B),
        unselectedItemColor: Colors.black45,

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),

        onTap: _onItemTapped,

        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.article_outlined,
              size: _selectedIndex == 0 ? 26 : 22,
            ),
            label: "Tin mới",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: _selectedIndex == 1 ? 26 : 22,
            ),
            label: "Tìm kiếm",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.grid_view_outlined,
              size: _selectedIndex == 2 ? 26 : 22,
            ),
            label: "Chuyên mục",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.podcasts_outlined,
              size: _selectedIndex == 3 ? 26 : 22,
            ),
            label: "Podcast",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: _selectedIndex == 4 ? 26 : 22,
            ),
            label: "Tài khoản",
          ),
        ],
      ),
    );
  }
}
