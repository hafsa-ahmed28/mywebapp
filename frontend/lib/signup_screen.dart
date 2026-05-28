import 'package:flutter/material.dart'; //Flutter UI building blocks
import 'api_service.dart'; //backend communication helper

class SignupScreen extends StatefulWidget { //stateful because text, loading, & mssgs change
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController(); //reads what user typed in email field
  final _usernameController = TextEditingController(); //reads what user typed in username field
  final _passwordController = TextEditingController(); //reads what user typed in password field

  bool _isLoading = false; //true while waiting for Django to respond
  String _message = ''; //success or error message shown below the form

  Future<void> _handleSignup() async { //runs when user taps Sign Up
    setState(() { //tell Flutter to redraw
      _isLoading = true;
      _message = '';
    });

    final result = await ApiService.signup( //send data to Django
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    setState(() { //redraw with the result
      _isLoading = false;
      if (result['statusCode'] == 201) {
        _message = 'Account created! Check your email to verify.';
      } else {
        _message = 'Signup failed: ${result['body']['error'] ?? result['body']}';
      }
    });
  }

  @override
  Widget build(BuildContext context) { //describes what to draw on screen, reruns on every setState
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0), //space around edges so content doesn't touch screen border
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16), //spacing
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16), //spacing
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, //hides characters as dots
            ),
            const SizedBox(height: 24), // spacing
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSignup, //disabled while loading
              child: _isLoading
                  ? const CircularProgressIndicator() //spinner while waiting
                  : const Text('Sign Up'),
            ),
            const SizedBox(height: 16), // spacing
            Text(_message, textAlign: TextAlign.center), //success or error message
          ],
        ),
      ),
    );
  }
}