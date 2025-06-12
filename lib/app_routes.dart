import 'package:brain_boost/screens/notifications/notification_screen.dart';
import 'package:flutter/material.dart';
import '../screens/auth/auth_checker.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/deckDetail/deck_details_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/nav/main_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/study/study_mode_screen.dart';
import '../screens/test/test_mode_screen.dart';
import 'screens/decks/decks_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const DecksScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/study':
        return MaterialPageRoute(builder: (_) => const StudyModeScreen());
      case '/test':
        return MaterialPageRoute(builder: (_) => const TestModeScreen());
      case '/main_screen':
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthChecker());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case '/deck-details':
        final deckId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DeckDetailsScreen(deckId: deckId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}