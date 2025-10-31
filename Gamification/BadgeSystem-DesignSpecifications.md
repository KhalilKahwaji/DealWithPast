# Badge System - UX/UI Design Specifications

**Target Audience:** UX/UI Designers  
**Component:** Achievement & Legacy System Visual Design  
**Platform:** Flutter Mobile App  

---

## Technical Design Requirements

### Icon Specifications
- **File Format:** SVG (vector scalable)
- **Primary Sizes:** 24px, 48px, 72px, 96px
- **States Required:** 
  - Full color (unlocked)
  - Grayscale (locked) 
  - Highlighted (newly unlocked with glow effect)
  - Disabled (not yet available)
- **Export Formats:** SVG primary, PNG fallbacks for each size
- **Naming Convention:** `badge_[category]_[name]_[state]_[size].svg`

### Cultural Design System
- **Primary Palette:** Rich burgundy (#8B1538), Cedar green (#0F5132), Gold accent (#FFD700)
- **Secondary Palette:** Limestone beige (#F5F5DC), Mediterranean blue (#1E3A8A)
- **Typography:** Inter (Latin), Noto Sans Arabic (Arabic text)
- **Cultural Elements:** Lebanese cedar motifs, traditional architectural patterns
- **Border Style:** Subtle Lebanese traditional patterns, 2px border radius

### Layout Specifications
- **Badge Grid:** 3 columns on mobile, 4 columns on tablet
- **Spacing:** 16px between badges, 24px between categories
- **Touch Target:** Minimum 44px x 44px for accessibility
- **Animation Duration:** 300ms unlock animation, 150ms hover states

---

## Badge Categories and Design Specifications

### Foundation Badges
*Entry-level recognition for initial courage and contribution*

#### **Memory Keeper**
**User Description:** Awarded for sharing your first approved story  
**Design Description:** Memorial flame with Lebanese cedar leaf accent, warm gold flame with green cedar element

**Visual Elements:**
- Central flame icon in warm gold (#FFD700)
- Small Lebanese cedar leaf at base in forest green (#0F5132)
- Circular background with subtle Lebanese stone texture
- Optional: Small Arabic calligraphy element

**Design Flow:** Story submission → Content approval → Celebration animation with flame lighting up → Badge appears in collection

---

#### **Witness** 
**User Description:** Awarded for adding photo, document, or visual evidence to stories  
**Design Description:** Vintage camera with Lebanese architectural frame element, sepia brown with metallic silver accents

**Visual Elements:**
- Classic camera silhouette in sepia brown (#8B4513)
- Lebanese arch frame surrounding camera in silver (#C0C0C0)
- Document/photo icon overlay
- Textured background suggesting old photographs

**Design Flow:** Media upload → Technical validation → Approval → Vintage photo development animation → Badge unlock

---

#### **Voice**
**User Description:** Awarded for submitting audio or video testimony  
**Design Description:** Microphone with sound waves forming Lebanese mountain silhouette, deep blue with silver wave accents

**Visual Elements:**
- Microphone icon in deep blue (#1E3A8A)
- Sound waves extending from mic forming mountain shape
- Silver wave accents (#C0C0C0) suggesting Lebanese mountains
- Optional: Small Lebanese flag colors in wave pattern

**Design Flow:** Audio/video upload → Technical processing → Content approval → Sound wave animation → Badge appears

---

### Community Badges
*Recognition for leadership and collaborative memory building*

#### **Mission Creator**
**User Description:** Awarded for creating a successful memory collection mission  
**Design Description:** Compass rose with Lebanese cedar at center, navy blue compass with gold cedar and directional points

**Visual Elements:**
- Traditional compass rose in navy blue (#1E3A8A)
- Lebanese cedar tree at center in gold (#FFD700)
- Eight directional points with subtle Arabic directional text
- Background suggesting Lebanese map outline

**Design Flow:** Mission creation → Community participation tracking → Goal achievement → Compass spinning animation → Badge unlock

---

#### **Bridge Builder**
**User Description:** Awarded for responding to someone else's mission call  
**Design Description:** Two hands reaching toward each other across Lebanese map outline, warm earth tones with connecting gold bridge element

**Visual Elements:**
- Two hands in warm earth tone (#D2B48C) reaching across space
- Lebanese map silhouette in background
- Golden bridge or connection line between hands
- Unity and collaboration visual metaphor

**Design Flow:** Mission discovery → Story contribution → Mission tagging → Approval → Hand-reaching animation → Badge unlock

---

#### **Network Builder**
**User Description:** Awarded for successfully inviting others who contribute stories  
**Design Description:** Family tree with Lebanese cedar branches and connecting nodes, green tree with gold connection points

**Visual Elements:**
- Stylized tree with Lebanese cedar characteristics
- Branches extending with small connection nodes
- Each node represents a recruited family member
- Growth pattern suggesting community expansion

**Design Flow:** Invitation sending → User registration tracking → Story contributions → Attribution confirmation → Tree growth animation → Badge unlock

---

#### **Ambassador**
**User Description:** Awarded for achieving leadership status in active mission  
**Design Description:** Lebanese cedar tree with protective circle and messenger elements, deep green cedar with gold protective circle

**Visual Elements:**
- Majestic Lebanese cedar in forest green (#0F5132)
- Circular border suggesting protection and authority
- Small messenger/diplomatic elements (scroll, olive branch)
- Leadership and trust visual indicators

**Design Flow:** Mission following → Active contribution → Recruitment success → Leadership recognition → Cedar growing animation → Badge unlock

---

### Legacy Badges
*Recognition for sustained commitment and cultural preservation*

#### **Guardian**
**User Description:** Awarded for preserving family or community history across generations  
**Design Description:** Protective shield with Lebanese family crest pattern and cedar elements, rich burgundy shield with gold cedar and family pattern

**Visual Elements:**
- Traditional heraldic shield in burgundy (#8B1538)
- Lebanese cedar emblem prominently displayed
- Family/community pattern elements within shield
- Generational continuity visual metaphors

**Design Flow:** Multi-generational content submission → Historical validation → Approval → Shield formation animation → Badge unlock

---

#### **Trusted Voice**
**User Description:** Awarded for sustained contributions across multiple themes and time periods  
**Design Description:** Multiple story pages with Lebanese calligraphy elements, royal blue pages with gold calligraphy accents

**Visual Elements:**
- Stack of pages/scrolls in royal blue (#4169E1)
- Lebanese Arabic calligraphy elements in gold
- Multiple theme icons subtly integrated
- Historical depth and knowledge representation

**Design Flow:** Story accumulation → Theme diversity analysis → Quality validation → Page-turning animation → Badge unlock

---

#### **Peacemaker**
**User Description:** Awarded for contributing stories demonstrating reconciliation, forgiveness, or cross-community understanding  
**Design Description:** Olive branch intertwined with Lebanese cedar forming peace symbol, olive green branch with cedar green, gold peace accents

**Visual Elements:**
- Olive branch in traditional olive green (#808000)
- Lebanese cedar branch intertwining
- Peace symbol formation from natural elements
- Unity and reconciliation visual metaphors

**Design Flow:** Reconciliation story submission → Cultural review → Peace-building assessment → Intertwining animation → Badge unlock

---

#### **Heritage Keeper**
**User Description:** Awarded for creating missions preserving specific cultural, regional, or traditional Lebanese practices  
**Design Description:** Ancient Lebanese column with cultural artifacts and cedar crown, limestone column color with cultural gold accents and green cedar

**Visual Elements:**
- Classical Lebanese architectural column
- Cultural artifacts (traditional items, musical instruments)
- Cedar crown or decorative element at top
- Heritage and preservation visual metaphors

**Design Flow:** Cultural mission creation → Community response → Content collection → Authenticity review → Column rising animation → Badge unlock

---

#### **Community Leader**
**User Description:** Awarded for multiple successful missions with high community participation  
**Design Description:** Lebanese cedar tree with multiple branches representing successful missions, majestic green cedar with gold branches and community connection elements

**Visual Elements:**
- Large, mature Lebanese cedar as central element
- Multiple branches, each representing a successful mission
- Community connection nodes on branches
- Leadership and community growth representation

**Design Flow:** Multiple mission tracking → Success rate calculation → Community impact measurement → Full tree growth animation → Badge unlock

---

## Typography Specifications

### Badge Names
- **Font:** Inter Bold, 14px
- **Arabic:** Noto Sans Arabic Bold, 14px
- **Color:** Primary text (#1F2937)
- **Letter Spacing:** 0.5px

### Badge Descriptions
- **Font:** Inter Regular, 12px
- **Arabic:** Noto Sans Arabic Regular, 12px
- **Color:** Secondary text (#6B7280)
- **Line Height:** 1.4

### Cultural Significance Text
- **Font:** Inter Medium, 11px
- **Style:** Italic for cultural context
- **Color:** Accent text (#8B5A2B)
- **Treatment:** Indented with Lebanese pattern border

### Design Descriptions (Internal Use)
- **Font:** Inter Regular, 10px
- **Color:** Design notes (#9CA3AF)
- **Treatment:** Background highlight for designer reference

---

## Animation Specifications

### Badge Unlock Celebrations
- **Duration:** 2 seconds total animation
- **Sequence:** 
  1. Badge appears with scale from 0 to 1.2 (300ms)
  2. Gentle bounce to scale 1.0 (200ms)
  3. Glow effect fade in and out (500ms)
  4. Cultural element animation (flame lighting, tree growing, etc.) (1000ms)

### Hover States
- **Scale:** 1.05x on hover
- **Duration:** 150ms ease-out
- **Shadow:** Subtle drop shadow increase
- **Cultural Element:** Gentle highlight of Lebanese design elements

### Progress Indicators
- **Loading:** Circular progress with Lebanese cedar pattern
- **Completion:** Check mark with cultural flourish
- **Near Completion:** Gentle pulsing glow effect

---

## Accessibility Requirements

### Color Contrast
- **Minimum Ratio:** 4.5:1 for all text elements
- **Icon Contrast:** 3:1 minimum for graphical elements
- **Alternative Text:** Descriptive alt text in Arabic and English

### Visual Indicators
- **Not Color Dependent:** All status indicated by shape/pattern changes
- **High Contrast Mode:** All badges readable in system high contrast
- **Cultural Sensitivity:** Colors respect Lebanese cultural associations

---

## Cultural Design Guidelines

### Lebanese Aesthetic Elements
- **Cedar Integration:** Subtle, respectful use of national symbol
- **Architectural Motifs:** Traditional Lebanese patterns and structures
- **Color Harmony:** Palette respects Lebanese cultural color associations
- **Religious Neutrality:** Design elements respect all Lebanese communities

### Cultural Review Checkpoints
- **Icon Design Review:** Cultural advisor approval before implementation
- **Color Validation:** Ensure cultural appropriateness of color choices
- **Symbol Verification:** Confirm respectful use of Lebanese cultural symbols
- **Community Testing:** Validation with Lebanese community members

---

## Implementation Notes for Developers

### Asset Organization
```
assets/
  badges/
    foundation/
      memory_keeper_unlocked_48.svg
      memory_keeper_locked_48.svg
      witness_unlocked_48.svg
      [etc.]
    community/
      [badge files]
    legacy/
      [badge files]
```

### Design System Integration
- Use established Lebanese color palette constants
- Implement cultural design components as reusable widgets
- Ensure consistent spacing and typography throughout badge system
- Integrate with existing app theme and cultural design elements