import 'package:flutter/material.dart';

class FinishQuizButton extends StatelessWidget {
  const FinishQuizButton({super.key, required this.finishQuiz});

  final void Function() finishQuiz; 

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        finishQuiz;
      },
      style: Theme.of(context).elevatedButtonTheme.style,
      icon: const Icon(Icons.app_registration_outlined),
      label: const Text('Finish Quiz'),
    );
  }
}
