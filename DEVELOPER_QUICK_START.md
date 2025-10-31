# Mission System - Developer Quick Start Guide

## What Was Built

### Backend (WordPress Plugin)
✅ **Plugin Name:** `dwp-gamification` (already uploaded to dwp.world)
✅ **Status:** Installed and activated

**What it includes:**
- 3 database tables created automatically
- Mission custom post type with 15 ACF fields
- 9 REST API endpoints (missions, reactions, sharing)
- Tag-based discovery system (neighborhood/decade/theme)
- Auto-calculated reward points (difficulty × goal_count)
- Category filtering (social/personal missions)

### Frontend (Flutter App)
✅ **Files Created:**
- `lib/Repos/MissionRepo.dart` - Service class to call APIs
- `lib/Missions/createMission.dart` - UI to create missions
- `lib/Map/map.dart` - Enhanced map with search, filters, mission discovery cards

✅ **Latest Features (Phase 1 Complete):**
- Search bar with RTL Arabic support
- Filter dialog for category/tag filtering
- Progress bar showing completion_count/goal_count
- Metadata badges (participants, decades, neighborhoods)
- Responsive mission card (80% screen height, scrollable)
- Color-coded tag badges (green=participants, yellow=decades, blue=neighborhoods)

---

## 🆕 New Features - Phase 1 (October 2025)

### WordPress Backend
| Feature | Location | Description |
|---------|----------|-------------|
| **Tag System** | `class-mission-cpt.php` | Added neighborhood_tags, decade_tags, theme_tags ACF fields |
| **Tag Filtering** | `class-api-endpoints.php` | Filter missions by tags via API parameters (`?neighborhood=Hamra&decade=1980s`) |
| **Auto Reward Points** | `format_mission_data()` | Calculates points: base[difficulty] × (goal_count/10). Replaces manual input. |
| **Category Field** | `class-mission-cpt.php` | Added `category` field (social/personal) for mission types |
| **Goal Count** | `class-mission-cpt.php` | Added `goal_count` field for progress tracking |

### Flutter Frontend
| Feature | File | Method/Widget | Description |
|---------|------|---------------|-------------|
| **Search Bar** | `map.dart:849-940` | `searchController` | RTL Arabic search with placeholder text based on view mode |
| **Filter Dialog** | `map.dart:617-749` | `_showFilterDialog()` | Modal bottom sheet with FilterChips for category selection |
| **Progress Bar** | `map.dart:1316-1355` | `_calculateProgress()` | Visual green bar showing completion_count/goal_count ratio |
| **Metadata Badges** | `map.dart:1357-1443` | Wrap widget | Color-coded badges: green (participants), yellow (decades), blue (neighborhoods) |
| **Responsive Card** | `map.dart:1170` | `MediaQuery` | Mission card uses 80% screen height with scrollable content |
| **Filter State** | `map.dart:80-86` | State variables | `selectedNeighborhood`, `selectedDecade`, `selectedTheme`, `selectedCategory` |

### API Parameters (New)
```
GET /missions/nearby?lat=33.8&lng=35.5&radius=10&neighborhood=Hamra&category=social
```
- `neighborhood` (string) - Filter by neighborhood tag
- `decade` (string) - Filter by decade tag (e.g., "1980s")
- `theme` (string) - Filter by theme tag (e.g., "war")
- `category` (string) - Filter by social/personal

### Response Changes
```json
{
  "missions": [{
    "goal_count": 10,                    // NEW: Target story count
    "category": "social",                // NEW: social or personal
    "reward_points": 15,                 // AUTO-CALCULATED (was manual)
    "neighborhood_tags": ["Hamra"],      // NEW: Array of neighborhoods
    "decade_tags": ["1980s", "1990s"],   // NEW: Array of decades
    "theme_tags": ["war", "daily life"]  // NEW: Array of themes
  }]
}
```

### Flutter Methods to Call
```dart
// Filter missions (already implemented in map.dart)
void _showFilterDialog() {
  // Opens modal with category filters
  // Sets: selectedCategory, selectedNeighborhood, etc.
}

// Calculate progress percentage
double _calculateProgress(dynamic completionCount, dynamic goalCount) {
  // Returns 0.0-1.0 for progress bar width
}

// Switch between Stories/Missions with filter support
void switchViewMode(String mode) {
  // Clears filters when switching modes
}
```

---

## 🚀 Quick Test Guide

### Step 1: Create Test Missions (WordPress Admin)

**URL:** https://dwp.world/wp-admin

1. Go to **Missions → Add New**
2. Fill in:
   - **Title:** "ساحة الشهداء - زيارة" (Martyrs' Square Visit)
   - **Description:** "التقط صورة في ساحة الشهداء الشهيرة وساهم في حفظ ذكرى المكان"
   - **Latitude:** 33.8938
   - **Longitude:** 35.5018
   - **Address:** "ساحة الشهداء، بيروت، لبنان"
   - **Difficulty:** easy
   - **Mission Type:** visit
   - **Category:** social
   - **Goal Count:** 10
   - **Neighborhood Tags:** "Hamra, Beirut Central"
   - **Decade Tags:** "1980s, 1990s"
   - **Theme Tags:** "war, reconstruction, daily life"
   - **Is Active:** Yes (checked)
   - **Reward Points:** Auto-calculated (read-only, will show 5 points for easy with goal_count=10)
3. Click **Publish**

**Create 2-3 more missions with different categories (social/personal) and tags to test filtering.**

---

### Step 2: Test API Endpoints (Browser)

Open these URLs in your browser to see the JSON response:

#### Get Nearby Missions (Public - No Auth)
```
https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=50
```

**Response Format:**
```json
{
  "success": true,
  "count": 2,
  "user_location": {"lat": 33.8938, "lng": 35.5018},
  "radius_km": 50,
  "filters": {"category": "social"},
  "missions": [
    {
      "id": 123,
      "title": "ساحة الشهداء - زيارة",
      "description": "التقط صورة في ساحة الشهداء...",
      "excerpt": "التقط صورة في ساحة...",
      "latitude": 33.8938,
      "longitude": 35.5018,
      "address": "ساحة الشهداء، بيروت، لبنان",
      "difficulty": "easy",
      "mission_type": "visit",
      "category": "social",
      "completion_count": 3,
      "goal_count": 10,
      "reward_points": 5,
      "is_active": true,
      "thumbnail": "https://dwp.world/wp-content/uploads/...",
      "story_id": null,
      "neighborhood_tags": ["Hamra", "Beirut Central"],
      "decade_tags": ["1980s", "1990s"],
      "theme_tags": ["war", "reconstruction", "daily life"],
      "created_at": "2025-10-15 10:30:00",
      "distance_km": 0.5
    }
  ]
}
```



## 📱 Flutter Usage (Frontend)

### Import the Repository
```dart
import 'package:interactive_map/Repos/MissionRepo.dart';
```

### Get Nearby Missions
```dart
MissionRepo missionRepo = MissionRepo();

// Get missions within 50km radius
var response = await missionRepo.getNearbyMissions(
  33.8938,  // user latitude
  35.5018,  // user longitude
  radius: 50,
);

if (response != null && response['success']) {
  List missions = response['missions'];
  print('Found ${missions.length} missions');

  // Access mission data
  for (var mission in missions) {
    print('${mission['title']} - ${mission['distance_km']} km away');
  }
}
```

### Get Mission Details
```dart
int missionId = 123;
String? token = null; // Optional: pass JWT token if user is logged in

var response = await missionRepo.getMissionDetails(missionId, token);

if (response != null && response['success']) {
  var mission = response['mission'];
  print('Mission: ${mission['title']}');
  print('Description: ${mission['description']}');
  print('Difficulty: ${mission['difficulty']}');
}
```

### Already Implemented in Map
The map screen (`lib/Map/map.dart`) already has:
- Mission loading: `retrieveMissions()` method
- Toggle between Stories/Missions: `switchViewMode()` method
- Mission markers on map (green pins)

---

## 🔑 API Endpoints Reference

### Public Endpoints (No Auth Required)

| Endpoint | Method | Parameters | Purpose |
|----------|--------|------------|---------|
| `/missions/nearby` | GET | `lat`, `lng`, `radius` (km) | Get missions near location |
| `/missions/{id}` | GET | Mission ID in URL | Get mission details |

### Protected Endpoints (Require JWT Token)

| Endpoint | Method | Body | Purpose |
|----------|--------|------|---------|
| `/missions/create` | POST | See below | Create new mission |
| `/missions/start` | POST | `{"mission_id": 123}` | Start a mission |
| `/missions/complete` | POST | `{"mission_id": 123, "proof_media": []}` | Complete mission |
| `/missions/my-missions` | GET | - | Get user's missions |

### Create Mission Body Example
```json
{
  "title": "Visit Historic Site",
  "description": "Take photos and explore the area",
  "latitude": 33.8938,
  "longitude": 35.5018,
  "address": "Beirut, Lebanon",
  "difficulty": "easy",
  "mission_type": "visit",
  "reward_points": 10
}
```
