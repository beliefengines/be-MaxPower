# 🚀 Sprint Guide — Cycle 1 & 2 Overview

## Cycle 1: Core UX P0-P1 Fixes
**Dates:** Feb 14 → Feb 28 (2 weeks)  
**Tasks:** 13 (3 P0 + 10 P1)  
**Goal:** Fix the biggest UX gaps so the app matches the PRD vision.

### Suggested Work Order

#### Phase 1: P0s (do first — they unblock everything)
1. **Ensure API returns structured belief data** — verify tool results have speaker, episode, timestamp, confidence fields
2. **Wire BeliefCard to search results** — import unused component, parse tool results, render cards
3. **Create Threads List panel** — dedicated MY THREADS view with title, date, delete, +New

#### Phase 2: Independent P1s (no dependencies, parallelize)
4. Filter unknown speakers from Speakers panel _(1-2h)_
5. Graph zoom controls +/−/Reset _(2-4h)_
6. Thread title + delete button _(2-4h)_
7. Recent search history on home _(4-8h)_
8. Wire SpeakerPanel to ontology graph _(4-8h)_
9. Hamburger menu / mobile nav drawer _(4-8h)_

#### Phase 3: Dependent P1s (need Phase 1 done)
10. Structured clickable citations _(needs BeliefCards)_
11. Per-belief Deep Analysis _(needs BeliefCards)_
12. Threads in navigation _(needs Threads List + Hamburger)_
13. \+ New Thread action _(needs Threads List)_

### Suggested PR Grouping

| PR | Scope | Module | Tasks |
|----|-------|--------|-------|
| **PR A** | BeliefCards + API data + citations | 🃏 Cards | #1, #2, #10, #11 |
| **PR B** | Threads list + title/delete + nav + new | 🔍 Search | #3, #6, #12, #13 |
| **PR C** | SpeakerPanel + zoom + unknown filter | 🎙️ Speakers + 🎮 UI | #5, #8, #4 |
| **PR D** | Hamburger menu + mobile nav | 🎮 UI | #9 |

### Key Files Reference

| Component | Path | Status |
|-----------|------|--------|
| BeliefCard | `src/components/search/belief-card.tsx` | EXISTS but unused |
| SpeakerPanel | `src/components/graph/speaker-panel.tsx` | EXISTS but not imported |
| KeyThemesCard | `src/components/search/key-themes-card.tsx` | Renders raw markdown |
| App Shell | `src/components/app-shell.tsx` | Main layout component |
| App Store | `src/stores/app-store.ts` | Zustand state (add PanelType) |
| Query API | `src/app/api/query/route.ts` | Streams search results |
| Thread API | `src/app/api/threads/[id]/route.ts` | DELETE exists |
| Analytics Panel | `src/components/panels/analytics-panel.tsx` | Speakers data source |

---

## Cycle 2: Visual Polish + Secondary Features
**Dates:** Mar 1 → Mar 14 (2 weeks)  
**Tasks:** 13 (8 P2 + 5 P3)  
**Goal:** Polish the UI to match PRD mockups. Add nice-to-have features.

### P2 Tasks (8)
1. Feature squares — dashed orange borders per mockup
2. Feature squares — active state indicator
3. Belief count above results ("23 beliefs found")
4. Graph filter dropdown (All / by topic)
5. Playbook save/share buttons
6. Playbook back navigation arrow (← not "Close" text)
7. Key themes in SpeakerPanel detail
8. Analytics square label alignment

### P3 Tasks (5)
9. "Start a new exploration" label above search
10. Ontology hint banner ("Click entities for info")
11. Notification bell + dropdown (stub)
12. Settings page beyond stub
13. Unknown speakers cleanup in data pipeline

---

## Reference Docs
- [PRD Gap Analysis](https://github.com/beliefengines/be-MaxPower/blob/main/docs/PRD_GAP_ANALYSIS.md) — all 26 gaps with file paths
- [QA Gap Analysis](https://github.com/beliefengines/be-MaxPower/blob/main/docs/GAP_ANALYSIS.md) — live site findings
- [Security Audit](https://github.com/beliefengines/be-MaxPower/blob/main/docs/SECURITY_AUDIT.md)
- [UI Rebuild Plan](https://github.com/beliefengines/be-MaxPower/blob/main/docs/UI_REBUILD_PLAN.md)

---

## Review Process
1. Dev team works through Cycle 1 tasks in suggested order
2. Group into PRs (A/B/C/D as suggested above)
3. Max reviews each PR (code + QA crawl of deploy preview)
4. Ryan gives final approval + merge
5. After all Cycle 1 PRs merged → start Cycle 2
