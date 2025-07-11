import 'package:flutter/material.dart';
import 'package:roulette_predictor_app/main.dart'; // Import your main app screen
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
		backgroundColor: Colors.black,
		body: Center(
		  child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: const [
			  Image(
				image: AssetImage('images/RouletteAIPredictor_main.png'),
				width: 200, // Adjust size as needed
			  ),
			  SizedBox(height: 24),
			  CircularProgressIndicator(
				valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
			  ),
			],
		  ),
		),
	  );
	}
}
