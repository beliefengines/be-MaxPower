# V2 Design Extraction Spec
## Polish v1 + Steal v2's Design System

**Author:** Max Power ⚡  
**Date:** 2026-02-12  
**Status:** Ready for engineering

---

## Strategy

v1 has the real backend (vector search, auth, AI streaming, playbook analysis).  
v2 has the real design (shadcn/ui, dark mode, matrix rain, typography).  
We steal v2's design and apply it to v1. Ship in ~1 week.

---

## Phase 1: Design System Extraction (Days 1-2)

### 1.1 — Install shadcn/ui in v1

v1 already uses Radix primitives. shadcn/ui wraps Radix, so this is an upgrade, not a rewrite.

```bash
pnpm dlx shadcn-ui@latest init
```

Config answers:
- Style: Default
- Base color: Neutral (we'll override with Bitcoin orange)
- CSS variables: Yes
- Tailwind config: `tailwind.config.ts`
- Components dir: `src/components/ui`

Then install the components v2 actually uses:
```bash
pnpm dlx shadcn-ui@latest add card badge avatar button skeleton accordion
```

### 1.2 — Port CSS Variables

**Source:** `replit-bitcoinology-v2/client/src/index.css`  
**Target:** `be-bitcoinology-v1/src/app/globals.css`

Copy the entire `:root` and `.dark` blocks from v2's `index.css`. Key values:

| Variable | Light | Dark |
|----------|-------|------|
| `--background` | `30 5% 96%` | `0 0% 4%` |
| `--foreground` | `30 5% 10%` | `30 10% 92%` |
| `--primary` | `25 95% 48%` | `25 95% 53%` |
| `--card` | `30 5% 93%` | `0 0% 7%` |
| `--border` | `30 5% 88%` | `25 6% 13%` |
| `--muted-foreground` | `30 5% 40%` | `30 5% 55%` |

Also add the font variables:
```css
--font-sans: 'Space Grotesk', 'Inter', sans-serif;
--font-serif: 'Libre Baskerville', Georgia, serif;
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

### 1.3 — Port Tailwind Config

**Source:** `replit-bitcoinology-v2/tailwind.config.ts`  
**Target:** Merge into `be-bitcoinology-v1/tailwind.config.ts`

Key additions to v1's tailwind config:
- Replace `btc.*` color definitions with the CSS variable-based system from v2
- Add `fontFamily` block (sans, serif, mono)
- Add `borderRadius` overrides (lg: 9px, md: 6px, sm: 3px)
- Add `tailwindcss-animate` and `@tailwindcss/typography` plugins

### 1.4 — Add Fonts

Add to `src/app/layout.tsx` or `_document.tsx`:
```html
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300..700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
```

### 1.5 — Port CSS Animations

From v2's `index.css`, copy these keyframes into v1's globals:
- `matrix-fall` — for the background effect
- `glow-pulse` — for subtle element glows  
- `float` — for floating elements
- The hover-elevate utility classes

---

## Phase 2: Component Ports (Days 2-3)

### 2.1 — Matrix Rain Background

**Source:** `replit-bitcoinology-v2/client/src/components/matrix-rain.tsx` (83 lines)  
**Target:** `be-bitcoinology-v1/src/components/matrix-rain.tsx`

Copy the file as-is. It uses:
- Canvas API
- Bitcoin-specific terms (HODL, SATS, HALVING, etc.)
- Theme-aware colors (orange on dark, muted on light)

Add to v1's root layout:
```tsx
import { MatrixRain } from "@/components/matrix-rain";
// Inside layout:
<MatrixRain />
```

Note: Needs a `useTheme` hook — either port v2's theme-provider or adapt to v1's existing dark mode system.

### 2.2 — Belief Card

**Source:** `replit-bitcoinology-v2/client/src/components/belief-card.tsx`  
**Target:** `be-bitcoinology-v1/src/components/belief-card.tsx`

This is the best component in v2. Features:
- Speaker avatar with initials fallback
- Atomic belief + worldview display
- Domain badge + tier badge
- Expandable section with: core axiom, source quote (blockquote), timestamps
- Clean typography hierarchy

**Adaptation needed:** v1's data comes from `transcript_chunks`, not `beliefs`. Map fields:
| v2 field | v1 equivalent |
|----------|---------------|
| `atomic_belief` | Extracted from chunk content |
| `worldview` | Context/summary |
| `quote` | `chunk_text` |
| `domain` | Category tag |
| `confidence` | Search relevance score |
| `person_id` | Speaker from transcript |

### 2.3 — Speaker Card

**Source:** `replit-bitcoinology-v2/client/src/components/speaker-card.tsx`  
**Target:** `be-bitcoinology-v1/src/components/speaker-card.tsx`

Port the card layout with avatar, name, bio truncation, belief count, episode count, and cluster badge.

### 2.4 — Search Bar

**Source:** `replit-bitcoinology-v2/client/src/components/search-bar.tsx`  
**Target:** Replace v1's existing search input

The dashed orange border search bar is distinctive. Port the styling.

### 2.5 — Feature Squares

**Source:** `replit-bitcoinology-v2/client/src/components/feature-squares.tsx`  
**Target:** Update `be-bitcoinology-v1/src/components/feature-squares.tsx`

Port the card styling (orange headers, stat numbers, descriptions).

### 2.6 — Header + Mobile Nav

**Source:** `replit-bitcoinology-v2/client/src/components/header.tsx` + `mobile-nav.tsx`  
**Target:** Replace v1's `nav-links.tsx`

v2's header has:
- Logo + nav links (desktop)
- Search icon + theme toggle (right side)
- Bottom tab bar on mobile (Home, Beliefs, Search, Speakers, Episodes)

---

## Phase 3: Fix v1's 13 Todos (Days 3-5)

Priority order (based on user-facing impact):

### P0 — Must Fix
1. **Thread loading** — search threads don't load properly
2. **URL sync** — panel state doesn't reflect in URL
3. **Search results rendering** — ensure vector search results display in new belief-card format

### P1 — Should Fix  
4. **Dead code cleanup** — remove unused components/routes
5. **Loading states** — add skeleton screens (port from v2's skeleton component)
6. **Error handling** — graceful failures for API errors
7. **Mobile responsiveness** — test with new mobile nav

### P2 — Nice to Fix
8-13. Remaining wiring fixes (see PR #13 comments for full list)

---

## Phase 4: Dark Mode (Day 3)

v1 likely has partial dark mode. v2's system is complete:

**Source:** `replit-bitcoinology-v2/client/src/components/theme-provider.tsx` + `theme-toggle.tsx`  
**Target:** Add to v1

Uses `next-themes` pattern:
- ThemeProvider wraps the app
- ThemeToggle is the sun/moon icon button
- CSS variables swap via `.dark` class on `<html>`

---

## Files to Copy (Direct Port)

These can be copied almost verbatim from v2 → v1:

| v2 File | v1 Destination | Notes |
|---------|---------------|-------|
| `components/matrix-rain.tsx` | `src/components/matrix-rain.tsx` | Adapt theme hook |
| `components/theme-provider.tsx` | `src/components/theme-provider.tsx` | Use next-themes instead |
| `components/theme-toggle.tsx` | `src/components/theme-toggle.tsx` | Direct port |
| `components/btc-logo.tsx` | `src/components/btc-logo.tsx` | Direct port |
| `components/ui/*.tsx` | `src/components/ui/*.tsx` | Use shadcn/ui init instead |
| `index.css` (variables only) | `src/app/globals.css` | Merge, don't replace |

## Files to Adapt (Needs Rewiring)

| v2 File | v1 Destination | Adaptation |
|---------|---------------|------------|
| `components/belief-card.tsx` | `src/components/belief-card.tsx` | Remap data fields |
| `components/speaker-card.tsx` | `src/components/speaker-card.tsx` | Remap data fields |
| `components/search-bar.tsx` | `src/components/search-bar.tsx` | Wire to existing search API |
| `components/feature-squares.tsx` | `src/components/feature-squares.tsx` | Wire to real stats |
| `components/header.tsx` | `src/components/header.tsx` | Keep v1's auth UI |
| `components/mobile-nav.tsx` | `src/components/mobile-nav.tsx` | Adapt to Next.js routing |

## Files to NOT Copy

- `server/*` — v1 has its own backend
- `shared/schema.ts` — different data model  
- `package.json` — different deps
- `pages/*` — different routing (v2 is SPA, v1 is Next.js)

---

## Dependencies to Add to v1

```bash
pnpm add class-variance-authority clsx tailwind-merge lucide-react
pnpm add tailwindcss-animate @tailwindcss/typography
pnpm add next-themes
```

(Most shadcn deps — Radix packages — are likely already in v1)

---

## Definition of Done

- [ ] Dark mode with Bitcoin orange theme matches v2's look
- [ ] Matrix rain background on all pages
- [ ] Belief cards with expand/collapse, quote, core axiom
- [ ] Speaker cards with avatars, badges, belief counts
- [ ] Mobile bottom nav bar
- [ ] Dashed-border search bar styling
- [ ] Feature squares with stats on home page
- [ ] Space Grotesk + JetBrains Mono fonts
- [ ] All 13 PR #13 todos resolved
- [ ] v1's existing features still work: auth, vector search, AI streaming, playbook

---

## What Comes After This

Once the design extraction is done, the next big feature is the **workflow tree visualization** — the animated pipeline that shows the agentic search process. That's the real PRD differentiator and what makes Bitcoinology unlike anything else.
