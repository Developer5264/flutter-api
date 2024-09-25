import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _username;
  String? _email;
  String? _profileImage;

  // Getter methods for user details
  String? get username => _username;
  String? get userId => _userId;
  String? get email => _email;
  String? get profileImage => _profileImage;

  void setUserProfile(
      String? userId, String? username, String? email, String? profileImage) {
    _userId = userId;
    _username = username;
    _email = email;
    _profileImage = profileImage;
    notifyListeners();
  }

  void setAllToNull() {
    _userId = null;
    _username = null;
    _email = null;
    _profileImage = null;
    notifyListeners();
  }
}
