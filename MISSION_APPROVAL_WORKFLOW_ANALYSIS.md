# Mission Approval Workflow - Analysis & Implementation Plan

## Current Situation (What We Just Built)

### Current Flow - INCORRECT ❌
1. User creates mission → API returns success
2. **MissionSuccessDialog shows immediately** (line 508 in create_mission_modal.dart)
3. Shows "Mission Created Successfully!" with sharing options
4. Mission has status 'pending' in WordPress
5. We just made it visible to creator in map query

### Problem
- User sees success celebration BEFORE admin approves
- This is misleading - mission isn't actually published yet
- Sharing won't work because mission is pending (others can't see it)

---

## Desired Workflow (User's Requirements) ✅

### Phase 1: Submission
```
User fills form → Submits mission
   ↓
Backend: Creates with status 'pending'
   ↓
App shows: "تم إرسال المهمة للمراجعة"
(Mission submitted for review)
   ↓
User waits (mission NOT visible on map)
```

### Phase 2: Admin Reviews
```
Admin Dashboard → Reviews mission
   ↓
Option A: APPROVE → status = 'publish'
   ↓
   → Trigger notification to creator
   → User gets SUCCESS dialog (the current MissionSuccessDialog)
   → Mission appears on map
   → User can now share

Option B: REJECT → status = 'rejected'
   ↓
   → Admin writes rejection reason (Arabic)
   → Trigger notification to creator
   → User sees rejection message with admin feedback
   → Option to edit and resubmit
```

---

## Technical Implementation Needed

### 1. Backend Changes (WordPress Plugin)

#### A. Revert SQL Changes
**File:** `wordpress-plugin/dwp-gamification/includes/class-api-endpoints.php`
- Lines 402-443: REVERT the changes we just made
- Go back to: `AND p.post_status = 'publish'` only
- Don't show pending missions to anyone

#### B. Add Rejection Tracking
**Add ACF fields to Mission post type:**
```php
// New fields needed:
- rejection_reason (text field) - Admin's feedback in Arabic
- reviewed_at (datetime) - When admin made decision
- reviewed_by (user ID) - Which admin reviewed
```

#### C. Add Admin Notification Hooks
**File:** `class-api-endpoints.php` or new `class-notifications.php`
```php
// WordPress action hook when post status changes
add_action('transition_post_status', 'notify_mission_creator', 10, 3);

function notify_mission_creator($new_status, $old_status, $post) {
    if ($post->post_type !== 'mission') return;

    $creator_id = $post->post_author;

    if ($new_status === 'publish' && $old_status === 'pending') {
        // Mission APPROVED
        // Send notification via:
        // - WordPress notification table
        // - Firebase Cloud Messaging (push notification)
        // - Email notification
    }

    if ($new_status === 'rejected') {
        // Mission REJECTED
        // Get rejection_reason from ACF
        // Send notification with reason
    }
}
```

#### D. Add Notification Endpoints
**New API endpoints needed:**
```php
// GET /wp-json/dwp/v1/notifications
// - Returns user's notifications (pending approvals, approvals, rejections)

// POST /wp-json/dwp/v1/notifications/{id}/mark-read
// - Marks notification as read

// Response format:
{
  "notifications": [
    {
      "id": 123,
      "type": "mission_approved",
      "mission_id": 956,
      "mission_title": "testing 956",
      "message": "تم قبول مهمتك! يمكنك الآن مشاركتها",
      "created_at": "2025-10-26 10:30:00",
      "is_read": false
    },
    {
      "id": 124,
      "type": "mission_rejected",
      "mission_id": 957,
      "mission_title": "test mission 2",
      "message": "لم يتم قبول المهمة: المحتوى غير مناسب",
      "rejection_reason": "المحتوى غير مناسب",
      "created_at": "2025-10-26 11:00:00",
      "is_read": false
    }
  ]
}
```

---

### 2. App Changes (Flutter)

#### A. Change Immediate Success to "Pending Review"

**File:** `lib/Missions/create_mission_modal.dart` (lines 498-515)

**CHANGE FROM:**
```dart
// Show success achievement dialog
await MissionSuccessDialog.show(
  context,
  missionTitle: _titleController.text.trim(),
  location: _locationController.text,
  period: '${_fromYearController.text} - ${_toYearController.text}',
  missionId: missionId,
);
```

**CHANGE TO:**
```dart
// Show "submitted for review" message
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'تم إرسال المهمة للمراجعة. سيتم إخطارك عند الموافقة عليها',
      style: TextStyle(fontFamily: 'Tajawal'),
    ),
    backgroundColor: Color(0xFF5A7C59),
    duration: Duration(seconds: 4),
  ),
);
```

#### B. Create Pending Review Dialog (Alternative)

**New file:** `lib/widgets/MissionPendingDialog.dart`
```dart
// Shows after submission
// Icon: Hourglass or clock (pending)
// Title: "تم إرسال المهمة للمراجعة"
// Message: "سيتم إخطارك عندما يتم مراجعة مهمتك من قبل الفريق"
// Note: "هذا يستغرق عادة 24-48 ساعة"
// Button: "حسناً" (OK)
```

#### C. Create Notification System

**New file:** `lib/services/NotificationService.dart`
```dart
class NotificationService {
  // Poll for notifications (or use Firebase Cloud Messaging)

  Future<List<Notification>> getNotifications(String token) async {
    final response = await http.get(
      Uri.parse('https://dwp.world/wp-json/dwp/v1/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // Parse and return
  }

  void checkForApprovals() {
    // When notification type = 'mission_approved'
    // Show MissionSuccessDialog (the celebration we have now)
    // This is when user sees the success screen!
  }

  void checkForRejections() {
    // When notification type = 'mission_rejected'
    // Show MissionRejectedDialog with admin's reason
  }
}
```

#### D. Create Rejection Dialog

**New file:** `lib/widgets/MissionRejectedDialog.dart`
```dart
// Shows when mission rejected
// Icon: Warning or info icon
// Title: "لم يتم قبول المهمة"
// Admin's reason: Display rejection_reason in Arabic
// Buttons:
//   - "تعديل المهمة" (Edit mission) → Open edit form
//   - "إغلاق" (Close)
```

#### E. Add Notification Badge to UI

**Update:** `lib/widgets/app_bottom_nav.dart` or main screen
- Show badge/dot on profile or notifications icon
- Number of unread notifications
- When tapped → Show notification list
- When mission_approved notification → Show MissionSuccessDialog

---

## Arabic Messages Required

### Submission Messages
```
تم إرسال المهمة للمراجعة
سيتم إخطارك عند الموافقة عليها
هذا يستغرق عادة 24-48 ساعة
```

### Approval Messages
```
تم قبول مهمتك!
يمكنك الآن مشاركتها مع الآخرين
```

### Rejection Messages
```
لم يتم قبول المهمة
السبب: [admin's reason here]
يمكنك تعديل المهمة وإعادة إرسالها
```

### Admin Interface (WordPress)
```
سبب الرفض:
[Text area for admin to write reason in Arabic]

أمثلة:
- المحتوى غير مناسب
- معلومات غير دقيقة تاريخياً
- موقع غير صحيح
- صور غير واضحة
```

---

## Implementation Priority

### Phase 1 (Immediate - Fix Current Issue)
1. ✅ Revert SQL changes (don't show pending missions)
2. ✅ Change success dialog to "pending review" message
3. ✅ Update all messages to proper Arabic

### Phase 2 (Notifications - 1-2 days)
1. Add ACF fields for rejection tracking
2. Create notification database table
3. Add notification API endpoints
4. Implement WordPress hooks for status changes

### Phase 3 (App Integration - 1 day)
1. Create NotificationService
2. Create MissionRejectedDialog
3. Add notification polling/FCM
4. Show MissionSuccessDialog ONLY when approved
5. Add notification badge to UI

### Phase 4 (Admin Experience - 1 day)
1. Create admin page for reviewing missions
2. Add rejection reason text field
3. Quick approve/reject buttons
4. Send email notifications to admins when new mission submitted

---

## Questions for Discussion

1. **Notification Method**: Use Firebase Cloud Messaging (instant) or polling (check every X minutes)?
2. **Approval Time**: What's expected review time? 24 hours? 48 hours?
3. **Email Notifications**: Should admins get email when new mission submitted?
4. **Resubmission**: Can users edit and resubmit rejected missions?
5. **Multiple Rejections**: Limit how many times user can resubmit?
6. **Auto-Approve**: Should trusted users (verified accounts) auto-approve?

---

## Testing Checklist

- [ ] User creates mission → Sees "pending review" message (NOT success)
- [ ] Mission NOT visible on map to anyone (including creator)
- [ ] Admin can see pending missions in dashboard
- [ ] Admin approves → User gets notification → Success dialog shows → Mission visible
- [ ] Admin rejects → User gets notification with reason → Can edit and resubmit
- [ ] All messages display in proper Arabic
- [ ] Sharing works ONLY after approval (not before)

---

## Files to Modify

### Backend (WordPress Plugin)
- `wordpress-plugin/dwp-gamification/includes/class-api-endpoints.php`
  - Revert nearby missions query (line 402-443)
  - Revert mission details query (line 501-515)
- New: `wordpress-plugin/dwp-gamification/includes/class-notifications.php`
- ACF field definitions (via WordPress admin or code)

### Frontend (Flutter App)
- `lib/Missions/create_mission_modal.dart` (line 508) - Change success to pending
- `lib/Repos/MissionRepo.dart` - Add notification endpoints
- New: `lib/services/NotificationService.dart`
- New: `lib/widgets/MissionPendingDialog.dart`
- New: `lib/widgets/MissionRejectedDialog.dart`
- Update: `lib/widgets/MissionSuccessDialog.dart` - Add proper Arabic
- Update: Main app - Add notification polling/listener

---

## Next Steps

1. Discuss this plan
2. Answer questions above
3. Agree on implementation phases
4. Start with Phase 1 (quick fixes)
