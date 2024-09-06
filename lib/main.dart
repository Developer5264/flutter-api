import 'package:api_practice/screens/home_screen.dart';
import 'package:api_practice/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<Widget>(
        future: _determineHomePage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            // Log the error and display a user-friendly message
            print('Error determining home page: ${snapshot.error}');
            return Center(child: Text('Error determining home page.'));
          } else {
            return Center(child: Text('Unexpected state.'));
          }
        },
      ),
    );
  }

  Future<Widget> _determineHomePage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        // Token exists, navigate to the home screen
        return HomeScreen();
      } else {
        // No token, navigate to the login screen
        return LoginScreen();
      }
    } catch (e) {
      // Log the error for debugging
      print('Exception in _determineHomePage: $e');
      throw e; // Rethrow the exception to be caught in the FutureBuilder
    }
  }
}
