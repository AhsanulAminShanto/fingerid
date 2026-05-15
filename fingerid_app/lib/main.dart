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
  final auth = LocalAuthentication();

  final String baseUrl = "http://192.168.0.106:5176";

  String status = "";
  String loginError = "";
  String? userId;

  bool loading = false;

  // ================= REGISTER =================
  Future<void> register() async {
    setState(() => loading = true);

    final res = await http.post(
      Uri.parse("$baseUrl/api/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "deviceId": "mobile_01",
      }),
    );

    setState(() => loading = false);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      setState(() {
        userId = data["userId"];
        status = "Registration Successful 🎉";
        loginError = "";
      });
    } else {
      setState(() {
        status = "";
        loginError = res.body;
      });
    }
  }

  // ================= LOGIN =================
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
      setState(() => loginError = "Fingerprint authentication failed");
      return;
    }

    final res = await http.post(
      Uri.parse("$baseUrl/api/fingerprint/verify"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "deviceId": "mobile_01"}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      Navigator.pushReplacement(
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
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.fingerprint,
                        size: 70,
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "FingerID Login System",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                          onPressed: login,
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

                      if (loginError.isNotEmpty)
                        Text(
                          loginError,
                          style: const TextStyle(color: Colors.red),
                        ),
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
