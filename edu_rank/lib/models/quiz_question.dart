class QuizQuestion {
  
  final String text;
  final List<String> answers;
  late List<String> shuffledAnswers;

  QuizQuestion(this.text, this.answers) {
    shuffledAnswers = getShuffledAnswers();
  }

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}