import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    required dynamic icon,
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
            // support both built-in IconData and FontAwesome icons
            icon is IconData
                ? Icon(icon, color: color, size: 40)
                : FaIcon(icon, color: color, size: 40),
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
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 48, 83, 119),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                        // ================= CORE SOCIAL =================
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

                        // ================= MESSAGING =================
                        socialTile(
                          icon: Icons.chat,
                          label: "WhatsApp",
                          color: Colors.green,
                          onTap: () => openSmartLink(
                            "whatsapp://send?text=Hello",
                            "https://wa.me/",
                          ),
                        ),

                        socialTile(
                          icon: Icons.camera_alt,
                          label: "Instagram",
                          color: Colors.pink,
                          onTap: () => openSmartLink(
                            "instagram://user",
                            "https://www.instagram.com/",
                          ),
                        ),

                        socialTile(
                          icon: Icons.alternate_email,
                          label: "X (Twitter)",
                          color: Colors.black,
                          onTap: () => openSmartLink(
                            "twitter://",
                            "https://twitter.com",
                          ),
                        ),

                        // ================= PROFESSIONAL =================
                        socialTile(
                          icon: Icons.video_library,
                          label: "YouTube",
                          color: Colors.red,
                          onTap: () => openSmartLink(
                            "youtube://",
                            "https://youtube.com",
                          ),
                        ),

                        socialTile(
                          icon: Icons.telegram,
                          label: "Telegram",
                          color: Colors.lightBlue,
                          onTap: () => openSmartLink(
                            "tg://resolve",
                            "https://telegram.org",
                          ),
                        ),

                        socialTile(
                          icon: Icons.discord,
                          label: "Discord",
                          color: Colors.indigo,
                          onTap: () => openSmartLink(
                            "discord://",
                            "https://discord.com",
                          ),
                        ),

                        // ================= DEV =================
                        socialTile(
                          icon: Icons.flutter_dash,
                          label: "Stack Overflow",
                          color: Colors.orange,
                          onTap: () =>
                              openSmartLink("", "https://stackoverflow.com"),
                        ),

                        // ================= GLOBAL =================
                        // socialTile(
                        //   icon: Icons.music_note,
                        //   label: "TikTok",
                        //   color: Colors.black,
                        //   onTap: () => openSmartLink(
                        //     "tiktok://",
                        //     "https://www.tiktok.com",
                        //   ),
                        // ),
                        socialTile(
                          icon: Icons.public,
                          label: "Reddit",
                          color: Colors.orangeAccent,
                          onTap: () => openSmartLink("", "https://reddit.com"),
                        ),

                        socialTile(
                          icon: Icons.snapchat,
                          label: "Snapchat",
                          color: Colors.yellow,
                          onTap: () => openSmartLink(
                            "snapchat://",
                            "https://snapchat.com",
                          ),
                        ),

                        socialTile(
                          icon: FontAwesomeIcons.pinterest,
                          label: "Pinterest",
                          color: Colors.redAccent,
                          onTap: () =>
                              openSmartLink("", "https://pinterest.com"),
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
