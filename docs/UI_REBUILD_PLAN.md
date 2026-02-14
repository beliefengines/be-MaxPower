# UI Rebuild Plan — Bitcoinology v1

**Author:** Max Power ⚡  
**Date:** 2026-02-11  
**Status:** Draft for Ryan's review

---

## The Gap

### Vision (from beaut.excalidraw + mockups + PRD)
- **"The Matrix, but orange"** — a living, gamified knowledge exploration tool
- Single-pane-of-glass app (not a website with routes)
- 3 interactive panels always visible: **2D Ontology | Analytics | Docs Quotes Data**
- Search triggers visible agentic workflows (animated pipeline tree)
- Every search builds the community knowledge graph
- Shareable search artifacts
- Obsidian-like personal knowledge base with AI

### Current State (bitcoinology.beliefengines.io)
- Standard Next.js multi-page app with separate routes
- Login page with magic link + Google OAuth
- Nav links as flat text in a row
- Home page shows recent threads or empty state with suggested tags
- Search redirects via `?q=` param
- No workflow visualization
- No knowledge graph building
- No sharing
- No gamification
- No animation or "alive" feeling

### What's Actually Working (keep this)
- ✅ Supabase auth (Google OAuth + magic link)
- ✅ API routes: `/api/query`, `/api/playbook`, `/api/graph/data`, `/api/threads`
- ✅ Qdrant vector search integration
- ✅ Thread persistence (Supabase)
- ✅ Chat component with streaming
- ✅ Playbook 4-lens analysis (beliefs/timeline/sentiment/context cards)
- ✅ Graph component (react-force-graph-2d)
- ✅ Key themes card
- ✅ Color palette (btc-orange, btc-dark, btc-card, btc-muted)

---

## Rebuild Strategy

### Principle: Single-Pane App Shell

Everything lives inside ONE view. No route changes. Panels swap content inline.

```
┌─────────────────────────────────────────────┐
│ HEADER: Logo + Avatar + Hamburger           │
├─────────────────────────────────────────────┤
│ ┌───────────┐┌───────────┐┌───────────────┐ │
│ │    2D     ││           ││    Docs       │ │
│ │  Ontology ││ Analytics ││   Quotes      │ │
│ │  [graph]  ││ [charts]  ││    Data       │ │
│ └───────────┘└───────────┘└───────────────┘ │
├─────────────────────────────────────────────┤
│                                             │
│            MAIN CONTENT AREA                │
│   (Search results / Playbook / Chat /       │
│    Expanded panel / Workflow tree)           │
│                                             │
├─────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────┐ │
│ │ Search beliefs...                   🔍  │ │
│ └─────────────────────────────────────────┘ │
│   Start a new exploration                   │
└─────────────────────────────────────────────┘
```

### Phase 1: App Shell (PR #1) — TONIGHT
**Goal:** Replace multi-route layout with single-pane app shell

1. **New `AppShell` component** — full-screen flex column
   - Header (logo + user avatar + hamburger)
   - Feature Squares row (3 tappable cards with icons)
   - Main content area (dynamic, panel-based)
   - Footer search bar (pinned bottom)

2. **Panel state management** — Zustand store
   - `activePanel`: `'home' | 'ontology' | 'analytics' | 'docs' | 'search' | 'playbook' | 'thread'`
   - `searchQuery`: current search
   - `activeThread`: current thread ID
   - Tapping a square sets `activePanel`, content area swaps

3. **Keep existing routes as fallbacks** but main experience is single-pane

4. **Style matching** — match the HTML mockups exactly:
   - Black background (`bg-black`)
   - Orange dashed borders on cards (`border-2 border-dashed border-btc-orange`)
   - Monospace font in results area
   - Mobile-first (390px base, scales up)
   - Card hover animations (translateY + orange glow)

### Phase 2: Workflow Visualization (PR #2)
**Goal:** When a search fires, show an animated tree of pipeline steps

1. **WorkflowTree component** — shows agentic pipeline in real-time
   - Tree nodes: Query → Route → Search/Playbook → Lenses → Synthesize → Response
   - Each node lights up (pending → active → complete)
   - Animated connections between nodes
   - Uses SSE events from Motia (`status` events already in the API contract)

2. **Replaces loading spinner** — the tree IS the loading state

3. **Debug mode for Ryan** — expanded view showing timing, tokens, agent used

### Phase 3: Knowledge Building (PR #3)
**Goal:** Searches accumulate into personal knowledge graph

1. **Save search artifacts** — each search creates a shareable card
2. **Personal ontology** — user's searches contribute nodes/edges
3. **Community rollup** — shared searches feed the global dataset

### Phase 4: Sharing & Gamification (Future)
- Public search URLs
- Community contributions to dataset
- 10 sats per search (Lightning integration)
- Leaderboards, badges

---

## Technical Decisions

### State Management
- **Zustand** for panel state (already in deps as recommendation)
- **React Query** for server state (API calls, caching)
- No URL routing for panel switches — feels like an app, not a website

### Animation
- **Framer Motion** for panel transitions and workflow tree
- CSS animations for card hovers (already in mockups)
- `requestAnimationFrame` for graph animations

### The 3 Squares
Each square is both a **nav element** and a **live preview**:
- **2D Ontology**: Mini force-graph preview, expands to full graph
- **Analytics**: Mini chart preview, expands to dashboard
- **Docs Quotes Data**: File/quote count, expands to artifact browser

### Search Flow
```
User types in footer search bar
  → Query hits /api/query (existing)
  → WorkflowTree animates pipeline steps
  → Results populate main content area
  → 3 squares update with relevant previews
  → User can tap any square to dive deeper
  → Search auto-saves to thread
```

---

## Files to Create/Modify

### New Files
- `src/components/app-shell.tsx` — Main app shell
- `src/components/feature-squares.tsx` — The 3 tappable cards
- `src/components/workflow-tree.tsx` — Animated pipeline viz
- `src/components/panels/ontology-panel.tsx` — Expanded graph view
- `src/components/panels/analytics-panel.tsx` — Expanded analytics
- `src/components/panels/docs-panel.tsx` — Expanded docs/quotes
- `src/components/panels/search-panel.tsx` — Search results
- `src/stores/app-store.ts` — Zustand store for panel state

### Modified Files
- `src/app/(main)/layout.tsx` — Simplify to render AppShell
- `src/app/(main)/page.tsx` — Simplify to render AppShell
- `src/components/layout/footer-search.tsx` — Restyle to match mockups

### Keep As-Is
- All `/api/` routes
- `src/components/search/chat.tsx`
- `src/components/search/key-themes-card.tsx`
- `src/components/playbook/*`
- `src/components/graph/*`
- `src/lib/*`
- Auth flow

---

## PR #1 Scope (Tonight)

Deliverable: Single-pane app shell with 3 feature squares, matching mockup style.

- [ ] AppShell component (header + squares + content + footer)
- [ ] Feature squares matching mockup design (dashed orange borders, icons)
- [ ] Panel state (Zustand) — tap square to switch content
- [ ] Footer search bar matching mockup (dashed border, orange button)
- [ ] Home state: recent searches as cards (matching mockup layout with mini squares)
- [ ] Search state: key themes card in main area
- [ ] Mobile-first responsive layout
- [ ] Dark theme matching mockups exactly
- [ ] Smooth panel transitions

**NOT in PR #1:**
- Workflow tree animation (PR #2)
- Knowledge graph building (PR #3)
- Sharing (PR #4)
