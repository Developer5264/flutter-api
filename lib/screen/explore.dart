import 'package:api_practice/services/api_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  AuthService _apiService = AuthService(); // Initialize the API service

  // Function to search users by username
  Future<void> _performSearch(String username) async {
    setState(() {
      _isLoading = true;
    });

    // Call the API service to search users
    final users = await _apiService.searchUser(username);

    setState(() {
      _searchResults = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by username',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(
                          _searchController.text); // Call the search function
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9Od1rpx4IGCvwx4TrzAmHLGDF2YRSmsomrIVwC7GvpiegUJ8CC3yHH9pDS3KSB5_ERwU&usqp=CAU"),
                          ),
                          title: Text(user['username']),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
