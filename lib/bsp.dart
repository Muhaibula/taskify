import 'package:flutter/material.dart';

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
            },
            accentColor: accentGreen,
          ),

          const SizedBox(height: 8),
          const Divider(thickness: 1),

          // About App
          _buildListTile(
            icon: Icons.info_outline,
            title: "About App",
            onTap: () {},
          ),

          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: () {},
          ),

          _buildListTile(
            icon: Icons.help_outline,
            title: "Help & Support",
            onTap: () {},
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
              onPressed: () {},
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

  // Helper widget for normal list tiles
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
