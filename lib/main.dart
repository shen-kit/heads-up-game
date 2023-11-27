import 'package:flutter/material.dart';

import 'components/game_mode_button.dart';

void main() => runApp(const ModeSelectScreen());

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hia\'s Up',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.amber,
          primary: Colors.lightBlue,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hia's Up!"),
          titleTextStyle: const TextStyle(
            fontFamily: "MarkerFelt",
            fontSize: 35,
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[700],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pick a topic...",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                  fontFamily: "MarkerFelt",
                  height: 2.5,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2,
                children: const [
                  GameModeButton(
                    "Star Wars IV-VI",
                    backgroundImageName: "star wars.jpg",
                  ),
                  GameModeButton(
                    "The Clone Wars",
                    backgroundImageName: "clone wars.jpg",
                  ),
                  GameModeButton(
                    "LOTR",
                    backgroundImageName: "lotr.jpg",
                  ),
                  GameModeButton(
                    "Trivia",
                    backgroundImageName: "trivia.jpg",
                  ),
                  GameModeButton(
                    "Asian Food",
                    backgroundImageName: "food1.jpeg",
                  ),
                  GameModeButton(
                    "Western Food",
                    backgroundImageName: "food2.jpg",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
