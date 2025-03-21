import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.answerText, this.onTap,
      {super.key, required this.answeredQuestion});

  final String answeredQuestion;
  final String answerText;
  final void Function() onTap;
  

  @override
  Widget build(BuildContext context) {
    bool isSelected = (answerText == answeredQuestion)? true : false;
    ElevatedButton answerButton = ElevatedButton(
      onPressed: onTap,
      style: Theme.of(context).elevatedButtonTheme.style,
      child: Text(
        answerText,
        textAlign: TextAlign.center,
      ),
    );

    if (isSelected) {
      answerButton = ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6572),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 4,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          answerText,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [answerButton, SizedBox(height: 5)],
    );
  }
}
