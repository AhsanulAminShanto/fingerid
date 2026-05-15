import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart'; // 👈 important (to go back to login page)

class HomePage extends StatelessWidget {
  final String message;
  final String userId;

  const HomePage({super.key, required this.message, required this.userId});

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not open $url";
    }
  }

  // ================= BACK TO LOGIN =================
  void goBackToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FingerIDApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xff1e293b),

        // ✅ BACK BUTTON
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goBackToLogin(context),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f172a), Color(0xff1e293b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, size: 80, color: Colors.green),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("User ID: $userId"),

                  const Divider(height: 30),

                  const Text(
                    "Connect with me",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: () => openUrl(
                      "https://www.linkedin.com/in/ahsanul-amin-shanto/",
                    ),
                    icon: const Icon(Icons.work),
                    label: const Text("LinkedIn Profile"),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: () => openUrl("https://shantotech.netlify.app/"),
                    icon: const Icon(Icons.language),
                    label: const Text("Portfolio Website"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
