import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static const String _scoreKey = 'totalScore';

  static Future<int> loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_scoreKey) ?? 0; // Eğer kayıtlı değilse varsayılan 0
  }

  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreKey, score);
  }
}
