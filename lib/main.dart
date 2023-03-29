import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pop It!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: background,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool hasAmplitudeControl = false;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _checkAmplitudeControl();
    super.initState();
  }

  _checkAmplitudeControl() async {
    hasAmplitudeControl = await Vibration.hasAmplitudeControl() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 7; i++)
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 7; j++)
                              Container(
                                  color: bubbleColors[i],
                                  child: Bubble(colorIndex: i))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 7; j++)
                              Container(
                                  color: bubbleColors[i],
                                  child: Bubble(colorIndex: i))
                          ]),
                    ],
                  )
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  splashRadius: 16,
                  tooltip: "Say Hi!",
                  onPressed: () async {
                    var url = "https://vanshika237.github.io/";
                    try {
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw "Could not launch $url";
                      }
                      // ignore: empty_catches
                    } catch (e) {}
                  },
                  icon: Icon(Icons.waving_hand_outlined,
                      color: Colors.white.withOpacity(0.5))),
            ),
          ],
        ));
  }
}

class Bubble extends StatefulWidget {
  final int colorIndex;
  const Bubble({super.key, required this.colorIndex});

  @override
  BubbleState createState() => BubbleState();
}

class BubbleState extends State<Bubble> {
  bool compress = false;

  _reset() {
    Timer(const Duration(seconds: 7), () {
      compress = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (!compress) {
          Vibration.vibrate(amplitude: 1, duration: 30);
          compress = true;
          if (mounted) {
            setState(() {});
          }
          _reset();
        }
      },
      child: Material(
        elevation: compress ? 0 : 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: compress ? darkShadow : lightShadows[widget.colorIndex],
                offset: const Offset(-6.0, -6.0),
                blurRadius: 12.0,
              ),
              BoxShadow(
                color: compress ? lightShadows[widget.colorIndex] : darkShadow,
                offset: const Offset(6.0, 6.0),
                blurRadius: 12.0,
              ),
            ],
            color: bubbleColors[widget.colorIndex],
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

Color background = Colors.black45;
Color darkShadow = Colors.black.withOpacity(0.1);

List<Color> lightShadows = [
  Colors.red.shade300,
  Colors.orange.shade300,
  Colors.yellow.shade300,
  Colors.green.shade300,
  Colors.blue.shade300,
  Colors.deepPurple.shade300,
  Colors.purple.shade300
];

List<Color> bubbleColors = [
  Colors.red.shade400,
  Colors.orange.shade400,
  Colors.yellow.shade400,
  Colors.green.shade400,
  Colors.blue.shade400,
  Colors.deepPurple.shade400,
  Colors.purple.shade400
];
