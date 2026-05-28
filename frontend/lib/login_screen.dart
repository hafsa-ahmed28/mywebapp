import 'package:flutter/material.dart'; //Flutter UI building blocks
import 'api_service.dart'; //backend communication helper

class LoginScreen extends StatefulWidget { //stateful bec text, loading, and mssgs change
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); //reads what user typed in email field
  final _passwordController = TextEditingController(); //reads what user typed in password field

  bool _isLoading = false; 
  String _message = ''; // success or error message shown below the form

  Future<void> _handleLogin() async { //runs when user taps Log In
    setState(() { //tell Flutter to redraw
      _isLoading = true;
      _message = '';
    });

    final result = await ApiService.login( //send credentials to Django
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() { //redraw with the result
      _isLoading = false;
      if (result['statusCode'] == 200) {
        _message = 'Welcome! Login successful.';
      } else {
        _message = 'Login failed: ${result['body']['error'] ?? result['body']}'; // show error Django sent back
      }
    });
  }

  @override
  Widget build(BuildContext context) { //describes what to draw on screen, reruns on every setState
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
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
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, //hides characters as dots
            ),
            const SizedBox(height: 24), // spacing
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin, //disabled while loading
              child: _isLoading
                  ? const CircularProgressIndicator() //spinner while waiting
                  : const Text('Log In'),
            ),
            const SizedBox(height: 16), // spacing
            Text(_message, textAlign: TextAlign.center), //success or error message
          ],
        ),
      ),
    );
  }
}