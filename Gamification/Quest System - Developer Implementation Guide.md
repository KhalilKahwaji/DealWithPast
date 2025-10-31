# Quest System - Developer Implementation Guide

**Target Audience:** Flutter Developers  
**Component:** Community Quest Creation with Discovery (Pillar 1)  
**Implementation:** Mission system, sharing, map/timeline discoverability  

---

## System Overview

The quest system enables users to create "Memory Missions" for collecting specific stories, discover missions through geographic and temporal browsing, follow missions for updates, and progress to ambassador status. The system includes sharing capabilities, map integration, and timeline integration with filtering between content and missions.

**IMPORTANT UI NOTE:** Both map and timeline views require 2 filter buttons:
1. **Content Only** - Shows only stories/content
2. **Missions Only** - Shows only active missions/quests

---

## Database Schema Requirements

### Core Tables

```sql
-- Missions/Quests table
CREATE TABLE missions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  creator_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  goal_count INT NOT NULL DEFAULT 10,
  current_count INT NOT NULL DEFAULT 0,
  start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  end_date TIMESTAMP NULL,
  status ENUM('active', 'completed', 'expired', 'paused') DEFAULT 'active',
  category ENUM('geographic', 'temporal', 'thematic', 'family') NOT NULL,
  geographic_region VARCHAR(100) NULL,
  time_period_start DATE NULL,
  time_period_end DATE NULL,
  tags JSON NULL,
  sharing_code VARCHAR(20) UNIQUE NOT NULL,
  visibility ENUM('public', 'private', 'invite_only') DEFAULT 'public',
  cultural_sensitivity_approved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (creator_id) REFERENCES users(id),
  INDEX idx_status_region (status, geographic_region),
  INDEX idx_category_period (category, time_period_start, time_period_end),
  INDEX idx_sharing_code (sharing_code)
);

-- Mission followers/participants
CREATE TABLE mission_followers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mission_id INT NOT NULL,
  user_id INT NOT NULL,
  follow_type ENUM('follower', 'contributor', 'ambassador') DEFAULT 'follower',
  followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  recruitment_count INT DEFAULT 0,
  contribution_count INT DEFAULT 0,
  FOREIGN KEY (mission_id) REFERENCES missions(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE KEY unique_mission_follower (mission_id, user_id)
);

-- Mission invitations and sharing
CREATE TABLE mission_invitations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mission_id INT NOT NULL,
  inviter_id INT NOT NULL,
  invited_user_id INT NULL, -- null for general sharing
  invitation_method ENUM('link', 'whatsapp', 'social', 'email', 'direct') NOT NULL,
  invitation_code VARCHAR(50) UNIQUE NOT NULL,
  invited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  accepted_at TIMESTAMP NULL,
  is_accepted BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (mission_id) REFERENCES missions(id) ON DELETE CASCADE,
  FOREIGN KEY (inviter_id) REFERENCES users(id),
  FOREIGN KEY (invited_user_id) REFERENCES users(id)
);

-- Mission progress tracking
CREATE TABLE mission_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mission_id INT NOT NULL,
  milestone_type ENUM('story_added', 'follower_joined', 'goal_reached', 'ambassador_promoted') NOT NULL,
  related_user_id INT NULL,
  related_story_id INT NULL,
  progress_data JSON NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (mission_id) REFERENCES missions(id) ON DELETE CASCADE,
  FOREIGN KEY (related_user_id) REFERENCES users(id),
  FOREIGN KEY (related_story_id) REFERENCES stories(id)
);
```

### Required Table Extensions

```sql
-- Add to existing stories table for mission linking
ALTER TABLE stories ADD COLUMN mission_id INT NULL;
ALTER TABLE stories ADD COLUMN mission_contribution_context JSON NULL;
ALTER TABLE stories ADD INDEX idx_mission_id (mission_id);

-- Add to existing users table for mission stats
ALTER TABLE users ADD COLUMN missions_created_count INT DEFAULT 0;
ALTER TABLE users ADD COLUMN missions_followed_count INT DEFAULT 0;
ALTER TABLE users ADD COLUMN ambassador_status_count INT DEFAULT 0;
```

---

## Flutter Data Models

```dart
// Mission model
class Mission {
  final int id;
  final int creatorId;
  final String title;
  final String description;
  final int goalCount;
  final int currentCount;
  final DateTime startDate;
  final DateTime? endDate;
  final MissionStatus status;
  final MissionCategory category;
  final String? geographicRegion;
  final DateTime? timePeriodStart;
  final DateTime? timePeriodEnd;
  final List<String> tags;
  final String sharingCode;
  final MissionVisibility visibility;
  final bool culturalSensitivityApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mission({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.goalCount,
    required this.currentCount,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.category,
    this.geographicRegion,
    this.timePeriodStart,
    this.timePeriodEnd,
    required this.tags,
    required this.sharingCode,
    required this.visibility,
    required this.culturalSensitivityApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progressPercentage => 
    goalCount > 0 ? (currentCount / goalCount).clamp(0.0, 1.0) : 0.0;
}

enum MissionStatus { active, completed, expired, paused }
enum MissionCategory { geographic, temporal, thematic, family }
enum MissionVisibility { public, private, inviteOnly }

// Mission follower model
class MissionFollower {
  final int missionId;
  final int userId;
  final FollowType followType;
  final DateTime followedAt;
  final DateTime lastActivity;
  final int recruitmentCount;
  final int contributionCount;

  MissionFollower({
    required this.missionId,
    required this.userId,
    required this.followType,
    required this.followedAt,
    required this.lastActivity,
    required this.recruitmentCount,
    required this.contributionCount,
  });
}

enum FollowType { follower, contributor, ambassador }

// Mission invitation model
class MissionInvitation {
  final int missionId;
  final int inviterId;
  final int? invitedUserId;
  final InvitationMethod invitationMethod;
  final String invitationCode;
  final DateTime invitedAt;
  final DateTime? acceptedAt;
  final bool isAccepted;

  MissionInvitation({
    required this.missionId,
    required this.inviterId,
    this.invitedUserId,
    required this.invitationMethod,
    required this.invitationCode,
    required this.invitedAt,
    this.acceptedAt,
    required this.isAccepted,
  });
}

enum InvitationMethod { link, whatsapp, social, email, direct }
```

---

## Core Flutter Widgets

### 1. Mission Card Widget

```dart
class MissionCard extends StatelessWidget {
  final Mission mission;
  final bool isFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onTap;
  final bool showProgress;

  const MissionCard({
    Key? key,
    required this.mission,
    this.isFollowing = false,
    this.onFollow,
    this.onTap,
    this.showProgress = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: LebanesePalette.primaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          mission.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: LebanesePalette.secondaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  _buildMissionIcon(),
                ],
              ),
              
              if (showProgress) ...[
                SizedBox(height: 12),
                _buildProgressBar(),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${mission.currentCount}/${mission.goalCount} stories',
                      style: TextStyle(
                        fontSize: 12,
                        color: LebanesePalette.secondaryText,
                      ),
                    ),
                    Text(
                      _getTimeRemaining(),
                      style: TextStyle(
                        fontSize: 12,
                        color: LebanesePalette.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
              
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCreatorInfo(),
                  _buildActionButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionIcon() {
    IconData icon;
    Color color;
    
    switch (mission.category) {
      case MissionCategory.geographic:
        icon = Icons.location_on;
        color = LebanesePalette.geographicBlue;
        break;
      case MissionCategory.temporal:
        icon = Icons.schedule;
        color = LebanesePalette.temporalOrange;
        break;
      case MissionCategory.family:
        icon = Icons.family_restroom;
        color = LebanesePalette.familyPurple;
        break;
      default:
        icon = Icons.campaign;
        color = LebanesePalette.thematicGreen;
    }
    
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.grey[200],
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: mission.progressPercentage,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(
              colors: [
                LebanesePalette.progressStart,
                LebanesePalette.progressEnd,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (!isFollowing)
          OutlinedButton(
            onPressed: onFollow,
            style: OutlinedButton.styleFrom(
              foregroundColor: LebanesePalette.primary,
              side: BorderSide(color: LebanesePalette.primary),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text('Follow', style: TextStyle(fontSize: 12)),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: LebanesePalette.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: LebanesePalette.primary,
                ),
                SizedBox(width: 4),
                Text(
                  'Following',
                  style: TextStyle(
                    fontSize: 12,
                    color: LebanesePalette.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(width: 8),
        IconButton(
          onPressed: () => _shareMission(context),
          icon: Icon(Icons.share, size: 18),
          padding: EdgeInsets.all(4),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  void _shareMission(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MissionSharingModal(mission: mission),
    );
  }

  String _getTimeRemaining() {
    if (mission.endDate == null) return 'Ongoing';
    
    final now = DateTime.now();
    final remaining = mission.endDate!.difference(now);
    
    if (remaining.isNegative) return 'Expired';
    if (remaining.inDays > 0) return '${remaining.inDays} days left';
    if (remaining.inHours > 0) return '${remaining.inHours} hours left';
    return 'Ending soon';
  }
}
```

### 2. Quest Banner Widget (Home Screen)

```dart
class QuestBanner extends StatelessWidget {
  final Mission? featuredMission;
  final bool isUserFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onViewDetails;

  const QuestBanner({
    Key? key,
    this.featuredMission,
    this.isUserFollowing = false,
    this.onFollow,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (featuredMission == null) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LebanesePalette.bannerGradientStart,
            LebanesePalette.bannerGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: LebanesePalette.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.campaign,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Active Mission',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              featuredMission!.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withOpacity(0.3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: featuredMission!.progressPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${featuredMission!.currentCount}/${featuredMission!.goalCount} stories collected',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                if (!isUserFollowing)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: LebanesePalette.primary,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Join Mission'),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Following - View Details'),
                    ),
                  ),
                SizedBox(width: 12),
                IconButton(
                  onPressed: () => _shareMission(context),
                  icon: Icon(Icons.share, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareMission(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MissionSharingModal(mission: featuredMission!),
    );
  }
}
```

### 3. Map Integration with Mission Filter

```dart
class EnhancedMapView extends StatefulWidget {
  @override
  _EnhancedMapViewState createState() => _EnhancedMapViewState();
}

class _EnhancedMapViewState extends State<EnhancedMapView> {
  MapDisplayMode _displayMode = MapDisplayMode.all;
  List<Story> _stories = [];
  List<Mission> _missions = [];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter buttons (REQUIRED)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildFilterButton(
                  'Content Only',
                  MapDisplayMode.contentOnly,
                  Icons.article,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFilterButton(
                  'Missions Only', 
                  MapDisplayMode.missionsOnly,
                  Icons.campaign,
                ),
              ),
            ],
          ),
        ),
        
        // Map view
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _buildMarkers(),
            initialCameraPosition: CameraPosition(
              target: LatLng(33.8547, 35.8623), // Beirut center
              zoom: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, MapDisplayMode mode, IconData icon) {
    final isSelected = _displayMode == mode;
    
    return ElevatedButton.icon(
      onPressed: () => _setDisplayMode(mode),
      icon: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : LebanesePalette.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : LebanesePalette.primary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
          ? LebanesePalette.primary 
          : LebanesePalette.primary.withOpacity(0.1),
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _setDisplayMode(MapDisplayMode mode) {
    setState(() {
      _displayMode = mode;
    });
    _loadMapData();
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};
    
    // Add story markers if showing content
    if (_displayMode == MapDisplayMode.all || _displayMode == MapDisplayMode.contentOnly) {
      for (final story in _stories) {
        if (story.latitude != null && story.longitude != null) {
          markers.add(Marker(
            markerId: MarkerId('story_${story.id}'),
            position: LatLng(story.latitude!, story.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: story.title,
              snippet: story.excerpt,
            ),
            onTap: () => _showStoryDetails(story),
          ));
        }
      }
    }
    
    // Add mission markers if showing missions
    if (_displayMode == MapDisplayMode.all || _displayMode == MapDisplayMode.missionsOnly) {
      for (final mission in _missions) {
        if (mission.geographicRegion != null) {
          final coords = _getRegionCoordinates(mission.geographicRegion!);
          if (coords != null) {
            markers.add(Marker(
              markerId: MarkerId('mission_${mission.id}'),
              position: coords,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              infoWindow: InfoWindow(
                title: mission.title,
                snippet: '${mission.currentCount}/${mission.goalCount} stories',
              ),
              onTap: () => _showMissionDetails(mission),
            ));
          }
        }
      }
    }
    
    return markers;
  }
}

enum MapDisplayMode { all, contentOnly, missionsOnly }
```

### 4. Timeline Integration with Mission Filter

```dart
class EnhancedTimelineView extends StatefulWidget {
  @override
  _EnhancedTimelineViewState createState() => _EnhancedTimelineViewState();
}

class _EnhancedTimelineViewState extends State<EnhancedTimelineView> {
  TimelineDisplayMode _displayMode = TimelineDisplayMode.all;
  List<TimelineItem> _timelineItems = [];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter buttons (REQUIRED)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildFilterButton(
                  'Content Only',
                  TimelineDisplayMode.contentOnly,
                  Icons.article,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFilterButton(
                  'Missions Only',
                  TimelineDisplayMode.missionsOnly,
                  Icons.campaign,
                ),
              ),
            ],
          ),
        ),
        
        // Timeline view
        Expanded(
          child: ListView.builder(
            itemCount: _timelineItems.length,
            itemBuilder: (context, index) {
              final item = _timelineItems[index];
              
              if (item.type == TimelineItemType.story) {
                return StoryTimelineCard(story: item.story!);
              } else {
                return MissionTimelineCard(mission: item.mission!);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, TimelineDisplayMode mode, IconData icon) {
    final isSelected = _displayMode == mode;
    
    return ElevatedButton.icon(
      onPressed: () => _setDisplayMode(mode),
      icon: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : LebanesePalette.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : LebanesePalette.primary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
          ? LebanesePalette.primary 
          : LebanesePalette.primary.withOpacity(0.1),
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _setDisplayMode(TimelineDisplayMode mode) {
    setState(() {
      _displayMode = mode;
    });
    _loadTimelineData();
  }

  Future<void> _loadTimelineData() async {
    List<TimelineItem> items = [];
    
    // Load stories if showing content
    if (_displayMode == TimelineDisplayMode.all || _displayMode == TimelineDisplayMode.contentOnly) {
      final stories = await StoryService.getStoriesForTimeline();
      items.addAll(stories.map((s) => TimelineItem.story(s)));
    }
    
    // Load missions if showing missions
    if (_displayMode == TimelineDisplayMode.all || _displayMode == TimelineDisplayMode.missionsOnly) {
      final missions = await MissionService.getMissionsForTimeline();
      items.addAll(missions.map((m) => TimelineItem.mission(m)));
    }
    
    // Sort by date
    items.sort((a, b) => b.date.compareTo(a.date));
    
    setState(() {
      _timelineItems = items;
    });
  }
}

enum TimelineDisplayMode { all, contentOnly, missionsOnly }

class TimelineItem {
  final TimelineItemType type;
  final DateTime date;
  final Story? story;
  final Mission? mission;

  TimelineItem.story(Story this.story) 
    : type = TimelineItemType.story,
      date = story!.createdAt,
      mission = null;

  TimelineItem.mission(Mission this.mission)
    : type = TimelineItemType.mission,
      date = mission!.createdAt,
      story = null;
}

enum TimelineItemType { story, mission }
```

---

## Mission Creation Flow

### 1. Mission Creation Wizard

```dart
class MissionCreationWizard extends StatefulWidget {
  @override
  _MissionCreationWizardState createState() => _MissionCreationWizardState();
}

class _MissionCreationWizardState extends State<MissionCreationWizard> {
  PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form data
  MissionCategory? _selectedCategory;
  String _title = '';
  String _description = '';
  int _goalCount = 10;
  String? _geographicRegion;
  DateTimeRange? _timePeriod;
  List<String> _tags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Mission'),
        backgroundColor: LebanesePalette.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 4,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(LebanesePalette.primary),
          ),
          
          // Wizard steps
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildCategoryStep(),
                _buildDetailsStep(),
                _buildTargetingStep(),
                _buildReviewStep(),
              ],
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentStep < 3 ? _nextStep : _createMission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LebanesePalette.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentStep < 3 ? 'Next' : 'Create Mission'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStep() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What type of mission do you want to create?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LebanesePalette.primaryText,
            ),
          ),
          SizedBox(height: 32),
          
          _buildCategoryOption(
            MissionCategory.geographic,
            'Geographic Mission',
            'Collect stories from a specific region or neighborhood',
            Icons.location_on,
            LebanesePalette.geographicBlue,
          ),
          
          _buildCategoryOption(
            MissionCategory.temporal,
            'Time Period Mission', 
            'Gather memories from a specific time period or era',
            Icons.schedule,
            LebanesePalette.temporalOrange,
          ),
          
          _buildCategoryOption(
            MissionCategory.family,
            'Family Mission',
            'Preserve stories from your family and relatives',
            Icons.family_restroom,
            LebanesePalette.familyPurple,
          ),
          
          _buildCategoryOption(
            MissionCategory.thematic,
            'Thematic Mission',
            'Focus on specific experiences or life aspects',
            Icons.campaign,
            LebanesePalette.thematicGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(
    MissionCategory category,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedCategory == category;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: LebanesePalette.primaryText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: LebanesePalette.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: color,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null;
      case 1:
        return _title.isNotEmpty && _description.isNotEmpty;
      case 2:
        return true; // Optional targeting
      case 3:
        return true; // Review step
      default:
        return false;
    }
  }

  Future<void> _createMission() async {
    try {
      final mission = await MissionService.createMission(
        category: _selectedCategory!,
        title: _title,
        description: _description,
        goalCount: _goalCount,
        geographicRegion: _geographicRegion,
        timePeriodStart: _timePeriod?.start,
        timePeriodEnd: _timePeriod?.end,
        tags: _tags,
      );
      
      // Navigate to mission details
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MissionDetailsPage(mission: mission),
        ),
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mission created successfully!'),
          backgroundColor: LebanesePalette.success,
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create mission: $e'),
          backgroundColor: LebanesePalette.error,
        ),
      );
    }
  }
}
```

---

## Mission Sharing System

### 1. Mission Sharing Modal

```dart
class MissionSharingModal extends StatelessWidget {
  final Mission mission;

  const MissionSharingModal({
    Key? key,
    required this.mission,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          
          Text(
            'Share Mission',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: LebanesePalette.primaryText,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Help others discover and contribute to this memory mission',
            style: TextStyle(
              fontSize: 14,
              color: LebanesePalette.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          
          // Sharing options
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildSharingOption(
                'WhatsApp',
                Icons.chat,
                LebanesePalette.whatsappGreen,
                () => _shareToWhatsApp(context),
              ),
              _buildSharingOption(
                'Copy Link',
                Icons.link,
                LebanesePalette.linkBlue,
                () => _copyLink(context),
              ),
              _buildSharingOption(
                'Social Media',
                Icons.share,
                LebanesePalette.socialPurple,
                () => _shareToSocial(context),
              ),
            ],
          ),
          SizedBox(height: 24),
          
          // Mission preview card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  mission.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: LebanesePalette.secondaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: LebanesePalette.secondaryText,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${mission.currentCount}/${mission.goalCount} stories',
                      style: TextStyle(
                        fontSize: 12,
                        color: LebanesePalette.secondaryText,
                      ),
                    ),
                  ],
                ),
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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
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
    final message = _buildShareMessage();
    final encodedMessage = Uri.encodeComponent(message);
    final url = 'https://wa.me/?text=$encodedMessage';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showErrorMessage(context, 'Could not open WhatsApp');
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    final link = _generateMissionLink();
    await Clipboard.setData(ClipboardData(text: link));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mission link copied to clipboard'),
        backgroundColor: LebanesePalette.success,
      ),
    );
  }

  Future<void> _shareToSocial(BuildContext context) async {
    final message = _buildShareMessage();
    await Share.share(message);
  }

  String _buildShareMessage() {
    return '''
🇱🇧 Help preserve Lebanese memory!

Join the mission: "${mission.title}"

${mission.description}

Progress: ${mission.currentCount}/${mission.goalCount} stories collected

Share your memory: ${_generateMissionLink()}

#LebaneseMemo ry #PreserveOurStories
''';
  }

  String _generateMissionLink() {
    return 'https://lebanesememory.app/mission/${mission.sharingCode}';
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

---

## Mission Service Implementation

```dart
class MissionService {
  // Create new mission
  static Future<Mission> createMission({
    required MissionCategory category,
    required String title,
    required String description,
    required int goalCount,
    String? geographicRegion,
    DateTime? timePeriodStart,
    DateTime? timePeriodEnd,
    List<String> tags = const [],
  }) async {
    final sharingCode = _generateSharingCode();
    
    final missionData = {
      'creator_id': UserService.currentUser.id,
      'title': title,
      'description': description,
      'goal_count': goalCount,
      'category': category.name,
      'geographic_region': geographicRegion,
      'time_period_start': timePeriodStart?.toIso8601String(),
      'time_period_end': timePeriodEnd?.toIso8601String(),
      'tags': jsonEncode(tags),
      'sharing_code': sharingCode,
      'status': 'active',
    };
    
    final response = await ApiService.post('/missions', missionData);
    return Mission.fromJson(response);
  }

  // Follow mission
  static Future<void> followMission(int missionId) async {
    await ApiService.post('/missions/$missionId/follow', {
      'user_id': UserService.currentUser.id,
      'follow_type': 'follower',
    });
    
    // Track badge eligibility
    await UserActionHandler.handleAction(UserAction(
      type: UserActionType.missionFollowed,
      userId: UserService.currentUser.id,
      data: {'missionId': missionId},
      timestamp: DateTime.now(),
    ));
  }

  // Get missions for map display
  static Future<List<Mission>> getMissionsForMap({
    String? region,
    MissionStatus? status,
  }) async {
    final params = <String, dynamic>{};
    if (region != null) params['region'] = region;
    if (status != null) params['status'] = status.name;
    
    final response = await ApiService.get('/missions/map', params);
    return (response as List).map((m) => Mission.fromJson(m)).toList();
  }

  // Get missions for timeline display  
  static Future<List<Mission>> getMissionsForTimeline({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['start_date'] = startDate.toIso8601String();
    if (endDate != null) params['end_date'] = endDate.toIso8601String();
    
    final response = await ApiService.get('/missions/timeline', params);
    return (response as List).map((m) => Mission.fromJson(m)).toList();
  }

  // Generate unique sharing code
  static String _generateSharingCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }
}
```

This implementation guide provides complete Flutter code for the quest system with sharing, map integration, timeline integration, and the required filter buttons for both map and timeline views. The system is designed to work seamlessly with the existing app while adding sophisticated mission discovery and community building capabilities.