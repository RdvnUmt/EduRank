import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_screen.dart';
import 'leaderboard.screen.dart';
import 'profile_screen.dart';
import 'quizzes_screen.dart';
import 'timer_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
    QuizzesScreen(),
    TimerScreen(),
    LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.person, text: 'Profil'),
              GButton(icon: Icons.quiz_outlined, text: 'Quiz'),
              GButton(icon: Icons.timer_outlined, text: 'Sayaç'),
              GButton(icon: Icons.leaderboard_rounded, text: 'Leaderboard'),
            ],
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedIndex: _selectedIndex,
            tabBackgroundGradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 48, 3, 3),
                Color.fromARGB(255, 68, 3, 3),
              ],
              begin: Alignment.topLeft,
            ),            
            gap: 6,
            padding: EdgeInsets.all(16),
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade900,
            mainAxisAlignment: MainAxisAlignment.center,
            tabBorderRadius: 42,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
