import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _username;
  String? _email;
  String? _profileImage;

  // Getter methods for user details
  String? get token => _token;
  String? get username => _username;
  String? get email => _email;
  String? get profileImage => _profileImage;

  // Function to load the token from SharedPreferences at startup
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      await fetchUserProfile();
    }
  }

// Function to fetch the user profile from the backend
  Future<void> fetchUserProfile() async {
    final url = Uri.parse(
        'http://192.168.18.27:3000/api/auth/profile'); // Replace with your actual URL
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token', // Ensure the format is correct
        },
      );

      print('Response status code: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _username = data['username'];
        _email = data['email'];
        _profileImage = data['profileImage'];
        notifyListeners();
      } else {
        print(
            'Error fetching user profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
}
