import 'package:flutter/material.dart';

/// Màn hình Home sau khi đăng nhập với BottomNavigationBar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text("Trang chủ", style: TextStyle(fontSize: 20))),
    Center(child: Text("Thể thao", style: TextStyle(fontSize: 20))),
    Center(child: Text("Giải trí", style: TextStyle(fontSize: 20))),
    Center(child: Text("Cá nhân", style: TextStyle(fontSize: 20))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Tin tức trong ngày"),
        centerTitle: true,
        automaticallyImplyLeading: true, 
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 30, 30, 255),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: "Thể thao",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Giải trí",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Cá nhân",
          ),
        ],
      ),
    );
  }
}
