import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

class PersonalBankingPage extends StatelessWidget {
  const PersonalBankingPage({super.key});

  // ================= OPEN BANK APP =================
  Future<void> openBank({
    required String packageName,
    required String webUrl,
  }) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: packageName,
        category: 'android.intent.category.LAUNCHER',
      );

      await intent.launch();
    } catch (e) {
      // fallback to web if app not found
      final uri = Uri.parse(webUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ================= TILE WIDGET =================
  Widget bankTile({
    required String name,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1e293b),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
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
        title: const Text(
          "Personal Banking",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff1e293b),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            // ================= CELLFIN (IBBL) =================
            bankTile(
              name: "Cellfin",
              subtitle: "IBBL Banking",
              icon: Icons.account_balance,
              color: Colors.blue,
              onTap: () => openBank(
                packageName: "com.dutchbanglabank.cellfin",
                webUrl: "https://www.dutchbanglabank.com",
              ),
            ),

            // ================= BKASH =================
            bankTile(
              name: "bKash",
              subtitle: "Mobile Banking",
              icon: Icons.payment,
              color: Colors.pink,
              onTap: () => openBank(
                packageName: "com.bKash.customerapp",
                webUrl: "https://www.bkash.com",
              ),
            ),

            // ================= NAGAD =================
            bankTile(
              name: "Nagad",
              subtitle: "Digital Wallet",
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
              onTap: () => openBank(
                packageName: "com.konasl.nagad",
                webUrl: "https://nagad.com.bd",
              ),
            ),

            // ================= ROCKET (DBBL) =================
            bankTile(
              name: "Rocket",
              subtitle: "DBBL Mobile Banking",
              icon: Icons.savings,
              color: Colors.deepPurple,
              onTap: () => openBank(
                packageName: "com.dbbl.mbs.apps.main",
                webUrl: "https://www.dutchbanglabank.com/rocket",
              ),
            ),

            // ================= ISLAMI BANK =================
            bankTile(
              name: "Islami Bank",
              subtitle: "IBBL App",
              icon: Icons.mosque,
              color: Colors.green,
              onTap: () => openBank(
                packageName: "",
                webUrl: "https://www.islamibankbd.com",
              ),
            ),

            // ================= UPAY =================
            bankTile(
              name: "Upay",
              subtitle: "Digital Payment",
              icon: Icons.mobile_friendly,
              color: Colors.teal,
              onTap: () =>
                  openBank(packageName: "", webUrl: "https://www.upaybd.com"),
            ),
          ],
        ),
      ),
    );
  }
}
