import 'package:edu_rank/models/quiz_question.dart';

class Quiz {

  List<QuizQuestion> questions;
  final int id;
  final String title;
  final String imageUrl;
  String bestTime = '0:00';
  int lastTime = 0;
  int score = 0;
  Quiz(this.id, this.title, this.imageUrl, this.questions){
    questions = getShuffledAnswers();
  }

  List<QuizQuestion> getShuffledAnswers() {
    final shuffledList = List.of(questions);
    shuffledList.shuffle();
    return shuffledList;
  }
}