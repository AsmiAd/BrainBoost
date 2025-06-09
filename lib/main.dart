import 'package:brain_boost/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: BrainBoostApp()));
}

class BrainBoostApp extends ConsumerWidget {
  const BrainBoostApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'BrainBoost',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: Builder(
        builder: (context) => AnimatedTheme(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          data: Theme.of(context), // Gets the current theme based on themeMode
          child:  LoginScreen(),
        ),
      ),
    );
  }
}