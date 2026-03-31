import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hover_effect.dart';
import '../screens/streak_screen.dart';

class StreakBadge extends StatelessWidget {
  final List<String> missedPrayers;
  final int streakCount;
  final bool isFrozen;
  final Function(String) onQadaComplete;
  final VoidCallback onToggleFreeze;

  const StreakBadge({
    super.key,
    required this.missedPrayers,
    required this.streakCount,
    required this.isFrozen,
    required this.onQadaComplete,
    required this.onToggleFreeze,
  });

  @override
  Widget build(BuildContext context) {
    return HoverEffect(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StreakScreen(
              missedPrayers: missedPrayers,
              streakCount: streakCount,
              isFrozen: isFrozen,
              onQadaComplete: onQadaComplete,
              onToggleFreeze: onToggleFreeze,
            ),
          ),
        );
      },
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E9DA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1F6F5B).withOpacity(0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isFrozen ? 'assets/images/icon_streak_freeze.png' : 'assets/images/icon_streak.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Text(
            '${streakCount}x',
            style: GoogleFonts.inter(
              color: isFrozen ? Colors.blue.shade700 : const Color(0xFF1F6F5B),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Days',
            style: GoogleFonts.inter(
              color: const Color(0xFF2C2C2C).withOpacity(0.6),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ));
  }
}
