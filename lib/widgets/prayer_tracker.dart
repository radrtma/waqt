import 'package:flutter/material.dart';
import 'prayer_indicator.dart';

class PrayerTracker extends StatelessWidget {
  final Map<String, bool> prayerStates;
  final Function(String) onToggle;
  final bool Function(String) isPrayerTimeReached;
  final bool Function(String) isPrayerMissed;

  const PrayerTracker({
    super.key,
    required this.prayerStates,
    required this.onToggle,
    required this.isPrayerTimeReached,
    required this.isPrayerMissed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIndicator('Fajr'),
          _buildIndicator('Dzuhur'),
          _buildIndicator('Ashar'),
          _buildIndicator('Maghrib'),
          _buildIndicator('Isha'),
        ],
      ),
    );
  }

  Widget _buildIndicator(String label) {
    return PrayerIndicator(
      label: label,
      isCompleted: prayerStates[label] ?? false,
      isClickable: isPrayerTimeReached(label),
      isMissed: isPrayerMissed(label),
      onTap: () => onToggle(label),
    );
  }
}
