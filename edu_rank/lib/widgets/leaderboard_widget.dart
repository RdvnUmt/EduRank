import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, int>> leaderboardData;
  final bool isScore;

  const LeaderboardWidget({super.key, required this.leaderboardData, required this.isScore});

  @override
  Widget build(BuildContext context) {
    String criteria = 'minutes';
    if(isScore) {
      criteria = 'points';
    }

    return SizedBox(
      height: 300,
      child: Center(
        child: ListView.builder(
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final entry = leaderboardData[index];
            final playerName = entry.keys.first;
            final score = entry[playerName]!;

            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(playerName, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                  trailing: Text('$score $criteria', style: TextStyle(fontSize: 16)),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
