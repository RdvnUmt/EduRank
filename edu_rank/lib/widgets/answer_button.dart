import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.answerText, this.onTap, {super.key});

  final String answerText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Text(answerText, textAlign: TextAlign.center,),
        ),
        SizedBox(height: 5)
      ],
    );
  }
}
