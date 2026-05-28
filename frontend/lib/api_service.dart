import 'dart:convert'; //converts between JSON text and Dart objects
import 'package:http/http.dart' as http; //for sending HTTP requests

class ApiService { //groups all backend communication in one place
  static const String baseUrl = 'https://10.0.0.216/api'; 


  // SIGNUP
  static Future<Map<String, dynamic>> signup({ 
    required String email,
    required String username,
    required String password,
  }) async { // this function has waiting in it
    try {
      final response = await http.post( //await = pause here until Django responds
        Uri.parse('$baseUrl/signup/'), //Uri.parse converts the string URL into a format http.post needs
        headers: {'Content-Type': 'application/json'}, //tells Django the body is JSON
        body: jsonEncode({ //jsonEncode converts Dart map to JSON string for sending
          'email': email,
          'username': username,
          'password': password,
        }),
      );
      return {
        'statusCode': response.statusCode, //the HTTP status code Django returned (201, 400 etc)
        'body': jsonDecode(response.body), //jsonDecode converts JSON string back to Dart map
      };
    } catch (e) {
      return {'statusCode': 0, 'body': {'error': 'Could not connect to server'}}; // network/server error
    }
  }


  // LOGIN - same pattern as signup, different endpoint, fewer fields
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
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
    } catch (e) {
      return {'statusCode': 0, 'body': {'error': 'Could not connect to server'}}; // network error or server is down
    }
  }
}