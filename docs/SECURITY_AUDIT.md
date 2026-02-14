# Security & Data Audit — Bitcoinology / Belief Engines

**Author:** Max Power ⚡  
**Date:** 2026-02-11  
**Status:** Initial assessment — needs Ryan's input on some items

---

## 1. Supabase Data Protection

### Current State
- Supabase is the primary datastore (Postgres + Auth + Storage)
- Contains: user accounts, threads, transcription data, beliefs
- Used by: be-bitcoinology-v1 (frontend), be-podcast-etl (writes), be-flow-dtd (writes)

### Recommendations

#### Backups
- [ ] **Enable Point-in-Time Recovery (PITR)** — Supabase Pro plan includes this. Allows recovery to any point in the last 7 days
- [ ] **Daily logical backups** — `pg_dump` cron job to cloud storage (S3/GCS) with 30-day retention
- [ ] **Test restore procedure** — backups are useless if we haven't tested restoring them

#### Access Controls
- [ ] **Review all Supabase API keys** — anon key vs service_role key usage
- [ ] **Row-Level Security (RLS)** — verify RLS is enabled on ALL tables
- [ ] **Max Power (me) should have read-only access** to production data via a separate service role
- [ ] **No DELETE permissions** for pipeline service accounts — append-only pattern
- [ ] **Audit who has the service_role key** — this bypasses RLS

#### Data Immutability
- [ ] **Soft deletes only** — add `deleted_at` column instead of actual DELETEs
- [ ] **Audit log table** — track all writes with timestamp, user, action
- [ ] **Consider Supabase Vault** for encrypting sensitive columns

---

## 2. GitHub Repository Security

### Current State
- 5 repos under `beliefengines` org
- 2 members: @goonerstrike (Ryan), @maxpower-be (Max)
- Classic PAT created for Max (repo scope, 30-day expiry — expires Mar 13, 2026)

### Recommendations
- [ ] **Enable branch protection on `main`** — require PR reviews, no direct pushes
- [ ] **Enable 2FA** on both GitHub accounts
- [ ] **Rotate Max's PAT to fine-grained token** once org approves (more scoped)
- [ ] **Add `.env` to .gitignore** (already done ✅)
- [ ] **Check for leaked secrets** — run `git log --all -p | grep -i "api_key\|secret\|password"` on all repos
- [ ] **Set up Dependabot** for dependency vulnerability alerts

---

## 3. Pipeline Security (be-flow-dtd, be-podcast-etl)

### Current State
- be-flow-dtd runs on bare metal (Ryan's machine), constantly
- be-podcast-etl runs on-demand
- Both write to Supabase

### Recommendations
- [ ] **Dedicated service account per pipeline** — separate Supabase credentials, minimal permissions
- [ ] **Pipeline should NOT have DROP TABLE or DELETE permissions**
- [ ] **State tracking** — DTD uses SQLite locally; ensure this is backed up too
- [ ] **Log retention** — pipeline logs should be stored for at least 30 days
- [ ] **Alerting** — notify on pipeline failures (Slack/Telegram webhook)

---

## 4. Inference Data (Expensive Stuff)

### What costs real money to recreate:
| Data | Est. Cost to Recreate | Location |
|------|----------------------|----------|
| Transcriptions (Whisper) | GPU hours, significant | Supabase Storage |
| Belief extractions | OpenAI API costs | Supabase DB |
| Embeddings (1536-dim) | OpenAI API costs | Qdrant + Parquet |
| Speaker diarization | GPU hours | Supabase Storage |

### Recommendations
- [ ] **HuggingFace as secondary store** — push processed datasets regularly (already planned)
- [ ] **Qdrant snapshots** — enable automatic snapshots in Qdrant Cloud settings
- [ ] **Parquet files on S3/GCS** — don't rely solely on Supabase Storage
- [ ] **Version the dataset** — tag releases on HuggingFace so we can roll back

---

## 5. Environment Variables & Secrets

### Current .env.example shows these are needed:
- OpenAI API key
- Anthropic API key  
- Supabase URL + keys
- Qdrant URL + API key
- Google OAuth credentials
- Various other service keys

### Recommendations
- [ ] **Use a secrets manager** — even if just Supabase Vault or GitHub Secrets for CI
- [ ] **Never commit .env files** — verified .gitignore covers this
- [ ] **Rotate API keys** on a schedule (quarterly minimum)
- [ ] **Age-encrypted .env** — I see `.env.age` in bitcoinology repo, good practice ✅

---

## 6. Action Items for Ryan

1. **What Supabase plan are you on?** (Free/Pro/Team) — determines backup options
2. **Who else has access to the Supabase dashboard?** 
3. **Is the bare metal machine (DTD) backed up?** SQLite state DB?
4. **Do you want me to set up branch protection rules on the repos?**
5. **Should I create a read-only Supabase service role for myself?**

---

## Priority Matrix

| Item | Impact | Effort | Priority |
|------|--------|--------|----------|
| Enable PITR on Supabase | Critical | Low (config change) | P0 |
| Branch protection on main | High | Low | P0 |
| Pipeline no-delete permissions | Critical | Medium | P0 |
| 2FA on GitHub accounts | High | Low | P1 |
| Daily backup cron | High | Medium | P1 |
| Qdrant snapshots | High | Low | P1 |
| Read-only role for Max | Medium | Low | P2 |
| Secrets rotation schedule | Medium | Low | P2 |
| Full audit log table | Medium | Medium | P2 |
