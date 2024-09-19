import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
      print(prefs.getString('userId'));
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

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (_userId == null) {
      // Handle case where user ID is not available
      print('User ID not available');
      return;
    }

    var uri = Uri.parse('http://192.168.18.27:3000/api/auth/update-profile');
    var request = http.MultipartRequest('PUT', uri);

    request.fields['username'] = _usernameController.text;
    request.fields['userId'] = _userId!; // Use the retrieved user ID

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profileImage', _imageFile!.path,
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
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
