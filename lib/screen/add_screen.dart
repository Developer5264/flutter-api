import 'dart:io';
import 'package:api_practice/services/api_service.dart';
import 'package:api_practice/services/imagepicker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _imageFile;
  final _authService = AuthService();

  TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(_imageFile!, height: 200),
            TextField(
              controller: captionController,
              decoration: InputDecoration(hintText: 'Write a caption...'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                File _imagefilee = await ImagePickerr().uploadImage('gallery');
                setState(() {
                  _imageFile = _imagefilee;
                });
              },
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.uploadPost(
                    context, _imageFile, captionController);
              },
              child: Text('Upload Post'),
            ),
          ],
        ),
      ),
    );
  }
}
