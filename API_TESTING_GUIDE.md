# Mission API Testing Guide

## Quick Answer to Developer Questions

### Q: "I don't get any data yet because the tables are empty"
**A:** The database tables exist, but missions must be created via WordPress admin first. The plugin doesn't auto-populate sample data.

### Q: "What I need is just a way to call and get the JSON file"
**A:** Use `MissionRepo` class in Flutter. See examples below.

---

## Create Test Data (5 Minutes)

### Step 1: Login to WordPress
URL: https://dwp.world/wp-admin

### Step 2: Create Missions
Go to: **Missions → Add New**

**Mission 1:**
```
Title: Visit Martyrs' Square
Description: Visit the historic Martyrs' Square and take a photo
Latitude: 33.8938
Longitude: 35.5018
Address: Martyrs' Square, Beirut, Lebanon
Difficulty: easy
Mission Type: visit
Reward Points: 10
Is Active: ✓ (checked)
```

**Mission 2:**
```
Title: Explore Roman Ruins
Description: Photograph the ancient Roman columns
Latitude: 33.9000
Longitude: 35.5200
Address: Baalbek, Lebanon
Difficulty: medium
Mission Type: photograph
Reward Points: 20
Is Active: ✓ (checked)
```

**Mission 3:**
```
Title: Interview Elder
Description: Record oral history from community elder
Latitude: 33.8800
Longitude: 35.4900
Address: Beirut Central District
Difficulty: hard
Mission Type: interview
Reward Points: 30
Is Active: ✓ (checked)
```

Click **Publish** for each mission.

---

## Test APIs (Choose Your Method)

### Method 1: Browser (Easiest)

Open these URLs in Chrome/Edge:

**Get all nearby missions:**
```
https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=50
```

**Get specific mission (replace 123 with real ID):**
```
https://dwp.world/wp-json/dwp/v1/missions/123
```

You should see JSON like:
```json
{
  "success": true,
  "count": 3,
  "missions": [...]
}
```

### Method 2: Postman
1. Download Postman (free)
2. Create GET request to: `https://dwp.world/wp-json/dwp/v1/missions/nearby`
3. Add Query Params:
   - `lat`: 33.8938
   - `lng`: 35.5018
   - `radius`: 50
4. Click **Send**

### Method 3: Curl (Command Line)
```bash
# Get nearby missions
curl "https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=50"

# Get mission details (replace 123 with real ID)
curl "https://dwp.world/wp-json/dwp/v1/missions/123"
```

---

## Flutter Integration

### Basic Usage

```dart
import 'package:interactive_map/Repos/MissionRepo.dart';

// Initialize repository
MissionRepo missionRepo = MissionRepo();

// Get missions near user location
Future<void> loadMissions() async {
  double userLat = 33.8938;
  double userLng = 35.5018;

  var response = await missionRepo.getNearbyMissions(
    userLat,
    userLng,
    radius: 50,
  );

  if (response != null && response['success'] == true) {
    List missions = response['missions'];
    print('Found ${missions.length} missions');

    // Loop through missions
    for (var mission in missions) {
      print('Mission: ${mission['title']}');
      print('Distance: ${mission['distance_km']} km');
      print('Reward: ${mission['reward_points']} points');
      print('---');
    }
  } else {
    print('Failed to load missions');
  }
}
```

### In Your Map Widget

The map screen already has this implemented:

```dart
// In map.dart - already exists

Future<dynamic> retrieveMissions() async {
  MissionRepo missionRepo = MissionRepo();

  // Get user's current location
  Position position = await Geolocator.getCurrentPosition();

  // Fetch missions within 50km
  var response = await missionRepo.getNearbyMissions(
    position.latitude,
    position.longitude,
    radius: 50,
  );

  if (response != null && response['success']) {
    setState(() {
      missions = response['missions'];
    });
    loadMissionMarkers(); // Show green markers on map
  }
}
```

### Toggle Between Stories and Missions

```dart
// Already implemented in map.dart

void switchViewMode(String mode) {
  setState(() {
    viewMode = mode; // 'stories' or 'missions'
  });
  updateMapMarkers(); // Refresh map markers
}

// User taps "المهمات" button → calls switchViewMode('missions')
// User taps "الروايات" button → calls switchViewMode('stories')
```

---

## Expected JSON Response

### Get Nearby Missions Response

```json
{
  "success": true,
  "count": 3,
  "user_location": {
    "lat": 33.8938,
    "lng": 35.5018
  },
  "radius_km": 50,
  "missions": [
    {
      "id": 456,
      "title": "Visit Martyrs' Square",
      "description": "Visit the historic Martyrs' Square and take a photo",
      "excerpt": "Visit the historic Martyrs' Square...",
      "latitude": 33.8938,
      "longitude": 35.5018,
      "address": "Martyrs' Square, Beirut, Lebanon",
      "difficulty": "easy",
      "mission_type": "visit",
      "completion_count": 0,
      "reward_points": 10,
      "is_active": true,
      "thumbnail": "https://dwp.world/wp-content/uploads/2025/10/mission.jpg",
      "story_id": null,
      "created_at": "2025-10-14 12:00:00",
      "distance_km": 0.12
    },
    {
      "id": 457,
      "title": "Explore Roman Ruins",
      "description": "Photograph the ancient Roman columns",
      "excerpt": "Photograph the ancient Roman...",
      "latitude": 33.9000,
      "longitude": 35.5200,
      "address": "Baalbek, Lebanon",
      "difficulty": "medium",
      "mission_type": "photograph",
      "completion_count": 5,
      "reward_points": 20,
      "is_active": true,
      "thumbnail": "https://dwp.world/wp-content/uploads/2025/10/ruins.jpg",
      "story_id": 123,
      "created_at": "2025-10-14 11:30:00",
      "distance_km": 3.45
    }
  ]
}
```

### Get Mission Details Response

```json
{
  "success": true,
  "mission": {
    "id": 456,
    "title": "Visit Martyrs' Square",
    "description": "Full description here...",
    "excerpt": "Short excerpt...",
    "latitude": 33.8938,
    "longitude": 35.5018,
    "address": "Martyrs' Square, Beirut, Lebanon",
    "difficulty": "easy",
    "mission_type": "visit",
    "completion_count": 12,
    "reward_points": 10,
    "is_active": true,
    "thumbnail": "https://dwp.world/wp-content/uploads/...",
    "story_id": null,
    "created_at": "2025-10-14 12:00:00",
    "user_status": "not_started",
    "user_progress": 0,
    "user_started_at": null
  }
}
```

---

## Common Issues & Solutions

### Issue: API returns `{"missions": []}`

**Causes:**
1. No missions created in WordPress
2. Missions are in "Draft" status (must be "Published")
3. "Is Active" field is unchecked
4. Radius too small (try 100km)
5. Lat/Lng coordinates too far from missions

**Solution:**
```
1. Check WordPress Admin → Missions
2. Verify missions are "Published"
3. Edit mission → check "Is Active" checkbox
4. Increase radius parameter to 100
```

### Issue: API returns 404

**Causes:**
1. Permalink structure not refreshed
2. Plugin not activated
3. Wrong URL

**Solution:**
```
1. WordPress Admin → Settings → Permalinks
2. Click "Save Changes" (no need to change anything)
3. Test URL again
```

### Issue: Flutter shows no markers

**Causes:**
1. API returns empty data
2. `viewMode` is not set to 'missions'
3. Map not refreshing after data load

**Solution:**
```dart
// Force refresh after loading missions
setState(() {
  missions = response['missions'];
  viewMode = 'missions';
});
loadMissionMarkers();
```

---

## For Your Meeting - Demo Script

### 1. Show Backend (2 min)
- Open: https://dwp.world/wp-admin/edit.php?post_type=mission
- Show list of missions
- Click "Add New" → show form fields
- Point out: Title, Lat, Lng, Difficulty, Mission Type

### 2. Show API (1 min)
- Open browser tab
- Paste: `https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=50`
- Show JSON response
- Say: "This is what Flutter app receives"

### 3. Show Flutter Code (2 min)
- Open: `lib/Repos/MissionRepo.dart`
- Show `getNearbyMissions()` method (line 12)
- Say: "This method calls the API and returns the JSON"

### 4. Show Map Integration (2 min)
- Open: `lib/Map/map.dart`
- Show `retrieveMissions()` method
- Show `loadMissionMarkers()` method
- Say: "Map already calls this and shows green markers"

### 5. Run Live Demo (3 min)
- Run Flutter app on phone
- Open map screen
- Tap "المهمات" button (green)
- Show green markers appear
- Tap a marker → show mission details

**Total: 10 minutes**

---

## What You Built (Summary for Developer)

✅ **WordPress Plugin:**
- Custom post type "Mission"
- 6 REST API endpoints
- Database tables for tracking user progress
- ACF fields for mission data

✅ **Flutter App:**
- `MissionRepo.dart` - Service class to call all APIs
- `createMission.dart` - Form to create missions from mobile
- `map.dart` - Toggle view + mission markers

✅ **Already Working:**
- API endpoints live at dwp.world
- Flutter code ready to use
- Map integration complete

❌ **What's Missing:**
- Test data (missions) in WordPress

---

## Next Steps

1. **Create 3-5 test missions** in WordPress admin (5 min)
2. **Test API in browser** - verify JSON response (1 min)
3. **Run Flutter app** - check map shows markers (2 min)
4. **Ready to demo** to team ✓

---

## Contact

For questions about:
- **Backend/WordPress:** Check plugin README.md
- **Frontend/Flutter:** Check MissionRepo.dart comments
- **API Structure:** Check this document's JSON examples

**The system is complete and working - just needs mission data to test!** 🚀
