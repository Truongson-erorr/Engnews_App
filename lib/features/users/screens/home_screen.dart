import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'category_tab.dart';
import 'podcast_tab.dart';
import 'profile_tab.dart';
import 'saved_articles_screen.dart';
import '../../../core/animation';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(key: ValueKey('home')),
    CategoryTab(key: ValueKey('category')),
    PodcastTab(key: ValueKey('podcast')),
    SavedArticlesScreen(key: ValueKey('saved')),
    ProfileTab(key: ValueKey('profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E0B12), 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 19, 34), 
        elevation: 0.8,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.tv_rounded),
          color: Colors.white,
          onPressed: () {},
          tooltip: "Bài đã đọc",
        ),
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
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                createSlideRoute(const SearchScreen()),
              );
            },
            tooltip: "Tìm kiếm",
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
            tooltip: "Thông báo",
          ),
        ],
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E0B12),
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD0021B), 
        unselectedItemColor: Colors.white70, 
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
              Icons.grid_view_outlined,
              size: _selectedIndex == 1 ? 26 : 22,
            ),
            label: "Chuyên mục",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.podcasts_outlined,
              size: _selectedIndex == 2 ? 26 : 22,
            ),
            label: "Podcast",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark_outline,
              size: _selectedIndex == 3 ? 26 : 22,
            ),
            label: "Đã lưu",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: _selectedIndex == 4 ? 26 : 22,
            ),
            label: "Tôi",
          ),
        ],
      ),
    );
  }
}
