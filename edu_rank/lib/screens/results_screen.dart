import 'package:edu_rank/data/quizzes_data.dart';
import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/questions_summary/questions_summary.dart';
import 'package:edu_rank/score_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(
      {super.key,
      required this.choosenAnswers,
      required this.onExit,
      required this.quiz});

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

  String get formattedTime {
    int minutes = quiz.lastTime ~/ 60;
    int seconds = quiz.lastTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = quiz.questions.length;
    final numCorrectAnswers = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    int newScore = ((1500 - (1000 * (quiz.lastTime / 120))) *
            (numCorrectAnswers / numTotalQuestions))
        .toInt();

    if (newScore > quiz.score) {
      quiz.score = newScore;
      quiz.bestTime = formattedTime;
      totalScore = 0;
      for (int i = 0; i < quizzes.length; i++) {
        totalScore += quizzes[i].score;
      }
      Future.delayed(Duration.zero, () async {
        await quiz.saveData();
        await ScoreManager.saveScore(totalScore);
      });
    }

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.timer, size: 28, color: Color(0xFF4A6572)),
                const SizedBox(width: 2),
                Text(
                  formattedTime,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Your score is $newScore',
                  style: GoogleFonts.lato(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Icon(Icons.stop_circle_rounded,
                    size: 24, color: Color(0xFF4A6572)),
              ],
            ),
            SizedBox(height: 30),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton.icon(
                  onPressed: onExit,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF4A6572),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  icon: const Icon(Icons.home),
                  label: const Text('Exit Quiz'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
