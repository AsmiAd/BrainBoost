import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'is_dark_theme';  // Storage key
  
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();  // Load saved theme on initialization
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool(_themeKey) ?? false 
          ? ThemeMode.dark 
          : ThemeMode.light;
    } catch (e) {
      // Fallback to light theme if error occurs
      state = ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, state == ThemeMode.dark);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
      // State still changes, just not persisted
    }
  }
}