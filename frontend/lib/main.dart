// Flutter's UI building blocks
import 'package:flutter/material.dart';

// Our two screens
import 'signup_screen.dart';
import 'login_screen.dart';

// runApp is the entry point - it's the first thing Flutter calls
void main() {
  runApp(const MyApp());
}

// Top-level app widget. Stateless because the app itself doesn't change.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TriSpects Auth',
      // Theme = colors, fonts, shapes used across the whole app
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // The first screen the user sees
      home: const HomeScreen(),
    );
  }
}

// Landing screen with two buttons: Sign Up and Log In
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TriSpects')),
      body: Center(
        // Stack the welcome text + buttons vertically, centered on screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign up or log in to continue',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Sign Up button — Navigator.push opens a new screen on top
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 12),
            // Log In button — same pattern, different destination
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}