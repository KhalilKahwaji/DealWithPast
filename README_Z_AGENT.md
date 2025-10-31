# Z Agent Setup for DealWithPast Project

## What is Z?

**Z** is your AI-powered Project Manager that helps you:
- Track progress across all features
- Visualize timelines with Gantt charts
- Manage bugs systematically
- Enforce code reuse and best practices
- Break down complex tasks
- Keep documentation up-to-date

## Quick Start

### 1. Tell Your AI Assistant to Act as Z

When starting a new session with Claude Code or any AI assistant, say:

```
Read Z_AGENT_UNDP.md and act as Z for the DealWithPast project.
```

### 2. Z Will Load Context and Report Status

Z will automatically:
- Read `PROJECT_STATE.md` for current metrics
- Read `CHANGELOG.md` for recent progress
- Read `BUGS.md` for active issues
- Display a status dashboard
- Show a Gantt timeline view
- Ask what you want to tackle

### 3. Give Z Tasks

Examples:
- "Fix the story upload bug on Android"
- "Add video support to galleries"
- "Optimize map loading performance"
- "Update Firebase dependencies"
- "Create a reusable loading indicator widget"

### 4. Z Manages Everything

Z will:
- Break down the task into subtasks
- Check for reusable code before creating new components
- Update the Gantt timeline
- Track progress in PROJECT_STATE.md
- Log changes in CHANGELOG.md
- Document bugs in BUGS.md
- Test on both iOS and Android
- Verify Arabic RTL support

## Files Overview

### Z_AGENT_UNDP.md
The complete Z agent behavior template. This defines how Z thinks, acts, and manages the project.

### PROJECT_STATE.md
The current state of the project:
- Feature progress percentages
- Active bugs count
- Platform status (iOS/Android)
- Dependencies
- Risks and blockers

**Update:** After completing any significant work

### CHANGELOG.md
A log of all changes:
- Features added
- Bugs fixed
- Technical updates
- Metrics per session

**Update:** At the end of each work session

### BUGS.md
A structured bug tracker:
- P0: Critical (blocks release)
- P1: High (current sprint)
- P2: Medium (next sprint)
- P3: Low (backlog)
- Recently Fixed

**Update:** When bugs are discovered or fixed

### MASTER_PLAN.md
The strategic roadmap:
- Project vision
- Success criteria
- Architecture overview
- Development priorities
- Quality standards
- Risk management

**Update:** When priorities or strategy changes

## Example Z Session

```
You: Read Z_AGENT_UNDP.md and act as Z for the DealWithPast project.

Z: [Reads context files...]

📱 App Status
- Version: 8.2.3
- Build Status: ✅ Working
- Feature Progress:
  - Story System: [████████░░] 80%
  - Map & Clustering: [██████████] 100%
  - Timeline: [███████░░░] 70%
  - Authentication: [██████████] 100%
  - Gallery: [█████████░] 90%
  - Profiles: [██████░░░░] 60%
- Active Bugs: 5 (P0: 0, P1: 1, P2: 2, P3: 2)

📅 Gantt Timeline View
Week 0    [=== Current Work ===]  ← Today (Oct 8)
Week 1         [== Next Feature ==]
Week 2                  ◆ Milestone

🎯 Today's Focus
In Progress: Bug assessment
Blocking: None
Next Up: Feature prioritization

💬 Ready for Instructions
What would you like to tackle?

---

You: I need to add the ability for users to edit their stories

Z: I'll implement story editing functionality. Let me break this down:

**Task Breakdown:**
1. Add edit button to My Stories screen
2. Create edit mode in addStory.dart
3. Add WordPress API endpoint for updates
4. Implement delete functionality
5. Add confirmation dialogs
6. Test on iOS and Android
7. Verify Arabic RTL layout

**Gantt Update:**
Week 0    [=== Story Edit UI ===]  ← Today
Week 1         [== API Integration ==] → [== Testing ==]
Week 2                                  ◆ Story Edit Complete

**Dependencies Checked:**
- Existing addStory.dart widget can be reused
- StoryRepo.dart needs new updateStory() method
- WordPress API supports PUT requests

Starting implementation...

[Z proceeds to implement, test, and document the changes]
```

## Benefits of Using Z

### 1. Consistency
Every session starts with context loading and ends with documentation updates. No lost progress.

### 2. Visibility
Always know:
- What's complete
- What's in progress
- What's coming next
- What's blocking you

### 3. Quality
Z enforces:
- Code reuse (no duplicate widgets)
- Testing on both platforms
- Arabic RTL verification
- Error handling
- Documentation

### 4. Planning
Gantt charts show:
- Timeline for features
- Dependencies between tasks
- Critical path to milestones
- Today's position

### 5. Bug Tracking
Systematic bug management:
- Prioritized by severity
- Tracked with details
- Moved to "Recently Fixed" when resolved
- Trends visible over time

## Tips for Working with Z

### Do:
✅ Start every session with "Read Z_AGENT_UNDP.md and act as Z"
✅ Let Z break down complex tasks
✅ Ask Z to show Gantt view when planning
✅ Tell Z about bugs you discover
✅ Review PROJECT_STATE.md weekly

### Don't:
❌ Skip the context loading step
❌ Update files manually without telling Z
❌ Create duplicate widgets (ask Z to check first)
❌ Forget to test on both platforms
❌ Ignore Arabic RTL layout

## Customization

Feel free to customize Z for your workflow:

1. **Edit Z_AGENT_UNDP.md** to change:
   - Response format
   - Metrics tracked
   - Priority levels
   - Decision frameworks

2. **Edit MASTER_PLAN.md** to adjust:
   - Project phases
   - Success criteria
   - Development priorities

3. **Edit PROJECT_STATE.md** to update:
   - Current status
   - Feature percentages
   - Active bugs

## Integration with Other Tools

Z works alongside:
- **Git:** Z can help with commit messages and PR descriptions
- **Flutter CLI:** Z knows Flutter commands
- **Firebase:** Z understands Firebase Auth and integration
- **WordPress API:** Z knows the backend structure

## Getting Help

If Z doesn't understand something:
1. Be specific about the task
2. Mention which component/file is involved
3. Specify if it's iOS-specific, Android-specific, or both
4. Clarify if WordPress API changes are needed

If you want to modify Z's behavior:
1. Edit Z_AGENT_UNDP.md
2. Tell your AI: "Reload Z_AGENT_UNDP.md and use the updated behavior"

---

## Ready to Start?

Open your AI assistant and say:

```
Read Z_AGENT_UNDP.md and act as Z for the DealWithPast project.
```

Z will take it from there!
