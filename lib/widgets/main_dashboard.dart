import 'package:flutter/material.dart';
import 'greeting_section.dart';
import 'prayer_card.dart';
import 'date_information.dart';
import 'prayer_tracker.dart';

class MainDashboard extends StatelessWidget {
  final Map<String, bool> prayerStates;
  final Function(String) onToggle;
  final Map<String, dynamic> timings;
  final String userName;
  final Map<String, dynamic> dateInfo;
  final DateTime currentTime;
  final bool Function(String) isPrayerTimeReached;
  final bool Function(String) isPrayerMissed;
  final List<Map<String, dynamic>> missedPrayers;
  final int streakCount;
  final bool isFrozen;
  final Function(int, String) onQadaComplete;

  const MainDashboard({
    super.key,
    required this.userName,
    required this.prayerStates,
    required this.onToggle,
    required this.timings,
    required this.dateInfo,
    required this.currentTime,
    required this.isPrayerTimeReached,
    required this.isPrayerMissed,
    required this.missedPrayers,
    required this.streakCount,
    required this.isFrozen,
    required this.onQadaComplete,
  });

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
            GreetingSection(
              userName: userName,
              missedPrayers: missedPrayers,
              streakCount: streakCount,
              isFrozen: isFrozen,
              onQadaComplete: onQadaComplete,
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 32),
            PrayerCard(
              prayerName: _getNextPrayerName(),
              prayerTime: timings[_getNextPrayerName()] ?? '--:--',
              nextPrayerInfo: 'Next Prayer (${_getNextPrayerName()}) In',
              nextPrayerCountdown: _getCountdown(_getNextPrayerName()),
            ),
            const SizedBox(height: 20),
            DateInformation(
              gDate: dateInfo['gregorian']['date'] ?? '',
              hDate: '${dateInfo['hijri']['day']} ${dateInfo['hijri']['month']['en']} ${dateInfo['hijri']['year']} H',
            ),
            const SizedBox(height: 24),
            PrayerTracker(
              prayerStates: prayerStates,
              onToggle: onToggle,
              isPrayerTimeReached: isPrayerTimeReached,
              isPrayerMissed: isPrayerMissed,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getCountdown(String prayerName) {
    if (timings[prayerName] == null) return '--:--:--';
    final parts = timings[prayerName].split(':');
    final prayerTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    var diff = prayerTime.difference(currentTime);
    if (diff.isNegative) {
      // Jika sudah lewat, mungkin besok (untuk Fajr)
      diff = prayerTime.add(const Duration(days: 1)).difference(currentTime);
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  String _getNextPrayerName() {
    final prayerNames = ['Fajr', 'Dzuhur', 'Ashar', 'Maghrib', 'Isha'];
    for (var name in prayerNames) {
      if (!isPrayerTimeReached(name)) return name;
    }
    return 'Fajr'; // Cycle back to Fajr if all prayers today are finished
  }
}
