import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// singleton pattern
class GameData {
  Map<String, dynamic> data = {};
  String docsDir = "";

  GameData._();

  static final GameData _instance = GameData._();

  factory GameData() {
    return _instance;
  }

  Future<GameData> loadGameData() async {
    final String jsonString =
        await rootBundle.loadString("assets/gameData.json");
    data = await json.decode(jsonString);

    docsDir = (await getApplicationDocumentsDirectory()).path;

    return _instance;
  }
}
