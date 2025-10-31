# Master Plan - DealWithPast (خارطة وذاكرة)

## Vision
Create a mobile platform that empowers communities to preserve and share their collective memory through geolocated stories, photos, and historical documentation. Support UNDP's mission of cultural preservation and historical awareness.

## Success Criteria
- [ ] Maintain stable app with <0.5% crash rate
- [ ] Preserve and display stories with accurate geolocation
- [ ] Support both Arabic (RTL) and English (LTR) seamlessly
- [ ] Enable anonymous and authenticated story submissions
- [ ] Provide intuitive map-based browsing experience
- [ ] Maintain WordPress backend integration
- [ ] Ensure offline capability for story viewing

## Current Status
- **Version:** 8.2.3
- **Phase:** Active Maintenance & Enhancement
- **Primary Goals:** Bug fixes, feature improvements, performance optimization

## App Architecture

### Current Structure
```
lib/
├── Backend/          # Auth (Google/Apple), WordPress API clients
├── Homepages/        # Landing pages, main navigation, guest/logged-in views
├── Map/              # Google Maps integration, markers, clustering
├── My Stories/       # User story creation, editing, management
├── View Stories/     # Browse all stories, filtering, viewing
├── Timeline/         # Chronological story display
├── Gallery/          # Image galleries, photo viewing
├── Repos/            # Data models (Story, User), repositories
├── ContactUs.dart    # Contact/support functionality
├── profile*.dart     # User profiles (multiple variants)
└── main.dart         # Entry point
```

### Key Components

#### 1. Story System
- **Models:** StoryClass.dart (title, description, date, location, media)
- **Repository:** StoryRepo.dart (CRUD operations via WordPress API)
- **Screens:** addStory.dart, Stories.dart, StoriesView.dart
- **Features:** Create, view, browse stories with location and media

#### 2. Interactive Map
- **Implementation:** Google Maps Flutter with clustering
- **Features:** Display story locations, marker clustering, location selection
- **File:** Map/map.dart

#### 3. Authentication
- **Provider:** Firebase Authentication
- **Methods:** Google Sign-In, Apple Sign-In
- **Files:** Backend/auth.dart, Backend/Login.dart
- **Flow:** Guest mode available, optional authentication

#### 4. WordPress Integration
- **Backend:** dwp.world WordPress site
- **API:** WordPress REST API (custom story post type)
- **Auth:** JWT bearer tokens
- **Endpoints:** /wp-json/wp/v2/stories/

#### 5. Localization
- **Primary Language:** Arabic (ar_MA)
- **Secondary:** English
- **RTL Support:** Full right-to-left layout for Arabic
- **Implementation:** flutter_localizations

## Technology Stack

### Framework & Language
- **Flutter:** Dart-based mobile framework
- **Dart SDK:** >= 2.12.0 < 3.0.0

### Core Dependencies
- **firebase_core:** 2.1.1 - Firebase integration
- **firebase_auth:** 4.1.1 - Authentication
- **google_sign_in:** 5.2.1 - Google OAuth
- **sign_in_with_apple:** 4.1.0 - Apple OAuth

### Maps & Location
- **google_maps_flutter:** 2.1.1 - Map display
- **google_maps_cluster_manager:** 3.0.0 - Marker clustering
- **geocoding:** 2.0.1 - Address/coordinate conversion
- **geolocator:** 9.0.1 - Device location
- **location:** 4.2.0 - Location permissions

### Data & Storage
- **sqflite:** Latest - Local SQLite database
- **http:** 0.13.4 - HTTP requests
- **dio:** 4.0.4 - Advanced HTTP client

### Media & UI
- **image_picker:** 0.8.4+4 - Camera/gallery access
- **file_picker:** 4.2.8 - File selection
- **cached_network_image:** 3.1.0+1 - Image caching
- **carousel_slider:** 4.0.0 - Image carousels
- **webview_flutter:** 3.0.4 - WebView embedding

### Utilities
- **flutter_easyloading:** 3.0.3 - Loading indicators
- **url_launcher:** 6.0.17 - External links
- **flutter_email_sender:** 5.1.0 - Email functionality
- **intl:** 0.20.2 - Internationalization

## Development Priorities

### Immediate (Next 2-4 weeks)
*To be defined based on current needs*
- [ ] Bug assessment and prioritization
- [ ] Performance profiling
- [ ] Code quality review
- [ ] Dependency audit and updates (if safe)

### Short-term (1-3 months)
*Suggestions - adjust based on priorities*
- [ ] Story editing functionality
- [ ] Enhanced error handling
- [ ] Offline story caching
- [ ] Performance optimization
- [ ] UI/UX improvements

### Medium-term (3-6 months)
*Future considerations*
- [ ] Video/audio support in stories
- [ ] Advanced search and filtering
- [ ] Push notifications
- [ ] Content moderation tools
- [ ] Analytics and insights

### Long-term (6+ months)
*Strategic enhancements*
- [ ] Community features (comments, reactions)
- [ ] Story collections/playlists
- [ ] Multi-language expansion
- [ ] AR story viewing
- [ ] Export and sharing features

## Quality Standards

### Code Quality
- Keep widgets focused and < 300 lines
- Extract reusable UI components
- Document public APIs
- Handle all API errors gracefully
- Follow Dart style guide

### Testing
- Manual test on both iOS and Android
- Test Arabic (RTL) and English (LTR) modes
- Test with various network conditions
- Test with large datasets
- Test authentication flows

### Performance
- App launch < 3 seconds
- Story load < 2 seconds
- Map render < 1 second
- Smooth scrolling (60fps)
- Efficient memory usage

### Accessibility
- Proper semantic labels
- Sufficient color contrast
- Screen reader support
- Adjustable text sizes

## Risk Management

### Technical Risks
1. **WordPress API Dependency**
   - Mitigation: Robust error handling, local caching, offline mode

2. **Google Maps Quota**
   - Mitigation: Efficient clustering, monitor usage, optimize API calls

3. **Large Media Files**
   - Mitigation: Image compression, lazy loading, pagination

4. **State Management Complexity**
   - Mitigation: Consider Provider/Riverpod if state grows complex

5. **Deprecated Dependencies**
   - Mitigation: Regular dependency audits, gradual migration plan

### Business Risks
1. **User Adoption**
   - Mitigation: Focus on UX, user feedback, community engagement

2. **Content Moderation**
   - Mitigation: Report system, admin tools, community guidelines

3. **Data Privacy**
   - Mitigation: Privacy policy, GDPR compliance, user consent

## Success Metrics

### Technical Health
- Crash-free rate: Target >99.5%
- API response time: Target <500ms
- App load time: Target <3s
- User retention: Monitor Day 1, 7, 30

### Content Metrics
- Stories submitted per week
- Active users (DAU/MAU)
- Average session duration
- Stories viewed per user

### Quality Metrics
- Bug count by priority
- Bug resolution time
- Code coverage (if testing implemented)
- Widget reuse percentage

## Development Workflow

### Before Starting Work
1. Read PROJECT_STATE.md
2. Review BUGS.md for blockers
3. Check CHANGELOG.md for recent changes
4. Verify `flutter pub get` runs successfully

### During Development
1. Test on both iOS and Android (if UI-related)
2. Test both Arabic and English modes
3. Add error handling for API calls
4. Document significant changes
5. Commit with clear messages

### After Completing Work
1. Update CHANGELOG.md
2. Update PROJECT_STATE.md metrics
3. Log or close bugs in BUGS.md
4. Run `flutter analyze`
5. Test on real devices if possible

## Notes
- App name is "interactive_map" in pubspec.yaml but branded as "DealWithPast"
- Primary market: Arabic-speaking regions (Morocco indicated by ar_MA locale)
- Current version: 8.2.3 (build 823)
- Guest mode available - authentication optional
- Stories synced from WordPress backend at dwp.world

---

*This master plan is a living document. Update as project priorities and requirements evolve.*
