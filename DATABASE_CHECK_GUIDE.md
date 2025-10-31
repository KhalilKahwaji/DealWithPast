# Database Check Guide - For Teams Using Database Admin Plugins

## Understanding the Database Structure

Your missions are stored across **multiple tables**, not in a single table. This is why some tables appear empty even though the API returns data.

---

## ⚠️ IMPORTANT: Which Tables to Check

### ✅ Tables WITH Mission Data (Check These!)

#### 1. **`wp_posts`** - Mission Records
This table contains the actual mission posts.

**SQL Query to Check:**
```sql
SELECT ID, post_title, post_type, post_status, post_date
FROM wp_posts
WHERE post_type = 'mission'
ORDER BY ID DESC
LIMIT 10;
```

**What You Should See:**
- 9 rows with `post_type = 'mission'`
- Mission titles like "ذاكرة ساحة الشهداء", "Sursock Museum Art Hunt", etc.
- `post_status` should be 'publish'

**Screenshot This Table to Share!**

---

#### 2. **`wp_postmeta`** - Mission Details
This table contains all the mission metadata (latitude, longitude, difficulty, reward points, etc.)

**SQL Query to Check:**
```sql
SELECT post_id, meta_key, meta_value
FROM wp_postmeta
WHERE post_id IN (
  SELECT ID FROM wp_posts WHERE post_type = 'mission'
)
AND meta_key IN ('latitude', 'longitude', 'difficulty', 'category', 'reward_points', 'goal_count')
ORDER BY post_id DESC, meta_key;
```

**What You Should See:**
- Hundreds of rows with mission metadata
- `meta_key` values like: latitude, longitude, difficulty, category, etc.
- `meta_value` with the actual data

---

### ❌ Tables That ARE Empty (This is Normal!)

#### 3. **`wp_user_missions`** - User Progress Tracking
**Status:** EMPTY (No users have started missions yet)

This table will ONLY have data when:
- A user starts a mission via the app
- A user completes a mission

**It's supposed to be empty right now!**

---

#### 4. **`wp_user_achievements`** - User Badges
**Status:** EMPTY (No users have unlocked achievements yet)

This table will ONLY have data when users complete missions and unlock badges.

**It's supposed to be empty right now!**

---

#### 5. **`wp_dwp_notifications`** - Push Notifications
**Status:** EMPTY (No notifications sent yet)

This table will have data when the system sends notifications to users.

**It's supposed to be empty right now!**

---

## Quick Verification Steps for Your Team

### Step 1: Count Missions
```sql
SELECT COUNT(*) as total_missions
FROM wp_posts
WHERE post_type = 'mission'
AND post_status = 'publish';
```
**Expected Result:** 9

---

### Step 2: Show Mission List
```sql
SELECT
  p.ID,
  p.post_title as mission_name,
  p.post_status,
  (SELECT meta_value FROM wp_postmeta WHERE post_id = p.ID AND meta_key = 'latitude' LIMIT 1) as lat,
  (SELECT meta_value FROM wp_postmeta WHERE post_id = p.ID AND meta_key = 'longitude' LIMIT 1) as lng,
  (SELECT meta_value FROM wp_postmeta WHERE post_id = p.ID AND meta_key = 'difficulty' LIMIT 1) as difficulty,
  (SELECT meta_value FROM wp_postmeta WHERE post_id = p.ID AND meta_key = 'category' LIMIT 1) as category
FROM wp_posts p
WHERE p.post_type = 'mission'
ORDER BY p.ID DESC;
```

**Expected Result:** 9 missions with complete data

---

### Step 3: Check Mission Metadata Count
```sql
SELECT COUNT(*) as total_metadata
FROM wp_postmeta
WHERE post_id IN (
  SELECT ID FROM wp_posts WHERE post_type = 'mission'
);
```
**Expected Result:** 100+ rows (each mission has ~15 metadata fields)

---

## What to Tell Your Team

### ✅ **The Database IS NOT Empty!**

1. **Mission data exists in `wp_posts` table** (9 missions)
2. **Mission details exist in `wp_postmeta` table** (100+ metadata records)
3. **Custom tables are empty because no users have used the app yet** (this is expected)

### 📊 **How WordPress Stores Custom Post Types**

WordPress doesn't create a separate table for each custom post type. Instead:
- All posts (blog posts, pages, missions, stories) → `wp_posts`
- All metadata (custom fields) → `wp_postmeta`
- Custom tables (`wp_user_missions`) → Only for tracking relationships

This is the **standard WordPress architecture** - it's not a bug!

---

## Visual Guide for Database Admin Plugins

### If Using "WP Data Access" Plugin:
1. Click "Explore" in sidebar
2. Select table: `wp_posts`
3. Add filter: `post_type = 'mission'`
4. Click "Search"
5. You should see 9 missions

### If Using "Adminer" or "phpMyAdmin":
1. Select your WordPress database
2. Click on `wp_posts` table
3. Go to "SQL" tab
4. Paste the SQL queries above
5. Click "Execute"

### If Using "Database Browser" Plugin:
1. Browse Tables → `wp_posts`
2. Add WHERE clause: `post_type = 'mission'`
3. Results will show

---

## Still Not Seeing Data?

### Check These Common Issues:

#### Issue 1: Wrong Database Selected
Make sure you're viewing the **production database**, not a local/dev copy.

#### Issue 2: Table Prefix is Different
Your site might use a different prefix (e.g., `wpxx_posts` instead of `wp_posts`)

**Find your prefix:**
```sql
SHOW TABLES LIKE '%posts';
```

Then replace `wp_` with your actual prefix in all queries.

#### Issue 3: Looking at Wrong Post Type
Make sure the filter is exactly: `post_type = 'mission'` (lowercase, singular)

---

## Test the API Instead

The easiest way to prove data exists:

**Open this URL in any browser:**
```
https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=100
```

**You'll see JSON with 9 missions immediately!**

This proves:
- Database has data ✅
- Plugin is working ✅
- API is functional ✅

---

## Summary for Non-Technical Team Members

**Question:** "Why do some tables appear empty?"

**Answer:** Because WordPress stores mission data in shared tables (`wp_posts` and `wp_postmeta`), not dedicated mission tables. The custom tables (`wp_user_missions`, etc.) will only fill up when users start using the app.

**Think of it like this:**
- `wp_posts` = Master list of all content (missions, stories, pages)
- `wp_postmeta` = Details about each piece of content
- `wp_user_missions` = User activity tracking (empty until users engage)

---

## Contact

If your team still has questions, share these resources:
1. This document (DATABASE_CHECK_GUIDE.md)
2. API test URL: `https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=100`
3. API testing guide: `API_TESTING_GUIDE.md`

**Bottom line:** The data is there - just need to look in the right tables! 🚀
