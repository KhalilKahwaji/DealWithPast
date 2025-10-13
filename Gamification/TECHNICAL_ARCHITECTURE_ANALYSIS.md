# Technical Architecture Analysis - DealWithPast Gamification
**Date:** October 10, 2025
**Analyst:** Z (Project Manager Agent)
**Purpose:** Deep technical analysis of existing architecture and gamification integration strategy

---

## Executive Summary

This document provides a comprehensive analysis of the DealWithPast mobile app's current architecture and identifies integration points, technical challenges, and implementation strategies for the 2-Pillar Gamification System.

**Key Finding:** The app uses a **Flutter mobile app + WordPress REST API** architecture. The map is **NOT a plugin** - it's native Google Maps Flutter with custom marker clustering. This is GOOD for gamification integration.

---

## Current Tech Stack Analysis

### Frontend: Flutter Mobile App

**Framework:**
- **Flutter SDK:** 3.10.6 (Dart 3.0.6) - **LOCKED VERSION** ⚠️
- **Platform:** iOS, Android, Web (Chrome tested)
- **App Version:** 8.2.3+823
- **Package Name:** `interactive_map`

**Critical Dependencies for Gamification:**
```yaml
google_maps_flutter: ^2.1.1              # Native map (not plugin!)
google_maps_cluster_manager: ^3.0.0     # Marker clustering
firebase_auth: ^4.1.1                    # Authentication
firebase_core: ^2.1.1                    # Firebase integration
sqflite: (latest)                        # Local database
cached_network_image: ^3.1.0+1          # Image caching
```

**Architecture Pattern:**
- StatefulWidget-based state management
- No Provider/Riverpod/Bloc detected
- Direct API calls from UI layer (no service layer abstraction)
- Local caching with SQLite

---

## Backend: WordPress REST API

### WordPress Site
**URL:** `http://dwp.world` (⚠️ Note: HTTP, not HTTPS in some endpoints)

### Current API Endpoints

#### 1. Authentication (JWT Auth Plugin)
```
POST https://dwp.world/wp-json/jwt-auth/v1/token
Body: { "username": "...", "password": "..." }
Response: { "token": "...", "user_email": "...", "user_nicename": "..." }
```

**Security Issue Found:**
- `lib/Repos/UserRepo.dart:43` - Hardcoded admin credentials in code! 🚨
- **Recommendation:** Remove hardcoded credentials before gamification launch

#### 2. User Registration
```
POST https://dwp.world/wp-json/wp/v2/users/register
Headers: { "Authorization": "Bearer {token}" }
Body: { "username": "...", "email": "...", "password": "..." }
```

#### 3. Stories (Custom Post Type)
```
GET http://dwp.world/wp-json/wp/v2/stories/?per_page=100&page={pageNum}
Headers: { "Authorization": "Bearer {token}" }

GET http://dwp.world/wp-json/wp/v2/stories/?status=pending
Filter by author: (client-side filtering after fetch)

POST https://dwp.world/wp-json/wp/v2/stories/
```

**Story Data Structure (ACF Fields):**
```json
{
  "title": { "rendered": "..." },
  "content": { "rendered": "..." },
  "date_gmt": "...",
  "author": 123,
  "status": "publish|pending",
  "better_featured_image": { "source_url": "..." },
  "acf": {
    "event_date": "DD/MM/YYYY",
    "gallery": [...],
    "anonymous": true|false,
    "targeted_person": "...",
    "map_location": {
      "name": "Location Name",
      "lat": 33.xxxx,
      "lng": 35.xxxx
    }
  }
}
```

---

## Map Implementation Deep Dive

### Current Map Architecture (lib/Map/map.dart)

**Map Setup:**
```dart
class MapPage extends StatefulWidget {
  // Initial camera position: Lebanon center
  static const _initialCameraPosition =
    CameraPosition(target: LatLng(33.8547, 35.9623), zoom: 8.5, bearing: 10);

  // Map boundaries (Lebanon only)
  cameraTargetBounds: CameraTargetBounds(LatLngBounds(
    northeast: LatLng(34.6566324, 36.6896525),
    southwest: LatLng(33.4569738, 35.4935346)
  ));
}
```

**Story Marker System:**
1. **Single Story Marker:**
   - Circular custom marker with story's featured image
   - Created using Canvas drawing (custom `getBytesFromAsset`)
   - Size: ~130x130px responsive

2. **Grouped Story Marker:**
   - Multiple stories at same location
   - Shows count badge in Arabic numerals (٠-٩)
   - Created using `getBytesFromCanvas` with number overlay
   - Size: ~200x200px responsive

**Marker Creation Process:**
```dart
// Custom marker with image
BitmapDescriptor.fromBytes(
  await getBytesFromAsset(
    story.featured_image,
    width,
    height,
    size
  )
)

// Grouped marker with count badge
BitmapDescriptor.fromBytes(
  await getBytesFromCanvas(
    story.featured_image,
    ui.Size(width, height),
    storyCount  // Displayed as Arabic numerals
  )
)
```

**Clustering:**
- Uses `google_maps_cluster_manager` package
- Groups stories by `locationName` (not by coordinates!)
- Manual grouping: `groupBy(stories, (Story s) => s.locationName)`

**Story Display:**
- Tap marker → Bottom sheet slides up (300px height)
- Shows: Image, Location, Date (in Arabic), "Read More" button
- Grouped markers → Shows list of all stories at that location

---

## Data Models Analysis

### Current Story Model (lib/Repos/StoryClass.dart)
```dart
class Story {
  final String title;
  final String description;
  final String event_date;         // DD/MM/YYYY format
  final String targeted_person;
  final String date_submitted;
  final String status;             // publish|pending
  final String featured_image;     // URL
  final dynamic author;            // WordPress user ID (int)
  final dynamic locationName;      // String
  final dynamic lat;               // double
  final dynamic lng;               // double
  final dynamic gallery;           // Array or false
  final dynamic anonymous;         // bool
  final dynamic link;              // WordPress permalink
}
```

### Current User Model (lib/Repos/UserClass.dart)
**Note:** Need to read this file to understand user structure for achievements

---

## Local Caching System

### Story Cache (lib/Map/map.dart:78-96)
```dart
Future<File> get _localFile async {
  final path = await getApplicationDocumentsDirectory();
  return File('$path/stories.json');
}

Future<dynamic> readCounter() async {
  final file = await _localFile;
  final contents = await file.readAsString();
  var data = await json.decode(contents);
  for (int i = 0; i < data.length; i++) {
    stories.add(Story.fromJson(data[i]));
  }
}
```

**Cache Strategy:**
- Stories cached locally as JSON
- Read on map initialization
- Appears to be write-once (no cache invalidation logic visible)

---

## Integration Points for Gamification

### ✅ EASY Integration Points

#### 1. Map Enhancement for Mission Discovery
**Current:** `lib/Map/map.dart` (637 lines)
**Strategy:**
- Map already supports custom markers with images
- Can create new mission marker style (different color/icon)
- Clustering already works - can extend to missions
- Add map layer toggle: Stories vs Missions vs Both

**Technical Approach:**
```dart
// New mission marker creation
BitmapDescriptor createMissionMarker(Mission mission) {
  // Similar to getBytesFromAsset but with mission icon
  // Different color scheme (e.g., blue for missions vs current style)
}

// Add mission layer
List<Marker> missionMarkers = [];
Set<Marker> allMapMarkers = Set.from([
  ...allMarkers,        // Story markers
  ...missionMarkers     // Mission markers
]);
```

#### 2. Home Screen Quest Banner
**Current:** `lib/Homepages/` (need to investigate structure)
**Strategy:**
- Add banner widget above existing featured stories
- Use StatefulWidget with mission priority algorithm
- Pull from mission API endpoint

#### 3. Story Submission Enhancement
**Current:** `lib/My Stories/addStory.dart`
**Strategy:**
- Add optional mission tagging to story submission form
- Link story to mission_id in WordPress post meta
- No major refactoring needed

### ⚠️ MEDIUM Complexity Integration Points

#### 4. User Profile & Achievements
**Current:** Multiple profile files (`profile*.dart`)
**Strategy:**
- Create new unified achievement page
- Query WordPress for user achievements
- Progressive layout based on achievement count
- Use `cached_network_image` for badge assets

#### 5. Follow System
**Current:** No existing follow system
**Strategy:**
- Need new WordPress endpoint for relationships
- Local SQLite table for follow cache
- Push notifications (may need Firebase Cloud Messaging setup)

### 🚨 HIGH Complexity Integration Points

#### 6. Memorial Plaque Generator
**Current:** No existing similar feature
**Strategy:**
- Canvas-based PDF/image generation
- Lebanese cultural design assets needed
- QR code generation (`qr_flutter` package)
- Family sharing integration with native share sheet

---

## WordPress Backend Requirements

### NEW Custom Post Type Needed: `missions`

**Required Fields (ACF):**
```json
{
  "title": "Mission Title",
  "description": "Mission Description",
  "creator_id": 123,
  "goal_count": 10,
  "current_count": 7,
  "start_date": "2025-10-10",
  "end_date": "2025-11-10",
  "status": "active|completed|expired",
  "target_area": {
    "region": "Beirut",
    "center_lat": 33.xxxx,
    "center_lng": 35.xxxx,
    "radius_km": 5,
    "neighborhoods": ["Dahiye", "Hamra"]
  },
  "target_period": {
    "start_year": 1975,
    "end_year": 1982,
    "decade_label": "Early War"
  },
  "tags": ["civil_war", "displacement"],
  "follower_ids": [123, 456],
  "ambassador_ids": [123]
}
```

### NEW Database Tables/Meta Needed

#### 1. Mission-Story Links
```sql
wp_postmeta:
  post_id (mission_id)
  meta_key: 'linked_stories'
  meta_value: [story_id_1, story_id_2, ...]
```

#### 2. Follow Relationships
```sql
wp_user_missions: (new table)
  user_id
  mission_id
  follow_date
  status (following|ambassador|co-creator)
  recruitment_count
```

#### 3. User Achievements
```sql
wp_user_achievements: (new table)
  user_id
  achievement_type (memory_keeper|bridge_builder|etc)
  unlock_date
  metadata (JSON)
```

### NEW API Endpoints Needed

```
Mission Endpoints:
POST   /wp-json/dwp/v1/missions                    (create)
GET    /wp-json/dwp/v1/missions                    (list all)
GET    /wp-json/dwp/v1/missions/{id}               (single)
GET    /wp-json/dwp/v1/missions?region=X&decade=Y  (filtered)
PUT    /wp-json/dwp/v1/missions/{id}               (update)
DELETE /wp-json/dwp/v1/missions/{id}               (delete)

Follow Endpoints:
POST   /wp-json/dwp/v1/missions/{id}/follow        (follow mission)
DELETE /wp-json/dwp/v1/missions/{id}/follow        (unfollow)
GET    /wp-json/dwp/v1/users/{id}/following        (user's followed missions)
GET    /wp-json/dwp/v1/missions/{id}/followers     (mission followers)
POST   /wp-json/dwp/v1/missions/{id}/ambassador    (promote to ambassador)

Contribution Endpoints:
POST   /wp-json/dwp/v1/stories/{id}/link-mission   (link story to mission)
GET    /wp-json/dwp/v1/missions/{id}/stories       (get mission stories)

Achievement Endpoints:
GET    /wp-json/dwp/v1/users/{id}/achievements     (user achievements)
POST   /wp-json/dwp/v1/achievements/check          (trigger achievement check)
POST   /wp-json/dwp/v1/achievements/{type}/unlock  (manually unlock)

Notification Endpoints:
GET    /wp-json/dwp/v1/users/{id}/notifications    (user notifications)
POST   /wp-json/dwp/v1/notifications/mark-read     (mark as read)
```

### WordPress Plugins Required

**Current:**
- ✅ Advanced Custom Fields (ACF) - Already in use
- ✅ JWT Authentication for WP REST API - Already in use
- ✅ Better Featured Image - Already in use

**NEW Required:**
- 🆕 Custom REST API endpoints plugin (or functions.php code)
- 🆕 Push notification service integration (OneSignal or Firebase)
- 🆕 (Optional) ACF to REST API plugin - expose custom fields

---

## Technical Challenges & Solutions

### Challenge 1: Flutter Version Lock (3.10.6)
**Problem:** Using 2-year-old Flutter version limits access to new features/packages

**Impact on Gamification:**
- Some newer packages may not be compatible
- Missing performance optimizations
- Older Firebase SDK

**Solution:**
- Work within Flutter 3.10.6 constraints
- Avoid packages requiring newer Flutter
- Document need for future Flutter upgrade (coordinate with team)

**Recommendation:** Phase 4 of rollout should include coordinated Flutter/dependency upgrade

---

### Challenge 2: No State Management Architecture
**Problem:** Current app uses StatefulWidget with direct API calls - no centralized state

**Impact on Gamification:**
- Follow status needs to sync across multiple screens
- Achievement unlocks need real-time updates
- Mission progress tracking needs centralized state

**Solution Options:**

**Option A: Continue StatefulWidget Pattern (Low Risk)**
- Use ValueNotifier for cross-widget state
- Event bus for achievement unlocks
- Local SQLite as source of truth
- Pros: Consistent with existing codebase
- Cons: More boilerplate, harder to maintain

**Option B: Introduce Provider for Gamification Only (Medium Risk)**
- Add `provider` package
- Create isolated providers for missions/achievements
- Don't refactor existing code
- Pros: Better state management for new features
- Cons: Mixed architecture patterns

**Recommendation:** **Option A** for Phase 1-2, evaluate Option B for Phase 3+

---

### Challenge 3: WordPress Backend Development
**Problem:** Unknown WordPress developer capacity and timeline

**Impact:**
- ALL gamification features depend on WordPress API
- Mission creation, follow system, achievements all need backend
- Cannot start Flutter development until APIs exist

**Critical Questions:**
1. Who is the WordPress developer?
2. What is their availability/capacity?
3. Timeline for custom endpoint development?
4. Are they familiar with ACF and custom post types?

**Mitigation Strategy:**
- Create mock API endpoints in Flutter for parallel development
- Use JSON files to simulate API responses
- Switch to real API in final integration phase

---

### Challenge 4: Map Performance with Missions
**Problem:** Current map creates custom bitmap markers for each story (expensive operation)

**Impact:**
- Adding mission markers will double marker creation work
- 100+ missions could cause lag on map load
- Custom canvas drawing is CPU-intensive

**Performance Concerns:**
```dart
// lib/Map/map.dart - Creates custom marker for EACH story
await getBytesFromAsset(story.featured_image, width, height, size)
```

**Solution:**
1. **Lazy Load Mission Markers:** Only create visible missions in current viewport
2. **Marker Caching:** Cache generated bitmaps in memory/disk
3. **Simpler Mission Icons:** Use built-in BitmapDescriptor.defaultMarker with custom color
4. **Progressive Loading:** Show simple pins first, upgrade to custom when idle

**Implementation Priority:**
- Phase 1: Simple colored pins for missions
- Phase 2: Custom mission icons (if performance acceptable)
- Phase 3: Advanced marker styles with images

---

### Challenge 5: Push Notifications
**Problem:** Follow system requires notifications, no current notification system

**Requirements:**
- Notify followers when mission has new contribution
- Notify when user achieves new badge
- Notify creator when mission reaches goal

**Options:**

**Option A: Firebase Cloud Messaging (FCM)**
- Already using Firebase Auth
- Free tier: Unlimited notifications
- Requires:
  - Firebase project setup
  - `firebase_messaging` package
  - WordPress plugin to send FCM messages

**Option B: OneSignal**
- Third-party service
- Easier WordPress integration
- Free tier: 10,000 subscribers
- Requires: WordPress OneSignal plugin

**Recommendation:** **Firebase Cloud Messaging**
- Already in Firebase ecosystem
- Better long-term scalability
- Can reuse Firebase authentication

---

### Challenge 6: Cultural Design Assets
**Problem:** Memorial plaque requires Lebanese cultural design elements

**Requirements:**
- Traditional Lebanese memorial aesthetics
- Arabic calligraphy fonts
- Cultural patterns and colors
- Appropriate symbolism for peace/remembrance

**Action Items:**
- [ ] Hire Lebanese graphic designer
- [ ] Create design system for badges and plaques
- [ ] Get cultural advisor approval
- [ ] Convert designs to Flutter-compatible assets (SVG/PNG)

**Timeline Impact:** Design assets needed by Week 2 (Phase 2) for achievement system

---

## Data Model Design Recommendations

### Mission Model (Flutter)
```dart
class Mission {
  final String id;              // WordPress post ID
  final String creatorId;       // WordPress user ID
  final String title;
  final String description;
  final int goalCount;
  final int currentCount;
  final DateTime startDate;
  final DateTime? endDate;      // Nullable for ongoing missions
  final MissionStatus status;   // enum: active, completed, expired
  final GeoLocation targetArea;
  final TimeRange targetPeriod;
  final List<String> tags;
  final List<String> followerIds;
  final List<String> ambassadorIds;
  final List<String> linkedStoryIds;

  // Methods
  double get progressPercentage => (currentCount / goalCount) * 100;
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);
  int get daysRemaining => endDate?.difference(DateTime.now()).inDays ?? 0;
}

enum MissionStatus { active, completed, expired }

class GeoLocation {
  final String region;           // "Beirut", "Tripoli", etc.
  final LatLng centerPoint;
  final double radiusKm;
  final List<String> neighborhoods;
}

class TimeRange {
  final int startYear;           // 1975
  final int endYear;             // 1982
  final String decadeLabel;      // "Early War Period"
}
```

### Achievement Model (Flutter)
```dart
class Achievement {
  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final String iconAsset;        // Path to badge icon
  final DateTime? unlockedDate;  // Null if not unlocked
  final AchievementCategory category;
  final Map<String, dynamic>? metadata;  // e.g., {"stories_count": 5}

  bool get isUnlocked => unlockedDate != null;
}

enum AchievementType {
  memoryKeeper,      // First story
  witness,           // Added photo
  voice,             // Audio/video
  missionCreator,    // Created mission
  bridgeBuilder,     // Responded to mission
  networkBuilder,    // Invited 3+ people
  ambassador,        // Ambassador status
  connector,         // Linked stories
  trustedVoice,      // 5+ approved stories
  guardian,          // Family history
  peacemaker,        // Reconciliation story
  heritageKeeper,    // Cultural mission
  communityLeader    // Multiple successful missions
}

enum AchievementCategory {
  foundation,  // Getting started
  community,   // Social engagement
  legacy       // Long-term impact
}
```

### Follow Relationship Model (Flutter)
```dart
class FollowRelationship {
  final String userId;
  final String missionId;
  final DateTime followDate;
  final FollowStatus status;
  final int recruitmentCount;    // Number of people user recruited

  bool get isAmbassador => status == FollowStatus.ambassador;
}

enum FollowStatus {
  following,
  ambassador,
  coCreator
}
```

---

## Local Database Schema (SQLite)

### Table: missions_cache
```sql
CREATE TABLE missions_cache (
  id TEXT PRIMARY KEY,
  creator_id TEXT,
  title TEXT,
  description TEXT,
  goal_count INTEGER,
  current_count INTEGER,
  start_date TEXT,
  end_date TEXT,
  status TEXT,
  target_area_json TEXT,     -- Serialized GeoLocation
  target_period_json TEXT,   -- Serialized TimeRange
  tags_json TEXT,            -- Serialized List<String>
  follower_ids_json TEXT,
  ambassador_ids_json TEXT,
  linked_story_ids_json TEXT,
  last_synced TEXT           -- For offline support
);
```

### Table: user_follows
```sql
CREATE TABLE user_follows (
  user_id TEXT,
  mission_id TEXT,
  follow_date TEXT,
  status TEXT,
  recruitment_count INTEGER,
  PRIMARY KEY (user_id, mission_id)
);
```

### Table: user_achievements
```sql
CREATE TABLE user_achievements (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  achievement_type TEXT,
  unlock_date TEXT,
  metadata_json TEXT
);
```

### Table: notifications
```sql
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  type TEXT,              -- mission_update, achievement, etc.
  title TEXT,
  message TEXT,
  data_json TEXT,         -- Related data (mission_id, etc.)
  is_read INTEGER,
  created_at TEXT
);
```

---

## Performance Optimization Strategy

### Map Loading Optimization
1. **Current Problem:** All markers loaded at once on map init
2. **Solution:**
   - Viewport-based loading: Only load missions in visible area
   - Progressive marker rendering: Stories first, missions after
   - Marker pooling: Reuse bitmap descriptors

### Mission Discovery Optimization
1. **Region-based loading:** Only fetch missions for selected region
2. **Decade filtering:** Filter by time period server-side
3. **Pagination:** Load 20 missions at a time, infinite scroll

### Achievement Checking
1. **Server-side calculation:** WordPress calculates achievements
2. **Client-side caching:** Cache achievement status locally
3. **Background sync:** Check for new achievements on app resume

---

## Risk Assessment Matrix

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| WordPress developer unavailable | HIGH | CRITICAL | Mock APIs + JSON simulation |
| Flutter version incompatibility | MEDIUM | HIGH | Test packages before integration |
| Map performance degradation | MEDIUM | MEDIUM | Progressive loading + simple pins |
| Cultural design rejection | MEDIUM | HIGH | Early advisor involvement |
| Team merge conflicts | HIGH | MEDIUM | Feature branches + code reviews |
| Push notification setup complexity | LOW | MEDIUM | Use Firebase (already integrated) |
| Local database migration issues | LOW | HIGH | Versioned migrations + backup |

---

## Recommended Architecture Changes

### Immediate (Phase 1)
1. ✅ Create `lib/Gamification/` folder structure
2. ✅ Add `lib/Repos/MissionRepo.dart` for API calls
3. ✅ Add `lib/Repos/AchievementRepo.dart`
4. ✅ Create `lib/widgets/gamification/` for reusable components

### Short-term (Phase 2)
1. ⏰ Add ValueNotifier for mission state sharing
2. ⏰ Implement SQLite caching layer
3. ⏰ Set up Firebase Cloud Messaging

### Long-term (Phase 3+)
1. 🔮 Consider Provider/Riverpod migration
2. 🔮 Implement service layer abstraction
3. 🔮 Coordinate Flutter version upgrade with team

---

## Next Steps

1. ✅ **Read this document** - Architecture understood
2. 📝 **Create WordPress Backend Requirements doc** - Spec all endpoints
3. 🎨 **Create Data Model Design doc** - Detailed Dart classes
4. 📅 **Create Phased Rollout Plan** - Break into manageable phases
5. 🔄 **Update CHANGELOG** - Reference all planning documents

---

## Questions for Team Discussion

### WordPress Backend Team:
1. Who will develop the custom mission endpoints?
2. What is realistic timeline for backend development?
3. Are you comfortable with ACF custom post types?
4. Preference for notification system (FCM vs OneSignal)?

### Design Team:
1. Who will create the Lebanese cultural design assets?
2. When can we get draft designs for cultural advisor review?
3. What tools are you using (Figma, Sketch, Adobe)?

### Project Manager:
1. Approval for phased rollout vs 3-week sprint?
2. Who is the Lebanese cultural advisor?
3. Budget for design assets?
4. Testing timeline and user group size?

---

**Document Status:** ✅ Complete
**Last Updated:** October 10, 2025
**Next Document:** WordPress Backend Requirements
