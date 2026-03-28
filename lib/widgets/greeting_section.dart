import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'streak_badge.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamu'alaikum",
                style: GoogleFonts.dmSerifDisplay(
                  color: const Color(0xFF2C2C2C).withOpacity(0.6),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Raffi Indra",
                style: GoogleFonts.dmSerifDisplay(
                  color: const Color(0xFF1F6F5B),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const StreakBadge(),
      ],
    );
  }
}
