import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/hero_header.dart';
import 'widgets/main_dashboard.dart';

import 'widgets/bottom_navbar.dart';

void main() {
  runApp(const WaqtApp());
}

class WaqtApp extends StatelessWidget {
  const WaqtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAQT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F6F5B),
          background: const Color(0xFFF5E9DA),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background for the image section
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Top Mosque Image Section
                HeroHeader(),
                // Bottom Content Section starting with a white card
                MainDashboard(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
