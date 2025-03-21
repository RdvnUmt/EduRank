import 'package:flutter/material.dart';

class QuizCategory {
  const QuizCategory({
    required this.id,
    required this.title,
    this.color = const Color.fromARGB(255, 139, 154, 162),
  });

  final int id;
  final String title;
  final Color color;
}
