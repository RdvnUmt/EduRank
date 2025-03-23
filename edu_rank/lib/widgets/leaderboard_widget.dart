import 'package:flutter/material.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, int>> leaderboardData;

  const LeaderboardWidget({super.key, required this.leaderboardData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: ListView.builder(
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final entry = leaderboardData[index];
            final playerName = entry.keys.first;
            final score = entry[playerName]!;
        
            return ListTile(
              leading: CircleAvatar(
                child: Text((index + 1).toString()),
              ),
              title: Text(playerName, style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(score.toString(), style: TextStyle(fontSize: 16)),
            );
          },
        ),
      ),
    );
  }
}
