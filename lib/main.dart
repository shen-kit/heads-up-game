import 'package:flutter/material.dart';

import 'game_data.dart';
import 'mode_select_screen.dart';

void main() async {
  // ensure widgets are initialised
  WidgetsFlutterBinding.ensureInitialized();

  // load game data (modes, questions, images)
  await GameData().loadGameData();

  // show the mode select screen on startup
  runApp(const ModeSelectScreen());
}
