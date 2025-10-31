# Artist Asset Pipeline & Specifications
## DealWithPast Gamification System

**Created:** 2025-10-12
**Purpose:** Define all visual assets needed from artist/designer
**Cultural Lead:** Ziad (Lebanese Cultural Approval Required)

---

## Overview

This document specifies all visual assets required for the gamification system. All designs MUST be reviewed and approved by Ziad for cultural sensitivity before implementation.

---

## 1. Achievement Badge Icons (14 Icons)

### Specifications
- **Format:** PNG with transparency
- **Sizes:** 3 variants each
  - `@1x`: 128x128px (base)
  - `@2x`: 256x256px (iOS Retina)
  - `@3x`: 384x384px (Android xxhdpi)
- **File naming:** `achievement_[slug]_[size].png`
  - Example: `achievement_first_mission_1x.png`
- **Color mode:** RGBA
- **Style:** Culturally appropriate, Lebanese/Middle Eastern motifs

### Required Badges

#### Tier 1: Beginner (3 badges)
1. **First Steps** (`first_mission`)
   - **Description:** Complete first mission
   - **Visual suggestion:** Footprints on ancient stone
   - **Cultural note:** Could incorporate Lebanese cedar motif

2. **Explorer** (`five_missions`)
   - **Description:** Complete 5 missions
   - **Visual suggestion:** Compass with Lebanese map outline

3. **Story Teller** (`story_teller`)
   - **Description:** Add 3 stories to the map
   - **Visual suggestion:** Open book with Arabic calligraphy accent

#### Tier 2: Intermediate (5 badges)
4. **Historian** (`ten_missions`)
   - **Description:** Complete 10 missions
   - **Visual suggestion:** Scroll with wax seal

5. **Memorial Keeper** (`memorial_keeper`)
   - **Description:** Create first memorial plaque
   - **Visual suggestion:** Marble plaque with olive branch

6. **Community Builder** (`community_builder`)
   - **Description:** Have 10 followers
   - **Visual suggestion:** Circle of people holding hands (abstract)

7. **Photographer** (`photographer`)
   - **Description:** Upload 20 photos
   - **Visual suggestion:** Camera with Lebanon silhouette

8. **Interviewer** (`interviewer`)
   - **Description:** Complete 5 interview missions
   - **Visual suggestion:** Microphone with sound waves

#### Tier 3: Advanced (4 badges)
9. **Guardian of Memory** (`guardian`)
   - **Description:** Complete 25 missions
   - **Visual suggestion:** Shield with cedar tree emblem

10. **Elder Wisdom** (`elder_wisdom`)
    - **Description:** Interview 10 elders
    - **Visual suggestion:** Wise elder silhouette with laurel wreath

11. **Pilgrimage** (`pilgrimage`)
    - **Description:** Visit 15 historical sites
    - **Visual suggestion:** Ancient pillar with hiking boots

12. **Connector** (`connector`)
    - **Description:** Introduce 2 users who then collaborate
    - **Visual suggestion:** Bridge connecting two points

#### Tier 4: Master (2 badges)
13. **Legacy Builder** (`legacy_builder`)
    - **Description:** Create 10 memorial plaques
    - **Visual suggestion:** Monument with rays of light

14. **Keeper of Stories** (`keeper_of_stories`)
    - **Description:** Complete 50 missions + 20 stories
    - **Visual suggestion:** Golden book with cedar tree on cover

---

## 2. Memorial Plaque Templates (3 Designs)

### Specifications
- **Format:** SVG (vector) + PNG exports
- **Dimensions:** 1080x1920px (9:16 portrait, standard phone wallpaper)
- **Editable text areas:** Title, dedication text, dates, QR code placement
- **Color mode:** CMYK (print-ready) + RGB (digital)
- **Background:** Textured (marble, aged paper, etc.)

### Cultural Requirements (CRITICAL)
- **MUST:** Reflect Lebanese heritage (cedar, olive, geometric patterns)
- **MUST:** Be respectful and dignified (memorial context)
- **MUST:** Work in both Arabic and English text
- **AVOID:** Religious symbols (project is secular/inclusive)
- **AVOID:** Political imagery
- **AVOID:** War/conflict imagery (focus on memory and healing)

### Template 1: Cedar Tree Design
**Theme:** Lebanon's iconic cedar
**Description:**
- Background: Subtle cedar wood texture
- Border: Hand-drawn cedar branch frame
- Top: Cedar tree silhouette (small, tasteful)
- Middle: Large text area for dedication
- Bottom: QR code + "Scan to remember" text
- Color palette: Forest green (#2D5016), gold (#D4AF37), cream (#F5F5DC)

**Text Areas:**
- Person's name (Arabic + English)
- Years of life (1930-2015)
- Dedication text (200 char max)
- "In loving memory" (Arabic: في ذكرى محبة)

### Template 2: Olive Branch Design
**Theme:** Peace and resilience
**Description:**
- Background: Warm beige with aged paper texture
- Border: Olive branch and leaves wrapping around
- Top: Small olive branch illustration
- Middle: Text area with elegant typography
- Bottom: QR code centered
- Color palette: Olive green (#6B8E23), terracotta (#CD853F), ivory (#FFFFF0)

### Template 3: Geometric Pattern Design
**Theme:** Islamic/Lebanese geometric art
**Description:**
- Background: Light stone texture
- Border: Traditional Lebanese geometric pattern (non-religious)
- Top: Star/flower geometric motif
- Middle: Text area with ornamental dividers
- Bottom: QR code with geometric frame
- Color palette: Navy blue (#000080), gold (#FFD700), white (#FFFFFF)

---

## 3. Mission Type Icons (5 Icons)

### Specifications
- **Format:** SVG (vector)
- **Size:** 64x64px (will be used as map markers)
- **Style:** Simple, line-art style (Material Design-esque)
- **Color:** Single color (will be tinted by app)
- **Background:** Transparent

### Required Icons
1. **Visit Location** (`visit`)
   - Icon: Map pin with walking person
   - Use case: Physical site visit missions

2. **Interview Elder** (`interview`)
   - Icon: Person with speech bubble
   - Use case: Interview recording missions

3. **Photograph Site** (`photograph`)
   - Icon: Camera with location pin
   - Use case: Photo documentation missions

4. **Research Archive** (`research`)
   - Icon: Magnifying glass over document
   - Use case: Historical research missions

5. **Create Memorial** (`memorial`)
   - Icon: Plaque/memorial stone
   - Use case: Memorial creation missions

---

## 4. UI Elements (Quest Banner Components)

### Specifications
- **Format:** PNG with transparency
- **Sizes:** @1x, @2x, @3x variants
- **Style:** Match app's existing design system

### Required Elements
1. **Quest Banner Background (3 variants)**
   - **Active Quest:** Bright gradient (gold/orange)
   - **Completed Quest:** Green checkmark overlay
   - **Locked Quest:** Grayscale with lock icon
   - Size: 360x120px @1x

2. **Priority Indicators (3 icons)**
   - High priority: Red star icon (32x32px)
   - Medium priority: Yellow star icon
   - Low priority: Gray star icon

3. **Difficulty Badges (3 badges)**
   - Easy: Green circle with "1" (24x24px)
   - Medium: Yellow circle with "2"
   - Hard: Red circle with "3"

---

## 5. Memorial Plaque Decorative Elements

### Specifications
- **Format:** SVG (for compositing in Flutter app)
- **Style:** Lebanese cultural motifs

### Required Elements
1. **Cedar Silhouettes (3 variations)**
   - Small: 64x64px
   - Medium: 128x128px
   - Large: 256x256px

2. **Olive Branch Graphics (2 variations)**
   - Horizontal: 200x50px (for borders)
   - Corner: 100x100px (for corner decorations)

3. **Geometric Patterns (5 seamless tiles)**
   - 128x128px seamless tiles
   - Traditional Lebanese patterns
   - For background textures

4. **Divider Lines (3 styles)**
   - Ornate: 400x20px (decorative horizontal line)
   - Simple: 400x2px (clean divider)
   - Dotted: 400x10px (traditional pattern)

---

## 6. App Icons & Branding (If Needed)

### Home Screen Bottom Navigation Icons (4 icons)
Only if redesign needed:
- Map icon (mission discovery)
- Achievements icon (trophy)
- Feed icon (community)
- Profile icon (user)

Size: 24x24dp (Android) / 24pt (iOS)
Format: SVG
Style: Material Icons or SF Symbols compatible

---

## Asset Delivery Checklist

### Phase 1 (Priority: HIGH - Needed for Weeks 3-5)
- [ ] Mission type icons (5 icons) - SVG
- [ ] Achievement badges Tier 1 (3 badges) - PNG @1x, @2x, @3x
- [ ] Quest banner background variants (3 images) - PNG
- [ ] Difficulty badges (3 badges) - PNG

### Phase 2 (Priority: MEDIUM - Needed for Weeks 6-7)
- [ ] Achievement badges Tier 2 (5 badges) - PNG @1x, @2x, @3x
- [ ] Priority indicator icons (3 icons) - PNG

### Phase 3 (Priority: HIGH - Needed for Weeks 8-9)
- [ ] Memorial plaque Template 1 (Cedar) - SVG + PNG
- [ ] Memorial plaque Template 2 (Olive) - SVG + PNG
- [ ] Memorial plaque Template 3 (Geometric) - SVG + PNG
- [ ] Cedar silhouettes (3 sizes) - SVG
- [ ] Olive branch graphics (2 variations) - SVG
- [ ] Geometric patterns (5 tiles) - SVG
- [ ] Divider lines (3 styles) - SVG

### Phase 4 (Priority: LOW - Nice to have)
- [ ] Achievement badges Tier 3 & 4 (6 badges) - PNG @1x, @2x, @3x

---

## File Delivery Structure

Artist should deliver assets in this folder structure:

```
dwp-gamification-assets/
├── achievement-badges/
│   ├── tier-1/
│   │   ├── achievement_first_mission_1x.png
│   │   ├── achievement_first_mission_2x.png
│   │   ├── achievement_first_mission_3x.png
│   │   ├── achievement_explorer_1x.png
│   │   └── ...
│   ├── tier-2/
│   └── tier-3/
├── memorial-templates/
│   ├── cedar-template.svg
│   ├── cedar-template.png (1080x1920)
│   ├── olive-template.svg
│   ├── olive-template.png
│   ├── geometric-template.svg
│   └── geometric-template.png
├── mission-icons/
│   ├── mission_visit.svg
│   ├── mission_interview.svg
│   ├── mission_photograph.svg
│   ├── mission_research.svg
│   └── mission_memorial.svg
├── ui-elements/
│   ├── quest-banner-active@1x.png
│   ├── quest-banner-active@2x.png
│   ├── quest-banner-completed@1x.png
│   └── ...
└── decorative-elements/
    ├── cedar-silhouette-small.svg
    ├── olive-branch-horizontal.svg
    ├── geometric-pattern-1.svg
    └── ...
```

---

## Cultural Review Process

### Step 1: Artist Delivers Concepts
- Artist provides 2-3 concept sketches per asset category
- Black and white or low-fidelity mockups

### Step 2: Ziad Reviews Concepts
- Review for cultural appropriateness
- Check for sensitive imagery
- Approve direction or request revisions

### Step 3: Artist Delivers Final Assets
- Full-color, high-resolution files
- All size variants
- Source files (AI, PSD, etc.)

### Step 4: Ziad Final Approval
- Review final assets in context (mockups)
- Approve for implementation

### Step 5: Implementation
- Developer integrates assets into Flutter app
- Developer uploads assets to WordPress media library

---

## Artist Brief Template

Use this when commissioning artist:

```
PROJECT: DealWithPast Mobile App Gamification System
CLIENT: UNDP Lebanon / DealWithPast Team
CULTURAL LEAD: Ziad (Lebanese, project lead)

ABOUT THE PROJECT:
DealWithPast is a mobile app that helps Lebanese citizens preserve family histories
and map stories of the Lebanese Civil War era. The gamification system encourages
users to contribute stories, visit historical sites, and interview elders through
missions and achievements.

TARGET AUDIENCE:
- Lebanese diaspora (18-55 years old)
- History enthusiasts
- Families preserving memories
- Students researching Lebanese history

DESIGN STYLE:
- Respectful, dignified, memorial-focused
- Lebanese cultural motifs (cedar tree, olive branches, traditional patterns)
- Warm, earthy color palette
- Avoid: War imagery, political symbols, religious symbols
- Think: Museum exhibit quality, not gamey/playful

CULTURAL SENSITIVITY:
This is a project about healing and remembrance. All designs must be approved
by Ziad, who is Lebanese and deeply familiar with the cultural context.
Please provide concepts before final execution.

DELIVERABLES:
[See Asset Delivery Checklist above]

TIMELINE:
- Phase 1 assets: Week 2 (by [DATE])
- Phase 2 assets: Week 5 (by [DATE])
- Phase 3 assets: Week 7 (by [DATE])

BUDGET: [TBD]

CONTACT:
Ziad - [email/phone]
```

---

## Design Tool Recommendations

### For Artist
- **Vector work:** Adobe Illustrator or Affinity Designer
- **Raster work:** Adobe Photoshop or Affinity Photo
- **Memorial templates:** Adobe Illustrator (for SVG export)
- **Mockups:** Figma or Adobe XD

### For Developer (Ziad)
- **Asset optimization:** TinyPNG, SVGOMG
- **Icon generation:** Android Asset Studio
- **Preview:** VS Code with SVG preview extension

---

## Asset Integration Plan

### WordPress Integration (Ziad)
1. Upload achievement badge PNGs to WordPress Media Library
2. Reference URLs in `class-achievement-manager.php` achievement definitions
   ```php
   'icon' => 'https://dwp.world/wp-content/uploads/gamification/achievement_first_mission_1x.png'
   ```

### Flutter Integration (Flutter Dev)
1. Place assets in `assets/gamification/` folder
2. Update `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/gamification/achievement-badges/
       - assets/gamification/mission-icons/
       - assets/gamification/memorial-templates/
   ```
3. Load assets in code:
   ```dart
   Image.asset('assets/gamification/achievement-badges/achievement_first_mission_1x.png')
   ```

---

## Questions for Artist (Send this questionnaire)

1. **Experience:**
   - Have you worked on memorial/historical projects before?
   - Are you familiar with Lebanese culture and aesthetics?

2. **Cultural Sensitivity:**
   - Are you comfortable working with cultural review feedback?
   - Can you provide 2-3 samples of culturally sensitive design work?

3. **Technical:**
   - Can you deliver vector files (SVG, AI)?
   - Can you provide multiple size exports (@1x, @2x, @3x)?
   - Do you have experience designing for mobile apps?

4. **Timeline:**
   - Can you commit to 3-phase delivery schedule (3 deliveries over 8 weeks)?
   - What is your revision policy (how many rounds included)?

5. **Pricing:**
   - What is your rate structure? (per icon, per hour, or flat project rate?)
   - What is your estimated total for all assets listed?

---

## Next Steps

1. **Find Artist/Designer**
   - Post job listing or contact design agencies
   - Share this document + Artist Brief
   - Request portfolio + quote

2. **Kickoff Meeting**
   - Review this document with artist
   - Discuss Lebanese cultural sensitivities
   - Set delivery dates for each phase

3. **Establish Communication**
   - Weekly check-ins
   - Slack/email channel for quick questions
   - Figma board for concept sharing

4. **Set Up Asset Repository**
   - Create shared Dropbox/Google Drive folder
   - `dwp-gamification-assets/` structure ready
   - Version control for asset iterations

---

**Ready to brief the artist?** Let me know when you have someone in mind and I can help draft the commission email!
