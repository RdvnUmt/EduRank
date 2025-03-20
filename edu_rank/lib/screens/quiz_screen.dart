import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/widgets/quiz_item.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget{
  const QuizScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            QuizItem(quiz: quiz),
            const SizedBox(height: 500)
            //Quiz skorları...
          ],
        ),
      )
    );
  }
}