# MEMORY.md - Long-Term Memory

## QA Notes
- **DO NOT search "Lex Fridman"** — dummy/test podcast data from before Max joined. Use real speakers for QA.

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

## Security Rules
- I should NOT have delete access to production data
- Pipeline data = append-only (expensive to recreate)
- Need: PITR on Supabase, branch protection, no-delete service roles

## Plane IDs (Full UUIDs)
- **States**: Backlog=`9575bfdc-fc87-40f0-aad9-cdc943a76b0a`, Todo=`17d39bd2-44ac-4614-b755-b332e9d2c298`, In Progress=`d509c9fb-7bf5-4694-804f-c0743849008e`, Done=`ab7a1ef0-f962-4bee-9996-c2e42a93755c`, Cancelled=`39b1061e-3f09-4d1e-984c-b9f7a08ab6f8`
- **Labels**: P0=`c5feb5aa-bdcf-4538-bfa4-8d7ce2f0d8e5`, P1=`39b5598a-7665-4201-ad91-ca17d10f8713`, P2=`22ec74f1-6cdb-4805-9ea9-759ef6f7d061`, P3=`2daedc12-afdb-4a99-b8fb-674e074c8b59`
- **Modules**: Search=`87dd25f9-e5c1-4d3b-a5b6-aeb2e73e2cae`, Speakers=`c1db14be-4487-4a72-8bc2-2e44b46eeb50`, Cards=`b0feb48c-2cf5-49c3-b5ce-be14effc0ed1`, Retro UI=`13ab0a04-b8fc-4e85-b1aa-e2e094ac4f3d`, Pipeline=`c2446d50`, Infra=`ffdbf61b`
- **Cycles**: Cycle 1 (P0-P1, Feb 14-28)=`361a0c25-cc03-4859-88a2-ba5cb7f69abc`, Cycle 2 (P2-P3, Mar 1-14)=`f8e77a4a-e22d-4786-be7f-0c68fad7c4f3`
- **Members**: maxpower=`c389f82d-b06b-49af-baa7-0327977de020`, ryan=`12b67814`

## Workflow Rules
- **All reports → GitHub (be-MaxPower) + Plane pages** — Ryan's rule: no local-only docs
- PDF generation: render markdown → HTML → browser PDF action (weasyprint broken on Mac mini)

## Recent PR History (Feb 14)
- PRs #30-34, #36 all merged to main
- PR #37 approved (15 Plane items — hamburger, search history, zoom, SpeakerPanel)
- PR #35 still open (threads + UI enhancements, may overlap with #37)
- Dev team completed 60/60 todos — Cycle 1 effectively done

## Plane Issues (Recent)
- BELIE-62 (P0, `07a29211`) — Search input missing on mobile → fixed by PR #36
- BELIE-63 (P1, `d26fec5c`) — FeatureSquares on all panels → fixed by PR #36
- BELIE-64 (P1, `ea7eec99`) — Footer search hidden on mobile → fixed by PR #36

## Open Items
- [ ] Install/configure gh CLI
- [ ] Rotate classic PAT to fine-grained token (needs org approval)
- [ ] Security audit items (see docs/SECURITY_AUDIT.md)
- [ ] Dataset hydration pipeline design (HF → Qdrant + Supabase sync)
- [ ] Feedback mechanism (thumbs up/down after searches)
- [ ] Set up engineering OpenClaw on Railway
- [ ] Explore Claude Teams for parallel work
- [ ] CI failing on main (commit 232a933) — needs investigation
- [ ] Move credentials to macOS Keychain (GitGuardian flagged be-MaxPower)
