// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/MissionRepo.dart';
import '../Repos/UserRepo.dart';
import 'mission_detail.dart';
import 'create_mission.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({Key? key}) : super(key: key);

  @override
  _MissionsPageState createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final MissionRepo _missionRepo = MissionRepo();
  final UserRepo _userRepo = UserRepo();

  List<Map<String, dynamic>> _missions = [];
  List<Map<String, dynamic>> _filteredMissions = [];
  bool _isLoading = true;
  String? _token;

  // Filter states
  String _sortBy = 'newest'; // newest, popular, ending_soon
  String? _difficultyFilter; // null = all, 'easy', 'medium', 'hard'
  String? _periodFilter; // null = all, or decade tags

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    setState(() => _isLoading = true);

    try {
      // Get auth token
      _token = await _userRepo.currentUserToken();

      // Fetch nearby missions (using Lebanon center coordinates)
      final response = await _missionRepo.getNearbyMissions(
        33.8938,
        35.5018,
        radius: 100,
        token: _token,
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

    // Apply difficulty filter
    if (_difficultyFilter != null) {
      filtered = filtered.where((m) => m['difficulty'] == _difficultyFilter).toList();
    }

    // Apply period filter (decade tags)
    if (_periodFilter != null) {
      filtered = filtered.where((m) {
        final tags = m['decade_tags'] as List?;
        return tags != null && tags.contains(_periodFilter);
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
        break;
      case 'popular':
        filtered.sort((a, b) => (b['completion_count'] ?? 0).compareTo(a['completion_count'] ?? 0));
        break;
      case 'ending_soon':
        filtered.sort((a, b) {
          final aProgress = (a['completion_count'] ?? 0) / (a['goal_count'] ?? 1);
          final bProgress = (b['completion_count'] ?? 0) / (b['goal_count'] ?? 1);
          return bProgress.compareTo(aProgress);
        });
        break;
    }

    setState(() => _filteredMissions = filtered);
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('الأحدث أولاً', 'newest'),
            _buildSortOption('الأكثر شعبية', 'popular'),
            _buildSortOption('الأقرب للإنتهاء', 'ending_soon'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = _sortBy == value;
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF3A3534),
        ),
      ),
      trailing: isSelected
        ? const Icon(Icons.check, color: Color(0xFF4CAF50))
        : null,
      onTap: () {
        setState(() => _sortBy = value);
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }

  void _showDifficultyFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDifficultyOption('كل المستويات', null),
            _buildDifficultyOption('سهل', 'easy'),
            _buildDifficultyOption('متوسط', 'medium'),
            _buildDifficultyOption('صعب', 'hard'),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyOption(String label, String? value) {
    final isSelected = _difficultyFilter == value;
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF3A3534),
        ),
      ),
      trailing: isSelected
        ? const Icon(Icons.check, color: Color(0xFF4CAF50))
        : null,
      onTap: () {
        setState(() => _difficultyFilter = value);
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }

  void _navigateToMissionDetail(Map<String, dynamic> mission) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MissionDetailPage(
          missionId: mission['id'] is int ? mission['id'] : int.parse(mission['id'].toString()),
          token: _token,
        ),
      ),
    );
  }

  void _navigateToCreateMission() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMissionPage(token: _token),
      ),
    ).then((_) => _loadMissions()); // Refresh after creating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text(
          'المهام والإنجازات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: _navigateToCreateMission,
            tooltip: 'إنشاء مهمة جديدة',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
        : RefreshIndicator(
            onRefresh: _loadMissions,
            color: const Color(0xFF4CAF50),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  children: [
                    _buildFilterBar(),
                    const SizedBox(height: 16),
                    _filteredMissions.isEmpty
                      ? _buildEmptyState()
                      : _buildMissionsList(),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterButton(
          label: _sortBy == 'newest' ? 'الأحدث أولاً' : _sortBy == 'popular' ? 'الأكثر شعبية' : 'الأقرب للإنتهاء',
          icon: Icons.sort,
          onTap: _showSortOptions,
        ),
        const SizedBox(width: 8),
        _buildFilterButton(
          label: _difficultyFilter == null ? 'كل المستويات' : _difficultyFilter == 'easy' ? 'سهل' : _difficultyFilter == 'medium' ? 'متوسط' : 'صعب',
          icon: Icons.filter_list,
          onTap: _showDifficultyFilter,
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            border: Border.all(color: const Color(0x1A3A3534), width: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 16, color: const Color(0x8C000000)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3A3534),
                    fontFamily: 'Tajawal',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا توجد مهام حالياً',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3534),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'قم بإنشاء مهمة جديدة أو غيّر الفلاتر',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredMissions.length,
      itemBuilder: (context, index) {
        return _buildMissionCard(_filteredMissions[index]);
      },
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    final title = mission['title'] ?? 'مهمة بدون عنوان';
    final description = _stripHtmlTags(mission['description'] ?? '');
    final category = mission['category'] ?? 'social';
    final difficulty = mission['difficulty'] ?? 'medium';
    final completionCount = mission['completion_count'] ?? 0;
    final goalCount = mission['goal_count'] ?? 10;
    final progress = goalCount > 0 ? completionCount / goalCount : 0.0;

    return GestureDetector(
      onTap: () => _navigateToMissionDetail(mission),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x1A3A3534), width: 0.7),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header row with icon and badges
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category == 'social' ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flag, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                // Badges column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3A3534),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Badges row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildDifficultyBadge(difficulty),
                          const SizedBox(width: 8),
                          _buildCategoryBadge(category),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              description,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.62,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 16),
            // Progress section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التقدم',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  '$completionCount / $goalCount',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A3534),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar
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
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Footer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View details button
                Row(
                  children: const [
                    Text(
                      'اضغط لعرض التفاصيل',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Color(0xFF4CAF50)),
                  ],
                ),
                // Contributors count
                Row(
                  children: [
                    Text(
                      '$completionCount مساهم',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: category == 'social' ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0),
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

  String _stripHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }
}
