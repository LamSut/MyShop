import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Loading...',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
