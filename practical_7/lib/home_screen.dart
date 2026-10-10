import 'package:flutter/material.dart';
import 'second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color cardColor = Colors.blue.shade100;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation & Gestures'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.touch_app,
                size: 70,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome Home!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore navigation and gestures',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Basic navigation using Navigator.push()
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Navigate using push()'),
                ),
              ),

              const SizedBox(height: 12),

              // Navigation using named routes
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },
                  icon: const Icon(Icons.route),
                  label: const Text('Navigate using Named Route'),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Try the gestures below!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Gesture detection
              GestureDetector(
                onTap: () {
                  showMessage('Single tap detected!');
                },
                onDoubleTap: () {
                  setState(() {
                    cardColor = cardColor == Colors.blue.shade100
                        ? Colors.orange.shade200
                        : Colors.blue.shade100;
                  });
                  showMessage('Card colour changed!');
                },
                onLongPress: () {
                  showMessage('Long press detected!');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.touch_app, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Touch Me!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Tap • Double tap • Long press'),
                      SizedBox(height: 8),
                      Text(
                        'The card changes colour on double tap.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}