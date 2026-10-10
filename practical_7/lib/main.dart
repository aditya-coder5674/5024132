import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'second_screen.dart';

void main() {
  runApp(const NavigationGestureApp());
}

class NavigationGestureApp extends StatelessWidget {
  const NavigationGestureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation & Gestures',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E75),
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}
