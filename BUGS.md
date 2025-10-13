# Active Bugs - DealWithPast

*Last Updated: October 9, 2025*

## P0 - Critical (Block Release)
*No critical bugs at this time*

---

## P1 - High (Current Sprint)
*To be populated as bugs are discovered*

---

## P2 - Medium (Next Sprint)
*To be populated as bugs are discovered*

---

## P3 - Low (Backlog)
*To be populated as bugs are discovered*

---

## Recently Fixed ✅

### Bug #001 - Flutter 3.35.4 Dependency Incompatibility - App Won't Compile ✅
- **Platform:** All (Web, iOS, Android, Desktop)
- **Status:** ✅ Fixed
- **Assignee:** Z (Project Manager Agent)
- **Created:** October 9, 2025
- **Fixed:** October 9, 2025
- **Description:** Project dependencies were incompatible with Flutter 3.35.4. The Dart compiler crashed during web compilation due to breaking changes in multiple packages.
- **Root Cause:** Flutter version too new (3.35.4) vs team's locked dependencies compatible with Flutter 3.10.6
  - Key issue: Running `flutter pub get` with Flutter 3.35.4 updated `firebase_auth_platform_interface` from 6.11.7 → 6.19.1, causing breaking API changes
  - The team's `pubspec.lock` had correct compatible versions
- **Solution Implemented:**
  1. Downgraded Flutter from 3.35.4 → 3.10.6 (using `git checkout 3.10.6` in Flutter directory)
  2. Restored team's original `pubspec.yaml` and `pubspec.lock` from git
  3. Ran `flutter pub get` with Flutter 3.10.6 (preserved team's locked versions)
  4. App compiled successfully and launched in Chrome
- **Key Learning:**
  - **NEVER run `flutter pub get` with a newer Flutter version** - it updates transitive dependencies
  - Always use the team's exact Flutter version to preserve `pubspec.lock` integrity
  - Required Flutter version: **3.10.6** (Dart 3.0.6, June 2023)
- **Verification:** Web build successful on Chrome (runtime Firebase config error is separate issue)
- **What Was Lost by Downgrading:**
  - ~2 years of Flutter SDK updates (3.10.6 → 3.35.4)
  - Newer DevTools, performance improvements, bug fixes
  - **Net Benefit:** MASSIVE - from "completely broken" to "working app"
- **Recommendation:** Team should coordinate a full dependency upgrade in future sprint

---

## Bug Template

Use this template when logging new bugs:

```markdown
### Bug #[NUMBER] - [Short Title]
- **Platform:** iOS ✅ / Android ✅ / Both
- **Status:** Pending / In Progress / Testing / Fixed
- **Assignee:** [Name or "Unassigned"]
- **Created:** [Date]
- **Description:** [Clear description of the issue]
- **Impact:** [How this affects users]
- **Steps to Reproduce:**
  1. [Step 1]
  2. [Step 2]
  3. [Observed behavior]
- **Expected Behavior:** [What should happen]
- **Component:** [File/folder where bug exists]
- **Related:** [Related bugs or features]
- **Screenshots:** [If applicable]
```

## Bug Numbering
Start bug numbers at #001 and increment sequentially. Once a bug is fixed and verified, move it to "Recently Fixed" section with the fix date and resolution.
