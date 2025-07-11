import 'package:flutter/material.dart';
import 'package:Roulette_AI_Predictor/main.dart'; // Import your main app screen
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {}); // Simulate loading time
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoulettePredictorScreen()),
      );
    }
  }

  @override
	Widget build(BuildContext context) {
	  return Scaffold(
		body: Stack(
		  fit: StackFit.expand,
		  children: [
			Image.asset(
			  'images/RouletteAIPredictor_main.png',
			  fit: BoxFit.cover, // This makes the image fill the screen
			),
			Center(
			  child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: const [
				  CircularProgressIndicator(
					valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
				  ),
				],
			  ),
			),
		  ],
		),
	  );
	}
}
