import 'package:brain_boost/screens/notifications/notification_screen.dart';
import 'package:brain_boost/screens/profile/feedback_screen.dart';
import 'package:brain_boost/screens/profile/help_screen.dart';
import 'package:brain_boost/screens/study/random_mix_screen.dart';
import 'package:brain_boost/screens/test/quiz_mode_screen.dart';
import 'package:brain_boost/screens/test/true_false_mode_screen.dart';
import 'package:flutter/material.dart';
import '../screens/auth/auth_checker.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/deckDetail/deck_details_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/nav/main_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/test/test_mode_screen.dart';
import 'models/deck_model.dart';
import 'screens/decks/decks_screen.dart';
import 'screens/flashcard/flashcards_screen.dart';
import 'screens/study/flash_mode_screen.dart';
import 'screens/study/quiz_mode_screen.dart';
import 'screens/study/spaced_repetition_screen.dart';
import 'screens/study/study_screen.dart';
import 'screens/study/timed_mode_screen.dart';
import 'screens/study/true_false_mode_screen.dart';
import 'screens/test/random_mix_mode_screen.dart';
import 'screens/test/timed_mode_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const DecksScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/study':
        return MaterialPageRoute(builder: (_) => const StudyScreen());
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
      case '/feedback':
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());
      case '/help':
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case '/quiz':
        return MaterialPageRoute(builder: (_) => const QuizModeScreen());

      case '/truefalse':
        final deck = settings.arguments as Deck; 
        return MaterialPageRoute(
          builder: (_) => TrueFalseModeScreen(deck: deck),
        );

      case '/timed':
        final deck = settings.arguments as Deck;
        return MaterialPageRoute(
          builder: (_) => TimedModeScreen(deck: deck),
        );

      case '/randommix':
        return MaterialPageRoute(builder: (_) => const RandomMixScreen());

      case '/quiz_mode':
        final deck = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => QuizModeStudyScreen(deckId: deck),
        );
 
      case '/random_mix':
        {
          return MaterialPageRoute(
            builder: (_) => const RandomMixStudyScreen(),
          );
        }

      case '/time':
        final deck = settings.arguments as Deck;
        return MaterialPageRoute(
          builder: (_) => TimedModeStudyScreen(deck: deck),
        );

      case '/true-false':
        final deck = settings.arguments as Deck;
        return MaterialPageRoute(
          builder: (_) => TrueFalseModeStudyScreen(deck: deck),
        );

      case '/flash_mode':
        {
          final deckId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => FlashModeScreen(deckId: deckId),
          );
        }

      case '/spaced_repetition':
        {
          final deckId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => SpacedRepetitionScreen(deckId: deckId),
          );
        }

      case '/flashcards':
        final deckId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => FlashcardsScreen(deckId: deckId),
        );

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
