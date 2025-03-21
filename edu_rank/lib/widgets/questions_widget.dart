import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/widgets/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
    required this.quiz,
    required this.onFinish,
    required this.goPrev,
    required this.goNext,
    required this.selectedAnswers,
  });

  final Quiz quiz;
  final void Function(String answer) onSelectAnswer;
  final void Function() onFinish;
  final void Function() goPrev;
  final void Function() goNext;
  final List<String> selectedAnswers;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      
    });
  }

  void nextQuestion() {
    if (widget.quiz.questions.length > currentQuestionIndex + 1) {
      setState(() {
        widget.goNext();
        currentQuestionIndex++;
      });
    }
  }

  void prevQuestion() {
    if (0 < currentQuestionIndex) {
      setState(() {
        widget.goPrev();
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(context) {
    final currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Container(
            margin: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentQuestion.text,
                  style: GoogleFonts.lato(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ...currentQuestion.getShuffledAnswers().map((answer) {
                  return AnswerButton(
                    answer,
                    () {
                      answerQuestion(answer);
                    },
                    answeredQuestion: widget.selectedAnswers[currentQuestionIndex],
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_circle_left_outlined, size: 50),
              onPressed: prevQuestion,
              style: IconButton.styleFrom(
                foregroundColor: const Color(0xFF4A6572),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.assistant_photo_outlined),
              onPressed: widget.onFinish,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4A6572),
              ),
              label: const Text(
                'Finish Quiz',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_circle_right_outlined, size: 50),
              onPressed: nextQuestion,
              style: IconButton.styleFrom(
                foregroundColor: const Color(0xFF4A6572),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
