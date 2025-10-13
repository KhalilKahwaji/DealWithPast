# DWP Gamification Plugin - Installation Instructions

## 📦 What You Have

The complete WordPress plugin is in: `wordpress-plugin/dwp-gamification/`

**Files created:**
- `dwp-gamification.php` - Main plugin file
- `database/schema.php` - Creates 3 database tables
- `includes/class-mission-cpt.php` - Missions custom post type + ACF fields
- `includes/class-api-endpoints.php` - REST API endpoints
- `includes/class-achievement-manager.php` - Achievement system
- `includes/class-notification-handler.php` - Notifications
- `README.md` - Full documentation

---

## 🚀 Installation Steps (10 minutes)

### Step 1: Zip the Plugin (2 minutes)

1. Navigate to: `C:\Users\ziadf\Documents\Projects\UNDP\wordpress-plugin\`
2. **Right-click** on the `dwp-gamification` folder
3. Select **"Send to" → "Compressed (zipped) folder"**
4. You'll get: `dwp-gamification.zip`

### Step 2: Upload to WordPress (3 minutes)

1. Go to: https://dwp.world/wp-admin
2. Log in with "Continue with Google"
3. Go to: **Plugins → Add New**
4. Click **"Upload Plugin"** button (top of page)
5. Click **"Choose File"**
6. Select `dwp-gamification.zip`
7. Click **"Install Now"**
8. Wait for upload (10-15 seconds)
9. Click **"Activate Plugin"**

### Step 3: Verify Installation (2 minutes)

After activation, check these:

**✅ New Menu Item:**
- Look at left sidebar
- You should see **"Missions"** with location pin icon
- Click it to verify

**✅ Database Tables Created:**
- Go to: **Database Manager → Open WP Adminer** (you have this plugin)
- Look for these 3 tables:
  - `wp_user_missions`
  - `wp_user_achievements`
  - `wp_dwp_notifications`

**✅ REST API Active:**
- Open browser, visit:
  ```
  https://dwp.world/wp-json/dwp/v1/
  ```
- You should see: `{"code":"rest_no_route","message":"No route was found matching the URL and request method"}`
- This is GOOD - it means the API namespace is registered

**✅ ACF Fields Added:**
- Go to: **Missions → Add New**
- Scroll down, you should see **"Mission Details"** box with fields:
  - Latitude
  - Longitude
  - Address
  - Linked Story
  - Difficulty
  - Mission Type
  - Completion Count
  - Active
  - Reward Points

---

## 🧪 Test the Plugin (5 minutes)

### Create Your First Test Mission

1. Go to: **Missions → Add New**
2. Fill in:
   - **Title:** "Visit Martyrs' Square"
   - **Description:** "Visit the historic Martyrs' Square in central Beirut and learn about its significance during the Lebanese Civil War."
   - **Latitude:** 33.8938
   - **Longitude:** 35.5018
   - **Address:** "Martyrs' Square, Beirut, Lebanon"
   - **Difficulty:** Easy
   - **Mission Type:** Visit Location
   - **Linked Story:** (select one if available)
   - **Active:** Yes (checked)
   - **Reward Points:** 10
3. Upload a **Featured Image** (mission photo)
4. Click **"Publish"**

### Test the API

Open these URLs in your browser:

**Test 1: Get nearby missions**
```
https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=10
```
**Expected:** JSON response with your test mission

**Test 2: Get all missions**
```
https://dwp.world/wp-json/wp/v2/missions
```
**Expected:** JSON array with your test mission

**Test 3: Get achievements**
```
https://dwp.world/wp-json/dwp/v1/achievements/all
```
**Expected:** JSON array with 7 achievements

---

## ✅ Success Checklist

- [ ] Plugin uploaded and activated
- [ ] "Missions" menu appears in WordPress admin
- [ ] 3 database tables created
- [ ] REST API endpoints respond
- [ ] ACF fields visible when creating mission
- [ ] Test mission created successfully
- [ ] API returns test mission in JSON

---

## 🐛 Troubleshooting

### Plugin won't activate
**Error:** "The plugin does not have a valid header"
**Fix:** Re-zip the `dwp-gamification` folder (not the parent folder)

### ACF fields not showing
**Error:** No "Mission Details" box when creating mission
**Fix:**
1. Go to **Plugins** → verify "Advanced Custom Fields PRO" is **Active**
2. Go to **Settings → Permalinks** → click **"Save Changes"** (flushes rewrite rules)
3. Deactivate and reactivate DWP Gamification plugin

### API returns 404
**Error:** `https://dwp.world/wp-json/dwp/v1/missions/nearby` returns 404
**Fix:**
1. Go to **Settings → Permalinks**
2. Make sure it's set to **"Post name"** (not "Plain")
3. Click **"Save Changes"**

### Database tables not created
**Error:** Tables missing in phpMyAdmin
**Fix:**
1. Deactivate the plugin
2. Activate it again (this triggers the activation hook)
3. Check database again

---

## 📊 What's Next?

Once the plugin is working:

### Phase 1 Week 3 Remaining Tasks:
1. **Create 9 more test missions** (total 10 missions in Beirut area)
2. **Test all API endpoints with Postman**
3. **Test achievement unlock** (start + complete mission)
4. **Brief Flutter team** on new API endpoints

### Documentation to Share with Flutter Team:
- `wordpress-plugin/dwp-gamification/README.md` - API documentation
- Postman collection (we'll create this next)
- Base URL: `https://dwp.world/wp-json/dwp/v1/`

---

## 🆘 Need Help?

If anything goes wrong:
1. Enable **WP_DEBUG** in `wp-config.php`
2. Check **Tools → Site Health → Info** for errors
3. Check browser console when testing API endpoints
4. Take screenshot of error and we'll debug

---

## 🎉 You're Ready!

Once you see ✅ on all checklist items above, **Phase 1 WordPress backend is 60% complete!**

Next session: We'll create the remaining test missions and test the entire API.
