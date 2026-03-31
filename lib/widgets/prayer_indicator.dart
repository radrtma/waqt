import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hover_effect.dart';

class PrayerIndicator extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isClickable;
  final bool isMissed;
  final VoidCallback onTap;

  const PrayerIndicator({
    super.key,
    required this.label,
    required this.isCompleted,
    required this.isClickable,
    required this.isMissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (isClickable || isMissed) ? 1.0 : 0.5,
      child: HoverEffect(
        onTap: (isClickable && !isCompleted && !isMissed) ? onTap : null,
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
                isMissed 
                    ? 'assets/images/icon_x.png'
                    : (isCompleted ? 'assets/images/icon_check.png' : 'assets/images/icon_clock.png'),
                color: isMissed
                    ? Colors.white.withOpacity(0.8)
                    : (isCompleted ? const Color(0xFF1F6F5B) : const Color(0xFFF5E9DA).withOpacity(0.8)),
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
        ),
      ),
    );
  }
}
