import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart'; 
import '../auth/login_screen.dart'; 

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to BrainBoost",
      "description": "Sharpen your memory with interactive flashcards!",
      "image": "assets/images/sharp brain.png"
    },
    {
      "title": "Track Your Progress",
      "description": "Stay motivated with goals and achievements.",
      "image": "assets/images/progress.png"
    },
    {
      "title": "Learn Anytime, Anywhere",
      "description": "Offline study, voice input, and more!",
      "image": "assets/images/learn anywhere.png"
    },
  ];

  void navigateToNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingContent(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                image: onboardingData[index]['image']!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == onboardingData.length - 1) {
                  navigateToNext();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text(
                _currentPage == onboardingData.length - 1
                    ? "Get Started"
                    : "Next",
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    final bool isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 22 : 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.text.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
