import 'package:brain_boost/screens/add/add_screen.dart';
import 'package:brain_boost/screens/home/home_screen.dart';
import 'package:brain_boost/screens/profile/profile_screen.dart';
import 'package:brain_boost/screens/search/search_screen.dart';
import 'package:brain_boost/screens/statistic/statistic_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:brain_boost/core/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    AddScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for curved nav bar transparency
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildCurvedNavBar(),
    );
  }

  Widget _buildCurvedNavBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent, // Removes white background
      ),
      child: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        color: AppColors.primary,
        buttonBackgroundColor: AppColors.primary.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        items: _navIcons.map((icon) => Icon(icon, size: 30)).toList(),
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}