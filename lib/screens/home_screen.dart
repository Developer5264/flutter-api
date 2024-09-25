import 'package:api_practice/providers/user_provider.dart';
import 'package:api_practice/screens/update_screen.dart';
import 'package:api_practice/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.loadUser(context);
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored preferences
    Provider.of<UserProvider>(context, listen: false).setAllToNull();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    print(userProvider.email);
    print(userProvider.profileImage);
    print(userProvider.username);
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
            IconButton(
              icon: Icon(Icons.new_label),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen()),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Username: ${userProvider.username ?? ''}'),
              Text('Email: ${userProvider.email ?? ''}'),
              if (userProvider.profileImage != null &&
                  userProvider.profileImage!.isNotEmpty)
                Image.network(
                  "http://192.168.18.186:3000${userProvider.profileImage!}",
                  width: 100,
                  height: 100,
                ),
            ],
          ),
        ));
  }
}
