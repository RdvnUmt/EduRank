import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<Map<String, int>> leaderboardData;
  final bool isScore;

  const LeaderboardWidget({super.key, required this.leaderboardData, required this.isScore});

  @override
  Widget build(BuildContext context) {
    String criteria = isScore ? 'puan' : 'dakika';
    print('Building LeaderboardWidget with ${leaderboardData.length} items');
    print('isScore: $isScore, criteria: $criteria');
    print('Data: $leaderboardData');

    return leaderboardData.isEmpty
        ? Center(
            child: Text(
              'Hiç veri bulunamadı. Henüz hiçbir quiz tamamlanmamış olabilir.',
              style: GoogleFonts.roboto(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final entry = leaderboardData[index];
              final playerName = entry.keys.first;
              final value = entry[playerName]!;
              
              // Eğer time leaderboard ise, saniyeyi dakikaya çevir
              final displayValue = isScore ? value : (value / 60).toStringAsFixed(1);
              
              print('Item $index: $playerName - $displayValue $criteria');

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      child: Text((index + 1).toString()),
                    ),
                    title: Text(playerName, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                    trailing: Text('$displayValue $criteria', style: TextStyle(fontSize: 16)),
                  ),
                  Divider(),
                ],
              );
            },
          );
  }
}
