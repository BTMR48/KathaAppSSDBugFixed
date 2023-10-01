import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:katha/splashScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

import 'Provider/internet_provider.dart';
import 'Provider/sign_in_provider.dart';
import 'Screens/GameScreen/Game/testing/dancing_screen.dart';
import 'Screens/GameScreen/Game/questionAnimation.dart';
import 'Screens/GameScreen/Game/testing/questionPage.dart';
import 'Screens/GameScreen/Game/testing/question_screen.dart';
import 'Screens/ScreenTest/Correct.dart';
import 'Screens/ScreenTest/InCorrect.dart';
import 'Screens/ScreenTest/HowToSpeak.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _jailbroken;
  bool? _developerMode;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_jailbroken == true || _developerMode == true) {
      // Handle jailbroken or developer mode enabled devices
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Jailbroken or Developer mode enabled'),
          ),
          body: Center(
            child: Text('Sorry, this app cannot run on jailbroken or developer mode enabled devices.'),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => SignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => InternetProvider()),
        ),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}