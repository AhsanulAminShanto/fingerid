import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  final String message;
  final String userId;

  const HomePage({super.key, required this.message, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String email = "";
  bool loading = true;

  final String baseUrl = "http://192.168.0.106:5176";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  // ================= FETCH USER FROM API =================
  Future<void> fetchUser() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/api/users/${widget.userId}"),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          name = data["name"] ?? "";
          email = data["email"] ?? "";
          loading = false;
        });
      } else {
        setState(() {
          name = "User not found";
          email = "";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        name = "Error loading user";
        email = "";
        loading = false;
      });
    }
  }

  Future<void> openSmartLink(String appUrl, String webUrl) async {
    final appUri = Uri.parse(appUrl);
    final webUri = Uri.parse(webUrl);

    if (appUrl.isNotEmpty && await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  void goBackToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FingerIDApp()),
    );
  }

  Widget socialTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1e293b),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f172a),

      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color.fromARGB(255, 212, 213, 214),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goBackToLogin(context),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= GREETING =================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $name 👋",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Your Mail: $email",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        socialTile(
                          icon: Icons.work,
                          label: "LinkedIn",
                          color: Colors.blue,
                          onTap: () => openSmartLink(
                            "linkedin://profile/ahsanul-amin-shanto",
                            "https://www.linkedin.com/in/ahsanul-amin-shanto/",
                          ),
                        ),

                        socialTile(
                          icon: Icons.language,
                          label: "Portfolio",
                          color: Colors.green,
                          onTap: () => openSmartLink(
                            "",
                            "https://shantotech.netlify.app/",
                          ),
                        ),

                        socialTile(
                          icon: Icons.code,
                          label: "GitHub",
                          color: Colors.white,
                          onTap: () => openSmartLink("", "https://github.com/"),
                        ),

                        socialTile(
                          icon: Icons.facebook,
                          label: "Facebook",
                          color: Colors.blueAccent,
                          onTap: () =>
                              openSmartLink("", "https://facebook.com"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
