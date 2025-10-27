// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../Repos/MissionRepo.dart';
import '../My Stories/addStory.dart';
import '../widgets/MissionReactions.dart';

class MissionDetailPage extends StatefulWidget {
  final int missionId;
  final String? token;

  const MissionDetailPage({
    Key? key,
    required this.missionId,
    this.token,
  }) : super(key: key);

  @override
  _MissionDetailPageState createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  final MissionRepo _missionRepo = MissionRepo();

  Map<String, dynamic>? _mission;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissionDetails();
  }

  Future<void> _loadMissionDetails() async {
    setState(() => _isLoading = true);

    try {
      final mission = await _missionRepo.getMissionDetails(widget.missionId, widget.token);

      if (mission != null) {
        final previousProgress = _calculateProgress();
        setState(() {
          _mission = mission;
          _isLoading = false;
        });

        // Check if mission was just completed
        final currentProgress = _calculateProgress();
        if (currentProgress >= 1.0 && previousProgress < 1.0) {
          _showCompletionDialog();
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading mission details: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showCompletionDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'مبروك! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3A3534),
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                'تم إكمال المهمة "${_mission!['title']}" بنجاح!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3A3534),
                  fontFamily: 'Tajawal',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Reward info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFDE73)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars, color: Color(0xFFFFB300), size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'الجميع حصل على ${_mission!['reward_points']} نقطة!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A3534),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Close button
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  color: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: const Text(
                    'رائع!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _joinMission() async {
    if (widget.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول للمشاركة في المهمة')),
      );
      return;
    }

    // Navigate to add story with mission ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStory(widget.token, missionId: widget.missionId),
      ),
    ).then((_) => _loadMissionDetails());
  }

  Future<void> _startMission() async {
    if (widget.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول للبدء في المهمة')),
      );
      return;
    }

    try {
      await _missionRepo.startMission(widget.missionId, widget.token!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم البدء في المهمة بنجاح!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      _loadMissionDetails();
    } catch (e) {
      print('Error starting mission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء البدء في المهمة')),
      );
    }
  }

  void _viewOnMap() {
    // Navigate to map tab with mission selected
    // This requires passing mission data back through the bottom nav
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('عرض على الخريطة - قيد التطوير'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareMission() async {
    if (_mission == null) return;

    final title = _mission!['title'] ?? 'مهمة';
    final description = _stripHtmlTags(_mission!['description'] ?? '');
    final category = _mission!['category'] == 'social' ? 'اجتماعية' : 'شخصية';
    final difficulty = _mission!['difficulty'] == 'easy'
        ? 'سهل'
        : _mission!['difficulty'] == 'hard'
            ? 'صعب'
            : 'متوسط';
    final rewardPoints = _mission!['reward_points'] ?? 0;
    final address = _mission!['address'] ?? '';

    // Build share message in Arabic
    final shareText = '''
🎯 $title

📝 $description

📊 التفاصيل:
• الفئة: $category
• الصعوبة: $difficulty
• المكافأة: $rewardPoints نقطة${address.isNotEmpty ? '\n• الموقع: $address' : ''}

انضم لهذه المهمة وساهم في صنع إرث يدوم! 🌟

#DWP #ديل_مع_الماضي #المهام
''';

    try {
      await Share.share(
        shareText,
        subject: title,
      );
    } catch (e) {
      print('Error sharing mission: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء المشاركة')),
        );
      }
    }
  }

  double _calculateProgress() {
    if (_mission == null) return 0.0;
    final completionCount = _mission!['completion_count'] ?? 0;
    final goalCount = _mission!['goal_count'] ?? 1;
    return (completionCount / goalCount).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text(
          'تفاصيل المهمة',
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
          if (_mission != null)
            IconButton(
              icon: const Icon(Icons.share, color: Color(0xFF3A3534)),
              onPressed: _shareMission,
              tooltip: 'مشاركة المهمة',
            ),
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
        : _mission == null
          ? _buildErrorState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroSection(),
                  _buildDetailsSection(),
                  const SizedBox(height: 20),
                  // Emoji reactions section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'التفاعلات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3A3534),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 12),
                        MissionReactions(missionId: widget.missionId),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error_outline, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لم نتمكن من تحميل تفاصيل المهمة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3534),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final category = _mission!['category'] ?? 'social';
    final color = category == 'social' ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0);
    final isCompleted = _calculateProgress() >= 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Large icon with completion badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.flag, size: 50, color: color),
              ),
              if (isCompleted)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB300),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            _mission!['title'] ?? 'مهمة',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 20),
          // Progress circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: _calculateProgress(),
                  strokeWidth: 12,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              Column(
                children: [
                  if (isCompleted)
                    const Text(
                      '✓',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  else
                    Text(
                      '${((_calculateProgress()) * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted ? 'مكتمل!' : 'مكتمل',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    final difficulty = _mission!['difficulty'] ?? 'medium';
    final category = _mission!['category'] ?? 'social';
    final completionCount = _mission!['completion_count'] ?? 0;
    final goalCount = _mission!['goal_count'] ?? 10;
    final rewardPoints = _mission!['reward_points'] ?? 0;
    final description = _stripHtmlTags(_mission!['description'] ?? '');

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Badges row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildDifficultyBadge(difficulty),
              const SizedBox(width: 8),
              _buildCategoryBadge(category),
            ],
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            description,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 17,
              height: 1.62,
              color: Color(0xFF3A3534),
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 30),
          // Stats grid
          Row(
            children: [
              Expanded(child: _buildStatCard(Icons.stars, '$rewardPoints نقطة', 'المكافأة')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(Icons.check_circle, '$completionCount / $goalCount', 'القصص')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(Icons.people, '$completionCount', 'المشاركين')),
            ],
          ),
          const SizedBox(height: 20),
          // Location
          if (_mission!['address'] != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x1A3A3534)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      _mission!['address'],
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3A3534),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on, color: Color(0xFF4CAF50)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          // Tags
          if (_mission!['decade_tags'] != null && (_mission!['decade_tags'] as List).isNotEmpty) ...[
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: (_mission!['decade_tags'] as List).take(5).map((tag) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDE73).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFDE73)),
                    ),
                    child: Text(
                      tag.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3A3534),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A3A3534)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3A3534),
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Join Mission button
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
              onPressed: _joinMission,
              color: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              child: const Text(
                'شارك في المهمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // View on map button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _viewOnMap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4CAF50)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.map, color: Color(0xFF4CAF50)),
                  SizedBox(width: 8),
                  Text(
                    'عرض على الخريطة',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: category == 'social' ? const Color(0xFF4CAF50) : const Color(0xFF9C27B0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category == 'social' ? 'اجتماعية' : 'شخصية',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
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
