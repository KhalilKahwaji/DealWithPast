// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/MissionRepo.dart';
import 'create_mission_modal.dart';

class MissionsListTab extends StatefulWidget {
  final String? token;
  final int? userId;

  const MissionsListTab({
    Key? key,
    this.token,
    this.userId,
  }) : super(key: key);

  @override
  _MissionsListTabState createState() => _MissionsListTabState();
}

class _MissionsListTabState extends State<MissionsListTab> {
  final MissionRepo _missionRepo = MissionRepo();

  List<Map<String, dynamic>> _missions = [];
  List<Map<String, dynamic>> _filteredMissions = [];
  bool _isLoading = true;

  // Filter states
  String _sortBy = 'newest';
  String? _difficultyFilter;

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    setState(() => _isLoading = true);

    try {
      final response = await _missionRepo.getNearbyMissions(
        33.8938,
        35.5018,
        radius: 100,
        token: widget.token,
      );

      if (response != null && response['missions'] != null) {
        setState(() {
          _missions = List<Map<String, dynamic>>.from(response['missions']);
          _filteredMissions = List.from(_missions);
          _isLoading = false;
        });
        _applyFilters();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading missions: $e');
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_missions);

    if (_difficultyFilter != null) {
      filtered = filtered.where((m) => m['difficulty'] == _difficultyFilter).toList();
    }

    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
        break;
      case 'popular':
        filtered.sort((a, b) => (b['completion_count'] ?? 0).compareTo(a['completion_count'] ?? 0));
        break;
    }

    setState(() => _filteredMissions = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mission list
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: Color(0xFF5A7C59)))
        else
          RefreshIndicator(
            onRefresh: _loadMissions,
            color: const Color(0xFF5A7C59),
            child: _filteredMissions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  itemCount: _filteredMissions.length,
                  itemBuilder: (context, index) => _buildMissionCard(_filteredMissions[index]),
                ),
          ),
        // FAB button
        Positioned(
          bottom: 100,
          left: 20,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Color(0xFF8B5A5A),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(35),
                onTap: () => _showCreateMissionModal(context),
                child: Center(
                  child: Icon(Icons.add, color: Colors.white, size: 36),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreateMissionModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateMissionModal(token: widget.token),
    );
    if (result == true) {
      _loadMissions();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.explore_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'لا توجد مهام حالياً',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    final title = mission['title'] ?? 'مهمة';
    final category = mission['category'] ?? 'social';
    final difficulty = mission['difficulty'] ?? 'medium';
    final completionCount = mission['completion_count'] ?? 0;
    final goalCount = mission['goal_count'] ?? 10;
    final progress = goalCount > 0 ? completionCount / goalCount : 0.0;
    final isCompleted = progress >= 1.0;

    // Get tags from mission data (could be array or single value)
    final tags = <String>[];
    if (mission['tags'] != null) {
      if (mission['tags'] is List) {
        tags.addAll((mission['tags'] as List).map((e) => e.toString()));
      } else {
        tags.add(mission['tags'].toString());
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3534),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.emoji_events : Icons.menu_book,
                  color: Color(isCompleted ? 0xFFD4AF37 : 0xFFE8A99C),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (isCompleted)
                          _buildBadge('مكتملة', const Color(0xFFD4AF37)),
                        _buildDifficultyBadge(difficulty),
                        if (tags.isNotEmpty)
                          ...tags.map((tag) => _buildBadge(tag, const Color(0xFF8B5A5A)))
                        else
                          _buildCategoryBadge(category),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF8B5A5A) : const Color(0xFF5A7C59),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completionCount / $goalCount قصص',
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: category == 'social' ? const Color(0xFF5A7C59) : const Color(0xFF9C27B0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category == 'social' ? 'اجتماعية' : 'شخصية',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    String label;

    switch (difficulty) {
      case 'easy':
        color = Colors.green;
        label = 'سهل';
        break;
      case 'hard':
        color = Colors.red;
        label = 'صعب';
        break;
      default:
        color = Colors.orange;
        label = 'متوسط';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
