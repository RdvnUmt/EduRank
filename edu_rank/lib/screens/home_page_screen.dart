import 'package:edu_rank/screens/quizzes_screen.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  void goToSettingsScreen() {
    // will be codded soon...
  }

  void goToLeaderBoardScreen() {
    // will be codded soon...
  }

  void goToQuizzesScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => QuizzesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page (will be edited soon...)'),
      ),
      body: Center(
        child: OutlinedButton.icon(
          icon: const Icon(Icons.app_registration),
          onPressed: () {goToQuizzesScreen(context);},
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF4A6572),
          ),
          label: const Text(
            'Quizzes',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
