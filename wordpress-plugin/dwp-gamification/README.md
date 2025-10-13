# DWP Gamification Plugin

WordPress plugin for DealWithPast gamification system - Missions, Achievements, and Memorial Plaques.

## Requirements

- WordPress 6.0+
- PHP 7.4+
- **Advanced Custom Fields (ACF) PRO** (already installed ✓)
- **JWT Authentication for WP-API** (already installed ✓)

## Installation

### Method 1: Upload via WordPress Admin (Recommended)

1. **Download** this entire `dwp-gamification` folder
2. **Zip it** (right-click folder → "Compress to ZIP file")
3. **Log into** https://dwp.world/wp-admin
4. Go to: **Plugins → Add New → Upload Plugin**
5. **Choose File** → select the ZIP file
6. Click **Install Now**
7. Click **Activate Plugin**

### Method 2: Manual FTP Upload

1. Upload the entire `dwp-gamification` folder to `/wp-content/plugins/`
2. Go to WordPress Admin → **Plugins**
3. Find "DWP Gamification" and click **Activate**

## What Happens on Activation

The plugin will automatically:
- ✅ Create 3 database tables:
  - `wp_user_missions` (track user progress)
  - `wp_user_achievements` (track unlocked achievements)
  - `wp_dwp_notifications` (store notifications)
- ✅ Register "Mission" custom post type
- ✅ Add ACF fields for missions (latitude, longitude, difficulty, etc.)
- ✅ Enable REST API endpoints at `/wp-json/dwp/v1/`

## After Activation

### Step 1: Create Test Missions

1. Go to: **Missions → Add New**
2. Fill in:
   - **Title**: "Visit Martyrs' Square"
   - **Description**: Write mission instructions
   - **Latitude**: 33.8938
   - **Longitude**: 35.5018
   - **Address**: "Martyrs' Square, Beirut, Lebanon"
   - **Difficulty**: Easy
   - **Mission Type**: Visit Location
   - **Linked Story**: (select existing story if available)
   - **Featured Image**: Upload mission photo
3. Click **Publish**

### Step 2: Test API Endpoints

Open browser and visit:

**Get nearby missions:**
```
https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=10
```

**Get all missions:**
```
https://dwp.world/wp-json/wp/v2/missions
```

### Step 3: Check Database Tables

Go to: **Database Manager → WP Adminer** (you have this plugin installed)

Check these tables exist:
- `wp_user_missions`
- `wp_user_achievements`
- `wp_dwp_notifications`

## REST API Endpoints

All endpoints are at: `https://dwp.world/wp-json/dwp/v1/`

### Missions

- `GET /missions/nearby` - Get missions near location
  - Parameters: `lat`, `lng`, `radius` (km)

- `GET /missions/{id}` - Get mission details

- `POST /missions/start` - Start a mission
  - Requires JWT auth
  - Body: `{"mission_id": 123}`

- `POST /missions/complete` - Complete a mission
  - Requires JWT auth
  - Body: `{"mission_id": 123, "proof_media": ["url1", "url2"]}`

- `GET /missions/my-missions` - Get user's missions
  - Requires JWT auth

### Achievements

- `GET /achievements` - Get user's achievements (locked/unlocked)
  - Requires JWT auth

### Notifications

- `GET /notifications` - Get user's notifications
  - Requires JWT auth

- `POST /notifications/{id}/read` - Mark notification as read
  - Requires JWT auth

## Built-in Achievements

The plugin includes 7 achievements that auto-unlock:

1. **First Steps** - Complete 1 mission
2. **Explorer** - Complete 5 missions
3. **Historian** - Complete 10 missions
4. **Guardian of Memory** - Complete 25 missions
5. **Memorial Keeper** - Create 1 memorial plaque
6. **Story Teller** - Add 3 stories
7. **Community Builder** - Have 10 followers

## Troubleshooting

### Plugin won't activate
- Check PHP version (need 7.4+)
- Check WordPress version (need 6.0+)
- Enable **WP_DEBUG** in `wp-config.php` to see errors

### ACF fields not showing
- Make sure ACF Pro is activated
- Go to **Settings → Permalinks** and click **Save Changes** (flushes rewrite rules)

### API returns 404
- Go to **Settings → Permalinks**
- Make sure it's set to "Post name" (not "Plain")
- Click **Save Changes**

### JWT auth not working
- Check JWT plugin is activated
- Test token endpoint: `https://dwp.world/wp-json/jwt-auth/v1/token`

## File Structure

```
dwp-gamification/
├── dwp-gamification.php (main plugin file)
├── README.md (this file)
├── includes/
│   ├── class-mission-cpt.php (missions post type)
│   ├── class-api-endpoints.php (REST API)
│   ├── class-achievement-manager.php (achievements)
│   └── class-notification-handler.php (notifications)
├── database/
│   └── schema.php (database tables)
└── admin/
    └── views/ (admin UI - future)
```

## Support

For issues, contact Ziad or check:
- GitHub: [Your repo]
- Documentation: `Gamification/WORDPRESS_DEV_ROADMAP.md`

## Version

**1.0.0** - Initial release (Phase 1: Mission Discovery Foundation)

## License

GPL v2 or later
