# Project Tasks - DealWithPast Gamification

*Last Updated: October 19, 2025*

---

## Phase 1 - Mission Discovery System

### ✅ Completed
- [x] Tag system (neighborhood, decade, theme tags)
- [x] Tag filtering in API
- [x] Category field (social/personal)
- [x] Goal count tracking
- [x] Auto-calculated reward points
- [x] Search bar with RTL Arabic support
- [x] Filter dialog (category chips)
- [x] Progress bar visualization
- [x] Metadata badges (color-coded)
- [x] Responsive mission cards
- [x] Bidirectional mission-story linking
- [x] Mission badge on stories
- [x] Mission info dialog

### 🔄 In Progress
- [ ] **Mission creator info on cards**
  - Show author name and avatar from WordPress post author
  - Location: `lib/Map/map.dart` mission cards
  - Need to fetch author data from WordPress API

---

## Phase 2 - Missions Page & Enhanced Features

### 🆕 Not Started

#### Missions Page (Full Implementation)
- [ ] **Design mission page UI** ⚠️ Needs designer input
  - List/grid view of all missions
  - Filter by category, difficulty, location, tags
  - Sort options: trending, new, completion rate, reward points
  - Visual cards adapted for list view
  - Quick actions: join mission, view details
  - File: `lib/Missions/missions.dart` (currently placeholder)

#### Follow System
- [ ] Follow missions (get updates when new stories added)
- [ ] Follow users (see their contributions)
- [ ] Notifications for followed items
- [ ] Following/followers count display

#### Time Indicators
- [ ] Show when mission was created
- [ ] Display deadlines (if applicable)
- [ ] Show "trending" or "hot" badges for active missions
- [ ] Time-based sorting options

#### User Dashboard
- [ ] Personal stats overview (stories contributed, missions joined)
- [ ] Active missions progress
- [ ] Completed missions history
- [ ] Points/rewards earned
- [ ] Achievement display

#### Achievements/Badges System
- [ ] Define achievement types (first story, 10 stories, complete mission, etc.)
- [ ] Badge design and icons
- [ ] Achievement unlock logic
- [ ] Display achievements on profile
- [ ] Share achievement functionality

---

## Phase 3 - Legacy Board & Social Features

### 🆕 Not Started

#### Legacy Board
- [ ] Hall of fame for completed missions
- [ ] Showcase top contributors
- [ ] Display mission completion stats
- [ ] Highlight impactful stories
- [ ] Timeline of completed community missions

#### Mission Icons/Imagery
- [ ] Custom mission category icons
- [ ] Mission header images/banners
- [ ] Icon selection system in WordPress admin
- [ ] Display icons in mission cards

#### Reactions System
- [ ] Like/favorite missions
- [ ] Comment on missions
- [ ] Share missions (social media, copy link)
- [ ] Reaction counts display
- [ ] Notification for reactions

#### Sharing Functionality
- [ ] Share missions to social media
- [ ] Share stories from missions
- [ ] Generate shareable links
- [ ] Share achievements
- [ ] Social media preview cards

---

## General App Improvements

### Short-term (1-3 months)
- [ ] Story editing functionality (currently can only create, not edit)
- [ ] Enhanced error handling across app
- [ ] Offline story caching for better performance
- [ ] Performance optimization (image loading, list scrolling)
- [ ] UI/UX improvements based on user feedback

### Medium-term (3-6 months)
- [ ] Video/audio support in stories
- [ ] Advanced search and filtering
- [ ] Push notifications system
- [ ] Content moderation tools for admins
- [ ] Analytics and insights dashboard

### Long-term (6+ months)
- [ ] Community features (comments on stories, reactions)
- [ ] Story collections/playlists
- [ ] Multi-language expansion (beyond Arabic/English)
- [ ] AR story viewing (view stories in real-world locations)
- [ ] Export and sharing features (PDF, social media)

---

## Quality & Technical Debt

### Code Quality
- [ ] Address 221 analysis warnings from Flutter analyzer
- [ ] Extract reusable UI components
- [ ] Refactor large widgets (>300 lines)
- [ ] Add documentation to public APIs
- [ ] Improve error handling consistency

### Testing
- [ ] Set up unit tests for repositories
- [ ] Set up widget tests for key screens
- [ ] Test on physical iOS device
- [ ] Test on physical Android device
- [ ] Test various network conditions
- [ ] Test with large datasets

### Performance
- [ ] Profile app launch time (target <3s)
- [ ] Profile story load time (target <2s)
- [ ] Optimize map rendering
- [ ] Ensure smooth scrolling (60fps)
- [ ] Monitor and optimize memory usage

### Dependencies
- [ ] Audit outdated packages (many have newer versions)
- [ ] Plan coordinated dependency upgrade
- [ ] Test compatibility with newer Flutter version
- [ ] Update deprecated API usage

---

## WordPress Plugin Tasks

### Pending Features
- [ ] Mission deadline/expiration dates
- [ ] Mission visibility controls (draft, published, archived)
- [ ] Bulk mission management tools
- [ ] Mission templates for admins
- [ ] Advanced analytics for missions

### Bug Fixes & Improvements
- [ ] Optimize API response times
- [ ] Add caching for frequently accessed missions
- [ ] Improve error messages in admin panel
- [ ] Add validation for mission fields

---

## Design Tasks (Needs Designer)

- [ ] **Missions page UI/UX design** ⚠️ Priority
- [ ] Achievement badge designs
- [ ] Legacy board layout
- [ ] Mission icon set
- [ ] Social sharing preview cards
- [ ] Loading states and animations
- [ ] Error state designs
- [ ] Empty state designs

---

## Notes

- **Java 17 Requirement:** All team members must use Java 17 for building Android
- **Flutter Version:** 3.10.6 (locked, do not upgrade without team coordination)
- **Design Coordination:** Major UI changes need designer approval before implementation
- **Team Collaboration:** This is a multi-developer project - always pull before starting work

---

*This task list is derived from MASTER_PLAN.md and PHASE_1_FEATURES_SUMMARY.md. Update as priorities change.*
