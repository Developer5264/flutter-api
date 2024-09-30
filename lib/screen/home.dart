import 'dart:convert';
import 'package:api_practice/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];
  final AuthService apiService = AuthService(); // Instantiate ApiService

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      List<dynamic> fetchedPosts = await apiService.fetchPosts();
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      // Handle the error appropriately here
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostTile(
                  timeAgo: post['createdAt'],
                  postImage: post['imageUrl'],
                  caption: post['caption'],
                );
              },
            ),
    );
  }
}

class PostTile extends StatelessWidget {
  final String timeAgo;
  final String postImage;
  final String caption;

  PostTile({
    required this.timeAgo,
    required this.postImage,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatTimeAgo(timeAgo),
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Image.network('http://192.168.18.27:3000' +
              postImage), // Display the post image
          SizedBox(height: 10),
          Text(caption),
          Divider(),
        ],
      ),
    );
  }

  // Utility function to format time (simplified for now)
  String _formatTimeAgo(String timestamp) {
    DateTime postTime = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
