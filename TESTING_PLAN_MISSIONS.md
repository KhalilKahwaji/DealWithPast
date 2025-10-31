# Mission System Testing Plan

## Version Check
**Current Plugin Version**: 1.1.0
**How to verify**: In WordPress admin → Plugins page → Look for "DWP Gamification" version number

If you see version **1.1.0**, you have the latest plugin with mission creation support.

---

## Pre-Test Checklist
- [ ] Plugin version 1.1.0 installed and activated on dwp.world
- [ ] ACF (Advanced Custom Fields) Pro plugin active
- [ ] Flutter app built and installed on test device
- [ ] Test user account with authentication working
- [ ] Device has GPS/location permissions enabled
- [ ] Device has internet connection

---

## Test Scenarios

### Test 1: Verify API Endpoint is Live
**Objective**: Confirm the backend is ready

1. Open browser and go to: `https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=10`
2. **Expected Result**: JSON response with success=true and missions array (might be empty)
3. **If it fails**: Check plugin is activated, check .htaccess for REST API

---

### Test 2: Create Mission from App
**Objective**: Test full mission creation flow

**Steps**:
1. Open DWP app on device
2. Login with test account
3. Navigate to Map page
4. Tap toggle button at top - switch to "المهمات" (Missions) view
5. Tap green flag button (FloatingActionButton) at bottom left
6. Fill in mission form:
   - **Title**: "Test Mission - [Your Name]"
   - **Description**: "This is a test mission to verify the creation system works"
   - **Location**: Tap location field → Pick any location on map (e.g., Martyrs' Square, Beirut)
   - **Difficulty**: Select "سهل" (Easy)
   - **Mission Type**: Select "زيارة موقع" (Visit Location)
   - **Reward Points**: Leave as 10
7. Tap "إنشاء المهمة" (Create Mission) button

**Expected Result**:
- Success dialog appears: "تم إنشاء المهمة بنجاح"
- App returns to home screen
- No error messages

**If it fails**:
- Check authentication token is valid
- Check network connectivity
- Check app logs for error details

---

### Test 3: View Created Mission on Map
**Objective**: Verify mission appears as green pin

**Steps**:
1. On Map page, ensure "المهمات" (Missions) toggle is selected
2. Navigate map to the location where you created the mission
3. Look for green map marker

**Expected Result**:
- Green pin appears at mission location
- Tapping pin shows mission title and excerpt

**If mission doesn't appear**:
- Pull to refresh the map (or restart app)
- Check you're within 50km of the mission location
- Switch to Stories view and back to Missions view to reload

---

### Test 4: Verify in WordPress Admin
**Objective**: Confirm mission saved correctly in backend

**Steps**:
1. Login to WordPress admin: `https://dwp.world/wp-admin`
2. Go to Missions menu (left sidebar)
3. Look for "Test Mission - [Your Name]" in list

**Expected Result**:
- Mission appears in list
- Status: Published
- All fields populated correctly (lat, lng, difficulty, mission_type, etc.)

---

### Test 5: View Nearby Missions
**Objective**: Test mission discovery for other users

**Steps**:
1. If possible, test with second device/account
2. Open app, go to Map
3. Switch to "المهمات" (Missions) view
4. Check if test mission appears (if within 50km)

**Expected Result**:
- Missions from other users appear as green pins
- Distance calculation working correctly

---

## Success Criteria

✅ All 5 tests pass without errors
✅ Mission creation works from app
✅ Missions appear on map as green pins
✅ Toggle switches correctly between stories and missions
✅ Mission data saved correctly in WordPress

---

## Known Limitations to Verify

1. **Location Permission**: App needs GPS permission to load nearby missions
2. **50km Radius**: Only missions within 50km of user location will appear
3. **Authentication**: User must be logged in to create missions
4. **Active Missions Only**: Only missions with `is_active=true` appear on map

---

## Debugging Tips

### If API returns 401 Unauthorized:
- Check user is logged in
- Verify Firebase Auth → WordPress token flow working
- Check token is being sent in Authorization header

### If API returns 500 Server Error:
- Check WordPress error logs
- Verify ACF fields are registered correctly
- Check database tables exist (wp_user_missions)

### If missions don't appear on map:
- Check console logs in app
- Verify `getNearbyMissions()` is being called
- Check user location coordinates are valid
- Try hardcoded test coordinates: lat=33.8938, lng=35.5018

### If map markers don't show:
- Check `viewMode` state variable is set to 'missions'
- Verify `loadMissionMarkers()` is being called
- Check missions array is populated with data

---

## Quick API Test (Curl)

```bash
# Test nearby missions endpoint (public)
curl "https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=10"

# Test create mission endpoint (requires auth token)
curl -X POST "https://dwp.world/wp-json/dwp/v1/missions/create" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Curl Test Mission",
    "description": "Testing mission creation via API",
    "latitude": 33.8938,
    "longitude": 35.5018,
    "difficulty": "easy",
    "mission_type": "visit",
    "reward_points": 10
  }'
```

---

## Rollback Plan

If testing reveals critical issues:

1. Deactivate plugin in WordPress admin
2. Previous version (1.0.0) can be reinstalled if needed
3. Flutter app will gracefully handle missing endpoint (no crashes)

---

## Post-Testing Actions

After successful testing:

- [ ] Document any issues found
- [ ] Create missions with real content (not test data)
- [ ] Test with multiple users
- [ ] Monitor for performance issues
- [ ] Gather user feedback

---

**Testing Date**: [To be scheduled]
**Tester**: Ziad
**Environment**: dwp.world production + Flutter mobile app
**Version**: Plugin 1.1.0, App [version TBD]
