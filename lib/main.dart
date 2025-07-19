import 'package:brain_boost/core/constants/app_theme.dart';
import 'package:brain_boost/providers/theme_provider.dart';
import 'package:brain_boost/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_routes.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Hive models
import 'models/deck_model.dart';
import 'models/flashcard_model.dart';
import 'models/study_progress.dart';
import 'providers/deck_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();

  // ✅ Register Hive adapters only if not already registered
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DeckAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(StudyProgressAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(FlashcardAdapter());
  }

  final container = ProviderContainer();
await container.read(deckLocalServiceInitProvider.future);
await container.read(flashcardLocalServiceInitProvider.future);


  // ✅ Open Hive boxes
  await Hive.openBox<Deck>('decks');
  await Hive.openBox<StudyProgress>('progress');
  await Hive.openBox<Flashcard>('flashcards');

  // ✅ Run the app with ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: BrainBoostApp(),
    ),
  );
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
