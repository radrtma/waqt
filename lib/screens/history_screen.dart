import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final Map<String, Map<String, bool>> historyData;

  const HistoryScreen({super.key, required this.historyData});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDays();
  }

  void _generateWeekDays() {
    // Generate dates for current week (Sunday to Saturday)
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));
    _weekDays = List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final dayData = widget.historyData[dateStr] ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFFF5E9DA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildCalendarRow(),
              const SizedBox(height: 40),
              Text(
                'Prayer Status',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F6F5B),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: dayData.isEmpty && !DateUtils.isSameDay(_selectedDate, DateTime.now())
                    ? _buildEmptyState()
                    : _buildPrayerStatusList(dayData),
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
        Text(
          'History',
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F6F5B),
          ),
        ),
        Text(
          'Your prayer journey this week',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF6B6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weekDays.map((date) => _buildCalendarDay(date)).toList(),
      ),
    );
  }

  Widget _buildCalendarDay(DateTime date) {
    final isSelected = DateUtils.isSameDay(date, _selectedDate);
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dayName = DateFormat('E').format(date)[0]; // S, M, T, W, T, F, S

    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      child: Column(
        children: [
          Text(
            dayName,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF1F6F5B) : const Color(0xFF6B6B6B),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1F6F5B) : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected
                  ? Border.all(color: const Color(0xFF1F6F5B), width: 1)
                  : isSelected ? Border.all(color: const Color(0xFFF2C94C).withValues(alpha: 0.3), width: 1) : null,
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xFFF2C94C).withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ] : null,
            ),
            alignment: Alignment.center,
            child: Text(
              date.day.toString(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFFF2C94C) : const Color(0xFF1F6F5B),
                shadows: isSelected ? [Shadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.3), blurRadius: 8)] : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStatusList(Map<String, bool> dayData) {
    final prayers = ['Fajr', 'Dzuhur', 'Ashar', 'Maghrib', 'Isha'];
    
    // If it's today and data is empty, it means no prayers joined yet or all false
    // But for today we should show the live status or at least current status
    // In this MVP, we'll just show what's in dayData.
    
    return ListView.builder(
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final isDone = dayData[prayer] ?? false;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFF1F6F5B) : Colors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: isDone ? Border.all(color: const Color(0xFFF2C94C).withValues(alpha: 0.2), width: 1) : null,
                  boxShadow: isDone ? [
                    BoxShadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.2), blurRadius: 10)
                  ] : null,
                ),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: isDone ? const Color(0xFFF2C94C) : Colors.grey,
                  size: 24,
                  shadows: isDone ? [Shadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.4), blurRadius: 10)] : null,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                prayer,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F6F5B),
                ),
              ),
              const Spacer(),
              Text(
                isDone ? 'Completed' : 'Missed',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDone ? const Color(0xFFF2C94C) : Colors.grey,
                  shadows: isDone ? [Shadow(color: const Color(0xFFF2C94C).withValues(alpha: 0.2), blurRadius: 8)] : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No history data for this day',
            style: GoogleFonts.inter(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
