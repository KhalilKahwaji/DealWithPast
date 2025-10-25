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
  String _missionType = 'all'; // 'all', 'created', 'joined'

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    setState(() => _isLoading = true);

    try {
      dynamic response;

      switch (_missionType) {
        case 'created':
          // TODO: Need API endpoint for missions created by user
          // For now, filter client-side by creator_id
          response = await _missionRepo.getNearbyMissions(
            33.8938,
            35.5018,
            radius: 50,
            token: widget.token,
          );
          break;
        case 'joined':
          // Use getMyMissions for missions user is participating in
          response = await _missionRepo.getMyMissions(widget.token ?? '');
          break;
        case 'all':
        default:
          // Get all nearby missions
          response = await _missionRepo.getNearbyMissions(
            33.8938,
            35.5018,
            radius: 50, // Reduced from 100km to 50km for Lebanon
            token: widget.token,
          );
          break;
      }

      if (response != null) {
        final missionsList = response['missions'] ?? response;
        setState(() {
          _missions = List<Map<String, dynamic>>.from(
            missionsList is List ? missionsList : [missionsList]
          );

          // Filter by creator if needed
          if (_missionType == 'created' && widget.userId != null) {
            _missions = _missions.where((m) =>
              m['creator_id'] == widget.userId ||
              m['user_id'] == widget.userId
            ).toList();
          }

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
        Column(
          children: [
            // Mission type filter tabs
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DCC8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildFilterTab('joined', 'انضممت إليها', Icons.check_circle_outline),
                  _buildFilterTab('created', 'أنشأتها', Icons.add_circle_outline),
                  _buildFilterTab('all', 'كل المهام', Icons.explore_outlined),
                ],
              ),
            ),
            // Mission list
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF5A7C59)))
                : RefreshIndicator(
                    onRefresh: _loadMissions,
                    color: const Color(0xFF5A7C59),
                    child: _filteredMissions.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                          itemCount: _filteredMissions.length,
                          itemBuilder: (context, index) => _buildMissionCard(_filteredMissions[index]),
                        ),
                  ),
            ),
          ],
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

  Widget _buildFilterTab(String type, String label, IconData icon) {
    final isSelected = _missionType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _missionType = type);
          _loadMissions();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8B5A5A) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF3A3534),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    color: isSelected ? Colors.white : const Color(0xFF3A3534),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = 'لا توجد مهام حالياً';
    if (_missionType == 'created') {
      message = 'لم تنشئ أي مهام بعد';
    } else if (_missionType == 'joined') {
      message = 'لم تنضم إلى أي مهام بعد';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            message,
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
                  color: isCompleted ? const Color(0xFFD4AF37) : const Color(0xFFE8A99C),
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
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF8B5A5A) : const Color(0xFF5A7C59),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
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
