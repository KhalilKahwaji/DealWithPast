# Mission Approval Workflow - Implementation Status

**Date:** October 26, 2025
**Status:** Backend Complete ✅ | Frontend In Progress 🔄

---

## ✅ COMPLETED - Backend (WordPress Plugin)

### 1. SQL Changes Reverted
**File:** `wordpress-plugin/dwp-gamification/includes/class-api-endpoints.php`
- ✅ Reverted nearby missions query (line 397)
- ✅ Only shows `post_status = 'publish'` missions
- ✅ Pending missions NOT visible to anyone (including creator)
- ✅ Reverted mission details endpoint (line 474)

### 2. Notification System Integration
**File:** `wordpress-plugin/dwp-gamification/includes/class-notification-handler.php`
- ✅ Existing notification endpoints confirmed (`/wp-json/dwp/v1/notifications`)
- ✅ Notification database table exists (`wp_dwp_notifications`)
- ✅ Added mission status change hooks (line 21)
- ✅ Handles: pending→publish (APPROVED), pending→trash (REJECTED), new→pending (SUBMITTED)

### 3. Arabic Notifications
**Arabic messages implemented:**
```
APPROVED: "تم قبول مهمتك! يمكنك الآن مشاركتها مع الآخرين"
REJECTED: "لم يتم قبول المهمة. السبب: [admin reason]"
SUBMISSION: Email sent to admin
```

### 4. Admin Email Notifications
**File:** `class-notification-handler.php` (line 410)
- ✅ Sends UTF-8 email to admin@dwp.world when mission submitted
- ✅ Includes mission details, creator info, coordinates
- ✅ Link to WordPress admin for review
- ✅ 24-hour review time mentioned

### 5. Rejection Reason Field
**File:** `wordpress-plugin/dwp-gamification/includes/class-mission-cpt.php` (line 268)
- ✅ Added ACF field `rejection_reason` (textarea)
- ✅ Label in Arabic: "Rejection Reason (سبب الرفض)"
- ✅ Placeholder: "اكتب سبب رفض المهمة هنا..."
- ✅ Admin sees this field in mission editor

### 6. Pending Missions Endpoint
**File:** `class-api-endpoints.php` (line 1372)
- ✅ New endpoint: `GET /wp-json/dwp/v1/missions/my-pending`
- ✅ Returns user's pending missions (for tracking submissions)
- ✅ Includes rejection_reason if previously rejected

### 7. Story Preservation
**File:** `class-notification-handler.php` (line 393)
- ✅ Comment added: "DO NOT delete stories attached to this mission"
- ✅ Missions can be deleted, stories must be preserved
- ⚠️ Note: Story deletion logic NOT modified (as requested)

### 8. Plugin Repackaged
- ✅ `wordpress-plugin/dwp-gamification.zip` updated
- ✅ Ready for upload to WordPress

---

## 🔄 IN PROGRESS - Frontend (Flutter App)

### Still Need to Implement:

#### 1. Change Mission Creation Success Flow
**File:** `lib/Missions/create_mission_modal.dart` (line 508)
- **CURRENT:** Shows `MissionSuccessDialog` immediately
- **NEED:** Show "pending review" message instead
- **Change:**
```dart
// REMOVE:
await Mission SuccessDialog.show(...);

// REPLACE WITH:
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      'تم إرسال المهمة للمراجعة. سيتم إخطارك عند الموافقة عليها (خلال 24 ساعة)',
      style: TextStyle(fontFamily: 'Tajawal'),
    ),
    backgroundColor: Color(0xFF5A7C59),
    duration: Duration(seconds: 5),
  ),
);
```

#### 2. Create MissionPendingDialog (Alternative)
**New File:** `lib/widgets/MissionPendingDialog.dart`
- Show after successful submission
- Icon: ⏳ or 🕐
- Title: "تم إرسال المهمة للمراجعة"
- Message: "سيتم إخطارك عندما يتم مراجعة مهمتك من قبل الفريق (عادة خلال 24 ساعة)"
- Button: "حسناً"

#### 3. Create NotificationService
**New File:** `lib/services/NotificationService.dart`
- Poll `/wp-json/dwp/v1/notifications` every 30 seconds
- Check for `mission_approved` type → Show MissionSuccessDialog
- Check for `mission_rejected` type → Show MissionRejectedDialog
- Store last check timestamp to avoid duplicates

#### 4. Create MissionRejectedDialog
**New File:** `lib/widgets/MissionRejectedDialog.dart`
- Icon: ⚠️ or ℹ️
- Title: "لم يتم قبول المهمة"
- Show `rejection_reason` from notification
- Buttons:
  - "تعديل المهمة" → Navigate to edit (can resubmit)
  - "إغلاق"

#### 5. Update MissionSuccessDialog
**File:** `lib/widgets/MissionSuccessDialog.dart`
- Keep existing design (looks great!)
- **Only show when:** `mission_approved` notification received
- Update messages to proper Arabic
- Change "Mission Created Successfully!" to "تم قبول مهمتك!"

#### 6. Add Notification Badge
**File:** `lib/widgets/app_bottom_nav.dart` or main screen
- Show red dot/number badge when unread notifications > 0
- Tap → Navigate to notifications screen
- Show `MissionSuccessDialog` or `MissionRejectedDialog` based on type

---

## 📋 Testing Checklist

### Backend Testing (WordPress)
- [ ] Upload plugin to WordPress
- [ ] Activate plugin
- [ ] Create test mission via app → Should go to "pending" status
- [ ] Check admin email received
- [ ] Approve mission in WordPress admin → Check notification created
- [ ] Reject mission with reason → Check notification has rejection_reason
- [ ] Verify mission NOT visible on map until approved

### Frontend Testing (After Implementation)
- [ ] Create mission → See "pending review" message (NOT success)
- [ ] Mission NOT visible on map
- [ ] Admin approves → Notification received → Success dialog shows
- [ ] Admin rejects → Notification received → Rejection dialog shows reason
- [ ] Can edit and resubmit rejected mission
- [ ] Sharing works ONLY after approval (not before)

---

## 🎯 Next Steps (Priority Order)

1. **Upload plugin to WordPress** (5 min)
   - Replace existing plugin with updated zip
   - Verify activation

2. **Quick Fix: Change submission message** (10 min)
   - Edit `create_mission_modal.dart` line 508
   - Replace success dialog with SnackBar
   - Test mission creation

3. **Create NotificationService** (30 min)
   - Implement polling mechanism
   - Handle mission_approved and mission_rejected

4. **Create dialogs** (20 min each)
   - MissionPendingDialog (optional but nice)
   - MissionRejectedDialog (required)

5. **Add notification badge** (15 min)
   - Show unread count
   - Navigate to notifications

6. **Full testing** (30 min)
   - Create → Submit → Approve → Verify
   - Create → Submit → Reject → Verify

---

## 📊 Implementation Timeline

| Phase | Task | Status | Time |
|-------|------|--------|------|
| 1 | Backend SQL revert | ✅ Done | 15 min |
| 1 | Notification hooks | ✅ Done | 30 min |
| 1 | Admin email | ✅ Done | 20 min |
| 1 | ACF rejection field | ✅ Done | 10 min |
| 1 | Plugin repackage | ✅ Done | 5 min |
| **2** | **Upload plugin** | ⏳ Next | 5 min |
| **2** | **Fix submission message** | ⏳ Next | 10 min |
| 2 | NotificationService | ⏳ Pending | 30 min |
| 2 | MissionRejectedDialog | ⏳ Pending | 20 min |
| 2 | Notification badge | ⏳ Pending | 15 min |
| 3 | Full testing | ⏳ Pending | 30 min |

**Total Time:** ~3 hours (1.5h done, 1.5h remaining)

---

## 🚀 Ready to Continue?

**Backend is 100% complete!** ✅

Plugin file ready at: `wordpress-plugin/dwp-gamification.zip`

**Next action:** Upload to WordPress and test, then implement frontend changes.

Let me know when you're ready to continue with the Flutter app implementation!
