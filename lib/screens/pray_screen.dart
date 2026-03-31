import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';

class PrayScreen extends StatefulWidget {
  const PrayScreen({super.key});

  @override
  State<PrayScreen> createState() => _PrayScreenState();
}

class _PrayScreenState extends State<PrayScreen> {
  Map<String, dynamic>? _timings;
  bool _isLoading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
    // Refresh UI every minute to update "Next Prayer" highlight
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.aladhan.com/v1/timingsByCity?city=Jakarta&country=Indonesia&method=11')); // Method 11 is Majlis Ugama Islam Singapura, often used in Indonesia/SE Asia, or method 2 (ISNA)

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _timings = data['data']['timings'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load prayer times';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connection error. Please check your internet.';
        _isLoading = false;
      });
    }
  }

  String _getActivePrayer() {
    if (_timings == null) return '';
    final now = DateTime.now();
    final format = DateFormat("HH:mm");

    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    String active = 'Isha'; // Default to Isha (before Fajr, previous night's Isha is still active)
    
    for (var prayer in prayers) {
      final timeStr = _timings![prayer];
      final prayerTime = format.parse(timeStr);
      final todayPrayer = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
      
      if (now.isAfter(todayPrayer) || now.isAtSameMomentAs(todayPrayer)) {
        active = prayer;
      } else {
        break;
      }
    }
    return active;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E9DA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchPrayerTimes,
          color: const Color(0xFF1F6F5B),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),
                    const SizedBox(height: 32),
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: CircularProgressIndicator(color: Color(0xFF1F6F5B)),
                        ),
                      )
                    else if (_error != null)
                      _buildErrorState()
                    else
                      _buildPrayerList(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prayer Times',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F6F5B),
                  ),
                ),
                Text(
                  'Jakarta, Indonesia',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F6F5B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.mosque_rounded,
                color: Color(0xFF1F6F5B),
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: const Color(0xFF6B6B6B)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchPrayerTimes();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F6F5B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList() {
    final activePrayer = _getActivePrayer();
    final prayers = [
      {'label': 'Fajr', 'icon': Icons.wb_twilight_rounded},
      {'label': 'Dhuhr', 'icon': Icons.wb_sunny_rounded},
      {'label': 'Asr', 'icon': Icons.wb_cloudy_rounded},
      {'label': 'Maghrib', 'icon': Icons.nights_stay_rounded},
      {'label': 'Isha', 'icon': Icons.bedtime_rounded},
    ];

    return Column(
      children: prayers.map((p) {
        final isActive = p['label'] == activePrayer;
        return _buildPrayerItem(
          p['label'] as String,
          _timings![p['label']] ?? '--:--',
          p['icon'] as IconData,
          isActive,
        );
      }).toList(),
    );
  }

  Widget _buildPrayerItem(String label, String time, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1F6F5B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withOpacity(0.2) : const Color(0xFFF5E9DA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF1F6F5B),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF1F6F5B),
                  ),
                ),
                if (isActive)
                  Text(
                    'Active Now',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : const Color(0xFF1F6F5B),
            ),
          ),
        ],
      ),
    );
  }
}
