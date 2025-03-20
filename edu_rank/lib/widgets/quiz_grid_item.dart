import 'package:edu_rank/models/quiz_category.dart';
import 'package:flutter/material.dart';

class QuizCategoryGridItem extends StatelessWidget {
  const QuizCategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectQuiz,
  });

  final QuizCategory category;
  final void Function() onSelectQuiz;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectQuiz,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
          colors: [
            category.color.withOpacity(0.55),
            category.color.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
