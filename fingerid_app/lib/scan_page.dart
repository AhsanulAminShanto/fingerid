import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class ScanPage extends StatefulWidget {
  final String userId;
  final String baseUrl;

  const ScanPage({super.key, required this.userId, required this.baseUrl});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final auth = LocalAuthentication();

  String status = "Tap scan to continue";

  Future<void> scanAndVerify() async {
    try {
      bool success = await auth.authenticate(
        localizedReason: "Scan fingerprint",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!success) {
        setState(() => status = "Fingerprint failed");
        return;
      }

      final res = await http.post(
        Uri.parse("${widget.baseUrl}/api/fingerprint/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId, "deviceId": "mobile_01"}),
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
          status = "❌ Not registered or fingerprint mismatch";
        });
      }
    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 80, color: Colors.blue),

              const SizedBox(height: 20),

              Text(status, textAlign: TextAlign.center),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: scanAndVerify,
                child: const Text("Start Scan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
