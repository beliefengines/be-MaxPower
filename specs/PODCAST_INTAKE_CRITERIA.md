# Podcast Intake Criteria — Bitcoinology

**Version:** 1.0  
**Date:** 2026-02-12  
**Author:** Belief Engines  
**Status:** Draft  

> Defines what qualifies a podcast for inclusion in the Bitcoinology belief extraction pipeline. Designed for programmatic implementation.

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Qualification Scoring Rubric](#2-qualification-scoring-rubric)
  - [2.1 Bitcoin Relevance Score (BRS)](#21-bitcoin-relevance-score-brs)
  - [2.2 Content Quality Score (CQS)](#22-content-quality-score-cqs)
  - [2.3 Reach & Influence Score (RIS)](#23-reach--influence-score-ris)
  - [2.4 Composite Qualification Score](#24-composite-qualification-score)
- [3. Minimum Thresholds](#3-minimum-thresholds)
- [4. Speaker Eligibility](#4-speaker-eligibility)
- [5. Exclusion Criteria](#5-exclusion-criteria)
- [6. Episode-Level Filtering](#6-episode-level-filtering)
- [7. Discovery Pipeline](#7-discovery-pipeline)
- [8. Current Dataset Analysis](#8-current-dataset-analysis)
- [9. Implementation Guide](#9-implementation-guide)

---

## 1. Overview

Bitcoinology extracts **atomic beliefs** from podcast transcripts and maps them to speakers. Not every podcast merits inclusion. This spec defines a repeatable, scorable process for qualifying podcasts and individual episodes.

**Core principle:** We want podcasts where knowledgeable people express substantive, attributable beliefs about Bitcoin — its technology, economics, philosophy, mining, regulation, and societal impact. We do NOT want price speculation, altcoin promotion, or shallow news recaps.

---

## 2. Qualification Scoring Rubric

Every candidate podcast receives three sub-scores that combine into a **Composite Qualification Score (0–100)**.

### 2.1 Bitcoin Relevance Score (BRS)

Weight: **50%** of composite score.

Measures how Bitcoin-focused the podcast is, scored 0–100.

| Signal | Method | Points |
|---|---|---|
| **Self-described focus** | Title/description contains "Bitcoin" (not just "crypto") | 0–20 |
| **Bitcoin episode ratio** | `bitcoin_episodes / total_episodes` | 0–30 |
| **Keyword density** | Sample 5 transcripts → avg frequency of Bitcoin-specific terms vs generic crypto terms | 0–25 |
| **Guest overlap** | % of guests who appear in known Bitcoin-focused podcasts | 0–15 |
| **Altcoin signal (penalty)** | Frequent mention of altcoins, "next 100x", token launches → subtract | −10 to 0 |

**Bitcoin episode detection** (for ratio calculation):
- Title contains: `bitcoin`, `btc`, `lightning`, `mining`, `halving`, `satoshi`, `proof of work`, `hard money`, `sound money`, `monetary policy` (Bitcoin context)
- OR: Guest is a known Bitcoin speaker (cross-reference speaker database)
- Threshold: episode is "Bitcoin-related" if ≥60% of substantive discussion is Bitcoin-specific

**Keyword density terms:**

| Bitcoin-specific (positive) | Generic crypto (neutral/negative) |
|---|---|
| bitcoin, satoshi, lightning network, proof of work, UTXO, mempool, halving, difficulty adjustment, block reward, timechain, cold storage, multisig, node, hash rate | crypto, token, DeFi, NFT, altcoin, Ethereum, Solana, yield farming, airdrop, Web3 |

**Scoring formula:**
```
bitcoin_ratio = bitcoin_keyword_count / (bitcoin_keyword_count + crypto_keyword_count)
keyword_score = bitcoin_ratio * 25
```

#### BRS Tiers

| BRS Range | Classification | Action |
|---|---|---|
| 80–100 | **Bitcoin-native** — podcast is primarily about Bitcoin | Auto-qualify (pending other scores) |
| 50–79 | **Bitcoin-adjacent** — significant Bitcoin content mixed with other topics | Qualify selectively (episode-level filtering required) |
| 20–49 | **Occasionally Bitcoin** — mostly other topics, some Bitcoin episodes | Episode-only ingestion; do not ingest full catalog |
| 0–19 | **Not Bitcoin** | Reject |

### 2.2 Content Quality Score (CQS)

Weight: **30%** of composite score.

| Signal | Method | Points |
|---|---|---|
| **Transcript availability** | RSS feed includes transcripts OR auto-transcription quality ≥90% WER | 0–20 |
| **Episode length** | Average episode ≥30 min (depth signal) | 0–15 |
| **Audio quality** | Sample SNR check — can Whisper transcribe at ≥90% accuracy? | 0–15 |
| **Discussion format** | Long-form interview/discussion vs news recap vs solo rant | 0–20 |
| **Guest diversity** | Unique guests per 50 episodes (more guests = more belief sources) | 0–15 |
| **Consistency** | Active in last 12 months, ≥2 episodes/month average | 0–15 |

**Format scoring:**

| Format | Score |
|---|---|
| Long-form interview (60+ min, 1-2 guests) | 20 |
| Panel discussion / debate | 18 |
| Deep-dive solo analysis (30+ min, structured) | 15 |
| Conversational interview (30-60 min) | 14 |
| News roundup with commentary | 8 |
| Short-form daily recap (<15 min) | 3 |
| Pure solo opinion / rant | 2 |

### 2.3 Reach & Influence Score (RIS)

Weight: **20%** of composite score.

| Signal | Method | Points |
|---|---|---|
| **Episode count** | Total published episodes (longevity signal) | 0–20 |
| **Platform presence** | Available on Apple, Spotify, YouTube, RSS (more = more reach) | 0–10 |
| **Social following** | Host's Twitter/Nostr following (proxy for reach) | 0–15 |
| **Guest caliber** | % of episodes with recognized Bitcoin speakers | 0–25 |
| **Citation frequency** | How often this podcast is referenced by other Bitcoin podcasts | 0–15 |
| **Community reputation** | Appears in Bitcoin community podcast lists, recommended by known Bitcoiners | 0–15 |

**Episode count scoring:**

| Episodes | Points |
|---|---|
| 500+ | 20 |
| 200–499 | 15 |
| 100–199 | 10 |
| 50–99 | 7 |
| 20–49 | 4 |
| <20 | 1 |

### 2.4 Composite Qualification Score

```
CQS_composite = (BRS × 0.50) + (CQS × 0.30) + (RIS × 0.20)
```

| Composite Score | Decision |
|---|---|
| **75–100** | ✅ Auto-qualify — full catalog ingestion |
| **55–74** | 🟡 Conditional — episode-level filtering, manual review of sample |
| **35–54** | 🟠 Selective — cherry-pick high-value episodes only |
| **0–34** | ❌ Reject |

---

## 3. Minimum Thresholds

Hard gates — a podcast must pass ALL of these regardless of composite score:

| Criterion | Minimum | Rationale |
|---|---|---|
| **Total episodes** | ≥20 | Establishes track record |
| **Bitcoin-related episodes** | ≥10 | Enough content for meaningful belief extraction |
| **Average episode length** | ≥20 minutes | Depth threshold |
| **Transcription accuracy** | ≥85% WER (Whisper) | Beliefs extracted from bad transcripts are unreliable |
| **Language** | English (primary) | Current pipeline limitation; expand later |
| **Active status** | Published ≥1 episode in last 18 months OR has 200+ episodes (legacy value) | Avoid dead feeds unless historically significant |
| **No exclusion flags** | See [Section 5](#5-exclusion-criteria) | Hard disqualifiers |

---

## 4. Speaker Eligibility

Not every voice on a podcast is worth extracting beliefs from. This section defines which speakers generate belief cards.

### 4.1 Speaker Qualification Matrix

| Signal | Weight | Measurement |
|---|---|---|
| **Appearances** | 30% | Total episodes across all ingested podcasts |
| **Expertise signals** | 30% | Professional role, publications, conference talks, known contributions to Bitcoin |
| **Belief density** | 20% | Avg extractable beliefs per episode (some guests make many claims; some make few) |
| **Attribution clarity** | 20% | Can we clearly attribute statements to this speaker? (multi-speaker diarization quality) |

### 4.2 Speaker Tiers

| Tier | Criteria | Treatment |
|---|---|---|
| **S-Tier** (Canonical) | 20+ episodes across 3+ podcasts, recognized industry figure | Full belief extraction, speaker profile card, priority indexing |
| **A-Tier** (Notable) | 5–19 episodes across 2+ podcasts, demonstrated expertise | Full belief extraction, speaker profile card |
| **B-Tier** (Contributing) | 2–4 episodes, or single podcast regular with clear expertise | Belief extraction, basic speaker entry |
| **C-Tier** (Incidental) | 1 episode, limited context | Extract beliefs only if episode scores high; no standalone speaker card |
| **Excluded** | Fails exclusion criteria | No extraction |

### 4.3 Expertise Signals (Automated Detection)

```python
EXPERTISE_KEYWORDS = {
    "developer": ["core developer", "contributor", "wrote the code", "pull request", "BIP"],
    "economist": ["monetary policy", "Austrian economics", "inflation", "central bank"],
    "miner": ["hash rate", "ASIC", "mining operation", "energy grid"],
    "researcher": ["paper", "published", "study", "data shows"],
    "entrepreneur": ["founded", "CEO", "built", "company"],
    "journalist": ["reporting", "investigation", "source"],
    "educator": ["teach", "course", "students", "explain"],
    "policy": ["regulation", "legislation", "senator", "congressman", "policy"]
}
```

Scan guest introduction segment (first 5 minutes) for these signals. Cross-reference with known speaker database.

---

## 5. Exclusion Criteria

### 5.1 Podcast-Level Exclusions

Automatic disqualification if ANY of these are true:

| Exclusion | Detection Method |
|---|---|
| **Altcoin promotion** — podcast primarily promotes specific altcoins/tokens | BRS < 20; title/description analysis |
| **Scam/fraud association** — host or podcast associated with known scams | Manual blocklist + community reports |
| **Paid promotion masquerading as content** — episodes are primarily sponsored shills | Sponsorship ratio > 40% of episode content |
| **AI-generated slop** — auto-generated podcast with no real host or guests | Audio fingerprinting, metadata analysis |
| **Hate speech / extremism** — content primarily promotes violence or hate | Content moderation flags |

### 5.2 Episode-Level Exclusions

Even from qualified podcasts, skip these episodes:

| Exclusion | Detection Method |
|---|---|
| **Pure price speculation** | Keyword density: "price target", "moon", "when lambo", "buy the dip" without substantive analysis |
| **Sponsor-only episodes** | Episode length < 10 min AND high ad keyword density |
| **Duplicate/rebroadcast** | Audio fingerprint matching against existing episodes |
| **Non-English episodes** | Language detection on first 60 seconds |
| **Live trading / market commentary** | Real-time price references, "looking at the chart right now" |
| **Episodes with <2 extractable beliefs** | Post-extraction filter — if pipeline extracts fewer than 2 beliefs, flag for review |

### 5.3 Exclusion Blocklist

Maintain a `blocklist.yaml` with:
```yaml
blocked_podcasts:
  - slug: "bitboy-crypto"
    reason: "Primarily altcoin promotion, fraud association"
    blocked_date: "2026-01-15"

blocked_speakers:
  - name: "Example Scammer"
    reason: "Convicted fraud"
    blocked_date: "2026-01-15"
```

---

## 6. Episode-Level Filtering

For podcasts scoring 35–74 (Conditional/Selective), apply episode-level filters:

### 6.1 Episode Relevance Score

```python
def episode_relevance_score(episode) -> float:
    """Score 0-100. Episodes ≥60 are ingested."""
    score = 0.0
    
    # Title relevance (0-25)
    title_keywords = count_bitcoin_keywords(episode.title)
    score += min(title_keywords * 8, 25)
    
    # Description relevance (0-20)
    desc_keywords = count_bitcoin_keywords(episode.description)
    score += min(desc_keywords * 4, 20)
    
    # Guest is known Bitcoin speaker (0-25)
    if episode.guest in KNOWN_BITCOIN_SPEAKERS:
        score += 25
    
    # Episode length (0-15)
    if episode.duration_min >= 60:
        score += 15
    elif episode.duration_min >= 30:
        score += 10
    elif episode.duration_min >= 20:
        score += 5
    
    # Negative signals (penalties)
    if has_altcoin_focus(episode):
        score -= 20
    if is_price_speculation(episode):
        score -= 15
    
    return max(0, min(100, score))
```

---

## 7. Discovery Pipeline

### 7.1 Discovery Sources

| Source | Method | Frequency | Expected Yield |
|---|---|---|---|
| **Podcast Index API** | Query for Bitcoin-tagged podcasts, filter by language=en, episodeCount ≥ 20 | Monthly | 50–100 candidates/quarter |
| **Apple Podcasts categories** | Scrape "Technology" and "Business" categories for Bitcoin keywords | Monthly | 20–40 candidates/quarter |
| **Spotify podcast search** | API search for "Bitcoin" in podcast names/descriptions | Monthly | 30–60 candidates/quarter |
| **Citation network** | Track which podcasts current speakers mention or appear on | Ongoing | 10–20 high-quality candidates/quarter |
| **Community submissions** | Twitter/Nostr form where users suggest podcasts | Ongoing | 5–15 candidates/quarter |
| **Conference speaker cross-ref** | Speakers at Bitcoin conferences → find their podcast appearances | Post-conference | 5–10 podcasts/event |
| **Fountain.fm** | Bitcoin-native podcast platform, curated lists | Monthly | 10–20 candidates/quarter |
| **Stacker News** | Community-upvoted podcast recommendations | Weekly scan | 3–5 candidates/month |

### 7.2 Discovery Pipeline Flow

```
Source → Candidate List → Auto-Score (BRS/CQS/RIS) → Threshold Filter → Manual Review Queue → Approve/Reject → Ingest
```

### 7.3 Deduplication

Before scoring, check:
- RSS feed URL already in database
- Podcast GUID match
- Title + host fuzzy match (Levenshtein distance < 3)

---

## 8. Current Dataset Analysis

### 8.1 Estimated Current Coverage

Based on 1,438 episodes in the current dataset:

| Podcast (Estimated) | Episodes (Est.) | Category | BRS Est. |
|---|---|---|---|
| What Bitcoin Did (Peter McCormack) | ~300 | Bitcoin-native, long-form interview | 90 |
| The Bitcoin Standard Podcast (Saifedean Ammous) | ~150 | Bitcoin-native, economics-focused | 95 |
| Bitcoin Audible (Guy Swann) | ~200 | Bitcoin-native, essay readings + commentary | 85 |
| Stephan Livera Podcast | ~200 | Bitcoin-native, technical + economic | 95 |
| Tales from the Crypt / TFTC (Marty Bent) | ~150 | Bitcoin-native, long-form | 88 |
| Bitcoin Magazine Podcast | ~100 | Bitcoin-native, news + interviews | 82 |
| The Investor's Podcast (Preston Pysh — Bitcoin episodes) | ~80 | Bitcoin-adjacent, finance crossover | 60 |
| Unchained (Laura Shin — Bitcoin episodes) | ~50 | Bitcoin-adjacent, broader crypto | 45 |
| Other / miscellaneous | ~208 | Various | Varies |

### 8.2 Coverage Gaps

**High-priority podcasts likely missing:**

| Podcast | Why It Matters | Est. Episodes | BRS Est. |
|---|---|---|---|
| Bitcoin Fundamentals (Preston Pysh) | Major investor audience, high-quality guests | 150+ | 85 |
| Once BITten (Daniel Prince) | UK Bitcoin community, unique guest pool | 200+ | 90 |
| Bitcoin Rapid-Fire (John Vallis) | Deep philosophical discussions | 200+ | 92 |
| Café Bitcoin (Alex Li) | Canadian Bitcoin community | 100+ | 85 |
| Fun With Bitcoin (various hosts) | Technical deep-dives | 80+ | 80 |
| The Bitcoin Layer (Nik Bhatia) | Macro-economics + Bitcoin | 100+ | 78 |
| Bitcoin Fixes This (Jimmy Song) | Developer + theological perspective | 100+ | 88 |
| Swan Signal (Brady Swenson) | Swan Bitcoin's podcast, high-caliber guests | 80+ | 85 |
| Closing the Loop | Human rights + Bitcoin | 50+ | 82 |
| Bitcoin Review (NVK + friends) | Technical, Optech-style | 60+ | 90 |
| Rabbit Hole Recap | Weekly news, multiple perspectives | 150+ | 80 |
| Bitcoin Daddy (Robert Breedlove) | Philosophy + Bitcoin | 100+ | 85 |

**Estimated gap:** ~1,500–2,000 additional qualifying episodes from ~12–15 missing podcasts.

### 8.3 Speaker Coverage Gaps

Cross-referencing the book ingestion spec's author list against likely podcast appearances:

| Speaker | In Dataset? | Gap |
|---|---|---|
| Saifedean Ammous | ✅ Likely (own podcast) | May be missing guest appearances elsewhere |
| Lyn Alden | 🟡 Partial | Appears on many podcasts; likely missing some |
| Jeff Booth | 🟡 Partial | High-frequency guest; check cross-podcast coverage |
| Michael Saylor | 🟡 Partial | Appears broadly; many appearances on non-Bitcoin-native shows |
| Jack Dorsey | ❓ Unknown | Fewer podcast appearances but high impact |
| Caitlin Long | ❓ Unknown | Banking + Bitcoin regulatory perspective |
| Elizabeth Stark | ❓ Unknown | Lightning Labs, technical perspective |

---

## 9. Implementation Guide

### 9.1 Automated Qualification Pipeline

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐     ┌────────────┐
│  Discovery   │────▶│  Auto-Score  │────▶│  Threshold   │────▶│  Ingest /  │
│  Sources     │     │  BRS+CQS+RIS │     │  Filter      │     │  Reject    │
└─────────────┘     └──────────────┘     └──────────────┘     └────────────┘
                           │                     │
                           ▼                     ▼
                    ┌──────────────┐     ┌──────────────┐
                    │  Sample 5    │     │  Manual      │
                    │  Transcripts │     │  Review Queue│
                    └──────────────┘     └──────────────┘
```

### 9.2 Data Schema

```sql
CREATE TABLE podcast_candidates (
    id TEXT PRIMARY KEY,                    -- podcast GUID or slug
    title TEXT NOT NULL,
    host TEXT,
    rss_url TEXT UNIQUE,
    description TEXT,
    total_episodes INTEGER,
    bitcoin_episodes_est INTEGER,
    brs_score REAL,                         -- 0-100
    cqs_score REAL,                         -- 0-100
    ris_score REAL,                         -- 0-100
    composite_score REAL,                   -- 0-100
    status TEXT CHECK (status IN ('candidate', 'qualified', 'conditional', 'selective', 'rejected', 'blocked')),
    rejection_reason TEXT,
    scored_at TIMESTAMP,
    reviewed_by TEXT,                        -- null = auto-scored only
    reviewed_at TIMESTAMP,
    ingested_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE podcast_blocklist (
    slug TEXT PRIMARY KEY,
    reason TEXT NOT NULL,
    blocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    blocked_by TEXT
);

CREATE TABLE episode_scores (
    episode_id TEXT PRIMARY KEY,
    podcast_id TEXT REFERENCES podcast_candidates(id),
    title TEXT,
    relevance_score REAL,                   -- 0-100
    duration_min INTEGER,
    guest_names TEXT[],
    excluded BOOLEAN DEFAULT FALSE,
    exclusion_reason TEXT,
    scored_at TIMESTAMP
);
```

### 9.3 Scoring Config

Store tunable weights in `config/intake_scoring.yaml`:

```yaml
composite_weights:
  brs: 0.50
  cqs: 0.30
  ris: 0.20

thresholds:
  auto_qualify: 75
  conditional: 55
  selective: 35
  reject_below: 35

minimums:
  total_episodes: 20
  bitcoin_episodes: 10
  avg_episode_length_min: 20
  transcription_accuracy: 0.85

episode_filter:
  ingest_above: 60
  review_range: [40, 60]
  reject_below: 40

rescore_interval_days: 90
```

### 9.4 Re-evaluation Schedule

| Trigger | Action |
|---|---|
| Every 90 days | Re-score all `conditional` and `selective` podcasts |
| New podcast discovery | Score immediately |
| Community report | Manual review within 7 days |
| Podcast ceases publishing (18 months inactive) | Mark `inactive`, keep data, stop checking RSS |
| Exclusion report | Review and block/clear within 48 hours |

---

## Appendix: Quick Reference

### Decision Flowchart

```
Is it in English? ──NO──▶ REJECT
       │YES
Has ≥20 episodes? ──NO──▶ REJECT (revisit when threshold met)
       │YES
On blocklist? ──YES──▶ REJECT
       │NO
Calculate BRS ──< 20──▶ REJECT
       │≥20
Calculate CQS + RIS
       │
Composite ≥ 75? ──YES──▶ AUTO-QUALIFY (full catalog)
       │NO
Composite ≥ 55? ──YES──▶ CONDITIONAL (episode filter)
       │NO
Composite ≥ 35? ──YES──▶ SELECTIVE (cherry-pick)
       │NO
       ▼
     REJECT
```
