import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String nextPrayerInfo;
  final String? nextPrayerCountdown;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.nextPrayerInfo,
    this.nextPrayerCountdown,
  });

  @override
  Widget build(BuildContext context) {
    IconData prayerIcon;
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        prayerIcon = Icons.wb_twilight_rounded;
        break;
      case 'dzuhur':
      case 'dhuhr':
        prayerIcon = Icons.wb_sunny_rounded;
        break;
      case 'ashar':
      case 'asr':
        prayerIcon = Icons.wb_cloudy_rounded;
        break;
      case 'maghrib':
        prayerIcon = Icons.nights_stay_rounded;
        break;
      case 'isha':
      default:
        prayerIcon = Icons.nightlight_round;
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFF2C94C).withValues(alpha: 0.1),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF243A5E).withValues(alpha: 0.25), // Softer, broader shadow
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
                      prayerIcon,
                      color: const Color(0xFFF2C94C),
                      size: 28,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFF2C94C).withValues(alpha: 0.3),
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
                            color: const Color(0xFFF2C94C).withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  prayerTime,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF5E9DA),
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  nextPrayerInfo,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
                if (nextPrayerCountdown != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFFF2C94C),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        nextPrayerCountdown!,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFF2C94C), // Gold for the countdown
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
