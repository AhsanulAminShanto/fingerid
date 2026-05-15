import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String message;
  final String userId;

  const HomePage({super.key, required this.message, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("User ID: $userId"),
          ],
        ),
      ),
    );
  }
}
