import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures proper initialization
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove Debug Banner
      title: 'HMPV Shield',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
