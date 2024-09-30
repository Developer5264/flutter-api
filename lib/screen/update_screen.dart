import 'dart:io';
import 'package:api_practice/providers/user_provider.dart';
import 'package:api_practice/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController(); // Email Controller
  final _passwordController = TextEditingController(); // Password Controller
  String? _userId; // Store the user ID

  XFile? _image;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Retrieve user ID on initialization
  }

  Future<void> _getUserId() async {
    setState(() {
      _userId = Provider.of<UserProvider>(context, listen: false).userId;
    });
  }

  Future<void> _pickImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _image != null ? FileImage(File(_image!.path)) : null,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController, // Email input
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController, // Password input
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _authService.updateProfile(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    _userId,
                    _image!.path);
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
