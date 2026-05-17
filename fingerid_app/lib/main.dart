import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'dart:convert';

import 'storage/user_storage.dart';
import 'home_page.dart';

void main() {
  runApp(const FingerIDApp());
}

class FingerIDApp extends StatelessWidget {
  const FingerIDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FingerHomePage(),
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

  final LocalAuthentication auth = LocalAuthentication();

  final String baseUrl = "http://192.168.0.106:5176";

  String status = "";
  String error = "";
  String? userId;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final id = await UserStorage.getUserId();
    if (id != null) {
      setState(() {
        userId = id;
        status = "Welcome back 👋";
      });
    }
  }

  Future<void> register() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();

    if (name.isEmpty || email.isEmpty) {
      setState(() => error = "Name and Email required");
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/users/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "deviceId": "mobile_01",
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        userId = data["userId"];
        await UserStorage.saveUserId(userId!);

        setState(() {
          status = "Registered Successfully 🎉";
        });
      } else {
        setState(() => error = data.toString());
      }
    } catch (e) {
      setState(() => error = "Server error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // ================= LOGIN =================
  Future<void> loginWithFingerprint() async {
    if (userId == null) {
      setState(() => error = "Please register first");
      return;
    }

    bool authOk = await auth.authenticate(
      localizedReason: "Scan fingerprint to login",
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    if (!authOk) {
      setState(() => error = "Fingerprint failed");
      return;
    }

    final res = await http.post(
      Uri.parse("$baseUrl/api/fingerprint/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "deviceId": "mobile_01"}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      setState(() {
        status = data["message"] ?? "Login Success 🎉";
        error = "";
      });

      // ================= NAVIGATE =================
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            message: data["message"] ?? "Login Successful",
            userId: userId!,
          ),
        ),
      );
    } else {
      setState(() => error = "Login failed");
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.fingerprint, size: 80),
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
                        ),
                      ),

                      TextField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(labelText: "Email"),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: loading ? null : register,
                        child: const Text("Register"),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: loginWithFingerprint,
                        child: const Text("Login with Fingerprint"),
                      ),

                      const SizedBox(height: 20),

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
