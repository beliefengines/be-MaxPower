# Chat Agent Architecture: Persistent User Companion

> **Every user gets a personal Bitcoin knowledge companion that remembers them.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. nanobot vs Custom: Evaluation](#2-nanobot-vs-custom)
- [3. Architecture](#3-architecture)
- [4. Memory Model](#4-memory-model)
- [5. Agent Orchestration](#5-agent-orchestration)
- [6. Session Lifecycle](#6-session-lifecycle)
- [7. The Gate Integration](#7-gate-integration)
- [8. Tiered Model Progression](#8-tiered-model-progression)
- [9. Tiered Agentic Workflows](#9-tiered-agentic-workflows)
- [10. Cost Model (Sats)](#10-cost-model)
- [11. Technical Stack](#11-technical-stack)
- [12. Implementation Phases](#12-implementation-phases)
- [13. Acceptance Criteria](#13-acceptance-criteria)

---

## 1. Overview

The user-facing chat agent is the primary interface between users and the Bitcoinology knowledge graph. Unlike stateless search, this agent:

- **Remembers** the user across sessions (topics explored, cards saved, preferences)
- **Orchestrates** Oracle, Jackal, and Playbook agents behind the scenes
- **Enforces** The Gate on every response
- **Progresses** users through model tiers as they invest deeper
- **Costs** sats per interaction via Lightning Network micropayments

The user talks to ONE agent. That agent manages everything.

---

## 2. nanobot vs Custom: Evaluation

### 2.1 nanobot (HKUDS/nanobot)

| Attribute | Details |
|---|---|
| **Size** | ~4,000 lines Python |
| **Maturity** | v0.1.3, launched Feb 2, 2026 (10 days old) |
| **Memory** | Built-in long-term memory system (just redesigned Feb 12) |
| **Multi-provider** | OpenRouter, OpenAI, Anthropic, DeepSeek, vLLM, Gemini |
| **Channels** | Telegram, Discord, WhatsApp, Slack, Email, QQ, Feishu |
| **Scheduling** | Natural language task scheduling |
| **License** | MIT |
| **Architecture** | Single-agent with tool use |

**Pros:**
- Ultra-lightweight, easy to understand and modify
- Built-in memory persistence
- Multi-channel out of the box
- MIT license — no restrictions
- Active development, responsive maintainers

**Cons:**
- 10 days old — immature, expect breaking changes
- No orchestration layer (can't manage sub-agents natively)
- Memory system just redesigned — stability unknown
- No built-in verification/citation system
- Would need significant customization for Gate enforcement

### 2.2 Custom Build

**Pros:**
- Purpose-built for Bitcoinology's exact needs
- Gate enforcement baked in from day one
- Orchestration layer designed for Oracle/Jackal/Playbook
- Full control over memory model
- Optimized for our specific dataset

**Cons:**
- More development time
- Need to build channel integrations
- More code to maintain

### 2.3 Recommendation: Hybrid Approach 🎯

**Use nanobot as the foundation, customize for Bitcoinology.**

1. Fork nanobot (MIT license allows this)
2. Add Gate enforcement as a middleware layer
3. Add agent orchestration (Oracle/Jackal/Playbook as tools)
4. Customize memory model for user profiles + saved cards
5. Keep the multi-channel support (Telegram, Discord, web)

**Why:** 4K lines of battle-tested basics (memory, providers, channels) saves months of infrastructure work. We add our unique value (Gate, orchestration, tiers) on top.

---

## 3. Architecture

### 3.1 System Diagram

```
┌─────────────────────────────────────────────────────┐
│                   USER INTERFACE                      │
│  (Web App / Telegram / Discord / API)                │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│              CHAT AGENT (nanobot fork)                │
│                                                       │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐ │
│  │   Memory     │  │   Session   │  │    Tier      │ │
│  │   Manager    │  │   Manager   │  │   Manager    │ │
│  └─────────────┘  └─────────────┘  └──────────────┘ │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │              GATE MIDDLEWARE                      │ │
│  │  Domain Check → Source Search → Verify → Cite    │ │
│  └─────────────────────────────────────────────────┘ │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │           AGENT ORCHESTRATOR                     │ │
│  │                                                   │ │
│  │  ┌──────────┐ ┌──────────┐ ┌────────────────┐  │ │
│  │  │ Oracle   │ │ Jackal   │ │   Playbook     │  │ │
│  │  │ (Search) │ │ (Research)│ │ (Exploration)  │  │ │
│  │  └──────────┘ └──────────┘ └────────────────┘  │ │
│  └─────────────────────────────────────────────────┘ │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│                   DATA LAYER                          │
│  Qdrant (vectors) + Supabase (DB) + Redis (cache)    │
└─────────────────────────────────────────────────────┘
```

### 3.2 Request Flow

1. User sends message
2. Session Manager loads user context + memory
3. Tier Manager checks user's current tier + sats balance
4. Chat Agent interprets intent → selects workflow
5. Agent Orchestrator dispatches to Oracle/Jackal/Playbook
6. Gate Middleware verifies all sources before response
7. Response rendered in user's tier format
8. Memory updated with interaction
9. Sats deducted via Lightning

---

## 4. Memory Model

### 4.1 Per-User Memory

```json
{
  "user_id": "usr_abc123",
  "profile": {
    "created_at": "2026-02-15T00:00:00Z",
    "tier": "sonnet",
    "total_sats_spent": 4200,
    "total_searches": 127,
    "saved_cards": ["bel_7acb", "bel_92ff", "spk_saylor"],
    "followed_users": ["usr_def456"]
  },
  "preferences": {
    "favorite_speakers": ["Michael Saylor", "Lyn Alden"],
    "favorite_domains": ["Economy & Money", "Self & Identity"],
    "display_mode": "detailed"
  },
  "conversation_memory": {
    "topics_explored": [
      {"topic": "corporate treasury strategy", "last_discussed": "2026-02-14", "depth": 3},
      {"topic": "Lightning Network scaling", "last_discussed": "2026-02-13", "depth": 1}
    ],
    "key_insights": [
      "User is interested in corporate Bitcoin adoption",
      "User disagrees with Saylor on ETF approach"
    ],
    "last_session_summary": "Explored Lyn Alden's views on monetary policy..."
  },
  "knowledge_graph": {
    "cards_mined": 42,
    "cards_crafted": 3,
    "connections_discovered": 18,
    "communities_joined": ["monetary-policy", "self-custody"]
  }
}
```

### 4.2 Memory Tiers

| Data Type | Storage | Retention |
|---|---|---|
| **Session context** | Redis | During session (TTL: 24h) |
| **User profile** | Supabase | Permanent |
| **Conversation memory** | Supabase | Last 90 days (summarized) |
| **Saved cards** | Supabase | Permanent |
| **Search history** | Supabase | Last 30 days |

### 4.3 Memory Operations

- **Remember**: After each session, summarize key points → store
- **Recall**: On session start, load user profile + recent memory
- **Forget**: User can request data deletion (GDPR compliance)
- **Evolve**: Periodically consolidate memory (daily summaries → weekly → monthly)

---

## 5. Agent Orchestration

### 5.1 Oracle (Quick Search)

- **Trigger:** Simple factual queries ("What did X say about Y?")
- **Model:** Haiku-tier (fast, cheap)
- **Flow:** Query → Vector search → Top-K results → Gate verify → Respond
- **Cost:** 10 sats

### 5.2 Jackal (Deep Research)

- **Trigger:** Complex/comparative queries ("How do views on X differ between speakers?")
- **Model:** Sonnet-tier (deeper reasoning)
- **Flow:** Query → Multi-vector search → Cross-reference → Synthesize → Gate verify → Respond
- **Cost:** 50 sats

### 5.3 Playbook (Guided Exploration)

- **Trigger:** Exploratory queries ("Tell me about monetary policy beliefs")
- **Model:** Sonnet-tier with structured output
- **Flow:** Query → Domain mapping → Curated path → Interactive cards → Gate verify → Respond
- **Cost:** 30 sats

### 5.4 Thesis Builder (Community Card Creation)

- **Trigger:** User initiates card creation ("I want to submit a belief")
- **Model:** Haiku → Sonnet → Opus (tiered progression)
- **Flow:** Gather → Structure → Verify → Submit
- **Cost:** 500 sats (includes Opus verification)

### 5.5 Auto-Routing

The chat agent analyzes user intent and routes to the right sub-agent:

```python
def route_query(query, user_context):
    intent = classify_intent(query)
    
    if intent == "factual_lookup":
        return Oracle(query)
    elif intent == "comparison" or intent == "analysis":
        return Jackal(query)
    elif intent == "exploration" or intent == "browse":
        return Playbook(query)
    elif intent == "create_card":
        return ThesisBuilder(query)
    else:
        return Oracle(query)  # Default to cheapest
```

---

## 6. Session Lifecycle

```
┌──────────────────────────────────────────────┐
│ 1. USER ARRIVES                               │
│    Load profile + memory + tier + sats balance│
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│ 2. GREETING (if returning)                    │
│    "Welcome back! Last time we explored..."   │
│    "You have 3 saved cards since last visit"  │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│ 3. CONVERSATION LOOP                          │
│    User query → Route → Execute → Gate → Show │
│    Update memory each turn                    │
└──────────────────┬───────────────────────────┘
                   ▼
┌──────────────────────────────────────────────┐
│ 4. SESSION END                                │
│    Summarize session → Store memory           │
│    Update user profile + stats                │
│    Deduct total sats spent                    │
└──────────────────────────────────────────────┘
```

---

## 7. Gate Integration

The Gate wraps EVERY agent response:

```python
async def respond(query, user):
    # 1. Domain check
    if not is_bitcoin_domain(query):
        return DOMAIN_REJECTION_TEMPLATE
    
    # 2. Route to sub-agent
    agent = route_query(query, user)
    raw_response = await agent.execute(query)
    
    # 3. Gate verification
    verified_response = await gate.verify(raw_response)
    
    # 4. Strip unverified claims
    if verified_response.has_unverified_claims:
        verified_response = gate.strip_unverified(verified_response)
    
    # 5. Add citations
    final = gate.attach_citations(verified_response)
    
    return final
```

No response bypasses the Gate. Ever.

---

## 8. Tiered Model Progression

### 8.1 Tier Structure

| Tier | Model Class | Unlock Condition | Capabilities | Cost/Search |
|---|---|---|---|---|
| ⚡ **Explorer** | Haiku | Default (new users) | Basic search, card viewing | 10 sats |
| ⚡⚡ **Researcher** | Sonnet | 100+ searches OR 1,000 sats spent | Deep research, comparisons, knowledge graph building | 50 sats |
| ⚡⚡⚡ **Scholar** | Opus | 500+ searches OR 5,000 sats spent | Thesis creation, Opus verification, community card minting | 500 sats |

### 8.2 Progression Mechanics

- Users START at Explorer tier
- Actions at each tier generate data that feeds their progression
- Upgrading unlocks NEW capabilities, not just "smarter" answers
- Users can always use lower tiers for cheap queries
- Tier status shown on their profile card

### 8.3 What Each Tier Unlocks

**⚡ Explorer (Haiku)**
- Basic belief search
- View belief cards + speaker cards
- Save cards to collection
- See public community cards

**⚡⚡ Researcher (Sonnet)**
- Everything in Explorer +
- Comparative analysis across speakers
- Knowledge graph visualization
- Domain deep-dives
- Challenge community cards (⚔️)
- Follow other users

**⚡⚡⚡ Scholar (Opus)**
- Everything in Researcher +
- Create Community Belief Cards
- Opus verification of thesis
- Access to full citation chain
- Vote on community challenges
- Publish shareable belief cards

---

## 9. Tiered Agentic Workflows

Each tier doesn't just use a different model — it has fundamentally different WORKFLOWS.

### 9.1 Explorer Workflow (Haiku)

```
Query → Single Vector Search → Top 5 Results → Format Cards → Respond
```

- **Tools:** Qdrant search only
- **Context window:** Minimal (saves tokens)
- **Animation:** Quick lightning zap ⚡
- **Response time:** < 3 seconds

### 9.2 Researcher Workflow (Sonnet)

```
Query → Intent Analysis → Multi-Vector Search → Cross-Reference 
    → Build Connections → Knowledge Graph Update → Format Report → Respond
```

- **Tools:** Qdrant search, Supabase joins, graph traversal
- **Context window:** Medium (includes user history)
- **Animation:** Lightning bolt splits into branches 🌳
- **Response time:** 5-15 seconds
- **Unique features:**
  - Side-by-side speaker comparison
  - "This connects to your earlier search about..."
  - Belief evolution timeline
  - Domain correlation maps

### 9.3 Scholar Workflow (Opus)

```
Thesis Input → Source Gathering (auto) → Claim Extraction 
    → Per-Claim Source Verification → Cross-Speaker Validation 
    → Contradiction Check → Confidence Scoring → Gate Review 
    → Community Card Minting → Respond
```

- **Tools:** Full pipeline — Qdrant, Supabase, transcript search, LLM verification
- **Context window:** Large (full thesis context)
- **Animation:** Full Punch-Out training montage → Lightning strike → Card mint 🏆
- **Response time:** 30-120 seconds (complex verification)
- **Unique features:**
  - Automated source finding for user's claims
  - Every sentence verified against transcripts
  - Contradiction detection with counter-evidence
  - Community Card generation with full citation chain
  - Shareable embed card creation

---

## 10. Cost Model (Sats)

### 10.1 Pricing (Lightning Network)

| Action | Cost | Model |
|---|---|---|
| Basic search (Explorer) | 10 sats | Haiku |
| Deep search (Researcher) | 50 sats | Sonnet |
| Comparison analysis | 75 sats | Sonnet |
| Knowledge graph query | 30 sats | Sonnet |
| Thesis submission | 500 sats | Haiku → Sonnet → Opus |
| Card challenge (⚔️) | 25 sats | Sonnet |
| Card save | Free | — |
| Profile view | Free | — |

### 10.2 Lightning Integration

- **L402 Protocol** (formerly LSAT) for API authentication
- Pay-per-request, no subscriptions
- Users hold a Lightning wallet (or we provide custodial)
- Micropayments settle instantly
- No minimum balance — pay as you go

### 10.3 Revenue Estimates

| Scenario | Monthly Users | Avg Searches/User | Revenue (sats) | Revenue (USD @ $100K BTC) |
|---|---|---|---|---|
| Early | 100 | 20 | 40,000 | $40 |
| Growth | 1,000 | 50 | 1,500,000 | $1,500 |
| Scale | 10,000 | 100 | 30,000,000 | $30,000 |

---

## 11. Technical Stack

| Component | Technology | Notes |
|---|---|---|
| Chat Agent | nanobot fork (Python) | Modified with Gate + orchestration |
| LLM Providers | Anthropic (Haiku/Sonnet/Opus) | Primary; OpenAI as fallback |
| Vector Search | Qdrant Cloud | Belief embeddings (1536-dim) |
| Database | Supabase (Postgres) | User profiles, memory, cards |
| Cache | Redis | Session state, recent queries |
| Payments | Lightning Network (L402) | Micropayments |
| Channels | Web (primary), Telegram, Discord | Via nanobot channel plugins |
| Hosting | fly.io or bare metal | Python/FastAPI backend |
| WebSocket | Native | Real-time streaming responses |

---

## 12. Implementation Phases

### Phase 1: MVP Chat (Weeks 1-3)
- [ ] Fork nanobot, strip to essentials
- [ ] Implement basic Oracle search (Qdrant integration)
- [ ] Add Gate middleware (domain check + citation attachment)
- [ ] Web chat interface (single-page, embedded in app)
- [ ] Basic user sessions (no persistence yet)
- [ ] Haiku tier only

### Phase 2: Memory + Tiers (Weeks 4-6)
- [ ] User profiles in Supabase
- [ ] Conversation memory (per-user)
- [ ] Tier system (Explorer → Researcher → Scholar)
- [ ] Sonnet-tier workflows (Jackal integration)
- [ ] Card saving functionality
- [ ] Session greeting with memory recall

### Phase 3: Payments + Community (Weeks 7-10)
- [ ] Lightning Network integration (L402)
- [ ] Sats-based pricing
- [ ] Scholar tier + Opus verification
- [ ] Community Card creation pipeline
- [ ] Comment system (follow-first sorting)
- [ ] Challenge mechanism (⚔️)

### Phase 4: Scale + Polish (Weeks 11+)
- [ ] Telegram/Discord channel support
- [ ] Real-time streaming with animations
- [ ] Knowledge graph visualization
- [ ] API for machine consumers
- [ ] Performance optimization
- [ ] Book source integration

---

## 13. Acceptance Criteria

### Core
- [ ] User can chat and receive cited, Gate-verified responses
- [ ] User returns to existing thread with memory intact
- [ ] Three tiers function with different models and workflows
- [ ] Off-topic queries rejected with domain-scoped suggestions
- [ ] Every response has expandable source citations

### Memory
- [ ] Agent greets returning users with context from last session
- [ ] Saved cards persist across sessions
- [ ] User preferences influence response formatting
- [ ] Memory can be deleted on request

### Tiers
- [ ] Explorer queries use Haiku and cost 10 sats
- [ ] Researcher queries use Sonnet and cost 50 sats
- [ ] Scholar thesis submission goes through full Opus verification
- [ ] Users can always use lower tiers
- [ ] Progression is tracked and visible

### Payments
- [ ] Lightning payments process in < 5 seconds
- [ ] Failed payments show clear error, don't deduct
- [ ] Users can check balance in-chat
- [ ] Receipt/history available

---

*The chat agent IS the product for most users. It's their companion, their guide, their research partner. Make it feel like a knowledgeable friend who happens to have perfect memory and access to 1,400+ hours of Bitcoin podcast wisdom.*
