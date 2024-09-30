import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  // Initialize the socket connection
  void connect() {
    socket = IO.io('http://192.168.18.27:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to the server
    socket!.connect();

    // Handle successful connection
    socket!.on('connect', (_) {
      print('Connected to WebSocket server with id: ${socket!.id}');
    });

    // Listen for incoming messages
    socket!.on('receiveMessage', (message) {
      print('Message received: $message');
    });

    // Handle disconnection
    socket!.on('disconnect', (_) {
      print('Disconnected from WebSocket server');
    });
  }

  // Function to send messages
  void sendMessage(String message) {
    socket!.emit('sendMessage', message);
  }

  // Disconnect from the server
  void disconnect() {
    socket!.disconnect();
  }
}
