import 'package:flutter/material.dart';
import 'package:hias_up/game_mode_settings_screen.dart';

class GameModeButton extends StatelessWidget {
  final String label;
  final String? backgroundImageName;

  const GameModeButton(this.label, {this.backgroundImageName, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameModeSettingsScreen(label),
          ),
        );
      },
      clipBehavior: Clip.antiAlias,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(0),
      ),
      child: Ink.image(
        image: backgroundImageName != null
            ? AssetImage("assets/gameModeBackgrounds/$backgroundImageName")
            : const AssetImage(""),
        // darken the image to make the text more readable
        colorFilter: ColorFilter.mode(
          Colors.black.withOpacity(0.4),
          BlendMode.darken,
        ),
        fit: BoxFit.cover,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24, shadows: [
              Shadow(
                blurRadius: 8,
                color: Colors.purple,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
