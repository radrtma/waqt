import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/hover_effect.dart';

class StreakScreen extends StatefulWidget {
  final List<String> missedPrayers;
  final int streakCount;
  final bool isFrozen;
  final Function(String) onQadaComplete;

  const StreakScreen({
    super.key,
    required this.missedPrayers,
    required this.streakCount,
    required this.isFrozen,
    required this.onQadaComplete,
  });

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  late List<String> _currentMissed;
  final List<String> _completedThisSession = [];

  @override
  void initState() {
    super.initState();
    _currentMissed = List.from(widget.missedPrayers);
  }

  void _completeQada(String prayer) {
    widget.onQadaComplete(prayer);
    setState(() {
      _completedThisSession.add(prayer);
    });
  }

  bool _isExtinguished() {
    // Only extinguished when streak was actually reset (qada not completed on time)
    return widget.streakCount == 0 && !widget.isFrozen;
  }

  @override
  Widget build(BuildContext context) {
    bool isAllQadaDone = _currentMissed.isNotEmpty && _completedThisSession.length == _currentMissed.length;
    bool isCurrentlyFrozen = widget.isFrozen && !isAllQadaDone;
    bool isExtinguished = _isExtinguished() && _completedThisSession.length < _currentMissed.length;
    
    String streakIcon = 'assets/images/icon_streak.png';
    if (isCurrentlyFrozen) {
      streakIcon = 'assets/images/icon_streak_freeze.png';
    } else if (isExtinguished) streakIcon = 'assets/images/icon_streak_off.png';

    Color themeColor = isExtinguished ? Colors.grey : const Color(0xFFF2C94C); // Gold
    Color heroBg = isExtinguished ? Colors.white : const Color(0xFF1F6F5B); // Dark Green
    if (isCurrentlyFrozen) {
      themeColor = Colors.white;
      heroBg = Colors.blue.shade700;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5E9DA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildStreakHeroCard(themeColor, heroBg, streakIcon, isExtinguished, isCurrentlyFrozen),
              const SizedBox(height: 24),
              _buildStatusCardsRow(heroBg, themeColor),
              const SizedBox(height: 40),
              _buildQadaSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color(0xFF1F6F5B),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spiritual Streak',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F6F5B),
              ),
            ),
            Text(
              'Keep your prayer flame alive',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakHeroCard(Color themeColor, Color bgColor, String streakIcon, bool isExtinguished, bool isCurrentlyFrozen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: !isExtinguished ? Border.all(color: themeColor.withValues(alpha: 0.2), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.25),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          if (!isExtinguished && !isCurrentlyFrozen) // Gold Glow
            BoxShadow(
              color: themeColor.withValues(alpha: 0.15),
              blurRadius: 50,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isExtinguished ? themeColor.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              streakIcon,
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.local_fire_department_rounded,
                size: 80,
                color: themeColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${widget.streakCount}',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: themeColor,
              shadows: (!isExtinguished) ? [
                Shadow(
                  color: themeColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                ),
              ] : null,
            ),
          ),
          Text(
            isCurrentlyFrozen 
              ? 'STREAK FROZEN' 
              : isExtinguished ? 'STREAK EXTINGUISHED' : 'DAYS STREAK',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: isExtinguished ? themeColor.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (isExtinguished) ...[
            const SizedBox(height: 12),
            Text(
              'Complete Qada to keep your streak!',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCardsRow(Color heroBg, Color themeColor) {
    return SizedBox(
      width: double.infinity,
      child: _buildActionCard(
        icon: Icons.history_rounded,
        title: 'Missed Today',
        subtitle: '${_currentMissed.length - _completedThisSession.length} Prayers',
        color: themeColor,
        onTap: () {},
        isActive: false,
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return HoverEffect(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withValues(alpha: 0.2) : const Color(0xFF1F6F5B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isActive ? Colors.white : const Color(0xFF1F6F5B), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isActive ? Colors.white : const Color(0xFF1F6F5B),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isActive ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQadaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Qada Sholat',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: const Color(0xFF1F6F5B),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_currentMissed.isNotEmpty)
              Text(
                '${_completedThisSession.length}/${_currentMissed.length}',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F6F5B),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_currentMissed.isEmpty)
          _buildEmptyState()
        else
          ..._currentMissed.map((prayer) => _buildQadaItem(prayer)),
      ],
    );
  }

  Widget _buildQadaItem(String prayer) {
    bool isDone = _completedThisSession.contains(prayer);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F6F5B).withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFF1F6F5B).withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check_circle_rounded : Icons.priority_high_rounded,
              color: isDone ? const Color(0xFF1F6F5B) : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF1F6F5B), // Green standard
                  ),
                ),
                Text(
                  isDone ? 'Goal Refilled' : 'Restore your streak',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          if (isDone)
            const Icon(Icons.verified_rounded, color: Color(0xFF1F6F5B), size: 32)
          else
            HoverEffect(
              onTap: () => _completeQada(prayer),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F6F5B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Qada Now',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF2C94C), // Deep Gold Inside Button!
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 64, color: const Color(0xFF1F6F5B).withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F6F5B).withValues(alpha: 0.5),
            ),
          ),
          Text(
            'No Qada prayers for today.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
