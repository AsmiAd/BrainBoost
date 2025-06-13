import 'package:brain_boost/core/constants/app_theme.dart';
import 'package:brain_boost/core/providers/theme_provider.dart';
import 'package:brain_boost/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_routes.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app with ProviderScope for state management
  runApp( ProviderScope(
      child: BrainBoostApp(), // Riverpod prefers dynamic instantiation
    ),);
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
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: '/',

      // Initial screen with smooth theme transition
      home: Builder(
        builder: (context) => AnimatedTheme(
          duration: const Duration(milliseconds: 300),
          data: Theme.of(context),
          child: const SplashScreen(),
        ),
      ),
    );
  }
}
