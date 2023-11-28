import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class GameModeSettingsScreen extends StatefulWidget {
  final String topic;

  const GameModeSettingsScreen(this.topic, {super.key});

  @override
  State<GameModeSettingsScreen> createState() => _GameModeSettingsScreenState();
}

class _GameModeSettingsScreenState extends State<GameModeSettingsScreen> {
  int _gameDuration = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
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
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      int duration = _gameDuration;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.amber,
                          title: const Text(
                            "Game Duration",
                            textAlign: TextAlign.center,
                          ),
                          content:
                              StatefulBuilder(builder: (context, setState) {
                            return NumberPicker(
                                value: duration,
                                minValue: 30,
                                maxValue: 180,
                                step: 10,
                                haptics: true,
                                itemCount: 7,
                                selectedTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                onChanged: (value) {
                                  setState(() => duration = value);
                                });
                          }),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() => _gameDuration = duration);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.timer_outlined),
                    label: Text("${_gameDuration.toString()}s"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
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
