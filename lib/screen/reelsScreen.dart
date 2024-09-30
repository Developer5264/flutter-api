import 'package:api_practice/services/socket_service.dart';
import 'package:flutter/material.dart';

class RealTimeChatScreen extends StatefulWidget {
  @override
  _RealTimeChatScreenState createState() => _RealTimeChatScreenState();
}

class _RealTimeChatScreenState extends State<RealTimeChatScreen> {
  SocketService _socketService = SocketService();
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _socketService.connect();

    // Listen for messages
    _socketService.socket!.on('receiveMessage', (message) {
      setState(() {
        _messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  // Send message function
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _socketService.sendMessage(_messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
