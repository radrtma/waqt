import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProfileScreen extends StatelessWidget {
  final String userName;
  final Function(String) onNameChanged;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.onNameChanged,
  });

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(text: userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF5E9DA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit Name',
          style: GoogleFonts.dmSerifDisplay(
            color: const Color(0xFF1F6F5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1F6F5B)),
            ),
          ),
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onNameChanged(controller.text.trim());
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F6F5B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E9DA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildProfileCard(context),
                const SizedBox(height: 24),
                _buildSettingsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F6F5B),
          ),
        ),
        Text(
          'Manage your account and preferences',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF6B6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF2C94C).withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F6F5B).withValues(alpha: 0.25),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow( // Gold Glow
            color: const Color(0xFFF2C94C).withValues(alpha: 0.15),
            blurRadius: 50,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF2C94C), width: 2), // Gold border
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.3), blurRadius: 15),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFF5E9DA),
                  child: Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: Color(0xFF1F6F5B),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2C94C), // Gold camera button
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.4), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFF1F6F5B),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFF2C94C),
                  shadows: [Shadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.3), blurRadius: 10)],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showEditNameDialog(context),
                icon: const Icon(Icons.edit_rounded, size: 20),
                color: const Color(0xFFF2C94C),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Text(
            'Member since March 2024',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingsItem(Icons.notifications_active_rounded, 'Notifications', 'Adhan & reminders'),
        _buildSettingsItem(Icons.location_on_rounded, 'Location', 'Jakarta, Indonesia'),
        _buildSettingsItem(Icons.language_rounded, 'Language', 'English'),
        _buildSettingsItem(Icons.info_rounded, 'About WAQT', 'Version 1.0.0', onTap: null),

      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1F6F5B), // Deep Green Box
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF2C94C).withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: const Color(0xFFF2C94C), size: 24, shadows: [Shadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.4), blurRadius: 8)]), // Glowing Gold Icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF1F6F5B),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
        ],
      ),
      ),
    );
  }
}
