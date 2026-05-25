// Flutter's UI building blocks
import 'package:flutter/material.dart';

// Our backend communication helper
import 'api_service.dart';

// Stateful because text input, loading, and messages all change over time
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Handles for reading what the user typed
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Track loading state to show a spinner during the network call
  bool _isLoading = false;
  // Status message shown below the form
  String _message = '';

  // Runs when user taps the Log In button
  Future<void> _handleLogin() async {
    // Tell Flutter to redraw with the loading state
    setState(() {
      _isLoading = true;
      _message = '';
    });

    // Send credentials to Django
    final result = await ApiService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Redraw with the result
    setState(() {
      _isLoading = false;
      if (result['statusCode'] == 200) {
        _message = 'Welcome! Login successful.';
      } else {
        // Django sends back { "error": "..." } - pull out the error text
        _message = 'Login failed: ${result['body']['error'] ?? result['body']}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password field (obscured)
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // Log In button — disabled while loading
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Log In'),
            ),
            const SizedBox(height: 16),
            // Success or error message
            Text(_message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}