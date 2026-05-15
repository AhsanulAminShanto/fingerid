import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';
import 'scan_page.dart';

void main() {
  runApp(const FingerIDApp());
}

class FingerIDApp extends StatelessWidget {
  const FingerIDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FingerID System",
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const FingerHomePage(),
    );
  }
}

class FingerHomePage extends StatefulWidget {
  const FingerHomePage({super.key});

  @override
  State<FingerHomePage> createState() => _FingerHomePageState();
}

class _FingerHomePageState extends State<FingerHomePage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final String baseUrl = "http://192.168.0.106:5176";

  String status = "";
  String error = "";
  String? userId;

  bool loading = false;

  // ================= REGISTER =================
  Future<void> register() async {
    setState(() {
      loading = true;
      error = "";
    });

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/users/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameCtrl.text.trim(),
          "email": emailCtrl.text.trim(),
          "deviceId": "mobile_01",
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          userId = data["userId"];
          status = "Registration Successful 🎉";
        });
      } else {
        setState(() {
          error = data.toString();
        });
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  // ================= GO TO SCAN PAGE =================
  void goToLogin() {
    if (userId == null) {
      setState(() {
        error = "Please register first";
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanPage(userId: userId!, baseUrl: baseUrl),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f172a), Color(0xff1e293b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.fingerprint,
                        size: 80,
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "FingerID System",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: loading ? null : register,
                          icon: const Icon(Icons.person_add),
                          label: const Text("Register"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: goToLogin,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text("Login with Fingerprint"),
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (status.isNotEmpty)
                        Text(
                          status,
                          style: const TextStyle(color: Colors.green),
                        ),

                      if (error.isNotEmpty)
                        Text(error, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
