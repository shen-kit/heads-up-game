import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hias_up/game_data.dart';
import 'package:hias_up/game_over_page.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GameScreen extends StatefulWidget {
  final List questions;
  final int gameDuration;

  const GameScreen(this.questions, this.gameDuration, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final double sensitivity = 0.6;
  final double answerDelay = 1;
  int timeToStart = 3;

  late List<dynamic>
      _questionsList; // edit this list so the game can be replayed
  List<String> questionsAsked = [];
  List<bool> answers = [];
  String currentQuestion = "";
  // 0 = default background, -1 = incorrect (red background), 1 = correct (green background)
  int lastAnswer = 0;

  bool listen = true;
  late int timeLeft;
  final List<Timer> _timers = [];
  late StreamSubscription<dynamic> gyroscopeSubscription;

  @override
  void initState() {
    super.initState();

    timeLeft = widget.gameDuration;

    // avoid duplicate questions from the previous game if doing the same topic again
    _questionsList = List.from(widget.questions);
    if (File("${GameData().docsDir}/prevGameQs.txt").existsSync()) {
      for (var question
          in File("${GameData().docsDir}/prevGameQs.txt").readAsLinesSync()) {
        _questionsList.remove(question);
      }

      // if not enough questions left to play, reset the questions list
      if (_questionsList.length < 20) {
        _questionsList = List.from(widget.questions);
        File("${GameData().docsDir}/prevGameQs.txt")
            .writeAsStringSync("", mode: FileMode.write);
      }
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        if (listen) {
          if (event.y > 1 / sensitivity) {
            onQuestionAnswered(true);
          } else if (event.y < -1 / sensitivity) {
            onQuestionAnswered(false);
          }
        }
      },
      cancelOnError: true,
    );

    countdownToStart();
  }

  void countdownToStart() {
    _timers.add(Timer(const Duration(seconds: 1), () {
      if (timeToStart > 1) {
        setState(() => timeToStart -= 1);
        countdownToStart();
      } else {
        timeToStart = 0;
        runTimer();
        showNextQuestion();
      }
    }));
  }

  void runTimer() {
    _timers.add(Timer(const Duration(seconds: 1), () {
      if (timeLeft > 1) {
        setState(() => timeLeft -= 1);
        runTimer();
      } else {
        // game over

        // show the most recent question at the end of the list
        if (questionsAsked[questionsAsked.length - 1] != currentQuestion) {
          questionsAsked.add(currentQuestion);
          answers.add(false);
        }

        // add shown questions to prevGameQs.txt to prevent being shown again
        String toWrite = "${questionsAsked.join("\n")}\n";
        // create the file if doesn't exist
        if (!File("${GameData().docsDir}/prevGameQs.txt").existsSync()) {
          File("${GameData().docsDir}/prevGameQs.txt").createSync();
        }
        // if 50+ items in prevGameQs.txt, clear the file and start anew. If < 50, append to the file
        FileMode mode = FileMode.append;
        if (File("${GameData().docsDir}/prevGameQs.txt")
                .readAsLinesSync()
                .length >=
            50) {
          mode = FileMode.write;
        }
        File("${GameData().docsDir}/prevGameQs.txt")
            .writeAsStringSync(toWrite, mode: mode);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => GameOverScreen(questionsAsked, answers)),
          (route) => false,
        );
      }
    }));
  }

  void onQuestionAnswered(bool correct) {
    // do nothing if finished the entire question list
    if (_questionsList.isEmpty || timeToStart > 0) {
      return;
    }

    // flash the screen green/red
    setState(() => lastAnswer = correct ? 1 : -1);

    // don't listen for phone rotation to allow the player to reset
    listen = false;
    _timers.add(Timer(Duration(milliseconds: (answerDelay * 1000).toInt()), () {
      showNextQuestion();
    }));

    questionsAsked.add(currentQuestion);
    answers.add(correct);
  }

  void showNextQuestion() {
    setState(() {
      listen = true;
      lastAnswer = 0;
      _questionsList.remove(currentQuestion);
      if (_questionsList.isNotEmpty) {
        currentQuestion =
            _questionsList[Random().nextInt(_questionsList.length)];
      } else {
        currentQuestion = "You finished the entire list for this topic!";
        Timer(
          const Duration(seconds: 3),
          () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => GameOverScreen(questionsAsked, answers)),
            (route) => false,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (lastAnswer == 0)
          ? Colors.amber
          : (lastAnswer == 1)
              ? Colors.green
              : Colors.red,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text(
                (timeToStart == 0) ? currentQuestion : "$timeToStart",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (timeToStart == 0) ? 56 : 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined),
                  Text(
                    timeLeft.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    gyroscopeSubscription.cancel();

    for (Timer timer in _timers) {
      if (timer.isActive) {
        timer.cancel();
      }
    }

    super.dispose();
  }
}
