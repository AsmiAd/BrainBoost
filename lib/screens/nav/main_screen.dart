// lib/screens/main_screen.dart
import 'package:brain_boost/core/constants/app_colors.dart' show AppColors;
import 'package:brain_boost/screens/add/add_screen.dart';
import 'package:brain_boost/screens/home/home_screen.dart';
import 'package:brain_boost/screens/profile/profile_screen.dart' show ProfileScreen;
import 'package:brain_boost/screens/search/search_screen.dart';
import 'package:brain_boost/screens/statistic/statistic_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:brain_boost/widgets/chat_support_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages =  [
    HomeScreen(),
    SearchScreen(),
    AddScreen(onDeckCreated: (deck){}),
    
    StatisticScreen(),
    
    ProfileScreen(),
  ];
    final List<IconData> _navIcons = [
    Icons.home,
    Icons.search,
    Icons.add,
    Icons.bar_chart,
    Icons.person,
  ];
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _pages[_selectedIndex], // ✅ current screen
          const ChatSupportButton(), // ✅ chat floating button
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blueAccent,
        buttonBackgroundColor: AppColors.primary,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          
          Icon(Icons.search,size:30),
          
          Icon(Icons.add,size:30),
          Icon(Icons.bar_chart, size: 30),
          Icon(Icons.person, size: 30),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
