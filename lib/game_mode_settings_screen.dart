import 'package:flutter/material.dart';

class GameModeSettingsScreen extends StatelessWidget {
  final String topic;

  const GameModeSettingsScreen(this.topic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
        titleTextStyle: const TextStyle(
          fontFamily: "MarkerFelt",
          fontSize: 35,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "When you're ready, press \"Start\" and turn your phone sideways.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 64),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Start!",
                        style: TextStyle(
                          fontSize: 42,
                          fontFamily: "MarkerFelt",
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[500],
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                "Back",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
