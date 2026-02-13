# Tiered Agentic Workflows: Haiku → Sonnet → Opus

> **Each tier isn't just a smarter model — it's a fundamentally different experience.**

---

## Table of Contents

- [1. Philosophy](#1-philosophy)
- [2. Tier Overview](#2-tier-overview)
- [3. Explorer Tier (Haiku)](#3-explorer-tier)
- [4. Researcher Tier (Sonnet)](#4-researcher-tier)
- [5. Scholar Tier (Opus)](#5-scholar-tier)
- [6. Visual Animations Per Tier](#6-visual-animations)
- [7. Workflow Routing Logic](#7-workflow-routing)
- [8. Cost Breakdown Per Workflow](#8-cost-breakdown)
- [9. Splash Page Tutorial Design](#9-splash-page)

---

## 1. Philosophy

The tiered model progression isn't a paywall — it's a **game mechanic**. Each tier unlocks new abilities, not just faster answers. The cost (in sats) acts as a quality filter: the more you invest, the higher quality your contributions must be.

This mirrors RPG progression:
- **Explorer** = Level 1-10, basic attacks, learn the world
- **Researcher** = Level 11-30, combo moves, build strategy
- **Scholar** = Level 31+, boss fights, create lasting artifacts

---

## 2. Tier Overview

| | ⚡ Explorer | ⚡⚡ Researcher | ⚡⚡⚡ Scholar |
|---|---|---|---|
| **Model** | Haiku | Sonnet | Opus |
| **Cost** | 10 sats/search | 50 sats/search | 500 sats/thesis |
| **Speed** | < 3 sec | 5-15 sec | 30-120 sec |
| **Tools** | Vector search | Multi-search + graph | Full pipeline + verification |
| **Output** | Belief cards | Analysis reports + graphs | Verified Community Cards |
| **Unlock** | Default | 100 searches / 1K sats | 500 searches / 5K sats |
| **Animation** | Quick zap ⚡ | Lightning tree 🌳 | Full Punch-Out montage 🥊 |

---

## 3. Explorer Tier (Haiku)

### 3.1 Purpose
Get users hooked. Fast, cheap, satisfying. The "first hit" of the Bitcoinology experience.

### 3.2 Capabilities
- Search beliefs by keyword/topic
- View belief cards (face + expanded)
- View speaker cards (basic stats)
- Save cards to personal collection
- Browse public community cards

### 3.3 Workflow

```
User Query
    │
    ▼
┌─────────────────┐
│ Intent Parse     │  Haiku classifies: what are they asking?
│ (Haiku, ~0.5s)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Vector Search    │  Single Qdrant query, top-5 results
│ (~0.3s)          │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Gate: Quick      │  Verify sources exist (cached check)
│ Verify (~0.2s)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Format Cards     │  Render belief cards with citations
│ (~0.3s)          │
└────────┬────────┘
         │
         ▼
   Response (< 3s)
```

### 3.4 Example Interaction

```
User: "What does Michael Saylor think about Bitcoin as savings?"

⚡ [Quick zap animation - 1.5 seconds]

🟠 Belief Card
"Bitcoin is the apex property of the human race — the most 
thermodynamically sound store of energy ever created."
— Michael Saylor

📎 What Bitcoin Did, Ep. 412, 34:12
🟢 Verified

[+ 4 more related beliefs]
[Save Card] [Explore Speaker]
```

### 3.5 Limitations
- No cross-speaker comparison
- No deep analysis or synthesis
- Can't create content
- No knowledge graph visualization
- Single-turn queries only (no follow-up context)

---

## 4. Researcher Tier (Sonnet)

### 4.1 Purpose
For serious users who want to UNDERSTAND, not just search. Build connections, compare perspectives, construct knowledge.

### 4.2 Capabilities
Everything in Explorer PLUS:
- Cross-speaker comparison analysis
- Belief evolution over time (same speaker, different episodes)
- Domain deep-dives with structured output
- Knowledge graph visualization (see connections)
- Multi-turn conversation with context memory
- Challenge community cards (⚔️)
- Follow other users
- Save and annotate findings

### 4.3 Workflow

```
User Query
    │
    ▼
┌─────────────────────┐
│ Intent + Context     │  Sonnet analyzes query + user history
│ Analysis (Sonnet)    │  "They were looking at Saylor last time..."
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Multi-Vector Search  │  Qdrant: semantic + keyword + speaker filter
│ + Supabase Joins     │  Supabase: related beliefs, episodes, metadata
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Cross-Reference      │  Find connections between results
│ Engine               │  Detect agreements/disagreements
│                      │  Map domain overlaps
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Synthesis            │  Sonnet synthesizes findings into
│ (Sonnet)             │  structured analysis with narrative
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Gate: Full Verify    │  Every claim → source verification
│                      │  Every quote → transcript check
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│ Render Report        │  Analysis + cards + graph + citations
│ + Graph Update       │  Update user's knowledge graph
└────────┬────────────┘
         │
         ▼
   Response (5-15s)
```

### 4.4 Example Interaction

```
User: "How do different speakers view Bitcoin's environmental impact?"

⚡⚡ [Lightning bolt splits into 4 branches - 8 seconds]

📊 Comparative Analysis: Bitcoin & Environment

Three distinct perspectives found across 7 speakers:

🟠 Pro-Environment Argument (3 speakers)
├─ Nic Carter: "Bitcoin mining incentivizes renewable energy..."
│  📎 What Bitcoin Did Ep. 290, 22:15 🟢
├─ Hass McCook: "Bitcoin mining is the cleanest industry..."  
│  📎 Bitcoin Audible Ep. 144, 8:30 🟢
└─ Troy Cross: [detailed view]

🟡 Nuanced Middle (2 speakers)
├─ Lyn Alden: "Energy use is a feature, not a bug, but..."
│  📎 Bitcoin Fundamentals Ep. 89, 45:00 🟢
└─ Alex Gladstein: [detailed view]

🔴 Critical View (1 speaker)
└─ [Speaker]: "We need to acknowledge the footprint..."
   📎 [Source] 🟢

🕸️ [View Knowledge Graph] — see how these beliefs connect
📈 This topic appears in 23 episodes across 4 podcasts

💡 "This connects to your search about monetary policy — 
    Lyn Alden discusses both topics in the same episode."

[Deep Dive: Nic Carter] [Compare All] [Save Analysis]
```

### 4.5 Unique Researcher Features

**Belief Evolution Timeline**
```
Michael Saylor on corporate treasury:

2020-08 │ "We're considering Bitcoin..."
2020-12 │ "We've purchased $1.1B..."
2021-06 │ "Bitcoin is the apex property..."
2023-01 │ "Every company should hold Bitcoin..."
         ▼
📈 Conviction increased from 0.6 → 0.95 over 3 years
```

**Domain Correlation**
```
Your exploration pattern:

[Economy & Money] ●●●●●○○ 71%
[Politics & Power] ●●●○○○○ 43%
[Self & Identity]  ●●○○○○○ 29%

💡 Speakers who discuss Economy & Money often also discuss
   Politics & Power. Want to explore that connection?
```

---

## 5. Scholar Tier (Opus)

### 5.1 Purpose
Create lasting artifacts. The Scholar doesn't just consume knowledge — they CONTRIBUTE to the dataset through verified Community Cards.

### 5.2 Capabilities
Everything in Researcher PLUS:
- Create Community Belief Cards (teal border)
- Full Opus verification of thesis/claims
- Access complete citation chains
- Vote on community challenges
- Publish shareable belief embeds
- Access raw API for machine queries

### 5.3 Thesis Submission Workflow

This is the crown jewel — a multi-stage pipeline:

```
STAGE 1: GATHER (Haiku — 10 sats)
┌─────────────────────────────────────┐
│ User describes their thesis          │
│ Haiku helps gather relevant beliefs  │
│ Auto-search for supporting evidence  │
│ Build a research folder              │
└──────────────────┬──────────────────┘
                   │
STAGE 2: STRUCTURE (Sonnet — 50 sats)
┌─────────────────────────────────────┐
│ Organize gathered evidence           │
│ Identify gaps in argumentation       │
│ Suggest additional sources           │
│ Build formal thesis structure        │
│ Map citation chain                   │
└──────────────────┬──────────────────┘
                   │
STAGE 3: VERIFY (Opus — 440 sats)
┌─────────────────────────────────────┐
│ Per-sentence source verification     │
│ Quote accuracy check against         │
│   original transcripts               │
│ Speaker attribution verification     │
│ Contradiction detection              │
│ Counter-argument identification      │
│ Confidence scoring per claim         │
│ Overall thesis strength assessment   │
└──────────────────┬──────────────────┘
                   │
STAGE 4: MINT (Free)
┌─────────────────────────────────────┐
│ Generate Community Belief Card       │
│ Assign card metadata + citations     │
│ Calculate thesis confidence score    │
│ Publish to community feed            │
│ Generate shareable embed             │
└─────────────────────────────────────┘

Total: 500 sats
```

### 5.4 Example Thesis Submission

```
Scholar: "I believe Bitcoin mining will become the primary 
         demand-side energy buyer within 20 years."

STAGE 1 — GATHERING ⚡ (Haiku)
[Punch-Out training montage: jogging, jump rope]

Found 34 relevant beliefs from 12 speakers:
• Nic Carter (8 beliefs on mining + energy)
• Hass McCook (5 beliefs on mining efficiency)  
• Troy Cross (4 beliefs on renewables)
• [+ 9 more speakers]

STAGE 2 — STRUCTURING ⚡⚡ (Sonnet)
[Sparring practice: testing combinations]

Your thesis has 4 supporting claims:
✅ Claim 1: Mining seeks cheapest energy (12 sources)
✅ Claim 2: Cheapest energy = stranded/renewable (8 sources)
⚠️ Claim 3: 20-year timeline (2 sources — weak)
✅ Claim 4: Grid stabilization benefit (6 sources)

Suggestion: Claim 3 needs stronger evidence. 
Want to adjust the timeline or add sources?

STAGE 3 — VERIFICATION ⚡⚡⚡ (Opus)
[Championship fight: full Punch-Out boss battle]

OPUS VERIFICATION REPORT:
┌────────────────────────────────────┐
│ Claim 1: Mining seeks cheap energy │
│ Sources: 12 verified 🟢            │
│ Confidence: 0.94                   │
│ No contradictions found            │
├────────────────────────────────────┤
│ Claim 2: Cheapest = renewable      │
│ Sources: 8 verified 🟢             │
│ Confidence: 0.87                   │
│ 1 partial contradiction (flagged)  │
├────────────────────────────────────┤
│ Claim 3: 20-year timeline          │
│ Sources: 2 verified 🟡             │
│ Confidence: 0.52                   │
│ ⚠️ Below threshold — marked        │
│   as "speculative"                 │
├────────────────────────────────────┤
│ Claim 4: Grid stabilization        │
│ Sources: 6 verified 🟢             │
│ Confidence: 0.91                   │
│ No contradictions found            │
└────────────────────────────────────┘

Overall Thesis Score: 0.81 (STRONG)
Weakest link: Timeline claim (speculative)

STAGE 4 — MINTING 🏆
[Victory celebration: card appears with glow effect]

🃏 COMMUNITY BELIEF CARD MINTED!
┌─────────────────────────────────┐
│ 🔵 Community Card               │
│                                  │
│ "Bitcoin mining will become the  │
│  primary demand-side energy      │
│  buyer within 20 years"          │
│                                  │
│ Author: @username                │
│ Verified: Feb 15, 2026           │
│ Score: 0.81 ████████░░           │
│ Sources: 28 citations            │
│ Status: Published                │
│                                  │
│ [Share] [Challenge ⚔️]           │
└─────────────────────────────────┘
```

---

## 6. Visual Animations Per Tier

### 6.1 Explorer — Quick Zap ⚡
- Duration: 1-2 seconds
- Visual: Single lightning bolt strikes down
- Sound: Quick electric crack
- Belief cards "fall" from the bolt like loot drops

### 6.2 Researcher — Lightning Tree 🌳
- Duration: 3-5 seconds
- Visual: Lightning bolt strikes, then SPLITS into branches
- Each branch = a search vector or speaker being queried
- Branches glow as results come back
- Results aggregate at the bottom into cards/report

### 6.3 Scholar — Punch-Out Montage 🥊
- Duration: 10-30 seconds (matches processing time)
- Stage 1 (Gather): Little Mac jogging, jump rope, collecting items
- Stage 2 (Structure): Sparring with trainer, testing combos
- Stage 3 (Verify): Championship fight, dodging/attacking
- Stage 4 (Mint): Victory pose, belt ceremony, card drops from ceiling

### 6.4 Animation Engine Requirements
- Animations are NOT just loading spinners — they're informative
- Each animation frame maps to actual pipeline progress (SSE events)
- User sees WHAT'S HAPPENING: "Searching 1,438 transcripts..." "Verifying quote from Ep. 412..."
- Pixel art style, consistent with overall NES/SNES aesthetic
- Animations can be skipped but are entertaining enough to watch

---

## 7. Workflow Routing Logic

### 7.1 Auto-Detection

```python
def detect_tier_needed(query: str, user: User) -> Tier:
    """Determine minimum tier needed for this query."""
    
    # Simple lookup = Explorer
    if is_simple_lookup(query):
        return Tier.EXPLORER
    
    # Comparison/analysis = Researcher  
    if has_comparison_intent(query) or has_analysis_intent(query):
        return Tier.RESEARCHER
    
    # Creation/submission = Scholar
    if has_creation_intent(query):
        return Tier.SCHOLAR
    
    # Default to user's current tier
    return user.current_tier

def has_comparison_intent(query: str) -> bool:
    """Check for comparison keywords/patterns."""
    patterns = [
        "compare", "difference between", "vs", "versus",
        "how do .* differ", "disagree", "agree",
        "perspectives on", "views on"
    ]
    return any(re.search(p, query, re.I) for p in patterns)
```

### 7.2 Tier Enforcement

- Users can ALWAYS use lower tiers (cheap queries stay cheap)
- Users CANNOT use higher tiers than unlocked
- System suggests tier upgrade when query needs it:
  *"This comparison needs Researcher tier. Upgrade? (50 sats)"*

---

## 8. Cost Breakdown Per Workflow

### 8.1 Token Economics

| Tier | Avg Input Tokens | Avg Output Tokens | LLM Cost | Our Markup | User Pays (sats) |
|---|---|---|---|---|---|
| Explorer (Haiku) | 2K | 500 | ~$0.001 | 10x | 10 sats (~$0.01) |
| Researcher (Sonnet) | 8K | 2K | ~$0.03 | 1.7x | 50 sats (~$0.05) |
| Scholar (Opus) | 20K | 5K | ~$0.30 | 1.7x | 500 sats (~$0.50) |

### 8.2 Margin Analysis

At $100K BTC (1 sat = $0.001):
- Explorer: 10 sats = $0.01, cost $0.001 → **90% margin**
- Researcher: 50 sats = $0.05, cost $0.03 → **40% margin**
- Scholar: 500 sats = $0.50, cost $0.30 → **40% margin**

---

## 9. Splash Page Tutorial Design

### 9.1 Punch-Out Style "How to Play"

A full-screen pixel art splash page that teaches the rules:

```
┌──────────────────────────────────────────────┐
│                                              │
│     🥊 BITCOINOLOGY: HOW TO PLAY 🥊          │
│                                              │
│     [Pixel art Doc Louis character]          │
│                                              │
│  "Listen up, kid. Here's how this works."    │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ ROUND 1: EXPLORE          10 ⚡/search│   │
│  │ Search beliefs. Find cards. Learn.    │   │
│  │ [Pixel art: basic punch]              │   │
│  └──────────────────────────────────────┘   │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ ROUND 2: RESEARCH         50 ⚡/search│   │
│  │ Compare. Analyze. Build knowledge.    │   │
│  │ [Pixel art: combo attack]             │   │
│  └──────────────────────────────────────┘   │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │ ROUND 3: PROVE           500 ⚡/thesis│   │
│  │ Submit your thesis. Face the Gate.    │   │
│  │ [Pixel art: TKO finish]              │   │
│  └──────────────────────────────────────┘   │
│                                              │
│  "Every search costs sats. Make 'em count." │
│                                              │
│         [ ⚡ START FIGHTING ⚡ ]              │
│                                              │
└──────────────────────────────────────────────┘
```

### 9.2 Interactive Elements
- Each round box expands on hover/click with more detail
- Doc Louis gives different tips as you scroll
- Sats counter shows example costs as you interact
- "Demo Mode" lets you try one free search before paying
- Animated pixel characters demonstrate each tier's workflow

### 9.3 Returning Users
- Splash shows only on first visit
- Returning users go straight to their chat thread
- Tutorial accessible from settings/help menu

---

*The tier system turns model costs into game progression. Users don't feel "charged" — they feel like they're "leveling up." That's the difference between a paywall and a game mechanic.*
