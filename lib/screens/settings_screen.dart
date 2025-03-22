import 'package:flutter/material.dart';
import 'ProfileScreen.dart'; // Import Profile Screen
import 'history_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Color(0xFF252525),
      ),
      body: ListView(
        children: [
          _buildSettingsTile(context, "Dark/Light Mode", Icons.brightness_6,
              () {
            // Implement dark/light mode logic later
          }),
          _buildSettingsTile(context, "History", Icons.history, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          }),
          _buildSettingsTile(context, "Favourites", Icons.favorite, () {
            // Implement favourites logic later
          }),
          _buildSettingsTile(context, "Profile", Icons.person, () {
            // Navigate to Profile Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      tileColor: Color(0xFF1E1E1E),
      onTap: onTap,
    );
  }
}
