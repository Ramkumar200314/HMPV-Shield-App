// lib/splash_screen.dart

import 'package:flutter/material.dart';
import 'screens/home_page.dart'; 
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the home screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash.png', // Load your logo image
              width: 400, // Adjust the width as needed
              height: 400, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            Text(
              'Hmpv Shield',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white, // Set text color to white
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
