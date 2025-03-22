import 'package:edu_rank/models/quiz_question.dart';

class Quiz {
  Quiz(this.id, this.title, this.imageUrl, this.questions);

  final List<QuizQuestion> questions;
  final int id;
  final String title;
  final String imageUrl;
  String bestTime = '0:00';
  int lastTime = 0;
  int score = 0;
}