# PRD: Bitcoinology v2 — "The Matrix, But Orange"

**Author:** Max Power ⚡  
**Date:** 2026-02-11  
**Status:** Draft — awaiting Ryan's user story walkthrough

---

## Vision

A gamified, single-pane knowledge exploration tool that extracts what people **believe** from podcast conversations and makes those beliefs searchable, visual, and shareable. 

Not a website. An **app** — alive, animated, community-driven.

"The Matrix, but orange."

---

## Core Principles

1. **Single-pane-of-glass** — everything in one view, no route changes
2. **Every search builds the knowledge graph** — users aren't just querying, they're contributing
3. **Visible AI** — show the agentic workflow, don't hide it behind a spinner
4. **Mobile-first** — 390px base, scales up
5. **Obsidian meets social** — personal knowledge base with community layer

---

## User Stories

*To be filled in with Ryan's walkthrough*

### US-1: First Visit
**As a** new user  
**I want to** understand what Bitcoinology does in 5 seconds  
**So that** I know whether to sign up  

**Acceptance Criteria:**
- [ ] TBD — pending Ryan's walkthrough

---

### US-2: Search
**As a** logged-in user  
**I want to** search what people believe about a Bitcoin topic  
**So that** I can explore different perspectives  

**Acceptance Criteria:**
- [ ] TBD

---

### US-3: Explore Results
**As a** user who just searched  
**I want to** see beliefs organized by speaker, sentiment, and abstraction level  
**So that** I can understand the landscape of opinions  

**Acceptance Criteria:**
- [ ] TBD

---

### US-4: Knowledge Graph
**As a** user  
**I want to** see how beliefs connect in a visual graph  
**So that** I can discover relationships I didn't expect  

**Acceptance Criteria:**
- [ ] TBD

---

### US-5: Share
**As a** user who found something interesting  
**I want to** share my search as a public artifact  
**So that** other Bitcoiners can explore and build on it  

**Acceptance Criteria:**
- [ ] TBD

---

### US-6: Provide Feedback
**As a** user  
**I want to** rate search results (thumbs up/down + optional note)  
**So that** the system improves over time  

**Acceptance Criteria:**
- [ ] TBD

---

## Screens

*Mockups to be generated with Nano Banana Pro based on user stories*

### Screen 1: Landing / Login
📸 *mockup pending*

### Screen 2: Home (Logged In)
📸 *mockup pending*

### Screen 3: Search Active (Workflow Tree)
📸 *mockup pending*

### Screen 4: Results View
📸 *mockup pending*

### Screen 5: Expanded Panel (Ontology Graph)
📸 *mockup pending*

### Screen 6: Expanded Panel (Analytics)
📸 *mockup pending*

### Screen 7: Expanded Panel (Docs/Quotes/Data)
📸 *mockup pending*

---

## Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Frontend | Next.js 14, Tailwind, shadcn/ui | Single-pane app shell |
| State | Zustand | Panel switching, no URL routing |
| Animation | Framer Motion | Panel transitions, workflow tree |
| Graph | react-force-graph-2d | 2D ontology visualization |
| Auth | Supabase Auth | Google OAuth + magic link |
| DB | Supabase (Postgres) | Threads, users, beliefs |
| Vector Search | Qdrant Cloud | 1536-dim embeddings |
| LLM | Claude (Anthropic) | Query routing, synthesis |
| Embeddings | OpenAI | text-embedding-ada-002 |
| Orchestration | Motia | Agentic workflow pipeline |
| Hosting | Vercel (frontend) | Considering Fly.io for pipeline |
| Dataset | HuggingFace | rchiera/bitcoinology |
| Design | Nano Banana Pro | AI mockup generation |

---

## Data Model

### Beliefs (from HuggingFace dataset)
- 8-layer abstraction: raw quote → surface → atomic belief → worldview → core axiom → polar analysis → tabloid headline → positioning vector
- 10-dimensional weights vector (domain affinity + positioning)
- 1536-dim semantic embeddings

### Threads
- User search sessions persisted in Supabase
- Each search creates/updates a thread

### Feedback (new)
- thumbs up/down per search result
- optional text note
- timestamp + user_id

---

## Open Questions for Ryan

1. What's the onboarding flow? Just Google OAuth, or do we want a tour/walkthrough?
2. How prominent should the workflow tree be? Full screen during search, or a sidebar?
3. Do we want audio playback? (We have timestamps back to the original podcast)
4. What's the monetization timeline for 10 sats/search?
5. How do community contributions work? Can users submit new podcast episodes?

---

*This doc will be updated as Ryan walks through user stories.*
