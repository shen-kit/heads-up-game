import 'package:flutter/material.dart';

import 'game_data.dart';
import 'mode_select_screen.dart';

void main() async {
  // ensure widgets are initialised
  WidgetsFlutterBinding.ensureInitialized();

  // load game data (modes, questions, images)
  await GameData().loadGameData();

  // show the mode select screen on startup
  runApp(
    MaterialApp(
      title: 'Hia\'s Up',
      // set the colour scheme
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.amber,
          primary: Colors.lightBlue,
        ),
        useMaterial3: true,
      ),
      home: const ModeSelectScreen(),
    ),
  );
}
