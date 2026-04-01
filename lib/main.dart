import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'widgets/bottom_navbar.dart';
import 'screens/home_content.dart';
import 'screens/pray_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'services/notification_service.dart';

void main() {
  runApp(const WaqtApp());
}

class WaqtApp extends StatelessWidget {
  const WaqtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAQT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F6F5B),
          background: const Color(0xFFF5E9DA),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Global State
  int _streakCount = 7;
  bool _isFrozen = false;
  bool _hasMissedToday =
      false; // Tracks if any prayer was missed today (real-time)
  String _userName = 'User';
  Map<String, bool> _prayerStates = {
    'Fajr': false,
    'Dzuhur': false,
    'Ashar': false,
    'Maghrib': false,
    'Isha': false,
  };
  final Map<String, Map<String, bool>> _historyData = {};
  final Set<String> _qadaCompleted = {};
  String _lastUpdateDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _initializeMockHistory();
    _initNotifications();
    // Check for day change every minute
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        _checkDayChange();
      }
    });
  }

  Future<void> _initNotifications() async {
    await NotificationService().init();
  }

  void _initializeMockHistory() {
    final now = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      _historyData[dateStr] = {
        'Fajr': i % 2 == 0,
        'Dzuhur': i % 3 != 0,
        'Ashar': true,
        'Maghrib': i % 4 != 0,
        'Isha': i % 5 != 0,
      };
    }
  }

  void _updatePrayerStatus(String label, bool status) {
    setState(() {
      _prayerStates[label] = status;

      // Jika semua sholat sudah dikerjakan, unfreeze streak
      bool hasUncompletedPrayers = _prayerStates.entries.any((e) => !e.value);
      if (!hasUncompletedPrayers && _isFrozen) {
        _isFrozen = false;
        _hasMissedToday = false;
      }
    });
  }

  /// Called from HomeContent when a prayer is detected as missed in real-time
  void _onPrayerMissed() {
    if (!_hasMissedToday) {
      setState(() {
        _hasMissedToday = true;
        _isFrozen = true; // Freeze immediately, don't extinguish
      });
    }
  }

  void _onQadaComplete(String label) {
    setState(() {
      _qadaCompleted.add(label);
      _prayerStates[label] =
          true; // Mark as done so streak doesn't break at day change

      // If all prayers are now completed, immediately unfreeze the streak
      bool hasUncompletedPrayers = _prayerStates.entries.any((e) => !e.value);
      if (!hasUncompletedPrayers && _isFrozen) {
        _isFrozen = false;
        _hasMissedToday =
            false; // Reset daily tracking so we can detect future misses today if needed
      }
    });
  }

  void _updateUserName(String newName) {
    setState(() {
      _userName = newName;
    });
  }

  void _resetStreak() {
    setState(() {
      _streakCount = 0;
    });
  }

  void _checkDayChange() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (today != _lastUpdateDate) {
      bool isMissed = _prayerStates.values.any((done) => !done);

      if (isMissed) {
        if (_isFrozen) {
          // Jika sudah nunggak sebelumnya (frozen) dan ganti hari masih tertinggal -> Reset
          _resetStreak();
          _isFrozen = false;
          NotificationService().showStreakResetAlert();
        } else {
          // Jika baru pertama kali tertinggal -> Freeze dulu (Grace period)
          _isFrozen = true;
          _prayerStates.forEach((prayer, done) {
            if (!done) NotificationService().showQadaAlert(prayer);
          });
          // streakCount tetap (tidak bertambah, tidak reset)
        }
      } else {
        // Jika semua sholat selesai (normal atau qada)
        if (!_isFrozen) {
          _streakCount++; // Hanya bertambah jika tertib sepenuhnya
        }
        _isFrozen = false; // Cairkan jika sebelumnya frozen
      }
      // Save to history before reset
      _historyData[_lastUpdateDate] = Map.from(_prayerStates);

      _prayerStates = {
        'Fajr': false,
        'Dzuhur': false,
        'Ashar': false,
        'Maghrib': false,
        'Isha': false,
      };
      _qadaCompleted.clear();
      _hasMissedToday = false;
      _lastUpdateDate = today;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeContent(
        userName: _userName,
        prayerStates: _prayerStates,
        onPrayerToggle: _updatePrayerStatus,
        streakCount: _streakCount,
        isFrozen: _isFrozen,
        qadaCompleted: _qadaCompleted,
        onQadaComplete: _onQadaComplete,
        onPrayerMissed: _onPrayerMissed,
      ),
      const PrayScreen(),
      HistoryScreen(historyData: _historyData),
      ProfileScreen(userName: _userName, onNameChanged: _updateUserName),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
