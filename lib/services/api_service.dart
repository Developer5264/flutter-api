import 'dart:convert';
import 'dart:io';
import 'package:api_practice/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  final String baseUrl = 'http://192.168.18.27:3000/api/auth';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "314831392071-cso4l5ffmo0jpanta3o0lvrlkdorhhg7.apps.googleusercontent.com");

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

  Future<void> updateProfile(String username, String email, String password,
      String? userId, String imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (userId == null) {
      print('User ID not available');
      return;
    }

    var uri = Uri.parse('$baseUrl/update-profile');
    var request = http.MultipartRequest('PUT', uri);

    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password; // Add password field
    request.fields['userId'] = userId;

    request.files.add(await http.MultipartFile.fromPath(
        'profileImage', imageFile,
        contentType: MediaType('image', 'jpeg')));

    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile');
      print(response.statusCode.toString());
    }
  }

  // Custom Login user
  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print("Login Status: ${response.statusCode}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Save token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await fetchUserProfile(context, data['token']);

      print("Here is the token: ${data['token']}");
    } else {
      throw Exception('Failed to login');
    }
  }

// Google Login user

  Future<void> googleSignIn(
    BuildContext context,
  ) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      print("googleUser: $googleUser");
      print("accessToken: $accessToken");
      print("idToken: $idToken");

      if (idToken != null) {
        // Send the ID token to your backend for verification and further processing
        final response = await http.post(
          Uri.parse('$baseUrl/auth/google-signin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'idToken':
                idToken, // Ensure this is the ID token from Google sign-in
          }),
        );

        if (response.statusCode == 200) {
          // Handle success (e.g., navigate to home screen)
          var data = jsonDecode(response.body);
          // Save token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          print("Here is the token: ${data['token']}");

          await fetchUserProfile(context, data['token']);
        } else {
          // Handle error
          print('Error');
        }
      }
    } catch (error) {
      print("Exception: $error");
    }
  }

// Function to fetch the user profile from the backend
  Future<void> fetchUserProfile(BuildContext context, String? token) async {
    var provider = Provider.of<UserProvider>(context, listen: false);
    print("Given Token: $token");
    var uri = Uri.parse('$baseUrl/profile');
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Ensure the format is correct
        },
      );

      print(
          'Response status code for fetchUserProfile: ${response.statusCode}'); // Debug log

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

  Future<void> uploadPost(BuildContext context, File? image,
      TextEditingController captionController) async {
    var provider = Provider.of<UserProvider>(context, listen: false);

    if (image == null) return;

    String? userId = provider.userId;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload-post'),
    );
    request.fields['userId'] = userId ?? '';
    request.fields['caption'] = captionController.text;
    request.files.add(await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType('image', 'jpeg')));

    var response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post uploaded successfully')));
    } else {
      print(response.statusCode);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload post')));
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  } // Function to search users by username

  Future<List<dynamic>> searchUser(String username) async {
    final apiUrl = '$baseUrl/search-user?username=$username';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Return the list of users
        return json.decode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/get-all-posts'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Returns the list of posts
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
