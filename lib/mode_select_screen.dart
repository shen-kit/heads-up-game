import 'package:flutter/material.dart';

import 'components/game_mode_button.dart';
import 'game_data.dart';

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  // generate a list of buttons for the user to select a game mode to play
  List<GameModeButton> createGameModeButtons() {
    return GameData()
        .data
        .keys
        .map((key) => GameModeButton(
              key,
              backgroundImageName: GameData().data[key]["background_image"],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hia's Up!"),
        titleTextStyle: const TextStyle(
          fontFamily: "MarkerFelt",
          fontSize: 35,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
      ),
      // scrollable widget containing all the game modes
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // physics: AlwaysScrollableScrollPhysics(),
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
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: createGameModeButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
