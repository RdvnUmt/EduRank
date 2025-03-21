import 'package:edu_rank/models/quiz.dart';
import 'package:edu_rank/widgets/quiz_item_trait.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class QuizItem extends StatelessWidget {
  const QuizItem({super.key, required this.quiz, required this.startQuiz});

  final void Function() startQuiz;
  final Quiz quiz;

  int get bestTime {
    return quiz.bestTime;
  }

  int get score {
    return quiz.score;
  }

  @override
  Widget build(context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: startQuiz,
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(quiz.imageUrl),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      quiz.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuizItemTrait(
                          icon: Icons.schedule,
                          label: '${quiz.bestTime} min',
                        ),
                        const SizedBox(width: 24),
                        QuizItemTrait(
                          icon: Icons.stop_circle_rounded,
                          label: '${quiz.score} p',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
