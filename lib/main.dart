import 'package:flutter/material.dart';

import 'components/game_mode_button.dart';
import 'game_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GameData().loadGameData();

  runApp(const ModeSelectScreen());
}

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

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
                children: createGameModeButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
