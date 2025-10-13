# Badge System - Developer Implementation Guide

**Target Audience:** Flutter Developers  
**Component:** Achievement & Legacy System Backend & Frontend  
**Implementation:** Step-by-step Flutter widgets and database integration  

---

## System Overview

The badge system provides automatic recognition for user contributions with progressive revelation. Users earn badges through specific actions, and badges build toward a unified memorial plaque. The system requires real-time tracking, celebration animations, and cultural design integration.

---

## Database Schema Requirements

### Core Tables

```sql
-- Badge definitions table
CREATE TABLE badges (
  id VARCHAR(50) PRIMARY KEY,
  name_en VARCHAR(100) NOT NULL,
  name_ar VARCHAR(100) NOT NULL,
  description_en TEXT NOT NULL,
  description_ar TEXT NOT NULL,
  category ENUM('foundation', 'community', 'legacy') NOT NULL,
  icon_path VARCHAR(200) NOT NULL,
  cultural_significance_en TEXT,
  cultural_significance_ar TEXT,
  unlock_criteria JSON NOT NULL,
  tier_requirements JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User badge achievements
CREATE TABLE user_badges (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  badge_id VARCHAR(50) NOT NULL,
  unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  tier ENUM('bronze', 'silver', 'gold') DEFAULT 'bronze',
  unlock_context JSON, -- stores specific achievement data
  is_celebrated BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (badge_id) REFERENCES badges(id),
  UNIQUE KEY unique_user_badge (user_id, badge_id)
);

-- Badge progress tracking
CREATE TABLE badge_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  badge_id VARCHAR(50) NOT NULL,
  progress_data JSON NOT NULL, -- current progress metrics
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (badge_id) REFERENCES badges(id),
  UNIQUE KEY unique_user_badge_progress (user_id, badge_id)
);
```

### Required User Table Extensions

```sql
-- Add to existing users table
ALTER TABLE users ADD COLUMN badge_count INT DEFAULT 0;
ALTER TABLE users ADD COLUMN achievement_level ENUM('foundation', 'development', 'legacy') DEFAULT 'foundation';
ALTER TABLE users ADD COLUMN memorial_unlocked BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN last_badge_unlock TIMESTAMP NULL;
```

### Required Story Table Extensions

```sql
-- Add to existing stories table  
ALTER TABLE stories ADD COLUMN contributed_to_mission_id INT NULL;
ALTER TABLE stories ADD COLUMN achievement_trigger_processed BOOLEAN DEFAULT FALSE;
```

---

## Flutter Data Models

```dart
// Badge definition model
class Badge {
  final String id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final BadgeCategory category;
  final String iconPath;
  final String culturalSignificanceEn;
  final String culturalSignificanceAr;
  final List<BadgeRequirement> unlockCriteria;
  final Map<BadgeTier, int> tierRequirements;

  Badge({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.category,
    required this.iconPath,
    required this.culturalSignificanceEn,
    required this.culturalSignificanceAr,
    required this.unlockCriteria,
    required this.tierRequirements,
  });
}

enum BadgeCategory { foundation, community, legacy }
enum BadgeTier { bronze, silver, gold }

// User badge achievement model
class UserBadge {
  final String badgeId;
  final int userId;
  final DateTime unlockedAt;
  final BadgeTier tier;
  final Map<String, dynamic> unlockContext;
  final bool isCelebrated;

  UserBadge({
    required this.badgeId,
    required this.userId,
    required this.unlockedAt,
    required this.tier,
    required this.unlockContext,
    required this.isCelebrated,
  });
}

// Badge progress tracking
class BadgeProgress {
  final String badgeId;
  final int userId;
  final Map<String, dynamic> progressData;
  final DateTime lastUpdated;

  BadgeProgress({
    required this.badgeId,
    required this.userId,
    required this.progressData,
    required this.lastUpdated,
  });
}
```

---

## Core Flutter Widgets

### 1. Badge Display Widget

```dart
class BadgeWidget extends StatelessWidget {
  final Badge badge;
  final UserBadge? userBadge;
  final bool isLocked;
  final VoidCallback? onTap;

  const BadgeWidget({
    Key? key,
    required this.badge,
    this.userBadge,
    this.isLocked = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked ? Colors.grey.shade300 : LebanesePalette.gold,
            width: 2,
          ),
          color: isLocked ? Colors.grey.shade100 : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              badge.iconPath,
              width: 32,
              height: 32,
              colorFilter: isLocked 
                ? ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                : null,
            ),
            SizedBox(height: 4),
            Text(
              badge.nameEn,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isLocked ? Colors.grey : LebanesePalette.primaryText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Badge Collection Grid

```dart
class BadgeCollectionGrid extends StatelessWidget {
  final List<Badge> allBadges;
  final List<UserBadge> userBadges;
  final Function(Badge) onBadgeTap;

  const BadgeCollectionGrid({
    Key? key,
    required this.allBadges,
    required this.userBadges,
    required this.onBadgeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: allBadges.length,
      itemBuilder: (context, index) {
        final badge = allBadges[index];
        final userBadge = userBadges.firstWhereOrNull(
          (ub) => ub.badgeId == badge.id,
        );
        final isLocked = userBadge == null;

        return BadgeWidget(
          badge: badge,
          userBadge: userBadge,
          isLocked: isLocked,
          onTap: () => onBadgeTap(badge),
        );
      },
    );
  }
}
```

### 3. Badge Unlock Celebration

```dart
class BadgeUnlockCelebration extends StatefulWidget {
  final Badge badge;
  final VoidCallback onComplete;

  const BadgeUnlockCelebration({
    Key? key,
    required this.badge,
    required this.onComplete,
  }) : super(key: key);

  @override
  _BadgeUnlockCelebrationState createState() => _BadgeUnlockCelebrationState();
}

class _BadgeUnlockCelebrationState extends State<BadgeUnlockCelebration>
    with TickerProviderStateMixin {
  
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCelebration();
  }

  void _setupAnimations() {
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  void _startCelebration() async {
    await _scaleController.forward();
    await _glowController.forward();
    await Future.delayed(Duration(milliseconds: 1500));
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleController, _glowController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: LebanesePalette.gold.withOpacity(_glowAnimation.value * 0.3),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 5 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            LebanesePalette.gold.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          widget.badge.iconPath,
                          width: 64,
                          height: 64,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.badge.nameEn,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LebanesePalette.primaryText,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.badge.descriptionEn,
                      style: TextStyle(
                        fontSize: 16,
                        color: LebanesePalette.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    
                    // Sharing buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareButton(
                          'Share',
                          Icons.share,
                          () => _showSharingOptions(context),
                        ),
                        _buildShareButton(
                          'Continue',
                          Icons.arrow_forward,
                          widget.onComplete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShareButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: LebanesePalette.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  void _showSharingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BadgeSharingModal(badge: widget.badge),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}
```

---

## Badge Unlock Logic Implementation

### 1. Badge Service Class

```dart
class BadgeService {
  static const List<String> _badgeIds = [
    'memory_keeper',
    'witness', 
    'voice',
    'mission_creator',
    'bridge_builder',
    'network_builder',
    'ambassador',
    'guardian',
    'trusted_voice',
    'peacemaker',
    'heritage_keeper',
    'community_leader',
  ];

  // Check for badge eligibility after user actions
  Future<List<Badge>> checkBadgeEligibility(int userId, UserAction action) async {
    List<Badge> newBadges = [];
    
    switch (action.type) {
      case UserActionType.storyApproved:
        newBadges.addAll(await _checkStoryBadges(userId, action));
        break;
      case UserActionType.missionCreated:
        newBadges.addAll(await _checkMissionBadges(userId, action));
        break;
      case UserActionType.userInvited:
        newBadges.addAll(await _checkNetworkBadges(userId, action));
        break;
    }

    return newBadges;
  }

  // Check story-related badges
  Future<List<Badge>> _checkStoryBadges(int userId, UserAction action) async {
    List<Badge> badges = [];
    
    // Memory Keeper - first approved story
    if (await _isFirstApprovedStory(userId)) {
      badges.add(await _getBadge('memory_keeper'));
    }
    
    // Witness - story with media
    if (action.data['hasMedia'] == true) {
      if (!await _userHasBadge(userId, 'witness')) {
        badges.add(await _getBadge('witness'));
      }
    }
    
    // Voice - audio/video story
    if (action.data['hasAudioVideo'] == true) {
      if (!await _userHasBadge(userId, 'voice')) {
        badges.add(await _getBadge('voice'));
      }
    }
    
    // Bridge Builder - contributed to someone else's mission
    if (action.data['missionId'] != null && action.data['isOwnMission'] != true) {
      if (!await _userHasBadge(userId, 'bridge_builder')) {
        badges.add(await _getBadge('bridge_builder'));
      }
    }
    
    // Check multi-story badges
    await _checkMultiStoryBadges(userId, badges);
    
    return badges;
  }

  // Award badge to user
  Future<void> awardBadge(int userId, String badgeId, Map<String, dynamic> context) async {
    final userBadge = UserBadge(
      badgeId: badgeId,
      userId: userId,
      unlockedAt: DateTime.now(),
      tier: BadgeTier.bronze,
      unlockContext: context,
      isCelebrated: false,
    );
    
    await _saveBadgeToDatabase(userBadge);
    await _updateUserBadgeCount(userId);
    await _triggerCelebration(userId, badgeId);
  }

  // Trigger celebration overlay
  Future<void> _triggerCelebration(int userId, String badgeId) async {
    final badge = await _getBadge(badgeId);
    
    // Show overlay in UI (use provider/bloc to trigger)
    BadgeNotificationProvider.instance.showBadgeUnlock(badge);
    
    // Mark as celebrated
    await _markBadgeCelebrated(userId, badgeId);
  }
}
```

### 2. User Action Tracking

```dart
enum UserActionType {
  storyApproved,
  storySubmitted,
  missionCreated,
  missionCompleted,
  userInvited,
  userRegistered,
  mediaUploaded,
}

class UserAction {
  final UserActionType type;
  final int userId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  UserAction({
    required this.type,
    required this.userId,
    required this.data,
    required this.timestamp,
  });
}

// Trigger badge checks after actions
class UserActionHandler {
  static final BadgeService _badgeService = BadgeService();

  static Future<void> handleAction(UserAction action) async {
    // Check for new badges
    final newBadges = await _badgeService.checkBadgeEligibility(
      action.userId, 
      action
    );
    
    // Award new badges
    for (final badge in newBadges) {
      await _badgeService.awardBadge(
        action.userId, 
        badge.id, 
        action.data
      );
    }
  }
}
```

---

## Integration Points

### 1. Story Submission Integration

```dart
// In story submission flow
class StorySubmissionService {
  Future<void> handleStoryApproval(Story story) async {
    // Existing story approval logic
    await _approveStory(story);
    
    // Trigger badge checking
    await UserActionHandler.handleAction(UserAction(
      type: UserActionType.storyApproved,
      userId: story.userId,
      data: {
        'storyId': story.id,
        'hasMedia': story.imageUrl != null || story.audioUrl != null,
        'hasAudioVideo': story.audioUrl != null || story.videoUrl != null,
        'missionId': story.contributedToMissionId,
        'isOwnMission': await _isOwnMission(story.userId, story.contributedToMissionId),
      },
      timestamp: DateTime.now(),
    ));
  }
}
```

### 2. Mission Integration

```dart
// In mission creation flow
class MissionService {
  Future<void> handleMissionSuccess(Mission mission) async {
    // Mission completion logic
    await _markMissionComplete(mission);
    
    // Trigger badge checking for creator
    await UserActionHandler.handleAction(UserAction(
      type: UserActionType.missionCompleted,
      userId: mission.creatorId,
      data: {
        'missionId': mission.id,
        'contributorCount': mission.contributorIds.length,
        'goalAchieved': mission.currentCount >= mission.goalCount,
      },
      timestamp: DateTime.now(),
    ));
  }
}
```

### 3. Profile Page Integration

```dart
// Enhanced profile page with badge display
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Badge> allBadges = [];
  List<UserBadge> userBadges = [];
  
  @override
  void initState() {
    super.initState();
    _loadBadgeData();
  }
  
  Future<void> _loadBadgeData() async {
    final badges = await BadgeService.getAllBadges();
    final userBadgeData = await BadgeService.getUserBadges(widget.userId);
    
    setState(() {
      allBadges = badges;
      userBadges = userBadgeData;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Existing profile content
            ProfileHeader(user: widget.user),
            
            // Badge collection section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Achievements',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  BadgeCollectionGrid(
                    allBadges: allBadges,
                    userBadges: userBadges,
                    onBadgeTap: _showBadgeDetails,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showBadgeDetails(Badge badge) {
    // Show badge detail modal
    showModalBottomSheet(
      context: context,
      builder: (context) => BadgeDetailModal(badge: badge),
    );
  }
}
```

---

## Testing Implementation

### 1. Badge Unlock Testing

```dart
// Test badge unlock triggers
class BadgeTestHelper {
  static Future<void> testMemoryKeeperBadge(int testUserId) async {
    // Create test story
    final story = Story(
      userId: testUserId,
      title: 'Test Story',
      content: 'Test content',
      isApproved: false,
    );
    
    // Submit and approve story
    await StoryService.submitStory(story);
    await StoryService.approveStory(story.id);
    
    // Verify badge was awarded
    final userBadges = await BadgeService.getUserBadges(testUserId);
    assert(userBadges.any((b) => b.badgeId == 'memory_keeper'));
  }
}
```

### 2. Performance Testing

```dart
// Test badge checking performance
class BadgePerformanceTest {
  static Future<void> testBulkBadgeChecking() async {
    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < 100; i++) {
      await BadgeService.checkBadgeEligibility(
        i,
        UserAction(
          type: UserActionType.storyApproved,
          userId: i,
          data: {},
          timestamp: DateTime.now(),
        ),
      );
    }
    
    stopwatch.stop();
    print('Badge checking for 100 users: ${stopwatch.elapsedMilliseconds}ms');
  }
}
```

---

## Performance Considerations

### 1. Caching Strategy
- Cache badge definitions in memory on app start
- Cache user badges locally with periodic sync
- Use badge progress table to avoid recalculating complex achievements

### 2. Database Optimization
- Index user_badges table on user_id and badge_id
- Use JSON columns for flexible criteria storage
- Batch badge checks where possible

### 3. Animation Performance
- Use Transform widgets for smooth animations
- Preload badge celebration animations
- Limit simultaneous badge celebrations to prevent performance issues

---

## Error Handling

### 1. Badge Award Failures
```dart
try {
  await BadgeService.awardBadge(userId, badgeId, context);
} catch (e) {
  // Log error but don't block user flow
  Logger.error('Badge award failed: $e');
  // Retry mechanism for important badges
  BadgeRetryQueue.add(userId, badgeId, context);
}
```

### 2. Celebration Display Failures
```dart
try {
  await _showBadgeCelebration(badge);
} catch (e) {
  // Fallback to simple notification
  _showSimpleBadgeNotification(badge);
}
```

---

## Badge Sharing System

### 1. Badge Sharing Modal

```dart
class BadgeSharingModal extends StatelessWidget {
  final Badge badge;
  final UserBadge? userBadge;

  const BadgeSharingModal({
    Key? key,
    required this.badge,
    this.userBadge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Share Your Achievement',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: LebanesePalette.primaryText,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Let others know about your contribution to preserving Lebanese memory',
                  style: TextStyle(
                    fontSize: 14,
                    color: LebanesePalette.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                
                // Badge display
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        LebanesePalette.gold.withOpacity(0.1),
                        LebanesePalette.cedar.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: LebanesePalette.gold.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        badge.iconPath,
                        width: 48,
                        height: 48,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.nameEn,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: LebanesePalette.primaryText,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              badge.culturalSignificanceEn,
                              style: TextStyle(
                                fontSize: 12,
                                color: LebanesePalette.secondaryText,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                
                // Sharing options
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    _buildSharingOption(
                      'WhatsApp',
                      Icons.chat,
                      LebanesePalette.whatsappGreen,
                      () => _shareToWhatsApp(context),
                    ),
                    _buildSharingOption(
                      'Social Media',
                      Icons.share,
                      LebanesePalette.socialBlue,
                      () => _shareToSocial(context),
                    ),
                    _buildSharingOption(
                      'Copy Link',
                      Icons.link,
                      LebanesePalette.linkPurple,
                      () => _copyBadgeLink(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharingOption(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareToWhatsApp(BuildContext context) async {
    final message = await SocialMessageService.getBadgeWhatsAppMessage(badge);
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/?text=$encodedMessage';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showErrorMessage(context, 'Could not open WhatsApp');
    }
  }

  Future<void> _shareToSocial(BuildContext context) async {
    final message = await SocialMessageService.getBadgeSocialMessage(badge);
    await Share.share(message);
  }

  Future<void> _copyBadgeLink(BuildContext context) async {
    final link = await SocialMessageService.getBadgeShareLink(badge);
    await Clipboard.setData(ClipboardData(text: link));
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Badge link copied to clipboard'),
        backgroundColor: LebanesePalette.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: LebanesePalette.error,
      ),
    );
  }
}
```

### 2. Social Message Service

```dart
class SocialMessageService {
  static Map<String, dynamic>? _messagesConfig;
  
  // Load messages from JSON config
  static Future<void> loadMessages() async {
    if (_messagesConfig == null) {
      final jsonString = await rootBundle.loadString('assets/config/social_messages.json');
      _messagesConfig = json.decode(jsonString);
    }
  }

  // Get WhatsApp sharing message for badge
  static Future<String> getBadgeWhatsAppMessage(Badge badge) async {
    await loadMessages();
    
    final template = _messagesConfig!['social_sharing_templates']
        ['badge_unlock']['whatsapp']['template_en'];
    final badgeConfig = _messagesConfig!['badge_celebrations'][badge.id];
    
    return template
        .replaceAll('{badge_name}', badge.nameEn)
        .replaceAll('{sharing_message}', badgeConfig['sharing_message_en'])
        .replaceAll('{app_link}', _messagesConfig!['app_info']['website']);
  }

  // Get social media sharing message for badge
  static Future<String> getBadgeSocialMessage(Badge badge) async {
    await loadMessages();
    
    final template = _messagesConfig!['social_sharing_templates']
        ['badge_unlock']['social_media']['template_en'];
    final badgeConfig = _messagesConfig!['badge_celebrations'][badge.id];
    final hashtags = (_messagesConfig!['app_info']['hashtags'] as List)
        .join(' ');
    
    return template
        .replaceAll('{badge_name}', badge.nameEn)
        .replaceAll('{sharing_message}', badgeConfig['sharing_message_en'])
        .replaceAll('{app_link}', _messagesConfig!['app_info']['website'])
        .replaceAll('{hashtags}', hashtags);
  }

  // Get legacy page WhatsApp message
  static Future<String> getLegacyWhatsAppMessage(
    User user,
    int storyCount,
    int badgeCount,
    int communityImpact,
  ) async {
    await loadMessages();
    
    final template = _messagesConfig!['social_sharing_templates']
        ['legacy_page']['whatsapp']['template_en'];
    
    return template
        .replaceAll('{story_count}', storyCount.toString())
        .replaceAll('{badge_count}', badgeCount.toString())
        .replaceAll('{community_impact}', communityImpact.toString())
        .replaceAll('{legacy_link}', await _getLegacyPageLink(user))
        .replaceAll('{app_link}', _messagesConfig!['app_info']['website']);
  }

  // Get legacy page social media message
  static Future<String> getLegacySocialMessage(
    User user,
    int storyCount,
    int badgeCount,
    int communityImpact,
  ) async {
    await loadMessages();
    
    final template = _messagesConfig!['social_sharing_templates']
        ['legacy_page']['social_media']['template_en'];
    final hashtags = (_messagesConfig!['app_info']['hashtags'] as List)
        .join(' ');
    
    return template
        .replaceAll('{badge_count}', badgeCount.toString())
        .replaceAll('{story_count}', storyCount.toString())
        .replaceAll('{community_impact}', communityImpact.toString())
        .replaceAll('{legacy_link}', await _getLegacyPageLink(user))
        .replaceAll('{app_link}', _messagesConfig!['app_info']['website'])
        .replaceAll('{hashtags}', hashtags);
  }

  // Get family sharing message for legacy
  static Future<String> getLegacyFamilyMessage(
    User user,
    int storyCount,
    String timePeriod,
  ) async {
    await loadMessages();
    
    final template = _messagesConfig!['social_sharing_templates']
        ['legacy_page']['family_sharing']['template_en'];
    
    return template
        .replaceAll('{time_period}', timePeriod)
        .replaceAll('{story_count}', storyCount.toString())
        .replaceAll('{legacy_link}', await _getLegacyPageLink(user))
        .replaceAll('{app_link}', _messagesConfig!['app_info']['website']);
  }

  // Generate badge share link
  static Future<String> getBadgeShareLink(Badge badge) async {
    final baseUrl = _messagesConfig!['app_info']['website'];
    return '$baseUrl/badge/${badge.id}?ref=user_share';
  }

  // Generate legacy page link
  static Future<String> _getLegacyPageLink(User user) async {
    final baseUrl = _messagesConfig!['app_info']['website'];
    return '$baseUrl/legacy/${user.id}?ref=legacy_share';
  }

  // Get celebration text for badge unlock
  static Future<String> getBadgeCelebrationText(Badge badge) async {
    await loadMessages();
    
    final badgeConfig = _messagesConfig!['badge_celebrations'][badge.id];
    return badgeConfig['celebration_text_en'];
  }

  // Get notification message for badge unlock
  static Future<String> getBadgeNotificationMessage(Badge badge) async {
    await loadMessages();
    
    final template = _messagesConfig!['notification_messages']
        ['badge_unlocked']['body_template_en'];
    
    return template.replaceAll('{badge_name}', badge.nameEn);
  }
}
```