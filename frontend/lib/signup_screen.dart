// Flutter's UI building blocks 
import 'package:flutter/material.dart';

// Our own API helper from earlier
import 'api_service.dart';

// "Stateful" for the data that changes whie user interacts 
// (typed text, loading state, error messages)
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers = handles for reading what the user typed into each field
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Tracks whether we're currently waiting on the backend (to show a spinner)
  bool _isLoading = false;
  // Holds any error or success message to show under the form
  String _message = '';

  // Called when the user taps the Sign Up button
  Future<void> _handleSignup() async {
    // setState tells Flutter "redraw the screen, something changed"
    setState(() {
      _isLoading = true;
      _message = '';
    });

    // Call the backend via our ApiService
    final result = await ApiService.signup(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    // Update UI based on what Django returned
    setState(() {
      _isLoading = false;
      if (result['statusCode'] == 201) {
        _message = 'Account created! Check your email to verify.';
      } else {
        // Show whatever error Django sent back
        _message = 'Signup failed: ${result['body']}';
      }
    });
  }

  // Build = describes what to draw on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar
      appBar: AppBar(title: const Text('Sign Up')),
      // Main content, padded inside from screen edges
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // Column = stack things vertically
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Username input
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            // Password input (obscureText hides the characters)
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // Sign Up button - shows spinner while loading
            ElevatedButton(
              // If loading, disable the button (onPressed: null)
              onPressed: _isLoading ? null : _handleSignup,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up'),
            ),
            const SizedBox(height: 16),
            // Status message (success or error)
            Text(_message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}