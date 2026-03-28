import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hover_effect.dart';

class PrayerIndicator extends StatelessWidget {
  final String label;
  final bool isCompleted;

  const PrayerIndicator({
    super.key,
    required this.label,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return HoverEffect(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFFF5E9DA) : const Color(0xFFF5E9DA).withOpacity(0.2),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            isCompleted ? 'assets/images/icon_check.png' : 'assets/images/icon_clock.png',
            color: isCompleted ? const Color(0xFF1F6F5B) : const Color(0xFFF5E9DA).withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFFF5E9DA),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ));
  }
}
