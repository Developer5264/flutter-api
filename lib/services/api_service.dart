import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  final String baseUrl = 'http://192.168.18.27:3000/api/auth';

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
  loginUser(String email, String password) async {
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

  // Logout user
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // Get stored token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
