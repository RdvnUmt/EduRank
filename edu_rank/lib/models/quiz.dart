import 'package:edu_rank/models/quiz_question.dart';

class Quiz {
  Quiz(this.id, this.title, this.imageUrl, this.questions);

  final List<QuizQuestion> questions;
  final int id;
  final String title;
  final String imageUrl;
  int bestTime = 0;
  int score = 0;
}