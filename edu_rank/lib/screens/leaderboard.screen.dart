import 'package:flutter/material.dart';
import 'package:edu_rank/widgets/leaderboard_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Toplam Skor', icon: Icon(Icons.leaderboard, color: Colors.black), height: 46),
            Tab(text: 'Çalışma Süresi', icon: Icon(Icons.timer, color: Colors.black), height: 46),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LeaderboardWidget(
              leaderboardData: [
                {"Utku": 2500},
                {"Rıdvan": 2200},
                {"Taha": 2100},
                {"Emirhan": 1900},
                {"Mirza": 1800},
                {"Ahmet": 1700},
                {"Işıkalp": 1600},
                {"Furkan": 1400},
                {"Mehmet": 1100},
                {"Efe": 900},
              ], isScore: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LeaderboardWidget(
              leaderboardData: [
                {"Utku": 120},
                {"Rıdvan": 100},
                {"Taha": 95},
                {"Emirhan": 85},
                {"Mirza": 80},
                {"Ahmet": 75},
                {"Işıkalp": 70},
                {"Furkan": 60},
                {"Mehmet": 50},
                {"Efe": 45},
              ], isScore: false,
            ),
          ),
        ],
      ),
    );
  }
}
