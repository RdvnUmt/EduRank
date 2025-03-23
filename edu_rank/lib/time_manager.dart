import 'package:shared_preferences/shared_preferences.dart';

class TimeManager {
  static const String _timeKey = 'totalTime';

  static Future<int> loadTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_timeKey) ?? 0; // Eğer kayıtlı değilse varsayılan 0
  }

  static Future<void> saveTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timeKey, time);
  }
}
