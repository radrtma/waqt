import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mosque_skyline.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0D1B2A).withOpacity(0.5),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
        // Centered Title
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'WAQT',
              style: GoogleFonts.dmSerifDisplay(
                color: const Color(0xFFF5E9DA),
                fontSize: 64,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: const Color(0xFFF2C94C).withOpacity(0.2),
                    offset: Offset.zero,
                    blurRadius: 20,
                  ),
                  Shadow(
                    color: const Color(0xFFF2C94C).withOpacity(0.1),
                    offset: Offset.zero,
                    blurRadius: 40,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
