import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_rank/models/quiz_question.dart';

class Quiz {
  List<QuizQuestion> questions;
  final int id;
  final String title;
  final String imageUrl;
  String bestTime = '0:00';
  int lastTime = 0;
  int score = 0;

  Quiz(this.id, this.title, this.imageUrl, this.questions) {
    questions = getShuffledAnswers();
    _loadData();
  }

  void init() async {
    await _loadData();
  }

  List<QuizQuestion> getShuffledAnswers() {
    final shuffledList = List.of(questions);
    shuffledList.shuffle();
    return shuffledList;
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quiz_${id}_score', score);
    await prefs.setString('quiz_${id}_bestTime', bestTime);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    score = prefs.getInt('quiz_${id}_score') ?? 0;
    bestTime = prefs.getString('quiz_${id}_bestTime') ?? '0:00';
  }
}
