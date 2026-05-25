// Built-in Dart library for Dart <-> JSON conversion
import 'dart:convert';

// External package for sending HTTP requests (added via `flutter pub add http`)
// 'as http' lets us write http.post() instead of the full path
import 'package:http/http.dart' as http;

// A container class that groups all our backend communication functions
class ApiService {
  // The base URL of the Django backend.
  // static = belongs to the class, no need to create an instance to use it
  // const = value can never change at runtime
  // If the VM IP changes, this is the one line to update.
  static const String baseUrl = 'https://10.0.0.216/api';


  // ====== SIGNUP ======
  // Sends a POST request to /api/signup/ with the user's signup data.
  // Returns a Map with the status code + decoded response body.
  // Future<...> = the result comes back later (network calls are slow)
  // async/await = wait for the slow operation without freezing the app
  // { required ... } = named parameters, must be provided when calling
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    // Send the request and pause here until Django responds
    final response = await http.post(
      // Uri.parse turns a string URL into a Uri object that http.post needs
      Uri.parse('$baseUrl/signup/'),
      // Tells Django the body is JSON (not form data, not plain text)
      headers: {'Content-Type': 'application/json'},
      // Encode: Dart Map -> JSON string (for sending over the wire)
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    // Hand back what the UI needs to react: the HTTP status + the parsed JSON
    return {
      'statusCode': response.statusCode,
      // Decode: JSON string -> Dart Map (so we can read fields easily)
      'body': jsonDecode(response.body),
    };
  }


  // ====== LOGIN ======
  // Same pattern as signup, but with a different endpoint and fewer fields.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
}