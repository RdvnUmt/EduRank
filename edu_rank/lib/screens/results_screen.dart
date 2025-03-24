import 'package:edu_rank/data/quizzes_data.dart';
import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/questions_summary/questions_summary.dart';
import 'package:edu_rank/services/leaderboard_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    super.key,
    required this.choosenAnswers,
    required this.onExit,
    required this.quiz,
  });

  final Quiz quiz;
  final void Function() onExit;
  final List<String> choosenAnswers;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    _updateScoreAndTime();
  }

  Future<void> _updateScoreAndTime() async {
    final summaryData = getSummaryData();
    final numTotalQuestions = widget.quiz.questions.length;
    final numCorrectAnswers = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    int newScore = ((1500 - (1000 * (widget.quiz.lastTime / 120))) *
            (numCorrectAnswers / numTotalQuestions))
        .toInt();
    totalTime += widget.quiz.lastTime;

    if (newScore > widget.quiz.score) {
      widget.quiz.score = newScore;
      widget.quiz.bestTime = formattedTime;
      await LeaderboardService.updateScore(widget.quiz.score.toDouble());
      await LeaderboardService.updateTimeSpent(totalTime);
    }

    // var totalScore1 = 0;
    // for (int i = 0; i < quizzes.length; i++) {
    //   totalScore1 += quizzes[i].score;
    // }
  }

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];
    for (var i = 0; i < widget.choosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': widget.quiz.questions[i].text,
        'correct_answer': widget.quiz.questions[i].answers[0],
        'user_answer': widget.choosenAnswers[i],
      });
    }
    return summary;
  }

  String get formattedTime {
    int minutes = widget.quiz.lastTime ~/ 60;
    int seconds = widget.quiz.lastTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = widget.quiz.questions.length;
    final numCorrectAnswers = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    int newScore = ((1500 - (1000 * (widget.quiz.lastTime / 120))) *
            (numCorrectAnswers / numTotalQuestions))
        .toInt();

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
                  onPressed: widget.onExit,
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
