import 'package:edu_rank/data/quiz_data.dart';
import 'package:edu_rank/data/quizzes_data.dart';
import 'package:edu_rank/models/quiz_category.dart';
import 'package:edu_rank/screens/quiz_info_screen.dart';
import 'package:edu_rank/widgets/quiz_grid_item.dart';
import 'package:flutter/material.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  void _selectQuiz(BuildContext context, QuizCategory quizCategory) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => QuizInfoScreen(quiz: quizzes[quizCategory.id - 1])),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a quiz'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            QuizCategoryGridItem(
              category: category,
              onSelectQuiz: () {
                _selectQuiz(context, category);
              },
            )
        ],
      ),
    );
  }
}
