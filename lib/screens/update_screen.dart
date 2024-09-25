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
  File? _imageFile;
  String? _userId; // Store the user ID

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getUserId(); // Retrieve user ID on initialization
  }

  Future<void> _getUserId() async {
    setState(() {
      _userId = Provider.of<UserProvider>(context, listen: false).userId;
      print(Provider.of<UserProvider>(context, listen: false).userId);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _authService.updateProfile(
                    _usernameController.text, _userId, _imageFile);
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
