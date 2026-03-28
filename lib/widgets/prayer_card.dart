import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hover_effect.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String nextPrayerInfo;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.nextPrayerInfo,
  });

  @override
  Widget build(BuildContext context) {
    return HoverEffect(
      onTap: () {
        // Optional action
      },
      child: Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFF2C94C).withOpacity(0.1),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF243A5E).withOpacity(0.25), // Softer, broader shadow
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/mosque_skyline.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.nightlight_round,
                      color: const Color(0xFFF2C94C),
                      size: 28,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFF2C94C).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      prayerName,
                      style: GoogleFonts.dmSerifDisplay(
                        color: const Color(0xFFF2C94C), // Gold
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFF2C94C).withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '$prayerTime PM',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF5E9DA),
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Next Prayer (Isha) In',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF5E9DA).withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  '1h 10m',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF2C94C), // Gold for the countdown
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
