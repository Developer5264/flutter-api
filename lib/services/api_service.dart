import 'dart:convert';
import 'dart:io';
import 'package:api_practice/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  final String baseUrl = 'http://192.168.18.186:3000/api/auth';
  // Register user
  Future<Map<String, dynamic>> registerUser(
      String username, String email, String password, String imagePath) async {
    var uri = Uri.parse('$baseUrl/register');
    var request = http.MultipartRequest('POST', uri);
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.files.add(await http.MultipartFile.fromPath(
        'profileImage', imagePath,
        contentType: MediaType('image', 'jpeg') // Set the correct MIME type
        ));

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 201) {
      return jsonDecode(responseData.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  // Login user
  void loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Save token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> updateProfile(
      String username, String? userId, File? imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (userId == null) {
      // Handle case where user ID is not available
      print('User ID not available');
      return;
    }

    var uri = Uri.parse('$baseUrl/update-profile');
    var request = http.MultipartRequest('PUT', uri);

    request.fields['username'] = username;
    request.fields['userId'] = userId; // Use the retrieved user ID

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profileImage', imageFile!.path,
          contentType: MediaType('image', 'jpeg') // Set the correct MIME type
          ));
    }

    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();
    if (response.statusCode == 200) {
      // Handle success
      print('Profile updated successfully');
    } else {
      // Handle error
      print('Failed to update profile');
    }
  }

// Function to fetch the user profile from the backend
  Future<void> fetchUserProfile(BuildContext context, String? token) async {
    var provider = Provider.of<UserProvider>(context, listen: false);

    var uri = Uri.parse('$baseUrl/profile');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Ensure the format is correct
        },
      );

      print('Response status code: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        provider.setUserProfile(
            data['_id'], data['username'], data['email'], data['profileImage']);
      } else {
        print(
            'Error fetching user profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  // Function to load the token from SharedPreferences at startup
  Future<void> loadUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      print("token: $token");
      await fetchUserProfile(context, token);
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
