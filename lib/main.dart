import 'package:api_practice/providers/user_provider.dart';
import 'package:api_practice/screens/home_screen.dart';
import 'package:api_practice/screens/login_screen.dart';
import 'package:api_practice/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // Add your UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data == true) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
