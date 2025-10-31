# Notification System Integration Guide

## Overview
Complete notification system for mission approval workflow with background polling, real-time updates, and rejection dialogs.

## Files Created
- `lib/Repos/NotificationClass.dart` - Notification model
- `lib/Repos/NotificationRepo.dart` - API methods
- `lib/services/NotificationService.dart` - Polling service
- `lib/widgets/NotificationBellIcon.dart` - Bell icon with badge
- `lib/widgets/NotificationListPage.dart` - Notification list
- `lib/widgets/RejectionDialog.dart` - Rejection reason dialog

## Integration Steps

### 1. Initialize NotificationService in Your Main App

Find where you initialize the app after user login (likely in `main.dart` or after login page):

```dart
import 'package:your_app/services/NotificationService.dart';

// After successful login/authentication
final notificationService = NotificationService();
notificationService.startPolling(
  token: yourJwtToken, // User's authentication token
  intervalSeconds: 60, // Poll every 60 seconds (adjust as needed)
);
```

### 2. Add NotificationBellIcon to Your App Bar

In your main scaffold or navigation widget (e.g., `app_bottom_nav.dart` or wherever your app bar is defined):

```dart
import 'package:your_app/widgets/NotificationBellIcon.dart';

AppBar(
  title: Text('Your App Title'),
  actions: [
    NotificationBellIcon(), // Add this
    // Your other app bar actions...
  ],
)
```

### 3. Stop Polling on Logout

When user logs out:

```dart
final notificationService = NotificationService();
notificationService.stopPolling();
```

## Features

### Bell Icon with Badge
- Shows red badge with unread count
- Badge disappears when no unread notifications
- Shows "99+" for counts over 99
- Taps opens notification list

### Notification List
- Pull-to-refresh support
- "Mark all as read" button
- Arabic relative timestamps ("منذ ساعة", "منذ يوم")
- Read/unread visual distinction
- Empty state message

### Rejection Dialog
- Automatic display when tapping rejected mission notification
- Shows rejection reason from admin
- "Edit Mission" button (placeholder - needs mission edit page)
- "Close" button

## Notification Types Supported

1. **mission_approved** - Mission gets approved by admin
   - Shows green check icon
   - Displays success message

2. **mission_rejected** - Mission gets rejected
   - Shows red cancel icon
   - Opens rejection dialog with reason
   - Provides edit option

3. **achievement_unlocked** - User unlocks badge
   - Shows gold trophy icon
   - (Future feature)

## API Endpoints Used

All endpoints are at `https://dwp.world/wp-json/dwp/v1`:

- `GET /notifications` - Get notifications (params: unread_only, limit)
- `GET /notifications/unread-count` - Get count of unread
- `POST /notifications/{id}/read` - Mark single notification as read
- `POST /notifications/read-all` - Mark all as read

## Customization Options

### Polling Interval
Default is 60 seconds. Adjust based on your needs:
- Shorter (30s) = More real-time but more server load
- Longer (120s) = Less real-time but less server load

```dart
notificationService.startPolling(
  token: token,
  intervalSeconds: 30, // Change this
);
```

### Manual Refresh
Call from anywhere to immediately fetch new notifications:

```dart
await NotificationService().refresh();
```

### Listen to Streams
Get real-time updates in your widgets:

```dart
final service = NotificationService();

// Listen to unread count
service.unreadCountStream.listen((count) {
  print('Unread count: $count');
});

// Listen to notifications
service.notificationsStream.listen((notifications) {
  print('New notifications: ${notifications.length}');
});
```

## Dependencies Added

```yaml
dependencies:
  timeago: ^3.0.2       # Relative time formatting
  shared_preferences: ^2.0.15  # Local storage (already added in Session 7)
```

Run `flutter pub get` after pulling this code.

## Testing

### Test Notification Flow:
1. Create a mission in the app
2. Go to WordPress admin (dwp.world/wp-admin)
3. Navigate to Missions → All Missions
4. Find the pending mission
5. Either:
   - Approve: Change status to "Published"
   - Reject: Change status to "Draft", add rejection reason in ACF field
6. Wait up to 60 seconds (polling interval)
7. Check notification bell icon for badge
8. Tap bell to see notification list
9. Tap notification to see details/rejection dialog

### Test Admin Email:
1. Create a mission
2. Check admin@dwp.world inbox
3. Should receive email with mission details

## WordPress Backend

The notification system is already set up in WordPress:
- `wordpress-plugin/dwp-gamification/includes/class-notification-handler.php`
- Notifications created automatically when mission status changes
- No additional WordPress work needed

## Next Steps

1. ✅ Add NotificationBellIcon to app bar
2. ✅ Initialize NotificationService after login
3. ✅ Test with real mission submissions
4. ⏳ Implement mission edit page (for rejection dialog "Edit" button)
5. ⏳ Add FCM push notifications (Phase 2.5)

## Troubleshooting

**No notifications showing?**
- Check that user is logged in with valid JWT token
- Verify token is passed to `startPolling()`
- Check console for API errors
- Verify mission status actually changed in WordPress

**Badge not updating?**
- Wait for polling interval (default 60s)
- Try manual refresh: `NotificationService().refresh()`
- Check that streams are being listened to

**Arabic timestamps not showing?**
- Timeago Arabic locale is registered in NotificationListPage
- Should work automatically

## Code Quality Notes

- All widgets are RTL-compliant
- Uses Tajawal font (already in project)
- Follows existing app color scheme
- Null-safe code
- Stream-based reactive architecture
- Singleton pattern for NotificationService
