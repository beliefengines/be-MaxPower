# The Gate: Citation & Source Verification Specification

> **Every agent response must trace back to source material. No source = no answer.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Core Principles](#2-core-principles)
- [3. Source Types](#3-source-types)
- [4. Gate Architecture](#4-gate-architecture)
- [5. Verification Pipeline](#5-verification-pipeline)
- [6. Response Templates](#6-response-templates)
- [7. Domain Scoping](#7-domain-scoping)
- [8. Edge Cases](#8-edge-cases)
- [9. Dual Interface (Human vs Agent)](#9-dual-interface)
- [10. Implementation Requirements](#10-implementation-requirements)
- [11. Acceptance Criteria](#11-acceptance-criteria)

---

## 1. Overview

The Gate is Bitcoinology's trust layer — a mandatory citation and verification system that ensures every piece of information surfaced to users is grounded in verifiable source material. This is the fundamental differentiator between Bitcoinology and generic AI chatbots.

**The Gate answers one question: "Where did this come from?"**

If the answer is "nowhere" — the response doesn't ship.

---

## 2. Core Principles

### 2.1 Constitutional Rules

1. **No hallucination.** Every belief, claim, or attribution must cite a specific source (transcript timestamp, book chapter, document section).
2. **No general knowledge.** The agent does not answer from its training data. It answers from the Bitcoinology dataset ONLY.
3. **Graceful refusal.** When no source exists: *"I don't have data on that in the Bitcoinology dataset yet."* — never fabricate.
4. **Domain enforcement.** Queries outside the Bitcoin/cryptocurrency domain are rejected: *"Bitcoinology is a Bitcoin knowledge engine. I can't help with that topic."*
5. **Attribution integrity.** Never attribute a belief to the wrong speaker. If speaker identification is uncertain, flag it.

### 2.2 Trust Hierarchy

| Trust Level | Source Type | Confidence Display |
|---|---|---|
| 🟢 **Verified** | Direct quote with transcript timestamp | Green shield |
| 🟡 **Inferred** | Paraphrased/summarized from source | Yellow indicator |
| 🔴 **Unsourced** | No source found | BLOCKED — not shown |

---

## 3. Source Types

### 3.1 Current Sources (Phase 1)

| Source | Format | Citation Style |
|---|---|---|
| Podcast transcripts | Diarized text with timestamps | `[Speaker, Episode Title, MM:SS]` |
| Episode metadata | Structured JSON | `[Podcast Name, Episode #, Date]` |
| Extracted beliefs | ETL pipeline output | `[Belief ID, Extraction Confidence]` |

### 3.2 Future Sources (Phase 2+)

| Source | Format | Citation Style |
|---|---|---|
| Published books | Chapter/page indexed | `[Author, Book Title, Ch. X, p. XX]` |
| Conference talks | Transcript + video timestamp | `[Speaker, Event, MM:SS]` |
| Academic papers | DOI-linked | `[Author(s), Title, Journal, Year]` |
| Community submissions | User-crafted + Opus-verified | `[Username, Card ID, Verification Date]` |

---

## 4. Gate Architecture

### 4.1 Flow Diagram

```
User Query
    │
    ▼
┌──────────────┐
│ Domain Check  │ ← Is this a Bitcoin/crypto question?
└──────┬───────┘
       │ YES                    NO → "Not in scope"
       ▼
┌──────────────┐
│ Source Search │ ← Qdrant vector search + Supabase lookup
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Citation      │ ← Match claims to specific sources
│ Extraction    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Verification  │ ← Confirm quotes exist in transcripts
│ Layer         │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Gate Check    │ ← Every claim has a source? 
└──────┬───────┘
       │ YES                    NO → Strip unsourced claims
       ▼
┌──────────────┐
│ Response      │ ← Format with citations + confidence
│ Rendering     │
└──────────────┘
```

### 4.2 Components

| Component | Responsibility | Technology |
|---|---|---|
| **Domain Classifier** | Reject off-topic queries | LLM prompt + keyword filter |
| **Source Retriever** | Find relevant beliefs/transcripts | Qdrant vector search |
| **Citation Matcher** | Map response claims → source material | LLM + embedding similarity |
| **Quote Verifier** | Confirm extracted quotes exist verbatim | Text search against transcript DB |
| **Confidence Scorer** | Rate citation reliability | Similarity score + extraction confidence |
| **Response Formatter** | Attach citations to output | Template engine |

---

## 5. Verification Pipeline

### 5.1 Pre-Response Verification

Before ANY response reaches the user:

1. **Claim Extraction** — Break the response into individual claims/assertions
2. **Source Matching** — For each claim, find the supporting source in the dataset
3. **Quote Validation** — If a direct quote is used, verify it exists in the transcript
4. **Speaker Verification** — Confirm the attributed speaker actually said it
5. **Confidence Assignment** — Score each claim's source confidence (0.0-1.0)
6. **Gate Decision** — Claims below threshold (0.6) are stripped or flagged

### 5.2 Confidence Scoring

```
confidence = (
    0.4 * embedding_similarity    # How close is the claim to the source?
    + 0.3 * quote_match_score     # Does the quote exist verbatim?
    + 0.2 * speaker_certainty     # Are we sure who said this?
    + 0.1 * extraction_confidence # How reliable was the ETL extraction?
)
```

### 5.3 Thresholds

| Score | Action |
|---|---|
| ≥ 0.8 | 🟢 Show with full citation |
| 0.6 - 0.8 | 🟡 Show with "paraphrased" flag |
| < 0.6 | 🔴 Strip from response |

---

## 6. Response Templates

### 6.1 Successful Response (Human Interface)

```
🟠 Michael Saylor believes that Bitcoin is the apex property of the human race.

📎 Source: "What Bitcoin Did" Episode 412, 34:12
   "Bitcoin is the apex property of the human race — it's the 
   most thermodynamically sound store of energy ever created."

🟢 Verified • Confidence: 0.94
```

### 6.2 Partial Response

```
🟠 Several speakers discuss Bitcoin's role in corporate treasury strategy.

📎 Sources:
  • Michael Saylor, "What Bitcoin Did" Ep. 412, 34:12 🟢
  • Lyn Alden, "Bitcoin Fundamentals" Ep. 89, 12:45 🟢
  • Unverified reference to Saifedean Ammous 🟡 (paraphrased)

⚠️ 1 claim could not be verified and was removed from this response.
```

### 6.3 No Data Response

```
🔍 I don't have data on [topic] in the Bitcoinology dataset yet.

This could mean:
  • No podcast guests have discussed this topic
  • The topic hasn't been processed through our pipeline yet

💡 Try searching for related topics: [suggestions based on nearest domains]
```

### 6.4 Off-Topic Response

```
🚫 Bitcoinology is a Bitcoin knowledge engine. 
   I can't help with [off-topic subject].

💡 Try asking about: Bitcoin, monetary policy, Lightning Network, 
   self-custody, mining, or any topic our speakers have discussed.
```

### 6.5 Agent/API Response (Machine Interface)

```json
{
  "query": "What does Saylor think about corporate Bitcoin adoption?",
  "results": [
    {
      "belief_id": "bel_7acbf85a",
      "speaker": "Michael Saylor",
      "atomic_belief": "Corporations should hold Bitcoin as primary treasury reserve",
      "source": {
        "episode": "What Bitcoin Did Ep. 412",
        "timestamp": "34:12",
        "quote": "Bitcoin is the apex property...",
        "transcript_chunk_id": "chunk_8821"
      },
      "confidence": 0.94,
      "verification_status": "verified",
      "domain": "Economy & Money",
      "subdomain": "corporate_treasury"
    }
  ],
  "meta": {
    "sources_searched": 1438,
    "beliefs_matched": 12,
    "verification_pass_rate": 0.92
  }
}
```

---

## 7. Domain Scoping

### 7.1 In-Scope Domains (Bitcoinology)

| Domain | Sub-domains |
|---|---|
| Economy & Money | monetary policy, corporate treasury, inflation, savings |
| Bitcoin Technology | protocol, mining, Lightning Network, Layer 2 |
| Self-Custody | hardware wallets, multisig, inheritance |
| Regulation & Law | policy, compliance, taxation, legal status |
| Philosophy & Ethics | Austrian economics, sound money, freedom, sovereignty |
| History | cypherpunks, Satoshi, Bitcoin history, monetary history |
| Culture & Society | adoption, community, media, education |
| Investment & Markets | price analysis, cycles, risk management |

### 7.2 Off-Scope (Rejected)

- General AI/tech questions unrelated to Bitcoin
- Personal advice (financial, medical, legal)
- Non-Bitcoin cryptocurrency promotion
- Current events not in the dataset
- Anything without a source in the Bitcoinology corpus

### 7.3 Edge: Adjacent Topics

Some queries touch Bitcoin tangentially (macroeconomics, monetary history, energy). These are allowed IF sources exist in the dataset discussing them in a Bitcoin context.

---

## 8. Edge Cases

### 8.1 Contradicting Beliefs

When two speakers disagree:
```
🟠 Speakers have different views on [topic]:

  Michael Saylor: "[Quote A]" 
  📎 Source: Ep. 412, 34:12 🟢

  Lyn Alden: "[Quote B]"
  📎 Source: Ep. 89, 12:45 🟢

  Bitcoinology presents both perspectives — you decide.
```

### 8.2 Stale/Outdated Beliefs

If a speaker has changed their position across episodes:
- Show the most recent statement with timestamp
- Note: "This speaker also said [earlier position] on [date]"
- Let the user see the evolution

### 8.3 Low-Confidence Speakers

For Common tier speakers (1-5 episodes):
- Fewer citations available
- Lower overall confidence scores
- Flag: "Limited data — based on [N] episodes"

### 8.4 Community Cards as Sources

After Opus verification, Community Cards become citable sources. They carry:
- Author attribution
- Verification timestamp
- Source chain (which original sources they cite)
- Community challenge status (any ⚔️ challenges?)

---

## 9. Dual Interface

### 9.1 Human Experience

- Gamified pixel art card interface
- Visual confidence indicators (shields, colors)
- Expandable citations (tap to see full quote)
- Source links to episode/timestamp
- Friendly, conversational tone

### 9.2 Agent/Machine Experience (API)

- Structured JSON responses
- Full citation metadata
- Embedding vectors included
- Confidence scores as floats
- Graph relationship data
- No visual formatting — pure data

### 9.3 Shared Backend

Both interfaces hit the same:
- Source retrieval pipeline
- Verification layer
- Confidence scoring
- Domain classifier

The Gate doesn't change based on who's asking — only the response format does.

---

## 10. Implementation Requirements

### 10.1 Phase 1 (MVP)

- [ ] Domain classifier (keyword + LLM-based)
- [ ] Vector search integration (Qdrant)
- [ ] Basic citation attachment (belief_id → source episode/timestamp)
- [ ] Off-topic rejection template
- [ ] No-data graceful response
- [ ] Minimum confidence threshold (0.6)

### 10.2 Phase 2

- [ ] Quote verbatim verification against transcripts
- [ ] Speaker verification (diarization cross-check)
- [ ] Confidence scoring formula implementation
- [ ] Contradiction detection between speakers
- [ ] Community Card citation chain

### 10.3 Phase 3

- [ ] Book source integration
- [ ] Real-time verification during streaming responses
- [ ] Automated source freshness checking
- [ ] Community challenge integration (⚔️ disputes affect confidence)
- [ ] Cross-episode belief evolution tracking

---

## 11. Acceptance Criteria

### Must Pass

- [ ] Zero hallucinated responses in test suite (100% source coverage)
- [ ] Off-topic queries rejected 100% of the time
- [ ] Every displayed belief has a clickable source citation
- [ ] Confidence scores visible on all belief cards
- [ ] "No data" response when corpus doesn't cover a topic
- [ ] API returns structured JSON with full citation metadata
- [ ] Speaker attribution matches diarized transcript

### Performance

- [ ] Gate verification adds < 500ms to response time
- [ ] Vector search returns results in < 200ms
- [ ] Citation rendering doesn't block UI interaction

### UX

- [ ] Users can expand any citation to see the full quote
- [ ] Confidence indicators are visually distinct (🟢🟡🔴)
- [ ] Off-topic rejection suggests related valid topics
- [ ] Contradicting beliefs are presented side-by-side, not averaged

---

*This spec is the foundation of everything. If the Gate is weak, the product is just another chatbot. If the Gate is strong, Bitcoinology is a knowledge protocol.*

**The Gate is the product.**
