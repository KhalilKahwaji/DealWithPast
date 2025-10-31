# Mission System - Onboarding Guide

**Goal:** Get the mission system running in 15 minutes.

---

## What You Have

### Backend
- WordPress plugin `dwp-gamification` (already installed on dwp.world)
- 6 REST API endpoints (working)
- 3 database tables (created automatically)
- Mission custom post type with ACF fields

### Frontend
- `lib/Repos/MissionRepo.dart` - API service
- `lib/Missions/createMission.dart` - Create mission UI
- `lib/Map/map.dart` - Map with mission markers

---

## Step 1: Create Test Data (2 minutes)

**Login:** https://dwp.world/wp-admin

1. Go to **Missions → Add New**
2. Fill in these fields:
   - **Title:** "Visit Martyrs' Square"
   - **Description:** "Take a photo at this historic location"
   - **Latitude:** 33.8938
   - **Longitude:** 35.5018
   - **Address:** "Martyrs' Square, Beirut, Lebanon"
   - **Difficulty:** easy
   - **Mission Type:** visit
   - **Reward Points:** 10
   - **Is Active:** ✓ (checked)
3. Click **Publish**

**Repeat for 2-3 more locations** to see multiple markers on the map.

---

## Step 2: Test the API (1 minute)

Open this URL in your browser:

```
https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=50
```

**Expected result:** JSON response with your missions

```json
{
  "success": true,
  "count": 1,
  "missions": [
    {
      "id": 123,
      "title": "Visit Martyrs' Square",
      "latitude": 33.8938,
      "longitude": 35.5018,
      "distance_km": 0.5,
      ...
    }
  ]
}
```

**If you see `"missions": []`:**
- Verify missions are **Published** (not Draft)
- Check **Is Active** is checked
- Increase radius to 100

---

## Step 3: Use in Flutter (5 minutes)

### Get Nearby Missions

```dart
import 'package:interactive_map/Repos/MissionRepo.dart';

MissionRepo repo = MissionRepo();

var response = await repo.getNearbyMissions(
  33.8938,  // user latitude
  35.5018,  // user longitude
  radius: 50,
);

if (response != null && response['success']) {
  List missions = response['missions'];
  print('Found ${missions.length} missions');
}
```

### Get Mission Details

```dart
var response = await repo.getMissionDetails(missionId, token);

if (response != null && response['success']) {
  var mission = response['mission'];
  print(mission['title']);
  print(mission['description']);
}
```

### Create Mission (Requires Auth)

```dart
var response = await repo.createMission(
  title: "New Mission",
  description: "Mission description",
  latitude: 33.8938,
  longitude: 35.5018,
  address: "Beirut, Lebanon",
  difficulty: "easy",
  missionType: "visit",
  rewardPoints: 10,
  token: userToken,  // JWT token from login
);
```

### Start/Complete Mission

```dart
// Start mission
await repo.startMission(missionId, token);

// Complete mission
await repo.completeMission(
  missionId,
  token,
  proofMedia: ["https://url-to-image.jpg"],
);
```

---

## API Endpoints Reference

### Public (No Auth)
| Endpoint | Method | Parameters |
|----------|--------|------------|
| `/missions/nearby` | GET | `lat`, `lng`, `radius` |
| `/missions/{id}` | GET | Mission ID |

### Protected (Requires JWT)
| Endpoint | Method | Body |
|----------|--------|------|
| `/missions/create` | POST | title, description, lat, lng, etc. |
| `/missions/start` | POST | `{"mission_id": 123}` |
| `/missions/complete` | POST | `{"mission_id": 123, "proof_media": []}` |
| `/missions/my-missions` | GET | - |

**Base URL:** `https://dwp.world/wp-json/dwp/v1/`

---

## Map Integration (Already Done)

The map screen already has:
- Mission loading via `retrieveMissions()`
- Toggle between Stories/Missions
- Green markers for missions

To show missions on map:
1. Toggle view mode to "missions"
2. Missions appear as green pins
3. Tap marker to see details

---

## Troubleshooting

### API returns 404
1. Go to **Settings → Permalinks** in WordPress
2. Click **Save Changes**
3. Try again

### No missions on map
1. Check `viewMode` is set to `'missions'`
2. Verify API works in browser first
3. Check Flutter console: `flutter logs`

### Empty missions array
- Verify missions are **Published**
- Check **Is Active** is enabled
- Increase radius parameter
- Verify lat/lng coordinates

---

## Key Points

1. **Database is empty until you create missions** via WordPress admin
2. **All APIs are working** - just need data
3. **Flutter code is ready** - just import `MissionRepo`
4. **No backend changes needed** - plugin handles everything

---

## Quick Test Checklist

- [ ] Create 2-3 missions in WordPress admin
- [ ] Test API in browser (nearby missions endpoint)
- [ ] Import `MissionRepo` in Flutter
- [ ] Call `getNearbyMissions()` and verify response
- [ ] Display missions on map
- [ ] Test mission start/complete flow (requires auth)

---

**That's it. The system is production-ready. Just add mission data and start using the APIs.**
