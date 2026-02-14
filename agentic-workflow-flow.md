# Agentic Workflow Architecture — High Level

## The Core Idea
Every search is **visible work, not a loading spinner**. The user sees a real-time workflow tree that shows what the AI agents are doing — like watching a factory build their answer.

## The Three Agents

### 🔮 Oracle (Search Agent)
- **Trigger:** User types a search query
- **Job:** Fast belief retrieval + synthesis
- **Flow:** Query → Embed → Vector Search (Qdrant) → Rank → Synthesize → Response
- **Speed:** 2-5 seconds

### 🐺 Jackal (Deep Research Agent)  
- **Trigger:** User clicks "Go Deeper" or Oracle finds thin coverage
- **Job:** Multi-hop reasoning across beliefs, connecting dots
- **Flow:** Seed Query → Decompose → Parallel Sub-Queries → Cross-Reference Beliefs → Build Argument Graph → Narrative Synthesis
- **Speed:** 10-30 seconds (this is where the animation matters most)

### 📖 Playbook (Guided Exploration)
- **Trigger:** User selects a Playbook topic
- **Job:** Structured learning path through the belief graph
- **Flow:** Topic → Load Playbook Template → Sequence Beliefs → Present Step-by-Step → Branch on User Choice

## High-Level Flow (What the User Sees)

```
┌─────────────────────────────────────────────────────────┐
│                    SEARCH BAR                            │
│  "What does Michael Saylor believe about nation states?" │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              🌳 WORKFLOW TREE (animated)                 │
│                                                         │
│  ⚡ Query Received                               [done] │
│  ├── 🧠 Understanding Intent                     [done] │
│  │   └── Detected: speaker=saylor, topic=nation-states  │
│  ├── 🔍 Vector Search                            [live] │
│  │   ├── Qdrant: 23 beliefs found                       │
│  │   └── Supabase: 4 episodes matched                   │
│  ├── ⚖️  Ranking & Filtering                    [queue] │
│  │   ├── Relevance scoring                              │
│  │   ├── Dedup by worldview                             │
│  │   └── Confidence weighting                           │
│  ├── 💬 Synthesizing Answer                     [queue] │
│  │   └── Claude: streaming response...                  │
│  └── 📊 Building Graph View                     [queue] │
│      ├── Belief clusters                                │
│      └── Speaker connections                            │
│                                                         │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌──────────┬──────────────────────┬───────────────────────┐
│ 2D GRAPH │   ANSWER + QUOTES    │   SOURCE EPISODES     │
│ (beliefs │   (streaming)        │   (expandable)        │
│  cluster)│                      │                       │
└──────────┴──────────────────────┴───────────────────────┘
```

## Jackal Deep Dive (the impressive one)

```
⚡ Deep Research: "Bitcoin adoption game theory"
├── 🧠 Decomposing Query
│   ├── Sub-Q1: "game theory + Bitcoin"
│   ├── Sub-Q2: "nation state adoption incentives"  
│   └── Sub-Q3: "prisoner's dilemma + Bitcoin reserves"
├── 🔍 Parallel Search (3 threads)          [live]
│   ├── Thread 1: 18 beliefs found
│   ├── Thread 2: 12 beliefs found           [live]
│   └── Thread 3: searching...               [live]
├── 🔗 Cross-Referencing                    [queue]
│   ├── Finding contradictions
│   ├── Finding agreements across speakers
│   └── Building argument chains
├── 🗺️  Mapping Belief Landscape            [queue]
│   └── Clustering by worldview
└── 📝 Narrative Synthesis                  [queue]
    └── Weaving findings into coherent analysis
```

## Technical Architecture (How It Works)

```
┌─────────┐     ┌──────────┐     ┌─────────────┐
│  Next.js │────▶│  Motia   │────▶│  AI Agents  │
│ Frontend │◀────│  (flows) │◀────│  (Claude)   │
│          │ SSE │          │     └──────┬──────┘
└─────────┘     └────┬─────┘            │
                     │            ┌─────▼──────┐
                     │            │   Qdrant    │
                     │            │  (vectors)  │
                     │            └────────────┘
                     │            ┌─────────────┐
                     └───────────▶│  Supabase   │
                                  │  (metadata) │
                                  └─────────────┘
```

### The SSE Stream (Server-Sent Events)
Each workflow step emits events the frontend consumes:

```json
{"type": "step_start", "id": "vector_search", "label": "🔍 Vector Search"}
{"type": "step_progress", "id": "vector_search", "data": {"found": 23}}
{"type": "step_complete", "id": "vector_search", "duration_ms": 340}
{"type": "step_start", "id": "ranking", "label": "⚖️ Ranking & Filtering"}
{"type": "stream_token", "id": "synthesis", "token": "Michael"}
{"type": "stream_token", "id": "synthesis", "token": " Saylor"}
...
```

### Motia Orchestration
Each agent is a Motia flow with discrete steps:
- Steps emit real-time status via SSE
- Steps can run in parallel (vector search + metadata lookup)
- Failed steps show red in the tree (with retry option)
- Each step logs to Supabase for analytics

## What Makes This Different
1. **Transparency** — Users see exactly what's happening, not a black box
2. **Education** — The tree teaches users how belief extraction works
3. **Trust** — Every claim links back to a specific quote + episode + timestamp
4. **Engagement** — Watching the tree build is genuinely fun (like watching a build pipeline)
5. **Community** — Searches build the graph; the more people search, the richer it gets
