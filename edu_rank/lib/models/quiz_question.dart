class QuizQuestion {
  
  final String text;
  List<String> answers;

  QuizQuestion(this.text, this.answers) {
    answers = getShuffledAnswers();
  }

  List<String> getShuffledAnswers() {
    final shuffledList = List.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}