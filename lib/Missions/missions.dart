import 'package:flutter/material.dart';
import 'missions_list_tab.dart';
import 'achievements_tab.dart';
import 'legacy_tab.dart';

class MissionsPage extends StatefulWidget {
  final String? token;
  final int? userId;

  const MissionsPage({
    Key? key,
    this.token,
    this.userId,
  }) : super(key: key);

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  int _selectedTab = 1; // Default to middle tab (Achievements)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8), // Cream background
      body: SafeArea(
        child: Column(
          children: [
            // Header with title and profile icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile icon (left)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4C5A0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.fingerprint, color: Colors.brown.shade700),
                  ),
                  // Title (right)
                  const Text(
                    'المهام والإنجازات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                      color: Color(0xFF3A3534),
                    ),
                  ),
                ],
              ),
            ),
            // Pill-shaped tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DCC8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildPillTab(
                      label: 'الإرث',
                      icon: Icons.location_pin,
                      index: 2,
                    ),
                    _buildPillTab(
                      label: 'الإنجازات',
                      icon: Icons.emoji_events,
                      index: 1,
                    ),
                    _buildPillTab(
                      label: 'المهام',
                      icon: Icons.track_changes,
                      index: 0,
                    ),
                  ],
                ),
              ),
            ),
            // Tab content
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  MissionsListTab(
                    token: widget.token,
                    userId: widget.userId,
                  ),
                  AchievementsTab(
                    token: widget.token,
                    userId: widget.userId,
                  ),
                  LegacyTab(
                    token: widget.token,
                    userId: widget.userId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillTab({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5A7C59) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFF3A3534),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Tajawal',
                  color: isSelected ? Colors.white : const Color(0xFF3A3534),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
