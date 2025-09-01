# Gamification v1 PRD

## Overview
- Objective: Increase engagement and data completeness via achievements, streaks, and timely nudges.
- Target Release: First version after TestFlight completion.
- Success Metrics:
  - +25% weekly active users within 4 weeks
  - +30% increase in complete fuel fill-ups logged per active user
  - +20% increase in maintenance records logged per month

## Scope (v1)
- Event-driven engine that updates progress and unlocks achievements from app events
- Achievement catalog (seeded at first launch)
- Streak logic for complete fuel fill-ups
- UI: Achievements list, detail, badges, and Home nudge card
- Optional notifications/in-app banners (opt-in)
- One-time backfill over existing data
- Analytics and QA hooks

Out-of-scope (v1): social sharing, server-side leaderboards, cross-account sync beyond CloudKit defaults

## Taxonomy
- Categories: Fuel, Maintenance, Expenses, Ownership
- Tiers: Bronze, Silver, Gold, Platinum (visual only; thresholds define unlock)
- Repeatable: Some achievements allow multiple unlocks (count badge on tile)

Example achievements
- Fuel (Counts): First, 5, 10, 25, 50, 100, 500, 1000, 5000 fill-ups
- Fuel (Streaks): 5, 10, 25, 50, 100 complete fill-ups in a row
- Maintenance: First maintenance record, 5 records total, 3 distinct categories covered, yearly service on time
- Expenses: First expense, 10 expenses, 3 categories, monthly budgeting streak (non-blocking placeholder)
- Ownership: First vehicle added, cost report viewed, documents uploaded

Copy guidelines: concise, action-oriented, positive framing; localization-ready keys

## Event Model
- Domain events consumed by engine:
  - fuelAdded(vehicleId, gallons, isCompleteFillHeuristic)
  - maintenanceAdded(vehicleId, category)
  - expenseAdded(vehicleId, category)
  - reportViewed(type)
- Backfill: iterate historical data (off-main), update progress, persist checkpoints
- Idempotency required (rehydration/backfill safe)

## Complete Fill-up Heuristic
- Default: gallons >= user’s 90th percentile over last N fill-ups OR explicit user toggle on entry
- Resets streak on partial/missed fill; record streakCurrent and streakBest

## Data Model (Core Data)
- Achievement: id, key, title, detail, category, tier, isRepeatable, thresholdType, thresholdValue
- UserAchievement: id, achievementKey, count, firstUnlockedAt, lastUnlockedAt, progressNumeric, streakCurrent, streakBest

## UX
- Achievements Screen: grid/list, filters (All/Unlocked/Locked), category tabs, progress bars, repeat count badge
- Detail Sheet: title, description, unlock history, progress
- Home Nudge: compact card with nextGoals() (e.g., “4 more fuel fill-ups to go!”) → deep-links into relevant screen
- Notifications/Banners: optional, respect quiet hours and user prefs
- Accessibility: VoiceOver labels, Dynamic Type, contrast

## Analytics & QA
- Log anonymized events for unlocks and streak changes
- DEBUG/TESTFLIGHT: QA panel to force-unlock for verification

## Performance
- Engine updates on background queues where possible; UI updates on main
- Backfill throttled; checkpointing to resume

## Security & Privacy
- No PII in analytics; local-only progress state
- Respect system notification permissions

## MVP Acceptance Criteria
- Catalog seeded on first launch; no duplicates
- Engine updates progress/unlocks on events and across app restarts
- Streak logic behaves as specified; unit tests for transitions and edge cases
- Achievements UI is responsive and accessible; empty states handled
- Home Nudge appears only when relevant and deep-links work
- Notifications/Banners only when enabled; tappable to achievement detail
- Backfill completes without UI jank and is idempotent

## Dependencies
- Core Data model update (Achievements, UserAchievements)
- Settings/Build: DEBUG or TESTFLIGHT gating for QA tools (already in place project-wide)

## Risks & Mitigations
- Heuristic misclassification: allow manual override flag on fuel entry; iterate thresholds
- Performance during backfill: batch and throttle; persist checkpoints
- Over-notification risk: default to conservative frequency and opt-in
