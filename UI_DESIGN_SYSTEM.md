# UI Design System - UNDP App

**Version:** 1.0
**Last Updated:** 2025-10-25
**Purpose:** Central reference for all UI components, colors, typography, spacing, and patterns used throughout the app.

---

## Table of Contents
1. [Colors](#colors)
2. [Typography](#typography)
3. [Spacing & Layout](#spacing--layout)
4. [Components](#components)
5. [Shadows & Elevation](#shadows--elevation)
6. [Border Radius](#border-radius)
7. [Icons](#icons)
8. [Interaction States](#interaction-states)

---

## Colors

### Brand Colors
```dart
// Primary
Color(0xFFD11F2E)  // Red - Primary brand color
Color(0xFFEF4444)  // Soft red - Primary soft variant

// Mission Colors
Color(0xFF4CAF50)  // Green - Social missions, success, progress
Color(0xFF9C27B0)  // Purple - Personal missions
Color(0xFFFFDE73)  // Gold - Rewards, badges, achievements
```

### Surface Colors
```dart
// Backgrounds
Color(0xFFFAF7F2)  // Cream/Beige - Main background (Figma missions)
Color(0xFFFFFFFF)  // White - Cards, surfaces
Color(0xFFF6F7F9)  // Light gray - Alternate surface
Color(0xFFF5F0E8)  // Light beige - Filter buttons

// Dark surfaces (for dialogs, overlays)
Color(0xFF252422)  // Dark brown/black - Mission dialogs
Color(0xFF3A3534)  // Dark brown - Text on light backgrounds
Color(0xFF1F2937)  // Dark gray - Card gradients
Color(0xFF374151)  // Medium gray - Card gradients
```

### Text Colors
```dart
Color(0xFF111827)  // Near-black - Primary text (existing)
Color(0xFF3A3534)  // Dark brown - Primary text (Figma missions)
Color(0xFF6B7280)  // Gray-500 - Muted/secondary text
Color(0xFFFFFFFF)  // White - Text on dark backgrounds

// Opacity variants
Color(0xFF3A3534).withOpacity(0.1)  // Very light borders
Colors.grey.shade400  // Light gray text
Colors.grey.shade700  // Medium gray text
```

### Status Colors
```dart
// Difficulty badges
Colors.green      // Easy
Colors.orange     // Medium
Colors.red        // Hard

// Mission categories
Color(0xFF4CAF50)  // Social (green)
Color(0xFF9C27B0)  // Personal (purple)
```

### Semantic Colors
```dart
// Success
Color(0xFF4CAF50)  // Green

// Warning
Colors.orange

// Error
Color(0xFFD11F2E)  // Brand red

// Info
Color(0xFF2F69BC)  // Blue - Neighborhood tags
```

---

## Typography

### Font Families
```dart
'Baloo'    // Current app font - friendly, rounded
'Tajawal'  // Figma missions font - clean, modern Arabic
```

**Priority:** Use 'Tajawal' for new missions features to match Figma. Gradually migrate other screens.

### Font Sizes
```dart
// Headers
fontSize: 24  // H1 - Page titles
fontSize: 20  // H2 - Section headers
fontSize: 18  // H3 - Card titles
fontSize: 16  // H4 - Subsection headers

// Body
fontSize: 17  // Body large - Main content
fontSize: 15  // Body medium - Descriptions
fontSize: 13  // Body small - Labels, captions
fontSize: 12  // Caption - Metadata, hints

// UI Elements
fontSize: 14  // Buttons, form inputs
fontSize: 11  // Very small labels
```

### Font Weights
```dart
FontWeight.w400  // Regular - Body text
FontWeight.w500  // Medium - Emphasis
FontWeight.w600  // Semi-bold - Buttons, labels
FontWeight.w700  // Bold - Headers, titles
```

### Line Heights
```dart
lineHeight: 1.5   // 150% - Body text (Figma standard)
lineHeight: 1.62  // 162% - Descriptions (Figma missions)
lineHeight: 1.2   // 120% - Headers
```

### Text Alignment
```dart
textAlign: TextAlign.right  // Default for Arabic RTL
textAlign: TextAlign.center // Centered content
```

---

## Spacing & Layout

### Container Width
```dart
// Mobile
width: 393.4  // Standard mobile width (Figma)
width: double.infinity  // Full width

// Content padding
horizontal: 16  // Standard screen padding
horizontal: 24  // Wide padding (Figma missions)
```

### Padding Values
```dart
// Standard spacing scale
padding: 4   // Tiny
padding: 8   // Extra small
padding: 12  // Small
padding: 16  // Medium (most common)
padding: 20  // Large
padding: 24  // Extra large
padding: 32  // XXL

// Figma specific (round from decimals)
padding: 16  // ~15.99px
padding: 12  // ~11.99px
```

### Margins & Gaps
```dart
// Gaps between elements
gap: 8   // Small gap
gap: 12  // Medium gap
gap: 16  // Large gap
gap: 20  // XL gap

// Vertical spacing
SizedBox(height: 8)
SizedBox(height: 12)
SizedBox(height: 16)
SizedBox(height: 20)
SizedBox(height: 24)
```

---

## Components

### 1. Cards

#### Mission Card (List)
```dart
Container(
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Color(0x1A3A3534),  // rgba(58, 53, 52, 0.1)
      width: 0.7,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000),  // rgba(0, 0, 0, 0.1)
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x1A000000),  // rgba(0, 0, 0, 0.1)
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
  ),
  // Content...
)
```

#### Mission Card (Map Detail)
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0xFF252422),  // Dark background
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 20,
        offset: Offset(0, -5),
      ),
    ],
  ),
  // Content...
)
```

### 2. Buttons

#### Filter Button (Missions)
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: Color(0xFFF5F0E8),
    border: Border.all(color: Color(0x1A3A3534), width: 0.7),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Row(
    children: [
      Icon(Icons.filter_list, size: 16, color: Color(0x8C000000)),
      SizedBox(width: 8),
      Text('الأحدث أولاً', style: TextStyle(fontSize: 13)),
    ],
  ),
)
```

#### Primary Button
```dart
MaterialButton(
  color: Color(0xFF4CAF50),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  child: Text(
    'شارك في المهمة',
    style: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),
  onPressed: () {},
)
```

#### Secondary Button
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Text('عرض التفاصيل', style: TextStyle(fontSize: 12, color: Colors.white)),
      SizedBox(width: 4),
      Icon(Icons.arrow_forward, size: 14, color: Colors.white),
    ],
  ),
)
```

### 3. Badges

#### Category Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
    color: Color(0xFF4CAF50),  // Green for social, purple for personal
    borderRadius: BorderRadius.circular(20),  // Pill shape
  ),
  child: Text(
    'اجتماعية',
    style: TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  ),
)
```

#### Difficulty Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
    color: Colors.orange,  // green/orange/red based on difficulty
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    'متوسط',
    style: TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  ),
)
```

### 4. Text Inputs

#### Standard Text Field (Mission Form)
```dart
TextField(
  textAlign: TextAlign.right,
  style: TextStyle(
    fontSize: 15,
    color: Color(0xFF3A3534),
  ),
  decoration: InputDecoration(
    hintText: 'أعط المهمة عنواناً واضحاً وجذاباً',
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Color(0xFFF5F0E8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.all(16),
  ),
)
```

#### Multiline Text Field
```dart
TextField(
  maxLines: 5,
  maxLength: 500,
  textAlign: TextAlign.right,
  style: TextStyle(fontSize: 15, color: Color(0xFF3A3534)),
  decoration: InputDecoration(
    hintText: 'اشرح الهدف من المهمة ونوع القصص المطلوبة...',
    hintStyle: TextStyle(color: Colors.grey.shade400),
    filled: true,
    fillColor: Color(0xFFF5F0E8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.all(16),
    counterText: '0 حرف',
    counterStyle: TextStyle(fontSize: 12, color: Colors.grey),
  ),
)
```

### 5. Dropdowns

#### Standard Dropdown (Mission Form)
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  decoration: BoxDecoration(
    color: Color(0xFFF5F0E8),
    borderRadius: BorderRadius.circular(12),
  ),
  child: DropdownButtonFormField<String>(
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'اختر نوع المهمة',
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
    items: [...],
    onChanged: (value) {},
  ),
)
```

### 6. Progress Indicators

#### Linear Progress Bar
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Text('8 / 10 قصص', style: TextStyle(fontSize: 13, color: Colors.grey)),
    SizedBox(height: 4),
    Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerRight,
        widthFactor: 0.8,  // 8/10 = 0.8
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ),
  ],
)
```

#### Circular Progress Indicator
```dart
CircularProgressIndicator(
  value: 0.75,
  strokeWidth: 8,
  backgroundColor: Colors.grey.shade300,
  valueColor: AlwaysStoppedAnimation(Color(0xFF4CAF50)),
)
```

### 7. Info Box (Mission Form)
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFFF5F0E8),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Color(0x1A3A3534), width: 1),
  ),
  child: Row(
    children: [
      Text('🌲', style: TextStyle(fontSize: 24)),
      SizedBox(width: 12),
      Expanded(
        child: Text(
          'أنشئ مهمة لجمع قصص حول موضوع أو فترة زمنية محددة...',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ),
    ],
  ),
)
```

---

## Shadows & Elevation

### Card Shadow (Light)
```dart
boxShadow: [
  BoxShadow(
    color: Color(0x1A000000),  // 10% black
    blurRadius: 3,
    offset: Offset(0, 1),
  ),
]
```

### Card Shadow (Medium)
```dart
boxShadow: [
  BoxShadow(
    color: Color(0x1A000000),  // 10% black
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
]
```

### Modal Shadow (Heavy)
```dart
boxShadow: [
  BoxShadow(
    color: Colors.black26,  // 26% black
    blurRadius: 20,
    offset: Offset(0, -5),
  ),
]
```

### Container Shadow (Figma)
```dart
boxShadow: [
  BoxShadow(
    color: Color(0x40000000),  // 25% black
    blurRadius: 50,
    offset: Offset(0, 25),
  ),
]
```

---

## Border Radius

### Standard Radii
```dart
BorderRadius.circular(8)   // Small - Buttons, small containers
BorderRadius.circular(10)  // Medium - Filter buttons, badges
BorderRadius.circular(12)  // Large - Cards, inputs
BorderRadius.circular(16)  // XL - Mission cards
BorderRadius.circular(20)  // Pill - Badges, tags
BorderRadius.circular(25)  // Rounded - Special buttons
BorderRadius.circular(30)  // Extra rounded - Modal tops
```

---

## Icons

### Icon Sizes
```dart
size: 14  // Tiny - Inside small buttons
size: 16  // Small - Filter buttons, labels
size: 18  // Medium - List items
size: 24  // Large - Primary actions
size: 28  // XL - Headers, close buttons
size: 64  // Huge - Empty states, hero sections
```

### Icon Colors
```dart
color: Color(0xFF3A3534)  // Dark - Primary icons
color: Color(0x8C000000)  // Semi-transparent - Secondary icons
color: Colors.white       // White - Icons on dark backgrounds
color: Color(0xFF4CAF50)  // Green - Success, mission icons
color: Colors.grey.shade400  // Light gray - Disabled icons
```

### Common Icons
```dart
Icons.emoji_events_outlined  // Missions tab
Icons.flag                   // Mission marker
Icons.category               // Category
Icons.speed                  // Difficulty
Icons.timeline               // Progress
Icons.location_on            // Location
Icons.people                 // Participants
Icons.arrow_forward          // Next/Details (RTL)
Icons.close                  // Close/Cancel
Icons.filter_list            // Filters
Icons.search                 // Search
Icons.keyboard_arrow_down    // Dropdown
```

---

## Interaction States

### Button States
```dart
// Default
color: Color(0xFF4CAF50)

// Pressed
color: Color(0xFF4CAF50).withOpacity(0.8)

// Disabled
color: Colors.grey.shade400
```

### Card States
```dart
// Default
border: Border.all(color: Color(0x1A3A3534))

// Hover/Tap (use GestureDetector)
onTap: () {
  // Navigate or show details
}

// Selected (optional)
border: Border.all(color: Color(0xFF4CAF50), width: 2)
```

---

## Layout Patterns

### Screen Structure (Standard)
```dart
Scaffold(
  backgroundColor: Color(0xFFFAF7F2),  // Cream background
  appBar: AppBar(
    title: Text('المهام'),
    backgroundColor: Color(0xFFFAF7F2),
    elevation: 0,
    centerTitle: true,
  ),
  body: SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        // Filter bar
        // Content
      ],
    ),
  ),
)
```

### Filter Bar Pattern
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FilterButton(...),
    SizedBox(width: 8),
    FilterButton(...),
    SizedBox(width: 8),
    FilterButton(...),
  ],
)
```

### List Pattern (Missions)
```dart
ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: missions.length,
  itemBuilder: (context, index) {
    return MissionCard(mission: missions[index]);
  },
)
```

---

## Forms Pattern (Mission Creation)

### Form Structure
```dart
Form(
  key: _formKey,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      // Info box
      InfoBox(text: '...'),
      SizedBox(height: 20),

      // Field label with required asterisk
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('*', style: TextStyle(color: Colors.red)),
          SizedBox(width: 4),
          Text('عنوان المهمة', style: TextStyle(fontSize: 16)),
        ],
      ),
      SizedBox(height: 8),

      // Input field
      TextField(...),
      SizedBox(height: 20),

      // Repeat for other fields...
    ],
  ),
)
```

---

## RTL Considerations

### Always Use RTL-Safe Widgets
```dart
// Use Row with mainAxisAlignment.end instead of .start
Row(mainAxisAlignment: MainAxisAlignment.end)

// Text alignment
textAlign: TextAlign.right

// Icons should be flipped for RTL
Icons.arrow_forward  // Use this for "next" in RTL (points left)
Icons.arrow_back     // Use this for "previous" in RTL (points right)
```

### Padding in RTL
```dart
// Prefer symmetric or all-sides padding
padding: EdgeInsets.all(16)
padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)

// If directional padding needed, use RTL-aware versions
EdgeInsetsDirectional.only(start: 16, end: 8)
```

---

## Animation Standards

### Durations
```dart
Duration(milliseconds: 200)  // Fast - Button press, small changes
Duration(milliseconds: 300)  // Medium - Card appearance, navigation
Duration(milliseconds: 500)  // Slow - Page transitions
```

### Curves
```dart
Curves.easeInOut      // Default smooth
Curves.easeOutCubic   // Smooth exit (cards, modals)
Curves.elasticOut     // Bouncy effect (success states)
```

### Animated Widgets
```dart
AnimatedPositioned  // Map cards sliding up
AnimatedContainer   // Button state changes
AnimatedOpacity     // Fade in/out
Hero                // Page transitions with shared elements
```

---

## Accessibility

### Minimum Touch Targets
```dart
minWidth: 44   // Minimum tappable width
minHeight: 44  // Minimum tappable height
```

### Contrast Ratios
- Text on light background: Use `Color(0xFF3A3534)` (passes WCAG AA)
- Text on dark background: Use `Colors.white`
- Important actions: High contrast (white on green, white on red)

---

## Bottom Navigation

### Standard Bottom Nav
```dart
BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.white,
  selectedItemColor: Color(0xFF4CAF50),
  unselectedItemColor: Colors.grey.shade600,
  selectedFontSize: 12,
  unselectedFontSize: 12,
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'الرئيسية',
    ),
    // ... other items
  ],
)
```

---

## Notes

- **Consistency First:** Always check this document before creating new components
- **Update After Changes:** Add new patterns here after implementing them
- **Platform Considerations:** Test on both iOS and Android for visual consistency
- **Dark Mode:** Currently not implemented, but consider planning for it in color choices

---

**Last Updated:** 2025-10-25
**Maintainer:** Claude Code
**Reference in:** CHANGELOG.md (top section)
