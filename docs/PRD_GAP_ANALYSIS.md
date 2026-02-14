# Bitcoinology PRD Gap Analysis

> **Generated:** 2026-02-13 | **PRD Source:** `_bmad-output/planning-artifacts/milestones-wireframes.md`
> **Live Site:** https://bitcoinology.beliefengines.io

---

## Table of Contents

- [Executive Summary](#executive-summary)
- [Milestone 1: Search & Results](#milestone-1-search--results)
  - [1.1 Login Screen](#11-login-screen)
  - [1.2 Home Screen (Post-Login)](#12-home-screen-post-login)
  - [1.3 Search Results](#13-search-results)
- [Milestone 2: Playbook Deep Analysis](#milestone-2-playbook-deep-analysis)
  - [2.1 Deep Analysis Button](#21-deep-analysis-button)
  - [2.2 4-Lens Analysis View](#22-4-lens-analysis-view)
- [Milestone 3: 2D Ontology Graph](#milestone-3-2d-ontology-graph)
  - [3.1 Graph View](#31-graph-view)
  - [3.2 Node Detail Panel](#32-node-detail-panel)
- [Milestone 4: Threads & Persistence](#milestone-4-threads--persistence)
  - [4.1 Threads List](#41-threads-list)
  - [4.2 Thread Conversation](#42-thread-conversation)
- [Shared UI Components](#shared-ui-components)
  - [Header & Navigation](#header--navigation)
  - [Dropdown Menus](#dropdown-menus)
  - [Feature Squares](#feature-squares)
- [Priority Summary Table](#priority-summary-table)

---

## Executive Summary

**Overall Progress: ~55% of M1-M4 PRD vision shipped.**

The app has a solid foundation: auth works, search streams results with citations, the ontology graph renders, speakers/docs panels exist, threads have basic CRUD, and the playbook 4-lens pipeline is wired end-to-end. The biggest gaps are **visual polish** (results render as markdown, not styled BeliefCards per mockups), **missing interactive features** (graph controls, node detail panel, search history on home), and **thread UX** (no threads list view, no delete). The playbook is functionally complete but needs UI refinement.

---

## Milestone 1: Search & Results

### 1.1 Login Screen

| Item | PRD | Current | Status |
|------|-----|---------|--------|
| Google SSO button | ✅ | ✅ Supabase Auth + Google | ✅ Done |
| "Search what people actually believe" tagline | ✅ | ✅ Shows in home panel | ✅ Done |
| Branding (globe logo + "Bitcoinology") | ✅ | ✅ BtcLogo component | ✅ Done |
| Invite-gated access | Not in PRD | ✅ Invite code system exists | ✅ Bonus |

**Gaps: None — Login is complete.**

### 1.2 Home Screen (Post-Login)

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| 3 feature squares (Ontology, Analytics, Docs) | ✅ Dashed orange borders, clickable | ✅ Solid border variant in app-shell | ⚠️ Partial | P2 | S |
| Recent search history cards | ✅ Shows previous searches with mini-thumbnails | ⚠️ Shows thread cards only (no search-only history) | ⚠️ Partial | P1 | M |
| Search bar at bottom | ✅ Sticky footer with input | ✅ `app-shell.tsx` has search form at bottom | ✅ Done | — | — |
| "Start a new exploration" label | ✅ Above search bar | ❌ Missing | P3 | S |
| Stats display (episodes, chunks, speakers) | Not in mockup | ✅ Fetched and shown in feature squares | ✅ Bonus | — | — |

**Key Gap:** PRD shows recent search cards on home (with mini ontology/analytics/docs thumbnails). Current implementation only shows saved threads. Unsaved searches are lost on home screen.

**Files to change:**
- `src/components/panels/home-panel.tsx` — Add search history (needs new store state or localStorage)
- `src/stores/app-store.ts` — Add `recentSearches` array
- `src/components/app-shell.tsx` — Wire feature square styling to match mockup (dashed orange borders)

### 1.3 Search Results

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| Key Themes card with numbered themes | ✅ Structured: theme title + quotes + episode@timestamp | ⚠️ Renders as markdown via `KeyThemesCard` | ⚠️ Partial | P0 | M |
| Timestamped citations per theme | ✅ `Episode: WBD-podcast @ 12:33` | ⚠️ Citations exist in AI output but not structured/clickable | P1 | M |
| Belief count ("23 beliefs found") | ✅ Above results | ❌ Missing | P2 | S |
| Individual BeliefCards with speaker, quote, timestamp, score | ✅ Per mockup | ⚠️ `BeliefCard` component exists but unused — results go through `KeyThemesCard` markdown | P0 | M |
| [Deep Analysis] button | ✅ Below results | ✅ "Deep Analysis" button renders after results | ✅ Done | — | — |
| [Save] button | ✅ Below results | ✅ "Save to Thread" button works | ✅ Done | — | — |
| [Share] button | ✅ Below results | ✅ "Share" copies to clipboard | ✅ Done | — | — |
| Feature squares remain visible during search | ✅ Always at top | ✅ App shell keeps squares above panel | ✅ Done | — | — |

**Key Gap:** The PRD vision is structured BeliefCards with discrete fields (speaker, quote, episode, timestamp, score). The current implementation streams everything through `KeyThemesCard` which renders raw markdown from the LLM. The `BeliefCard` component exists at `src/components/search/belief-card.tsx` but is **not imported or used anywhere**.

**Files to change:**
- `src/components/search/chat.tsx` — Parse structured results from tool invocations; render `BeliefCard` for individual beliefs + `KeyThemesCard` for synthesis
- `src/app/api/query/route.ts` — Ensure tool results include structured belief data (speaker, episode, timestamp) alongside LLM synthesis
- `src/components/search/key-themes-card.tsx` — Refactor to render structured themes, not raw markdown

---

## Milestone 2: Playbook Deep Analysis

### 2.1 Deep Analysis Button

| Item | PRD | Current | Status |
|------|-----|---------|--------|
| "Deep Analysis" CTA after search results | ✅ | ✅ Button renders, triggers playbook | ✅ Done |
| Per-belief "Deep Analysis" button | ✅ On each BeliefCard | ⚠️ `BeliefCard` has `onDeepAnalysis` prop but component unused | P1 | M |

### 2.2 4-Lens Analysis View

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| BELIEFS lens | ✅ List of key beliefs | ✅ `BeliefsCard` component | ✅ Done | — | — |
| TIMELINE lens | ✅ Timeline chart with events | ✅ `TimelineCard` component | ✅ Done | — | — |
| SENTIMENT lens | ✅ Bullish/Neutral/Bearish bars + trend | ✅ `SentimentCard` component | ✅ Done | — | — |
| CONTEXT lens | ✅ Similar speakers with % match | ✅ `ContextCard` component | ✅ Done | — | — |
| SYNTHESIS section | ✅ Streaming paragraph | ✅ `SynthesisSection` streams text | ✅ Done | — | — |
| 2×2 grid layout | ✅ Per wireframe | ✅ `grid grid-cols-1 md:grid-cols-2` | ✅ Done | — | — |
| Back navigation (← in header) | ✅ | ❌ Only "Close" text button on playbook | P2 | S |
| Skeleton loading states | ✅ | ✅ Skeleton components for each lens | ✅ Done | — | — |
| [Save] and [Share] buttons | ✅ Below synthesis | ❌ No save/share on playbook view | P2 | S |

**Assessment: Milestone 2 is ~85% complete.** The 4-lens pipeline is fully wired: API route streams SSE with lenses + synthesis. UI renders all 4 cards + synthesis. Minor gaps are save/share on playbook and back navigation polish.

**Files to change:**
- `src/components/playbook/playbook-view.tsx` — Add Save/Share buttons
- `src/components/search/chat.tsx` — Wire back navigation for playbook state

---

## Milestone 3: 2D Ontology Graph

### 3.1 Graph View

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| Force-directed speaker network | ✅ SVG with nodes + connections | ✅ `react-force-graph-2d` canvas rendering | ✅ Done | — | — |
| Orange glow on nodes | ✅ Per mockup | ✅ `shadowColor: 'rgba(247, 147, 26, 0.6)'` | ✅ Done | — | — |
| Dashed connection lines | ✅ Animated dash pattern | ✅ `ctx.setLineDash([4, 4])` | ✅ Done | — | — |
| Matrix-style grid background | ✅ `.ontology-grid` CSS | ✅ Class applied in `speaker-graph.tsx` | ✅ Done | — | — |
| Zoom controls ([+] [-] [Reset]) | ✅ Per wireframe | ❌ No `GraphControls` UI wired | P1 | S |
| Filter dropdown (All / by topic) | ✅ `Filter: [All v]` | ❌ No filter UI | P2 | M |
| Node click → triggers search | ✅ Tap node → see belief summary | ✅ `onNodeClick` sets search + switches panel | ✅ Done | — | — |
| Hint banner ("Click entities for info") | ✅ Per mockup | ❌ Missing | P3 | S |
| Active state on Ontology square | ✅ Solid border + bg fill when active | ❌ Feature squares don't show active state | P2 | S |

**Files to change:**
- `src/components/graph/graph-controls.tsx` — File exists but need to verify if wired
- `src/components/graph/speaker-graph.tsx` — Wire zoom controls, add filter prop
- `src/components/panels/ontology-panel.tsx` — Add hint banner, wire controls

### 3.2 Node Detail Panel

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| Slide-in detail panel on node tap | ✅ Shows speaker name, belief count, connections, themes | ✅ `SpeakerPanel` component exists with connections + "View All Beliefs" | ⚠️ Partial | P1 | M |
| Speaker panel wired to graph | ✅ | ❌ `SpeakerPanel` not imported in `OntologyPanel` — node click goes straight to search | P1 | M |
| "View All Beliefs" button | ✅ | ✅ Exists in `SpeakerPanel` | ✅ Done | — | — |
| Key themes list on speaker detail | ✅ 3 themes per speaker | ❌ Not in `SpeakerPanel` | P2 | M |
| "Connected: N speakers" + "Strongest: X (87%)" | ✅ | ✅ `SpeakerPanel` shows top 5 connections with % | ✅ Done | — | — |

**Key Gap:** `SpeakerPanel` (`src/components/graph/speaker-panel.tsx`) is a complete component but **not used**. `OntologyPanel` skips it entirely — clicking a node immediately triggers a search. The PRD flow is: tap node → see speaker detail panel → optionally click "View All Beliefs" to search.

**Files to change:**
- `src/components/panels/ontology-panel.tsx` — Import and render `SpeakerPanel` on node click instead of immediate search
- `src/components/graph/speaker-panel.tsx` — Add key themes section (needs API or pre-computed data)

---

## Milestone 4: Threads & Persistence

### 4.1 Threads List

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| "MY THREADS" heading | ✅ | ❌ No dedicated threads list view | P0 | M |
| List of threads with title + date | ✅ | ⚠️ Home panel shows threads but no dedicated panel/route | P0 | M |
| [+ New] button | ✅ | ❌ Missing | P1 | S |
| Thread cards clickable → opens conversation | ✅ | ✅ Home panel thread cards navigate to thread panel | ✅ Done | — | — |
| Threads accessible from hamburger/nav | ✅ | ❌ No way to reach threads except from home | P1 | S |

**Key Gap:** The PRD shows a dedicated "MY THREADS" screen accessible from navigation. Currently, threads only appear on the home panel mixed with other content. There's no way to get to threads from the hamburger menu, and no "+ New Thread" action.

### 4.2 Thread Conversation

| Item | PRD | Current | Status | Priority | Effort |
|------|-----|---------|--------|----------|--------|
| Thread title at top | ✅ "ETF Deep Dive" | ❌ Thread title not displayed in thread panel | P1 | S |
| [Delete] button | ✅ Per wireframe | ❌ Missing (API exists at `/api/threads/[id]` but no UI) | P1 | S |
| YOU / BOT labels on messages | ✅ Per wireframe | ✅ Labels shown in thread mode | ✅ Done | — | — |
| Follow-up input at bottom | ✅ "Ask follow-up..." | ✅ Thread continuation form exists | ✅ Done | — | — |
| Feature squares visible in thread view | ✅ Per wireframe | ✅ App shell keeps squares above | ✅ Done | — | — |
| Thread persistence (close + reopen) | ✅ | ✅ Threads saved to Supabase, loaded on reopen | ✅ Done | — | — |
| Conversation context maintained across follow-ups | ✅ | ✅ `Chat` sends `threadId` + `saveToThread` in body | ✅ Done | — | — |

**Files to change:**
- `src/stores/app-store.ts` — Add `'threads'` to `PanelType` union
- `src/components/panels/` — Create `threads-list-panel.tsx`
- `src/components/panels/thread-panel.tsx` — Add thread title display + delete button
- `src/components/app-shell.tsx` — Wire threads panel to navigation

---

## Shared UI Components

### Header & Navigation

| Item | PRD (mockups) | Current | Status | Priority | Effort |
|------|--------------|---------|--------|----------|--------|
| Notification bell icon | ✅ `bitcoinology-dropdown-header.html` | ❌ Missing | P3 | M |
| Settings gear icon | ✅ `bitcoinology-dropdown-settings.html` | ⚠️ Stub in user menu dropdown ("Soon") | P3 | L |
| Hamburger menu (≡) | ✅ All mockups show it | ❌ No hamburger/mobile nav drawer | P1 | M |
| User avatar with initial | ✅ Orange circle with letter | ✅ `UserAvatar` component | ✅ Done | — | — |
| Theme toggle | Not in mockups | ✅ Light/dark toggle exists | ✅ Bonus | — | — |

### Dropdown Menus

| Item | PRD (mockups) | Current | Status | Priority | Effort |
|------|--------------|---------|--------|----------|--------|
| User menu dropdown (Settings, Sign out) | ✅ `bitcoinology-dropdown-usermenu.html` | ✅ Radix dropdown with settings stub + sign out | ✅ Done | — | — |
| Notifications dropdown | ✅ `bitcoinology-dropdown-notif.html` | ❌ Not implemented | P3 | L |
| Settings dropdown/page | ✅ `bitcoinology-dropdown-settings.html` | ❌ Stub only | P3 | L |

### Feature Squares

| Item | PRD (mockups) | Current | Status | Priority | Effort |
|------|--------------|---------|--------|----------|--------|
| Dashed orange borders | ✅ `border-2 border-dashed border-btc-orange` | ❌ Using solid muted borders | P2 | S |
| Active state (solid bg fill) | ✅ `bg-btc-orange/20` on active tab | ❌ No active state indicator | P2 | S |
| 3-column grid always visible | ✅ | ✅ | ✅ Done | — | — |
| Square labels match mockup ("2D Ontology", "Analytics", "Docs Quotes Data") | ✅ | ⚠️ Labels exist but "Analytics" shows as "Speakers" | P2 | S |

---

## Priority Summary Table

| ID | Gap | Priority | Effort | Milestone |
|----|-----|----------|--------|-----------|
| **G-01** | Search results render as markdown, not structured BeliefCards | **P0** | **M** | M1 |
| **G-02** | No dedicated Threads List panel | **P0** | **M** | M4 |
| **G-03** | `BeliefCard` component exists but unused — wire to search results | **P0** | **M** | M1 |
| **G-04** | Timestamped citations not structured/clickable | **P1** | **M** | M1 |
| **G-05** | Recent search history on home (not just threads) | **P1** | **M** | M1 |
| **G-06** | `SpeakerPanel` exists but not wired to ontology — node click bypasses detail | **P1** | **M** | M3 |
| **G-07** | Graph zoom controls not wired | **P1** | **S** | M3 |
| **G-08** | Thread title not shown in thread view | **P1** | **S** | M4 |
| **G-09** | Thread delete button missing (API exists) | **P1** | **S** | M4 |
| **G-10** | Hamburger menu / mobile nav drawer missing | **P1** | **M** | Shared |
| **G-11** | Threads not accessible from navigation | **P1** | **S** | M4 |
| **G-12** | Per-belief Deep Analysis button (unused `BeliefCard` prop) | **P1** | **M** | M2 |
| **G-13** | "+ New Thread" action | **P1** | **S** | M4 |
| **G-14** | Feature squares: dashed orange borders per mockup | **P2** | **S** | Shared |
| **G-15** | Feature squares: active state indicator | **P2** | **S** | Shared |
| **G-16** | Belief count above results ("23 beliefs found") | **P2** | **S** | M1 |
| **G-17** | Graph filter dropdown (topic/all) | **P2** | **M** | M3 |
| **G-18** | Playbook save/share buttons | **P2** | **S** | M2 |
| **G-19** | Back navigation on playbook (← not just "Close" text) | **P2** | **S** | M2 |
| **G-20** | Key themes in speaker detail panel | **P2** | **M** | M3 |
| **G-21** | Analytics square label mismatch ("Speakers" vs "Analytics") | **P2** | **S** | Shared |
| **G-22** | "Start a new exploration" label above search | **P3** | **S** | M1 |
| **G-23** | Hint banner on ontology ("Click entities for info") | **P3** | **S** | M3 |
| **G-24** | Notification bell + dropdown | **P3** | **L** | Shared |
| **G-25** | Settings page (beyond stub) | **P3** | **L** | Shared |
| **G-26** | Unknown speakers filtering | **P3** | **S** | M3 |

### By Priority

- **P0 (3 items):** G-01, G-02, G-03 — Core UX gaps that block the PRD's primary user stories
- **P1 (10 items):** G-04 through G-13 — Important functionality that's partially built or has components ready to wire
- **P2 (8 items):** G-14 through G-21 — Visual polish and secondary features
- **P3 (5 items):** G-22 through G-26 — Nice-to-haves, future milestones

### Effort Breakdown

- **S (Small, <4h):** G-07, G-08, G-09, G-11, G-13, G-14, G-15, G-16, G-18, G-19, G-21, G-22, G-23, G-26
- **M (Medium, 4-16h):** G-01, G-02, G-03, G-04, G-05, G-06, G-10, G-12, G-17, G-20
- **L (Large, 1-3 days):** G-24, G-25
