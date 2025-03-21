import 'package:edu_rank/data/quizzes_data.dart';
import 'package:edu_rank/screens/quiz_screen.dart';
import 'package:edu_rank/widgets/quiz_item.dart';
import 'package:flutter/material.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  void _startQuiz(BuildContext context, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => QuizScreen(quiz: quizzes[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (ctx, index) => QuizItem(
        quiz: quizzes[index],
        startQuiz: () {
          _startQuiz(context, index);
        },
      ),
    );

    if (quizzes.isEmpty) {
      content = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Nothing here!',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 16),
          Text('try to add a new quiz to quizzes list...',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick a Quiz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: content,
    );
  }
}
