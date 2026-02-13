# 🎯 MVP 2-Hour Sprint: "Show Friends" Build

> **Goal:** A working search → results experience with retro pixel art aesthetic. Must look impressive on mobile.
> **Deadline:** 2 hours from now
> **Repo:** `beliefengines/be-bitcoinology-v1` (branch off `main`)
> **Live site:** https://bitcoinology.beliefengines.io/

---

## Context

PR #13 just merged — the app has a single-pane shell with Zustand state management and v2 design tokens extracted. The backend API routes already work (`/api/query`, `/api/graph`, `/api/threads`). We just need the frontend to look good and work.

## Task 1: Dark Theme + Pixel Font (30 min)

### What
Transform the app from generic to retro Bitcoin aesthetic.

### How
1. **Global styles** — update `globals.css` or Tailwind config:
   - Background: `#0a0a0a` (near black)
   - Primary accent: `#F7931A` (Bitcoin orange)
   - Secondary: `#1a1a2e` (dark panels)
   - Text: `#e0e0e0` (light gray)
   - Borders: `#F7931A33` (orange with opacity)

2. **Fonts** — add to `layout.tsx` or `_document`:
   ```html
   <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&family=VT323&display=swap" rel="stylesheet">
   ```
   - `Press Start 2P` for headings/logo
   - `VT323` for body text (readable pixel font)
   - Fallback: `monospace`

3. **Apply globally** — every component gets dark bg, orange accents, pixel fonts

### Acceptance
- [ ] Page loads with dark background
- [ ] All text uses pixel fonts
- [ ] Orange accent color visible on interactive elements
- [ ] No white/light backgrounds remaining

---

## Task 2: Search Bar — Front and Center (30 min)

### What
A big, prominent search input that connects to the existing query API.

### How
1. **Layout** — center the search bar vertically on the main page:
   ```jsx
   <div className="flex flex-col items-center justify-center min-h-[60vh]">
     <h1 className="font-['Press_Start_2P'] text-[#F7931A] text-2xl mb-8">
       BITCOINOLOGY
     </h1>
     <input 
       type="text"
       placeholder="What do Bitcoiners believe?"
       className="w-full max-w-xl px-6 py-4 bg-[#1a1a2e] border-2 border-[#F7931A] 
                  text-[#e0e0e0] font-['VT323'] text-xl rounded-none
                  focus:outline-none focus:border-[#F7931A] focus:shadow-[0_0_10px_#F7931A33]"
     />
     <button className="mt-4 px-8 py-3 bg-[#F7931A] text-black font-['Press_Start_2P'] 
                        text-sm hover:bg-[#ff9f2f] transition">
       ⚡ SEARCH
     </button>
   </div>
   ```

2. **API connection** — on submit, POST to `/api/query`:
   ```typescript
   const response = await fetch('/api/query', {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify({ query: searchText })
   });
   const data = await response.json();
   ```

3. **Loading state** — show "⚡ Searching..." with a simple pulse animation while waiting

### Acceptance
- [ ] Search bar centered on page with "BITCOINOLOGY" title above
- [ ] Typing and hitting enter/button triggers API call
- [ ] Loading state visible during search
- [ ] Results appear below search bar

---

## Task 3: Belief Card Display (45 min)

### What
Show search results as styled belief cards with speaker attribution and source citation.

### How
1. **Card component** — create `BeliefCard.tsx`:
   ```jsx
   <div className="border-2 border-[#F7931A] bg-[#1a1a2e] p-4 mb-4 max-w-xl w-full">
     <p className="font-['VT323'] text-[#e0e0e0] text-lg mb-3">
       "{belief.quote_text || belief.atomic_belief}"
     </p>
     <div className="flex justify-between items-center">
       <span className="font-['Press_Start_2P'] text-[#F7931A] text-xs">
         — {belief.speaker_name}
       </span>
       <span className="font-['VT323'] text-[#666] text-sm">
         📎 {belief.episode_title || belief.source}
       </span>
     </div>
   </div>
   ```

2. **Results list** — map over API response, render cards below search:
   ```jsx
   {results.map((belief, i) => (
     <BeliefCard key={i} belief={belief} />
   ))}
   ```

3. **Empty state** — if no results: "No beliefs found. Try a different search."

4. **Adapt to API response** — check what `/api/query` actually returns and map fields accordingly. The response likely has `transcript_chunks` with fields like `content`, `metadata.speaker`, `metadata.episode_title`.

### Acceptance
- [ ] Search results display as orange-bordered cards
- [ ] Each card shows quote, speaker name, source
- [ ] Cards are responsive (look good on mobile ~390px)
- [ ] Empty state message when no results

---

## Task 4: Polish + Mobile (15 min)

### What
Final pass to make it phone-ready and impressive.

### How
1. **Mobile responsive** — test at 390px width, ensure:
   - Search bar doesn't overflow
   - Cards stack vertically with proper padding
   - Font sizes readable on mobile
   - No horizontal scroll

2. **Add subtle flair:**
   - Scanline CSS overlay (optional, 2 lines of CSS):
     ```css
     body::after {
       content: '';
       position: fixed;
       inset: 0;
       background: repeating-linear-gradient(
         0deg, transparent, transparent 2px, rgba(0,0,0,0.03) 2px, rgba(0,0,0,0.03) 4px
       );
       pointer-events: none;
       z-index: 9999;
     }
     ```
   - Orange glow on search bar focus
   - Slight text-shadow on the title

3. **Remove unused UI** — hide any old nav links, sidebars, or components that don't fit the new look

### Acceptance
- [ ] Looks great on mobile (390px)
- [ ] No visual artifacts or broken layouts
- [ ] Old/unused UI elements removed
- [ ] Ready to show friends

---

## API Reference (already working)

```
POST /api/query
Body: { "query": "string" }
Returns: search results with transcript chunks

GET /api/graph
Returns: speaker graph data

POST /api/threads
Body: { "message": "string" }
Returns: chat thread response
```

## Design Tokens (from v2 extraction)

```css
--background: #0a0a0a
--foreground: #e0e0e0  
--primary: #F7931A (Bitcoin orange)
--secondary: #1a1a2e (dark panels)
--border: #F7931A33 (orange translucent)
--accent: #ff9f2f (hover orange)
```

## What NOT to Build (out of scope for this sprint)

❌ Login/auth
❌ Animations/lightning effects
❌ Tier system
❌ Speaker cards
❌ Knowledge graph
❌ Comments
❌ Community cards
❌ Anything not in the 4 tasks above

**Focus. Ship. Show friends. Iterate tomorrow.**
