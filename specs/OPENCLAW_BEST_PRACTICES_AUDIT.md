# OpenClaw Best Practices Audit

> **Compared against Robert Heubanks' Mac Mini setup guide (v1.1, Feb 11, 2026)**

---

## Table of Contents

- [1. Credential Storage](#1-credential-storage)
- [2. API Spending Limits](#2-api-spending-limits)
- [3. Backup Strategy](#3-backup-strategy)
- [4. Hooks & Automation](#4-hooks-automation)
- [5. Memory & Embeddings](#5-memory-embeddings)
- [6. Skills & Package Management](#6-skills-package-management)
- [7. Action Items](#7-action-items)

---

## 1. Credential Storage

### Current State: 🔴 Critical

Credentials are stored in plaintext in:
- `MEMORY.md` (Gmail password, GitHub PAT, HuggingFace password)
- `memory/*.md` daily notes (various passwords)

**Risk:** These files are backed up to GitHub. While the repo is private, this is one leak away from full compromise.

### Recommendation

1. Move all credentials to macOS Keychain (`security add-generic-password`)
2. Remove all passwords from markdown files
3. Store only references: "Gmail password: stored in Keychain as 'max-gmail'"
4. OpenClaw can access Keychain via exec tool when needed
5. Session transcripts also contain credentials — excluded from GitHub backup ✅

### Priority: P0 — Do this ASAP

---

## 2. API Spending Limits

### Current State: 🟡 Unknown

We don't know what spending limits are set on:
- Anthropic API
- Google/Gemini API (image generation)
- Any other providers

**Risk:** A runaway loop, misconfigured heartbeat, or sub-agent gone wild could burn through credits fast. Ryan explicitly said "max out the Pro Max plan" for overnight work, but there should still be guardrails.

### Recommendation

1. Set Anthropic monthly cap: $200-500 (adjust based on usage patterns)
2. Set Google API daily limit: $10-20
3. Monitor usage via OpenClaw session_status after heavy work sessions
4. Set up a monthly cost review cadence

### Priority: P1 — Set up this week

---

## 3. Backup Strategy

### Current State: 🟢 Implemented (partially)

- ✅ GitHub nightly backup of workspace files (cron at 3am PST)
- ✅ Session transcripts excluded (contain secrets)
- ⬜ Time Machine not yet set up (Ryan has 22TB drive)
- ⬜ Backblaze not yet set up ($9/mo)
- ⬜ Docker recovery image not built

### Recommendation

1. Ryan plugs in 22TB drive → enable Time Machine (2 min setup)
2. Sign up for Backblaze Personal ($9/mo)
3. Build Docker recovery image for OpenClaw
4. Test recovery process (from GitHub + config restore)

### Priority: P1 — Time Machine is highest ROI (free, 2 minutes)

---

## 4. Hooks & Automation

### Current State: 🟡 Minimal

OpenClaw supports hooks for:
- **Boot hooks** — run scripts on gateway start
- **Command logger** — log all commands for audit
- **Session memory** — automatic memory management

We haven't configured any of these.

### Recommendation

1. Add boot hook to verify backup cron is running
2. Add session memory hooks if available
3. Consider command logging for security audit trail
4. Review OpenClaw docs for available hook types

### Priority: P2 — Nice to have

---

## 5. Memory & Embeddings

### Current State: 🟡 Default

Using default OpenClaw memory search (memory_search tool). The Substack guide mentions:
- **Local embeddings** for private, free memory search (Appendix B)
- Could reduce API calls for memory lookups

### Recommendation

1. Evaluate local embedding options for memory search
2. If memory search is already fast enough, skip this optimization
3. Monitor memory search quality — if it misses things, local embeddings may help

### Priority: P3 — Optimization, not critical

---

## 6. Skills & Package Management

### Current State: 🟢 Good

- Using pnpm (correct for the repo)
- Skills loaded from OpenClaw default location
- Custom skills possible via skill-creator

### Recommendation

1. Use pnpm for all skill installations (per guide recommendation)
2. Document installed skills in TOOLS.md
3. Consider creating custom skills for recurring workflows

### Priority: P3 — As needed

---

## 7. Action Items

### P0 (Do Today)
- [ ] Move all credentials from markdown files to macOS Keychain
- [ ] Remove plaintext passwords from MEMORY.md and daily notes
- [ ] Verify `.gitignore` excludes any credential files

### P1 (This Week)
- [ ] Set API spending limits on all providers
- [ ] Ryan: Plug in 22TB drive + enable Time Machine
- [ ] Ryan: Sign up for Backblaze ($9/mo)
- [ ] Build + test Docker recovery image

### P2 (This Month)
- [ ] Configure OpenClaw boot hooks
- [ ] Set up command logging
- [ ] Monthly cost review process

### P3 (Eventually)
- [ ] Evaluate local embeddings for memory search
- [ ] Document all installed skills
- [ ] Create custom skills for recurring workflows

---

*Security isn't sexy but losing everything because of one leaked credential is even less sexy. Fix the credentials first, everything else can wait.*
