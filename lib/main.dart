import 'package:flutter/material.dart';
import 'splshscrn.dart';
import 'wecme.dart';
import 'signin.dart';
import 'creteac.dart';
import 'homescreen.dart';
void main() {
  runApp(const TaskifyApp());
}

class TaskifyApp extends StatelessWidget {
  const TaskifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskify',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Start from Splash
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/sign in': (context) => const SignInScreen(),
        '/create account': (context) => const CreateAccountScreen(),
        '/homepage': (context) => const HomeScreen(),
      },
    );
  }
}
