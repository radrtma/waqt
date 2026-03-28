import 'package:flutter/material.dart';
import 'greeting_section.dart';
import 'prayer_card.dart';
import 'date_information.dart';
import 'prayer_tracker.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 260), // Overlap slightly
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF5E9DA), // Cream background for content
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GreetingSection(),
            const SizedBox(height: 32),
            const PrayerCard(
              prayerName: 'Maghrib',
              prayerTime: '18:12',
              nextPrayerInfo: 'Next Prayer (Isha) In',
            ),
            const SizedBox(height: 20),
            const DateInformation(),
            const SizedBox(height: 24),
            const PrayerTracker(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
