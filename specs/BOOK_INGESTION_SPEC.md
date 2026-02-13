# Book Ingestion Pipeline: Expanding the Knowledge Base

> **Same ETL pipeline, new source type. Speaker cards get beliefs from BOTH podcasts AND books.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Target Books](#2-target-books)
- [3. Ingestion Pipeline](#3-ingestion-pipeline)
- [4. ETL Modifications](#4-etl-modifications)
- [5. Citation Model](#5-citation-model)
- [6. Speaker Card Impact](#6-speaker-card-impact)
- [7. Dataset Size Estimates](#7-dataset-size-estimates)
- [8. Legal Considerations](#8-legal-considerations)
- [9. Implementation Plan](#9-implementation-plan)
- [10. Priority Ranking](#10-priority-ranking)

---

## 1. Overview

Many podcast guests in the Bitcoinology dataset are also published authors. Their books contain deeper, more structured versions of beliefs they express in podcasts. Ingesting books creates:

- **Richer speaker profiles** — beliefs from both spoken AND written sources
- **Better verification** — cross-reference podcast claims with book arguments
- **Deeper content** — books have structured reasoning that podcasts often lack
- **More citation paths** — Gate can cite both transcript AND chapter/page

---

## 2. Target Books

### 2.1 High-Priority (Authors likely in current dataset)

| Author | Book | Year | Relevance | Est. Beliefs |
|---|---|---|---|---|
| Saifedean Ammous | *The Bitcoin Standard* | 2018 | 🔴 Critical | 200+ |
| Saifedean Ammous | *The Fiat Standard* | 2021 | 🔴 Critical | 150+ |
| Lyn Alden | *Broken Money* | 2023 | 🔴 Critical | 200+ |
| Jeff Booth | *The Price of Tomorrow* | 2020 | 🟠 High | 150+ |
| Alex Gladstein | *Check Your Financial Privilege* | 2022 | 🟠 High | 100+ |
| Vijay Boyapati | *The Bullish Case for Bitcoin* | 2021 | 🟠 High | 80+ |
| Nic Carter | Various essays/reports | Ongoing | 🟡 Medium | 100+ |
| Parker Lewis | *Gradually, Then Suddenly* | 2024 | 🟠 High | 150+ |
| Robert Breedlove | *Thank God for Bitcoin* (co-author) | 2020 | 🟡 Medium | 80+ |
| Jimmy Song | *The Little Bitcoin Book* (co-author) | 2019 | 🟡 Medium | 60+ |
| Jimmy Song | *Thank God for Bitcoin* (co-author) | 2020 | 🟡 Medium | 60+ |
| Andreas Antonopoulos | *The Internet of Money* (series) | 2016-2019 | 🟡 Medium | 150+ |
| Andreas Antonopoulos | *Mastering Bitcoin* | 2014/2017 | 🟡 Medium | 100+ |
| Knut Svanholm | *Bitcoin: Everything Divided by 21 Million* | 2020 | 🟡 Medium | 60+ |
| Knut Svanholm | *Bitcoin: Sovereignty Through Mathematics* | 2019 | 🟡 Medium | 50+ |

### 2.2 Estimated Totals

| Metric | Estimate |
|---|---|
| Target books | 15-20 |
| Total pages | ~5,000-7,000 |
| Total words | ~1.5M-2M |
| Expected beliefs | 1,500-2,500 |
| Processing cost (LLM) | ~$15-30 |

---

## 3. Ingestion Pipeline

### 3.1 Source Acquisition

```
Book Source
    │
    ▼
┌─────────────────┐
│ Digital Format   │ ← EPUB, PDF, or plain text
│ Acquisition      │   (purchased or public domain)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Text Extraction  │ ← Convert to clean plaintext
│ + Cleaning       │   Remove headers, page numbers, etc.
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Chapter/Section  │ ← Split by chapter, preserve structure
│ Segmentation     │   Metadata: chapter #, title, page range
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Chunk Creation   │ ← Sliding window, ~500 words/chunk
│                  │   Overlap: 50 words between chunks
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Belief ETL       │ ← Same be-podcast-etl pipeline
│ (existing)       │   Input: chunks instead of transcript segments
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Attribution      │ ← Author = Speaker (map to existing speaker_id)
│ + Dedup          │   Deduplicate with podcast beliefs (semantic sim)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Dataset Merge    │ ← Add to HuggingFace dataset
│ + Index          │   Update Qdrant + Supabase
└─────────────────┘
```

### 3.2 Key Difference from Podcast Pipeline

| Aspect | Podcast | Book |
|---|---|---|
| **Source format** | Audio → transcript | Text (EPUB/PDF) |
| **Diarization** | Multi-speaker | Single author (usually) |
| **Segmentation** | By timestamp/speaker turn | By chapter/section/page |
| **Attribution** | Speaker diarization | Author (known) |
| **Citation** | `[Speaker, Episode, MM:SS]` | `[Author, Book, Ch. X, p. XX]` |
| **Context** | Conversational | Structured argument |
| **Belief density** | Lower (cross-talk, tangents) | Higher (focused writing) |

---

## 4. ETL Modifications

### 4.1 New Source Type

Add `source_type` field to belief schema:

```json
{
  "source_type": "book",  // NEW — vs "podcast"
  "source_metadata": {
    "book_title": "The Bitcoin Standard",
    "author": "Saifedean Ammous",
    "isbn": "978-1119473862",
    "chapter": 8,
    "chapter_title": "Digital Money",
    "page_range": "182-195",
    "publication_year": 2018
  }
}
```

### 4.2 Changes to be-podcast-etl

| Component | Change Needed |
|---|---|
| **Input loader** | Add EPUB/PDF/TXT reader alongside audio transcript loader |
| **Chunker** | Add chapter-aware chunking (respect section boundaries) |
| **Belief extractor** | No changes — works on text chunks regardless of source |
| **Embedding generator** | No changes — same model (text-embedding-3-small) |
| **Output schema** | Add `source_type` + `source_metadata` fields |
| **Deduplication** | New: check semantic similarity with existing beliefs from same author |
| **Attribution** | Simplified: single author per book (no diarization needed) |

### 4.3 Deduplication Strategy

When an author says the same thing in a podcast AND a book:

1. Keep BOTH beliefs in the dataset
2. Link them as "corroborating sources" 
3. INCREASE the belief's confidence score (said it multiple times = higher conviction)
4. Display both sources in the citation:
   ```
   📎 Sources:
     • The Bitcoin Standard, Ch. 8, p. 185 🟢
     • What Bitcoin Did, Ep. 412, 34:12 🟢
     (Same belief expressed in both — high conviction)
   ```

---

## 5. Citation Model

### 5.1 Book Citation Format (Human Interface)

```
📖 "Sound money is the foundation of civilization."
   — Saifedean Ammous

   📎 The Bitcoin Standard, Chapter 1: "Money", p. 23
   🟢 Verified • Published 2018
```

### 5.2 Book Citation Format (API)

```json
{
  "citation": {
    "source_type": "book",
    "author": "Saifedean Ammous",
    "title": "The Bitcoin Standard",
    "chapter": 1,
    "chapter_title": "Money",
    "page": 23,
    "isbn": "978-1119473862",
    "year": 2018,
    "quote": "Sound money is the foundation of civilization.",
    "quote_exact": true
  }
}
```

### 5.3 Cross-Source Citation

When a belief appears in both podcast and book:

```
📎 Multiple Sources (High Conviction):
  📖 The Bitcoin Standard, Ch. 1, p. 23 (2018)
  🎙️ What Bitcoin Did, Ep. 412, 34:12 (2024)
  
  Saifedean has expressed this belief consistently 
  over 6 years across different formats.
  
  Conviction Trend: ████████░░ 0.95
```

---

## 6. Speaker Card Impact

### 6.1 Enhanced Speaker Profiles

Books add a new section to speaker cards:

```
┌──────────────────────────────────────┐
│ 📖 Published Works                    │
│                                       │
│ • The Bitcoin Standard (2018)         │
│   142 beliefs extracted               │
│ • The Fiat Standard (2021)            │
│   98 beliefs extracted                │
│                                       │
│ Total: 240 beliefs from books         │
│        180 beliefs from podcasts      │
│        420 total beliefs              │
│                                       │
│ 📊 Cross-reference rate: 34%         │
│    (beliefs confirmed in both)        │
└──────────────────────────────────────┘
```

### 6.2 Tier Implications

Book data could change speaker tier status:

| Speaker | Podcast Beliefs | Book Beliefs | Total | Old Tier | New Tier |
|---|---|---|---|---|---|
| Saifedean | 80 | 350 | 430 | Rare | **Legendary** |
| Jeff Booth | 40 | 150 | 190 | Common | **Epic** |
| Alex Gladstein | 30 | 100 | 130 | Common | **Rare** |

Books are a tier multiplier for authors.

---

## 7. Dataset Size Estimates

### 7.1 Current Dataset (Podcasts Only)

| Metric | Value |
|---|---|
| Episodes | 1,438 |
| Transcripts | ~3.5M words |
| Beliefs (enriched) | 134 (test), 1K-10K (full pipeline) |
| Speakers | ~200 |

### 7.2 Projected Dataset (Podcasts + Books)

| Metric | Current | + Books | % Increase |
|---|---|---|---|
| Source documents | 1,438 | 1,458 (+20 books) | +1.4% |
| Total words | ~3.5M | ~5.5M | +57% |
| Beliefs | ~5K | ~7.5K | +50% |
| Unique speakers with books | 0 | ~15 | — |
| Cross-referenced beliefs | 0 | ~500 | — |

### 7.3 Processing Cost

| Item | Cost |
|---|---|
| Text extraction (EPUB→plaintext) | Free (python libraries) |
| Chunking + preprocessing | Free (compute) |
| Belief extraction (LLM) | ~$15-25 (Haiku for extraction) |
| Embedding generation | ~$2-3 (text-embedding-3-small) |
| Verification pass | ~$5-10 (spot-check sample) |
| **Total** | **~$25-40** |

---

## 8. Legal Considerations

### 8.1 Fair Use Analysis

| Factor | Assessment |
|---|---|
| **Purpose** | Transformative — extracting beliefs, not reproducing text |
| **Nature** | Published, non-fiction works |
| **Amount** | Short quotes only, not full chapters |
| **Market impact** | Minimal — drives interest in the books |

### 8.2 Approach

- Extract BELIEFS (transformative), not reproduce text
- Store only short quotes (< 300 words) as supporting evidence
- Link to purchase pages (Amazon, publisher) — drives book sales
- Attribution always includes full book metadata
- If any author objects, remove their content immediately

### 8.3 Author Relations

Many Bitcoin authors would likely WELCOME this:
- Free promotion and discoverability
- Their ideas cited alongside podcast appearances
- Links to purchase their books
- Increased visibility in the Bitcoin community

Could reach out to authors for explicit permission (strongest legal position).

---

## 9. Implementation Plan

### Phase 1: Proof of Concept (1 book)
- [ ] Pick one book (*The Bitcoin Standard* — most relevant)
- [ ] Build EPUB/PDF → plaintext extractor
- [ ] Add chapter-aware chunking to ETL
- [ ] Run through existing belief extraction pipeline
- [ ] Manual quality review of extracted beliefs
- [ ] Merge with existing dataset
- [ ] Verify Gate citations work for book sources

### Phase 2: Batch Processing (5 books)
- [ ] Process top 5 priority books
- [ ] Build deduplication logic (podcast ↔ book)
- [ ] Update speaker cards with book data
- [ ] Add cross-source citation rendering
- [ ] Test tier recalculations

### Phase 3: Scale (15+ books)
- [ ] Process remaining target books
- [ ] Automate the pipeline (new books auto-ingested)
- [ ] Add book purchase links to citations
- [ ] Update HuggingFace dataset
- [ ] Author outreach for permissions

---

## 10. Priority Ranking

### Must-Have Books (Phase 1-2)

1. 🥇 *The Bitcoin Standard* — Saifedean Ammous
2. 🥈 *Broken Money* — Lyn Alden  
3. 🥉 *The Fiat Standard* — Saifedean Ammous
4. *The Price of Tomorrow* — Jeff Booth
5. *Gradually, Then Suddenly* — Parker Lewis

### Nice-to-Have (Phase 3)

6. *Check Your Financial Privilege* — Alex Gladstein
7. *The Bullish Case for Bitcoin* — Vijay Boyapati
8. *The Internet of Money* (Vol 1-3) — Andreas Antonopoulos
9. *Thank God for Bitcoin* — Multiple authors
10. *Bitcoin: Everything Divided by 21 Million* — Knut Svanholm

### Future Expansion

- Conference talk transcripts
- Long-form essays/articles (Nic Carter's Castle Island reports)
- Academic papers on Bitcoin
- Historical monetary texts cited by speakers

---

*Books turn speaker cards from "someone who talks about Bitcoin" into "a published thinker with a body of work." That's the difference between a podcast aggregator and a knowledge protocol.*
