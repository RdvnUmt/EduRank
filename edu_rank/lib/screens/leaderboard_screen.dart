import 'package:flutter/material.dart';
import 'package:edu_rank/widgets/leaderboard_widget.dart';
import 'package:edu_rank/services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, int>> _scoreLeaderboard = [];
  List<Map<String, int>> _timeLeaderboard = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final scoreResult = await LeaderboardService.getScoreLeaderboard();

      if (scoreResult['success']) {
        final scoreData = scoreResult['leaderboard'] as List;

        final typedScoreData = scoreData.map((entry) {
          return {
            entry['username'] as String: entry['total_score'].round() as int
          };
        }).toList();

        setState(() {
          _scoreLeaderboard = typedScoreData;
        });
      } else {
        setState(() {
          _errorMessage = scoreResult['message'];
        });
      }

      final timeResult = await LeaderboardService.getTimeLeaderboard();

      if (timeResult['success']) {
        final timeData = timeResult['leaderboard'] as List;

        final typedTimeData = timeData.map((entry) {
          final totalTime = entry['total_time_spent'];
          int timeInMinutes;

          if (totalTime is double) {
            timeInMinutes = totalTime.toInt();
          } else if (totalTime is int) {
            timeInMinutes = totalTime;
          } else {
            throw Exception("Unexpected type for total_time_spent");
          }

          return {entry['username'] as String: timeInMinutes};
        }).toList();

        setState(() {
          _timeLeaderboard = typedTimeData;
        });
      } else {
        setState(() {
          _errorMessage = timeResult['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load leaderboard data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            Tab(
                text: 'Toplam Skor',
                icon: Icon(Icons.leaderboard, color: Colors.black)),
            Tab(
                text: 'Çalışma Süresi',
                icon: Icon(Icons.timer, color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLeaderboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchLeaderboardData,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardWidget(
                        leaderboardData: _scoreLeaderboard,
                        isScore: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardWidget(
                        leaderboardData: _timeLeaderboard,
                        isScore: false,
                      ),
                    ),
                  ],
                ),
    );
  }
}
