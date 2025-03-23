import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/screens/results_screen.dart';
import 'package:edu_rank/widgets/questions_widget.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.quiz, required this.refreshQuizzesScreen});

  final Quiz quiz;
  final void Function() refreshQuizzesScreen;

  @override
  State<QuizScreen> createState() {
    return _QuizScreenState();
  }
}

class _QuizScreenState extends State<QuizScreen> {
  late List<String> selectedAnswers;
  var activeScreen = 'questions-screen';
  var index = 0;
  @override
  void initState() {
    super.initState();
    selectedAnswers =
        List.filled(widget.quiz.questions.length, 'null', growable: false);
  }

  void chooseAnswer(String answer) {
    if (index < widget.quiz.questions.length && index >= 0) {
      selectedAnswers[index] = answer;
    }
  }

  void finishQuiz() {
    setState(() {
      index = 0;
      activeScreen = 'results-screen';
    });
  }

  void nextQuestion() {
    if (index + 1 < widget.quiz.questions.length) {
      index++;
      setState(() {
        
      });
    }
  }

  void prevQuestion() {
    if (index > 0) {
      index--;
      setState(() {
        
      });
    }
  }

  void exitQuiz() {
    index = 0;
    selectedAnswers =
        List.filled(widget.quiz.questions.length, 'null', growable: false);
    Navigator.of(context).pop();
    widget.refreshQuizzesScreen();
  }

  @override
  Widget build(context) {
    Widget screenWidget = QuestionsScreen(
      onSelectAnswer: chooseAnswer,
      quiz: widget.quiz,
      onFinish: finishQuiz,
      goPrev: prevQuestion,
      goNext: nextQuestion,
      selectedAnswers: selectedAnswers,
      shuffledAnswers: widget.quiz.questions[index].shuffledAnswers,
    );

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
          onSelectAnswer: chooseAnswer,
          quiz: widget.quiz,
          onFinish: finishQuiz,
          goPrev: prevQuestion,
          goNext: nextQuestion,
          selectedAnswers: selectedAnswers,
          shuffledAnswers: widget.quiz.questions[index].shuffledAnswers);
    } else if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
          choosenAnswers: selectedAnswers,
          quiz: widget.quiz,
          onExit: exitQuiz); // exitQuiz ile değiş
    }

    return PopScope(
      canPop: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.quiz.title),
          ),
          body: Container(
            child: screenWidget,
          ),
        ),
      ),
    );
  }
}
