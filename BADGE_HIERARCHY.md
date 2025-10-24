# Badge & Level Icon Hierarchy

## Complete List: 16 Icons

---

## 🎖️ Badges (12 Total)

### Foundation Badges (3)
Path: `assets/badges/foundation/`

| # | File Name | Arabic Name | English | Color Code | Color |
|---|-----------|-------------|---------|------------|-------|
| 1 | `voice.png` | صوت | Voice | #E57373 | 🟥 Pink/Red |
| 2 | `memory_keeper.png` | حارس الذاكرة | Memory Keeper | #4A7C59 | 🟩 Cedar Green |
| 3 | `narrator.png` | سارد | Narrator | #8B1538 | 🟥 Burgundy |

**Requirements:**
- Voice: Add 1 story with audio/video
- Memory Keeper: Add 1 accepted story
- Narrator: Add 3 accepted stories

---

### Community Badges (4)
Path: `assets/badges/community/`

| # | File Name | Arabic Name | English | Color Code | Color |
|---|-----------|-------------|---------|------------|-------|
| 4 | `community_builder.png` | باني المجتمع | Community Builder | #42A5F5 | 🔵 Blue |
| 5 | `peace_messenger.png` | رسول السلام | Peace Messenger | #F59E0B | 🟠 Amber |
| 6 | `memory_protectors.png` | حفظة الذاكرة | Memory Protectors | #8B5CF6 | 🟣 Purple |
| 7 | `gatherer.png` | الجامع | Gatherer | #EC4899 | 🩷 Pink |

**Requirements:**
- Community Builder: Create 1 mission
- Peace Messenger: Contribute to 3 missions
- Memory Protectors: Invite 5 people
- Gatherer: Participate in 5 missions

---

### Legacy Badges (5)
Path: `assets/badges/legacy/`

| # | File Name | Arabic Name | English | Color Code | Color |
|---|-----------|-------------|---------|------------|-------|
| 8 | `generation_witness.png` | شاهد الأجيال | Generation Witness | #D4AF37 | 🟡 Gold |
| 9 | `family_storyteller.png` | راوي العائلة | Family Storyteller | #6366F1 | 🔵 Indigo |
| 10 | `peacemaker.png` | صانع السلام | Peacemaker | #10B981 | 🟢 Emerald |
| 11 | `culture_guardian.png` | حامي الثقافة | Culture Guardian | #F59E0B | 🟠 Amber |
| 12 | `story_champion.png` | بطل القصص | Story Champion | #E57373 | 🟥 Rose |

**Requirements:**
- Generation Witness: Reach Ambassador status (15+ stories)
- Family Storyteller: Add family history story
- Peacemaker: Add reconciliation story
- Culture Guardian: Create cultural mission
- Story Champion: Contribute to 3+ different missions

---

## 🏆 Levels (4 Total)

Path: `assets/levels/`

| # | File Name | Arabic Name | English | Stories Required | Color Code | Color |
|---|-----------|-------------|---------|------------------|------------|-------|
| 1 | `follower.png` | متابع | Follower | 0-4 | #9CA3AF | ⚪ Gray |
| 2 | `contributor.png` | مساهم | Contributor | 5-14 | #4A7C59 | 🟩 Cedar Green |
| 3 | `ambassador.png` | سفير | Ambassador | 15-29 | #D4AF37 | 🟡 Gold |
| 4 | `founding_partner.png` | شريك مؤسس | Founding Partner | 30+ | #8B1538 | 🟥 Burgundy |

**Progression:**
- متابع → مساهم: Add 5 stories
- مساهم → سفير: Add 15 stories (total)
- سفير → شريك مؤسس: Add 30 stories (total)

---

## 📁 Complete File Structure

```
assets/
├── badges/
│   ├── foundation/
│   │   ├── voice.png                (+ @2x, @3x)
│   │   ├── memory_keeper.png        (+ @2x, @3x)
│   │   └── narrator.png             (+ @2x, @3x)
│   │
│   ├── community/
│   │   ├── community_builder.png    (+ @2x, @3x)
│   │   ├── peace_messenger.png      (+ @2x, @3x)
│   │   ├── memory_protectors.png    (+ @2x, @3x)
│   │   └── gatherer.png             (+ @2x, @3x)
│   │
│   └── legacy/
│       ├── generation_witness.png   (+ @2x, @3x)
│       ├── family_storyteller.png   (+ @2x, @3x)
│       ├── peacemaker.png           (+ @2x, @3x)
│       ├── culture_guardian.png     (+ @2x, @3x)
│       └── story_champion.png       (+ @2x, @3x)
│
└── levels/
    ├── follower.png                 (+ @2x, @3x)
    ├── contributor.png              (+ @2x, @3x)
    ├── ambassador.png               (+ @2x, @3x)
    └── founding_partner.png         (+ @2x, @3x)
```

**Total Files:** 16 base icons × 3 resolutions = **48 PNG files**

---

## 🎨 Color Palette Summary

### Primary Colors
- **Cedar Green** (#4A7C59) - Memory Keeper, Contributor level
- **Gold** (#D4AF37) - Generation Witness, Ambassador level
- **Burgundy** (#8B1538) - Narrator, Founding Partner level

### Badge Colors
- **Pink/Red** (#E57373) - Voice, Story Champion
- **Blue** (#42A5F5) - Community Builder
- **Amber** (#F59E0B) - Peace Messenger, Culture Guardian
- **Purple** (#8B5CF6) - Memory Protectors
- **Pink** (#EC4899) - Gatherer
- **Indigo** (#6366F1) - Family Storyteller
- **Emerald** (#10B981) - Peacemaker
- **Gray** (#9CA3AF) - Follower level

---

## 📐 Icon Size Specifications

### Resolution Variants
Each icon needs 3 files for iOS/Android display density:

| Variant | Size | File Naming |
|---------|------|-------------|
| @1x (base) | 64×64px | `badge_name.png` |
| @2x (retina) | 128×128px | `badge_name@2x.png` |
| @3x (super retina) | 192×192px | `badge_name@3x.png` |

### Example for "Voice" Badge
```
voice.png       ← 64×64px
voice@2x.png    ← 128×128px
voice@3x.png    ← 192×192px
```

---

## 🎯 Quick Reference: Generation Order

If generating icons in ChatGPT/DALL-E, use this order:

### Foundation (3)
1. Voice (Pink)
2. Memory Keeper (Green)
3. Narrator (Burgundy)

### Community (4)
4. Community Builder (Blue)
5. Peace Messenger (Amber)
6. Memory Protectors (Purple)
7. Gatherer (Pink)

### Legacy (5)
8. Generation Witness (Gold)
9. Family Storyteller (Indigo)
10. Peacemaker (Emerald)
11. Culture Guardian (Amber)
12. Story Champion (Rose)

### Levels (4)
13. Follower (Gray)
14. Contributor (Green)
15. Ambassador (Gold)
16. Founding Partner (Burgundy)

---

## 🔗 Related Files

- **BADGE_ICON_AI_PROMPTS.md** - Detailed AI prompts for each icon
- **DESIGNER_BRIEF_BADGES.md** - Complete designer brief for ChatGPT
- **PLACEHOLDER_SYSTEM.md** - How placeholders work while icons are generated
- **GAMIFICATION_PROGRESS.md** - Overall implementation progress

---

## ✅ Checklist for Icon Generation

- [ ] Generate 16 base icons (64×64px)
- [ ] Verify each icon matches its color code
- [ ] Resize each to @2x (128×128px)
- [ ] Resize each to @3x (192×192px)
- [ ] Name files correctly (underscore naming)
- [ ] Upload to correct asset folders
- [ ] Run `flutter pub get`
- [ ] Test in app - placeholders should disappear
- [ ] Verify locked badges show grayscale
- [ ] Verify unlocked badges show full color

---

**Total Icons to Generate: 16**
**Total Files After Resizing: 48**
**Current Status: Placeholders Active ✅**
