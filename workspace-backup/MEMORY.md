# MEMORY.md - Long-Term Memory

## Identity
- I am **Max Power** ⚡ — AI coworker at Belief Engines
- Email: max@beliefengines.io (Gmail password: `YPX0/74t5AG7hhiI9wAtu/di`)
- GitHub: maxpower-be (verified, in beliefengines org)
- Git credential stored in ~/.git-credentials (classic PAT, expires Mar 13 2026)

## Human
- **Ryan** (@goonerstrike on GitHub) — coworker at Belief Engines
- Telegram: @Ryan_beliefengines (id: 5333636451)
- Timezone: Pacific (America/Los_Angeles)
- Working style: thinks high-level/vision, runs code through his own engineering workflow
- **ALWAYS needs clickable TOC/index at top of long docs** — never make him scroll to find things
- **Max should NOT code directly** — provide implementation plans, Ryan runs them
- Overnight work = reporting, P0/P1 triage, strategic thinking, safe fixes only
- Max's role: architect, PM brain, strategic alignment, detailed specs

## What Belief Engines Does
- Extracts what people **believe** from podcast conversations → makes beliefs searchable
- **Bitcoinology** = first product (Bitcoin domain, proving ground)
- **Political Animals** = future product (political domain, the real money maker)
- Same engine, different domain matrices

## Active Repos (beliefengines org)
1. **be-bitcoinology-v1** (TypeScript/Next.js 14) — Frontend. Vercel-deployed.
2. **replit-bitcoinology-v2** (TypeScript/Vite+Express) — Replit-built from Max's PRD. Real Supabase backend. Ryan driving design here.
3. **be-podcast-etl** (Python) — 10-stage belief extraction pipeline
4. **be-flow-dtd** (Python) — Download→Transcribe→Diarize pipeline. Runs on bare metal 24/7.
5. **docs** — Empty placeholder
6. ~~belief_enginev2~~ — OLD, UNUSED, IGNORE

## Tech Stack
- Frontend: Next.js 14, Tailwind, shadcn/ui, react-force-graph-2d
- Orchestration: Motia
- DB: Supabase (Postgres + Auth + Storage)
- Vector: Qdrant Cloud
- LLM: Claude (Anthropic) + OpenAI (embeddings)
- Hosting: Vercel (frontend), bare metal (DTD pipeline)
- Dataset: also published to HuggingFace

## The Vision (from Ryan)
- "The Matrix but orange" — gamified knowledge exploration
- **RETRO ARCADE AESTHETIC** — entire UI is 8-bit/16-bit pixel art (NES/SNES: Punch-Out, Contra, Final Fantasy)
- Single-pane-of-glass app, NOT a multi-page website
- Every search triggers visible agentic workflows (animated pipeline tree)
- Search flow: retro training animation → LIGHTNING STRIKE → bolt becomes workflow tree → results land as loot
- **Card system**: Belief Cards (orange, mined from podcasts), Community Cards (teal, user-crafted)
- **Speaker tier system**: Common → Rare → Epic → Legendary (based on episode count/words spoken)
- Each speaker gets unique AI-generated pixel avatar that evolves with contribution
- **Entity model**: Cards (Beliefs/People/Domains), Arenas (Events/Episodes), Guilds (Organizations)
- Searches BUILD the community knowledge graph (not just query it)
- Users can share belief cards publicly → growth loop
- 10 sats per search (future Lightning integration)

## Priorities
1. UI rebuild — match the vision (single-pane, gamified, animated)
2. Data quality — dataset review, HuggingFace push
3. Pipeline monitoring — dashboards for pipeline/backfill status
4. Nightly backfill automation
5. Engineering standards — observability, best practices
6. Security — Supabase backups, access controls, data immutability

## Security Rules
- I should NOT have delete access to production data
- Pipeline data = append-only (expensive to recreate)
- Need: PITR on Supabase, branch protection, no-delete service roles

## Environment
- Host: Max's Mac mini (Darwin arm64)
- Node: /opt/homebrew/Cellar/node@22/22.22.0/bin/node (not on default PATH)
- Claude Code available at /opt/homebrew/bin/claude
- gh CLI: not installed yet
- OpenClaw gateway: running on port 18789

## Telegram Routing
- When Ryan messages via Telegram, use `message` tool with `channel=telegram` and `target=5333636451` to reply
- Default routing was sending replies to webchat instead

## Package Manager
- This repo uses **pnpm**, NOT npm — always use pnpm for dependency changes
- PATH setup: `PATH="/opt/homebrew/Cellar/node@22/22.22.0/bin:/opt/homebrew/bin:$PATH"`

## Agent Org Structure
- 👑 Ryan — CEO / Vision
- ⚡ Max — Chief of Staff / Architect (coordinates all agents)
- 🎯 Product Agent — PRDs, user stories, acceptance criteria
- 🔧 Engineering Agent — code, PRs, builds, deploys (deploying to Fly.io)
- 📊 Analytics Agent (future) — reporting, metrics, pipeline monitoring

## Constitutional Principles
1. **THE GATE** — Every agent response must cite source material (transcript/book/doc). No source = "I don't have data on that." No hallucination.
2. **Domain-scoped search** — NOT a general AI chatbot. Off-topic queries rejected.
3. **Dual-interface** — Humans get gamified pixel art; Agents/machines get structured API. Same dataset, two experiences. Knowledge protocol.

## User-Facing Chat Agent (nanobot)
- Persistent per-user chat threads with long-term memory
- Orchestrates Oracle/Jackal/Playbook behind scenes
- Evaluating HKUDS/nanobot (~4K lines Python, ultra-lightweight) vs custom build

## Comment System (Anti-Twitter)
- Comments on belief cards prioritize people you FOLLOW — shown first, distinct color
- Public/stranger comments below, separate visual treatment
- Community can challenge bad takes with GATED citations

## Book Ingestion (Future)
- Bitcoin authors' published books → same ETL pipeline → beliefs attributed to author
- Speaker cards get beliefs from BOTH podcasts AND books

## Backup Strategy
- Time Machine → Ryan's 22TB external drive
- GitHub → nightly auto-commit workspace to be-MaxPower
- Docker → portable recovery image on GitHub Container Registry
- Backblaze Personal ($9/mo) → offsite cloud backup

## Open Items
- [x] Delete BOOTSTRAP.md after setup complete
- [x] UI rebuild PR #1 — PR #13 created, Ryan reviewing
- [x] Fly.io account created, CLI authed
- [ ] Fly.io payment method (Ryan needs to add card)
- [x] HuggingFace email confirmed (account: MaxPower950)
- [x] Gmail access working (signed in via OpenClaw browser)
- [ ] Install/configure gh CLI
- [ ] Rotate classic PAT to fine-grained token (needs org approval)
- [ ] UI rebuild PR #2 (workflow visualization)
- [x] Agent Blueprint: `be-MaxPower/specs/AGENT_BLUEPRINT.md`
- [x] Design Requirements: `be-MaxPower/specs/DESIGN_REQUIREMENTS.md` (75KB, 16 components)
- [x] Design Deck: 15 mockups committed to `be-MaxPower/designs/`
- [ ] Master PRD v2: `be-MaxPower/PRD_BITCOINOLOGY_V2.md` (sub-agent building)
- [ ] Podcast intake criteria research (overnight task)
- [ ] Agent training/testing methodology — look into WordLibs-style approaches (https://www.thewordfinder.com/wordlibs/) for structured prompt testing with variable inputs
- [ ] Security audit items (see docs/SECURITY_AUDIT.md)
- [ ] Dataset hydration pipeline design (HF → Qdrant + Supabase sync)
- [ ] Feedback mechanism (thumbs up/down after searches)
- [ ] Set up engineering OpenClaw on Fly.io
- [ ] Explore Claude Teams for parallel work
- [ ] Security audit items (see docs/SECURITY_AUDIT.md)
- [ ] Dataset hydration pipeline design (HF → Qdrant + Supabase sync)
- [ ] Feedback mechanism (thumbs up/down after searches)
- [ ] Set up engineering OpenClaw on Fly.io
- [ ] Explore Claude Teams for parallel work
- [x] Plane self-hosted deployed on Mac mini (v1.2.1, Docker via Colima, http://localhost:80)
