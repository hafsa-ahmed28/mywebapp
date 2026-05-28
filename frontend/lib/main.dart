import 'package:flutter/material.dart'; //Flutter UI building blocks
import 'signup_screen.dart'; //signup screen
import 'login_screen.dart'; //login screen

void main() { //entry point, first thing Flutter runs
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //stateless bec the app shell never changes
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWebApp',
      debugShowCheckedModeBanner: false, //hides the debug banner in the top corner
      theme: ThemeData(
        primarySwatch: Colors.blue, //sets the color theme across the whole app
        useMaterial3: true,
      ),
      home: const HomeScreen(), //first screen the user sees
    );
  }
}

class HomeScreen extends StatelessWidget { //stateless because nothing on this screen changes
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyWebApp')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //centers everything vertically
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), //spacing
            const Text(
              'Sign up or log in to continue',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40), //spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()), //opens signup screen on top
                );
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 12), //spacing
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()), //opens login screen on top
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