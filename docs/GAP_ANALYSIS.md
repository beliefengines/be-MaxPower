# 🔍 Bitcoinology Gap Analysis — Post PR #15
**Date:** Feb 13, 2026 | **Crawled:** bitcoinology.beliefengines.io (live)

---

## Status Summary

| Area | Status |
|------|--------|
| 🔍 Search + Results | ✅ Working |
| 📊 Ontology Graph | ✅ Working |
| 📄 Docs & Data Panel | ✅ Working (100 episodes) |
| 👥 Speakers Panel | ❌ Broken — shows empty |
| 📱 Mobile Layout | ⚠️ Partial — nav works, issues below |

---

## 🔴 P0 — Critical (Blocks Core UX)

### 1. Speakers Panel Empty
**Severity:** P0
**What:** Clicking "Speakers" shows blank page with "Search what people actually believe" fallback instead of the 281 speakers list.
**Expected:** Scrollable speaker list with names, episode counts, word counts (per AnalyticsPanel wired in PR #15).
**Likely cause:** `AnalyticsPanel` either isn't fetching from `/api/speakers` or the API route doesn't exist/returns empty. Check if the Supabase RPC `get_speaker_aggregations` is being called.
**Fix scope:** Small — verify API route exists, check fetch call in AnalyticsPanel component.

### 2. Search Results Don't Persist on Panel Switch
**Severity:** P0
**What:** After searching "Michael Saylor" and getting results, clicking any feature square (Ontology/Speakers/Docs) wipes the search results. Going back to search shows empty state.
**Expected:** Search results should persist in Zustand store and restore when returning to search view.
**Fix scope:** Medium — need to cache last search results in app store, restore on panel switch back.

---

## 🟠 P1 — High (Degrades Core Experience)

### 3. No Belief Cards — Results are Raw Markdown
**Severity:** P1
**What:** Search results render as markdown text (headers + blockquotes). Vision calls for styled **Belief Cards** (orange bordered cards with speaker avatar, timestamp, episode link).
**Expected (from PRD):** Each belief = card with: quote text, speaker name, episode title, timestamp link, save/share actions.
**Fix scope:** Large — new `BeliefCard` component, structured data parsing from SSE stream.

### 4. No "Deep Analysis" / Playbook Flow
**Severity:** P1
**What:** "Deep Analysis" button exists on results but is non-functional. PRD Milestone 2 specifies a 4-lens analysis (Steel Man, Blind Spots, Historical, Related).
**Expected:** Clicking triggers multi-lens agentic analysis with animated progress.
**Fix scope:** Large — new API route + frontend panel + streaming multi-step response.

### 5. No Thread Persistence
**Severity:** P1
**What:** "Save to Thread" button exists but threads aren't implemented. No thread list, no conversation history.
**Expected (PRD M4):** Saved threads in sidebar, persistent conversations, thread management.
**Fix scope:** Large — needs Supabase `threads` table, thread list UI, thread navigation.

### 6. Speaker Names Show as Slugs
**Severity:** P1
**What:** Docs panel shows `michael-saylor`, `unknown-host`, `unknown-speaker-2` instead of proper names.
**Expected:** Display names (e.g., "Michael Saylor"), handle unknowns gracefully (hide or show "Unknown Host").
**Fix scope:** Small — map slugs to display names, either in API response or frontend transform.

### 7. Ontology Graph — No Node Interaction
**Severity:** P1
**What:** Graph shows floating orange circles with single-letter labels. No click/tap behavior, no tooltips, no detail panel.
**Expected (PRD M3):** Click node → speaker detail panel (beliefs count, top episodes, related speakers). Hover = tooltip with name.
**Fix scope:** Medium — add click handler to graph nodes, wire to speaker detail view.

---

## 🟡 P2 — Medium (Polish / UX Quality)

### 8. No Search Animation / Lightning Bolt
**Severity:** P2
**What:** Search shows "Thinking..." → "Analyzing..." → results. No visual flair.
**Expected (Vision):** Retro training animation → lightning strike → bolt becomes workflow tree → results land as "loot."
**Fix scope:** Large — custom animation system, workflow visualization.

### 9. Feature Squares Not Interactive Enough
**Severity:** P2
**What:** Feature squares show stats but descriptions are truncated on mobile. No hover states or visual feedback on desktop.
**Fix scope:** Small — add hover effects, ensure text doesn't clip.

### 10. No User Profile / Settings
**Severity:** P2
**What:** "M" avatar button in header has no menu/dropdown. No settings, no profile, no logout.
**Expected:** User menu dropdown with profile, settings, logout.
**Fix scope:** Medium — dropdown component + auth integration.

### 11. No Search History / Recent Searches
**Severity:** P2
**What:** Home screen has no search history. PRD shows "Recent: Saylor, Alden, Pysh" below search bar.
**Fix scope:** Medium — store searches in localStorage or Supabase, display as chips.

### 12. Mobile: Search Bar Buried at Bottom
**Severity:** P2
**What:** Search input is at the very bottom of the page, below the fold on mobile. Users must scroll past the full graph/panel to find it.
**Expected:** Search bar prominent and accessible — consider sticky bottom bar or top placement on mobile.
**Fix scope:** Small — CSS repositioning.

---

## 🔵 P3 — Low (Future / Nice-to-Have)

### 13. No Retro Pixel Art Aesthetic
**What:** Current UI is clean dark theme with orange accents. Vision calls for full 8-bit/16-bit NES/SNES pixel art aesthetic.
**Scope:** Massive — complete design system overhaul. Recommend: do this as a dedicated design sprint AFTER core functionality works.

### 14. No Gamification Layer
**What:** No speaker tiers (Common→Legendary), no XP, no collectible cards, no sat costs.
**Scope:** Massive — game design + implementation sprint.

### 15. No Share Functionality
**What:** "Share" button exists on results but non-functional.
**Scope:** Medium — generate shareable URLs or card images.

### 16. No MCP Server / API Mode
**What:** PRD mentions dual-interface (human + machine). No structured API exists yet.
**Scope:** Large — separate workstream.

### 17. Episode Detail View Missing
**What:** Docs panel lists episodes but clicking does nothing. Should open episode detail with transcript segments, speakers, timeline.
**Scope:** Medium.

---

## 📋 Recommended Sprint Order

**Sprint 1 (Quick Wins — 1-2 days):**
- Fix #1 (Speakers panel) — P0
- Fix #6 (Speaker name slugs) — P1
- Fix #12 (Mobile search bar) — P2

**Sprint 2 (Core UX — 3-5 days):**
- Fix #2 (Search persistence) — P0
- Fix #3 (Belief Cards) — P1
- Fix #7 (Graph interaction) — P1
- Fix #10 (User menu) — P2

**Sprint 3 (Depth Features — 1-2 weeks):**
- Fix #4 (Deep Analysis) — P1
- Fix #5 (Threads) — P1
- Fix #11 (Search history) — P2

**Sprint 4+ (Vision):**
- #8 (Animations), #13 (Pixel art), #14 (Gamification)
