import 'package:flutter/material.dart';
import 'prayer_indicator.dart';

class PrayerTracker extends StatelessWidget {
  const PrayerTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6F5B),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PrayerIndicator(label: 'Fajr', isCompleted: true),
          PrayerIndicator(label: 'Dzuhur', isCompleted: true),
          PrayerIndicator(label: 'Ashar', isCompleted: true),
          PrayerIndicator(label: 'Maghrib', isCompleted: true),
          PrayerIndicator(label: 'Isha', isCompleted: false),
        ],
      ),
    );
  }
}
