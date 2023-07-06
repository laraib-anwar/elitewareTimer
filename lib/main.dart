import 'dart:async';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isTimerMode = true;
  Duration timerDuration = Duration(hours: 0, minutes: 0, seconds: 0);
  Duration elapsedTime = Duration();

  bool isRunning = false;
  bool isPaused = false;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
  }

  void start() {
    startTime = DateTime.now().subtract(elapsedTime);
    isRunning = true;
    isPaused = false;
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        elapsedTime = DateTime.now().difference(startTime);
      });
    });
  }

  void reset() {
    setState(() {
      isRunning = false;
      isPaused = false;
      elapsedTime = Duration();
    });
  }

  void toggleMode() {
    setState(() {
      isTimerMode = !isTimerMode;
    });
  }

  void setTimer(Duration duration) {
    setState(() {
      timerDuration = duration;
    });
  }

  void stop() {
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void popup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timer Expired'),
          content: Text('The timer has reached 00:00:00.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours.remainder(60));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer/Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isTimerMode ? 'Timer Mode' : 'Stopwatch Mode',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              isTimerMode
                  ? formatDuration(timerDuration)
                  : formatDuration(elapsedTime),
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isRunning) {
                      stop();
                    } else {
                      start();
                    }
                  },
                  child: Text(
                    isRunning ? 'Stop' : 'Start',
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isRunning ? null : reset,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleMode,
              child:
                  Text(isTimerMode ? 'Switch to Stopwatch' : 'Switch to Timer'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimerScreen(),
  ));
}
