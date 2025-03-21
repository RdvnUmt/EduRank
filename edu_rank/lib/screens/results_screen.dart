import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/questions_summary/questions_summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.choosenAnswers, required this.onExit, required this.quiz});

  final Quiz quiz;
  final void Function() onExit;
  final List<String> choosenAnswers;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];
    for (var i = 0; i < choosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': quiz.questions[i].text,
        'correct_answer': quiz.questions[i].answers[0],
        'user_answer': choosenAnswers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = quiz.questions.length;
    final numCorrectAnswers = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'You answered $numCorrectAnswers out of $numTotalQuestions questions correctly!',
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          QuestionsSummary(getSummaryData()),
          SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onExit,
            style: Theme.of(context).textButtonTheme.style,
            icon: const Icon(Icons.home),
            label: const Text('Exit Quiz'),
          ),
        ]),
      ),
    );
  }
}
