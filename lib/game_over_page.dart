import 'package:flutter/material.dart';
import 'package:hias_up/mode_select_screen.dart';

class GameOverScreen extends StatefulWidget {
  final List<String> questionsShown;
  final List<bool> answers;

  const GameOverScreen(this.questionsShown, this.answers, {super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  List<Text> generateAnswersList() {
    List<Text> answersTextList = [];
    for (var i = 0; i < widget.questionsShown.length; i++) {
      final String question = widget.questionsShown[i];
      final bool correct = widget.answers[i];
      answersTextList.add(Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: correct ? Colors.green[700] : Colors.red[700],
        ),
      ));
    }
    return answersTextList;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(),
                  Column(
                    children: [
                      const Text(
                        "Game Over",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        // (answers.length-1) to exclude the last-shown question. If not impossible to get 100%
                        "Your Score: ${widget.answers.where((element) => element == true).length} / ${widget.answers.length - 1}",
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: SingleChildScrollView(
                          child: Column(children: generateAnswersList()),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ModeSelectScreen()),
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: Text("Loading..."),
          ),
        );
      }
    });
  }
}
