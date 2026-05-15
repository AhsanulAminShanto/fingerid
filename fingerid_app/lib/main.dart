import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  final auth = LocalAuthentication();

  final String baseUrl = "http://192.168.0.106:5176";

  String status = "";
  String loginError = "";
  String? userId;

  Future<void> register() async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "deviceId": "mobile_01",
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      setState(() {
        userId = data["userId"];
        status = "Registered Successfully";
      });
    } else {
      setState(() {
        status = "Register Failed: ${res.body}";
      });
    }
  }

  Future<void> login() async {
    if (userId == null) {
      setState(() => loginError = "Please register first");
      return;
    }

    bool success = await auth.authenticate(
      localizedReason: "Verify fingerprint",
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    if (!success) {
      setState(() => loginError = "Fingerprint failed");
      return;
    }

    final res = await http.post(
      Uri.parse("$baseUrl/api/fingerprint/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "deviceId": "mobile_01"}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(message: data["message"], userId: data["userId"]),
        ),
      );
    } else {
      setState(() {
        loginError = res.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FingerID Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl),
            TextField(controller: emailCtrl),

            ElevatedButton(onPressed: register, child: const Text("Register")),

            ElevatedButton(onPressed: login, child: const Text("Login")),

            Text("STATUS: $status"),

            if (loginError.isNotEmpty)
              Text(loginError, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
