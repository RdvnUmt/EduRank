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
  bool _isUploading = false;
  String? _errorMessage;
  bool _uploadSuccess = false;

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
    }
    
    totalScore = 0;
    for (int i = 0; i < quizzes.length; i++) {
      totalScore += quizzes[i].score;
    }
    
    setState(() {
      _isUploading = true;
      _errorMessage = null;
      _uploadSuccess = false;
    });
    
    try {
      print('Sending score to server: $totalScore');
      final scoreResult = await LeaderboardService.updateScore(totalScore.toDouble());
      
      if (!scoreResult['success']) {
        setState(() {
          _errorMessage = 'Skor güncellenirken hata: ${scoreResult['message']}';
          _isUploading = false;
        });
        return;
      }
      
      print('Sending time to server: $totalTime');
      final timeResult = await LeaderboardService.updateTimeSpent(totalTime);
      
      if (!timeResult['success']) {
        setState(() {
          _errorMessage = 'Süre güncellenirken hata: ${timeResult['message']}';
          _isUploading = false;
        });
        return;
      }
      
      setState(() {
        _isUploading = false;
        _uploadSuccess = true;
      });
      
      if (scoreResult['total_score'] != null) {
        totalScore = scoreResult['total_score'].toDouble().toInt();
        print('Total score updated from server: $totalScore');
      }
      
      if (timeResult['total_time_spent'] != null) {
        totalTime = timeResult['total_time_spent'];
        print('Total time updated from server: $totalTime');
      }
      
      print('Score and time updated successfully!');
      print('New total score: ${scoreResult['total_score']}');
      print('New total time: ${timeResult['total_time_spent']}');
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Sunucu iletişim hatası: ${e.toString()}';
        _isUploading = false;
      });
      print('Error updating score and time: $e');
    }
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
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_uploadSuccess)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Score and time updated successfully!',
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
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
