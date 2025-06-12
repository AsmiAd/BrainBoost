import 'package:brain_boost/screens/add/add_screen.dart';
import 'package:brain_boost/screens/home/home_screen.dart';
import 'package:brain_boost/screens/profile/profile_screen.dart';
import 'package:brain_boost/screens/search/search_screen.dart';
import 'package:brain_boost/screens/statistic/statistic_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> data = [
    const HomeScreen(),
    SearchScreen(),
    const AddScreen(),
    const StatisticScreen(),
    const ProfileScreen(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.home,
        size: 30,
      ),
      Icon(
        Icons.search,
        size: 30,
      ),
      Icon(
        Icons.add,
        size: 30,
      ),
      Icon(
        Icons.bar_chart,
        size: 30,
      ),
      Icon(
        Icons.person,
        size: 30,
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: data[index],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        height: 60,
        index: index,
        items: items,
        onTap: (newIndex) => setState(() => index = newIndex),
      ),
    );
  }
}
