import 'package:flutter/material.dart';
import 'package:caonientruongson/features/users/screens/home_tab.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    HomeTab(),
    SearchTab(),
    CategoryTab(),
    SupportTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "EngNews - Diễn đàn quốc tế",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 30, 30, 255),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,      
          highlightColor: Colors.transparent, 
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.grey[850],
          selectedItemColor: const Color.fromARGB(255, 29, 55, 255),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: _selectedIndex == 0 ? 25 : 22,
              ),
              label: "Trang chủ",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: _selectedIndex == 1 ? 25 : 22,
              ),
              label: "Tìm kiếm",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category_outlined,
                size: _selectedIndex == 2 ? 25 : 22,
              ),
              label: "Chủ đề",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.lightbulb_outline,
                size: _selectedIndex == 3 ? 25 : 22,
              ),
              label: "Tiện ích",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: _selectedIndex == 4 ? 25 : 22,
              ),
              label: "Tôi",
            ),
          ],
        ),
      ),
    );
  }
}
