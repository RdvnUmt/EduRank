import 'dart:async';
import 'package:edu_rank/models/quiz.dart';
import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  const QuizTimer({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  int _seconds = 0; // 5 dakika (örnek olarak)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds < 3600) {
        setState(() {
          _seconds++;
          widget.quiz.lastTime++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(Icons.timer, size: 28, color: Color(0xFF4A6572)),
        const SizedBox(width: 8),
        Text(
          formattedTime,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
