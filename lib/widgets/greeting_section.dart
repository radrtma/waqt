import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'streak_badge.dart';

class GreetingSection extends StatelessWidget {
  final String userName;
  final List<Map<String, dynamic>> missedPrayers;
  final int streakCount;
  final bool isFrozen;
  final Function(int, String) onQadaComplete;

  const GreetingSection({
    super.key,
    required this.userName,
    required this.missedPrayers,
    required this.streakCount,
    required this.isFrozen,
    required this.onQadaComplete,
  });

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
                userName,
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
        StreakBadge(
          missedPrayers: missedPrayers,
          streakCount: streakCount,
          isFrozen: isFrozen,
          onQadaComplete: onQadaComplete,
        ),
      ],
    );
  }
}
