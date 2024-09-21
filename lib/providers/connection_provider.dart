import 'dart:convert';
import 'dart:io';
import 'package:chat_app/models/payload.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagesProvider = StateNotifierProvider<MessagesNotifier, List<Message>>((ref) {
  return MessagesNotifier();
});

class MessagesNotifier extends StateNotifier<List<Message>> {
  MessagesNotifier() : super([]);

  void addMessage(String message) {
    Map<String, dynamic> decoded = jsonDecode(message);
    final msg = Message.fromJson(decoded);
    state = [...state, msg];
  }
}

final tcpConnectionProvider = StateNotifierProvider<TcpConnectionNotifier, Socket?>((ref) {
  return TcpConnectionNotifier(ref: ref);
});

class TcpConnectionNotifier extends StateNotifier<Socket?> {
  final StateNotifierProviderRef ref;
  TcpConnectionNotifier({required this.ref}) : super(null);

  // Method to initiate the connection and listen for incoming data
  Future<void> connect(String destinationIP, int port) async {
    try {
      final socket = await Socket.connect(destinationIP, port);
      state = socket;
      print('Connected to $destinationIP on port $port!');

      // Listen to incoming messages from the peer
      socket.listen(
            (List<int> data) {
          final message = String.fromCharCodes(data);
          print('Received message: $message');
          ref.read(messagesProvider.notifier).addMessage(message);
          // You can add further logic here to handle the message (e.g., parse it into a Payload)
        },
        onDone: () {
          print('Connection closed by peer.');
          disconnect();
        },
        onError: (error) {
          print('Connection error: $error');
          disconnect();
        },
      );
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  // Method to send data over the connection
  void sendMessage(String message, String uuid) {
    if (state != null) {
      final msg = Message(message: message, uuid: uuid, ip: state!.address.address, port: state!.port);
      state!.write(jsonEncode(msg.toJson()));
      print('Sent message: $message');
    } else {
      print('No active connection.');
    }
  }

  // Method to disconnect the socket
  void disconnect() {
    if (state != null) {
      state!.destroy();
      state = null;
      print('Disconnected from the peer.');
    }
  }
}

final tcpListenerProvider = StateNotifierProvider<TcpListenerNotifier, ServerSocket?>((ref) {
  return TcpListenerNotifier(ref: ref);
});

class TcpListenerNotifier extends StateNotifier<ServerSocket?> {
  final StateNotifierProviderRef ref;
  TcpListenerNotifier({required this.ref}) : super(null);

  // Method to start listening for incoming connections
  Future<void> startListening(int port) async {
    try {
      final serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port, shared: true);
      state = serverSocket;
      print('Listening on port $port...');

      // Listen to incoming connections
      serverSocket.listen(
            (Socket socket) {
          print('Connection from ${socket.remoteAddress.address}:${socket.remotePort}');
          ref.read(tcpConnectionProvider.notifier).state = socket;

          // Listen to incoming messages from the peer
          socket.listen(
                (List<int> data) {
              final message = String.fromCharCodes(data);
              print('Received message: $message');
              ref.read(messagesProvider.notifier).addMessage(message);
            },
            onDone: () {
              print('Connection closed by peer.');
              ref.read(tcpConnectionProvider.notifier).disconnect();
            },
            onError: (error) {
              print('Connection error: $error');
              ref.read(tcpConnectionProvider.notifier).disconnect();
            },
          );
        },
        onError: (error) {
          print('Failed to listen: $error');
        },
      );
    } catch (e) {
      print('Failed to bind: $e');
    }
  }

  // Method to stop listening for incoming connections
  void stopListening() {
    if (state != null) {
      state!.close();
      state = null;
      print('Stopped listening.');
    }
  }
}
