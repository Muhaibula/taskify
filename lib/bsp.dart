import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color.fromARGB(255, 240, 223, 245); // pastel mint green
    final Color accentGreen = const Color.fromARGB(255, 244, 224, 244); // soft teal green
    final Color backgroundColor = const Color(0xFFF8FFF8); // very light green tint

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Allow Notifications
          _buildSwitchTile(
            title: "Allow Notifications",
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? "Notifications enabled"
                      : "Notifications disabled"),
                ),
              );
            },
            accentColor: accentGreen,
          ),

          _buildSwitchTile(
            title: "Dark Mode",
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value ? "Dark mode on" : "Dark mode off"),
                ),
              );
            },
            accentColor: accentGreen,
          ),

          const SizedBox(height: 8),
          const Divider(thickness: 1),

          // About App
          _buildListTile(
            icon: Icons.info_outline,
            title: "About App",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Taskify",
                applicationVersion: "1.0.0",
                children: const [
                  Text(
                      "Taskify helps you organize your tasks efficiently and stay productive.\n\nBuilt with Flutter & Firebase 💚"),
                ],
              );
            },
          ),

          // Privacy Policy
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Privacy Policy"),
                  content: const Text(
                      "We value your privacy. Taskify does not share your data with third parties. Your data is securely stored in Firebase."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),

          // Help & Support
          _buildListTile(
            icon: Icons.help_outline,
            title: "Help & Support",
            onTap: () {
              final _controller = TextEditingController();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Send Feedback"),
                  content: TextField(
                    controller: _controller,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Describe your issue or suggestion",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final msg = _controller.text.trim();
                        if (msg.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter feedback")),
                          );
                          return;
                        }
                        await FirebaseFirestore.instance
                            .collection('feedback')
                            .add({
                          'message': msg,
                          'user': FirebaseAuth.instance.currentUser?.uid,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Thanks for your feedback!")),
                        );
                      },
                      child: const Text("Send"),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(thickness: 1),

          // Follow Us section
          _buildListTile(
            icon: Icons.group_outlined,
            title: "Follow Us",
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Follow us"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.link),
                        title: const Text("Twitter"),
                        subtitle:
                            const Text("https://twitter.com/taskifyofficial"),
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text: "https://twitter.com/taskifyofficial"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Twitter link copied")),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.link),
                        title: const Text("Instagram"),
                        subtitle:
                            const Text("https://instagram.com/taskifyapp"),
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
                              text: "https://instagram.com/taskifyapp"));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Instagram link copied")),
                          );
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(thickness: 1),

          // Log Out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 246, 145, 145).withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signed out successfully")),
                  );
                  Navigator.pushReplacementNamed(context, '/welcome');
                }
              },
              child: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for switch tiles
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color accentColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        activeColor: Colors.white,
        activeTrackColor: accentColor,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // Helper widget for list tiles
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
