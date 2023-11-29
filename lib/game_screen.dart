import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heads_up/game_over_page.dart';
import 'package:heads_up/mode_select_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GameScreen extends StatefulWidget {
  final List questions;
  final int gameDuration;

  const GameScreen(this.questions, this.gameDuration, {super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final double sensitivity = 0.75;
  final double answerDelay = 0.75;

  List<String> questionsAsked = [];
  List<bool> answers = [];
  String currentQuestion = "";
  // 0 = default background, -1 = incorrect (red background), 1 = correct (green background)
  int lastAnswer = 0;

  bool listen = true;
  late int timeLeft;
  Timer? _timer1;
  Timer? _timer2;
  late StreamSubscription<dynamic> gyroscopeSubscription;

  @override
  void initState() {
    super.initState();

    timeLeft = widget.gameDuration;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
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

    runTimer();
    showNextQuestion();
  }

  void runTimer() {
    _timer1 = Timer(const Duration(seconds: 1), () {
      if (timeLeft > 1) {
        setState(() => timeLeft -= 1);
        runTimer();
      } else {
        // game over
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => GameOverScreen(questionsAsked, answers)),
          (route) => false,
        );
      }
    });
  }

  void onQuestionAnswered(bool correct) {
    // flash the screen green/red for 2 seconds
    setState(() => lastAnswer = correct ? 1 : -1);

    // don't listen for phone rotation for 2 seconds to allow the player
    // to reset
    listen = false;
    _timer2 = Timer(Duration(milliseconds: (answerDelay * 1000).toInt()), () {
      showNextQuestion();
    });

    questionsAsked.add(currentQuestion);
    answers.add(correct);
  }

  void showNextQuestion() {
    setState(() {
      listen = true;
      lastAnswer = 0;
      currentQuestion =
          widget.questions[Random().nextInt(widget.questions.length)];
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
                currentQuestion,
                style: const TextStyle(
                  fontSize: 56,
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

    if (_timer1 != null && _timer1!.isActive) {
      _timer1!.cancel();
    }
    if (_timer2 != null && _timer2!.isActive) {
      _timer2!.cancel();
    }

    super.dispose();
  }
}
