import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/screens/quiz_screen.dart';
import 'package:edu_rank/widgets/quiz_item.dart';
import 'package:flutter/material.dart';

class QuizInfoScreen extends StatelessWidget {
  const QuizInfoScreen({super.key, required this.quiz});

  final Quiz quiz;

  void _startQuiz(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => QuizScreen(quiz: quiz)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quiz.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuizItem(
              quiz: quiz,
              startQuiz: () {
                _startQuiz(context);
              },
            ),
            const SizedBox(height: 400)
            //Quiz skorları...
          ],
        ),
      ),
    );
  }
}
