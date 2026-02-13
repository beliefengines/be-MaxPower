# OpenClaw Engineering Bot — Local Setup Plan

**Purpose:** Set up a second OpenClaw instance on Ryan's M3 Max Mac for the engineering team to use as a coding/building agent that works from our specs and PRDs.

**Machine:** Mac M3 Max, 30GB+ RAM, macOS  
**Runtime:** Docker (containerized gateway + daily backups)

---

## Table of Contents

- [1. Prerequisites](#1-prerequisites)
- [2. Install Docker](#2-install-docker)
- [3. Clone & Build OpenClaw](#3-clone--build-openclaw)
- [4. Configure the Engineering Agent](#4-configure-the-engineering-agent)
- [5. Connect Channels](#5-connect-channels)
- [6. Workspace Setup](#6-workspace-setup)
- [7. Backup Strategy](#7-backup-strategy)
- [8. Security Hardening](#8-security-hardening)
- [9. Maintenance](#9-maintenance)
- [10. Troubleshooting](#10-troubleshooting)
- [Appendix: Cost](#appendix-cost)

---

## 1. Prerequisites

| Requirement | Version | Check |
|------------|---------|-------|
| macOS | 14+ (Sonoma/Sequoia) | `sw_vers` |
| Docker Desktop | Latest | `docker --version` |
| Git | 2.x+ | `git --version` |
| Node.js | 22+ | `node --version` (only if running from source) |
| Anthropic API key | — | For Claude access |

**Estimated setup time:** 30-45 minutes

---

## 2. Install Docker

If Docker Desktop is not already installed:

```bash
# Option A: Download from docker.com
# https://www.docker.com/products/docker-desktop/

# Option B: Homebrew
brew install --cask docker

# Verify
docker --version
docker compose version
```

**Docker Desktop settings (recommended for M3 Max):**
- CPUs: 4 (leave rest for host)
- Memory: 8GB (plenty for OpenClaw)
- Disk: 30GB

---

## 3. Clone & Build OpenClaw

```bash
# Choose install location
mkdir -p ~/openclaw-eng && cd ~/openclaw-eng

# Clone the repo
git clone https://github.com/openclaw/openclaw .

# Run the automated setup script
./docker-setup.sh
```

**What `docker-setup.sh` does automatically:**
1. Builds the Docker image (`openclaw:local`)
2. Runs the onboarding wizard (API key setup, channel config)
3. Generates a gateway token + writes to `.env`
4. Starts the gateway via Docker Compose

**After setup completes:**
- Open `http://127.0.0.1:18789/` in browser
- Paste the gateway token into Control UI (Settings → token)
- If you need the token again: `docker compose run --rm openclaw-cli dashboard --no-open`

---

## 4. Configure the Engineering Agent

### 4.1 Set API Keys as Secrets

Edit `~/.openclaw/openclaw.json` (or use the Control UI):

```json5
{
  "env": {
    "ANTHROPIC_API_KEY": "sk-ant-...",
    // Optional: for embeddings, web search, etc.
    "OPENAI_API_KEY": "sk-...",
    "BRAVE_API_KEY": "BSA..."
  },
  "models": {
    "default": "anthropic/claude-sonnet-4-20250514"
  }
}
```

### 4.2 Agent Identity

Create `~/.openclaw/workspace/SOUL.md`:

```markdown
# Engineering Agent — Belief Engines

You are the engineering agent for Belief Engines. Your job is to build 
features from specs and PRDs. You write clean, tested TypeScript/Python code.

## Your repos
- be-bitcoinology-v1 (Next.js frontend — PRIMARY)
- be-podcast-etl (Python pipeline)
- be-flow-dtd (Python DTD pipeline)

## Rules
- Always read the relevant spec/PRD before coding
- Write tests for new code
- Use pnpm (not npm) for JS projects
- Create PRs, never push directly to main
- Ask before making breaking changes
```

### 4.3 Mount Project Repos

Set `OPENCLAW_EXTRA_MOUNTS` so the agent can access the codebase:

```bash
export OPENCLAW_EXTRA_MOUNTS="$HOME/repos/beliefengines:/home/node/repos:rw"
./docker-setup.sh  # Re-run to apply mounts
```

Or if repos are already cloned elsewhere, adjust the path accordingly.

---

## 5. Connect Channels

### Option A: Telegram Bot (recommended for team)

1. Create a new bot via [@BotFather](https://t.me/BotFather) — name it something like `@BE_EngineerBot`
2. Get the bot token
3. Configure in `~/.openclaw/openclaw.json`:

```json5
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "BOT_TOKEN_HERE"
    }
  }
}
```

4. Restart: `docker compose restart openclaw-gateway`

### Option B: Control UI Only (simplest)

Just use the web UI at `http://127.0.0.1:18789` — no channel setup needed.

### Option C: Discord Channel

See: https://docs.openclaw.ai/channels/discord

---

## 6. Workspace Setup

The workspace is where the agent's memory, skills, and context live.

```bash
# The workspace directory
ls ~/.openclaw/workspace/

# Clone our specs into the workspace so the agent has context
cd ~/.openclaw/workspace
git clone https://github.com/beliefengines/be-MaxPower specs-reference

# Create the agent's working files
cat > AGENTS.md << 'EOF'
# Engineering Agent

## On Every Session
1. Read SOUL.md — who you are
2. Check current tasks in TASKS.md
3. Read the relevant spec before coding

## Memory
- Daily notes: memory/YYYY-MM-DD.md
- Task tracking: TASKS.md
EOF
```

### Link the PRD + Specs

The agent should have easy access to:
- `be-MaxPower/PRD_BITCOINOLOGY_V2.md` — the master PRD
- `be-MaxPower/specs/DESIGN_REQUIREMENTS.md` — component specs
- `be-MaxPower/specs/AGENT_BLUEPRINT.md` — agent architecture
- `be-MaxPower/designs/` — all mockups

Either mount the be-MaxPower repo directly or symlink it into the workspace.

---

## 7. Backup Strategy

### 7.1 What to Back Up

| Path | Contents | Critical? |
|------|----------|-----------|
| `~/.openclaw/` | Config, credentials, agent state | ✅ Yes |
| `~/.openclaw/workspace/` | Skills, memories, prompts | ✅ Yes |
| `~/.openclaw/agents/` | Session transcripts | Nice to have |
| `~/.openclaw/credentials/` | Channel auth tokens | ✅ Yes |

### 7.2 Daily Backup Script

Create `~/scripts/backup-openclaw.sh`:

```bash
#!/bin/bash
# OpenClaw Engineering Bot — Daily Backup
# Runs via cron at 3 AM daily

BACKUP_DIR="$HOME/backups/openclaw-eng"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/openclaw-eng-$TIMESTAMP.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create compressed backup
tar czf "$BACKUP_FILE" \
  -C "$HOME" \
  .openclaw/openclaw.json \
  .openclaw/workspace/ \
  .openclaw/agents/ \
  .openclaw/credentials/ \
  .openclaw/.env \
  2>/dev/null

# Calculate size
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo "$(date): Backup created: $BACKUP_FILE ($SIZE)"

# Retain last 7 days of backups
find "$BACKUP_DIR" -name "openclaw-eng-*.tar.gz" -mtime +7 -delete
echo "$(date): Old backups cleaned (keeping 7 days)"
```

Make executable and schedule:

```bash
chmod +x ~/scripts/backup-openclaw.sh

# Add to crontab — runs daily at 3 AM
crontab -e
# Add this line:
0 3 * * * $HOME/scripts/backup-openclaw.sh >> $HOME/backups/openclaw-eng/backup.log 2>&1
```

### 7.3 Restore from Backup

```bash
# List available backups
ls -la ~/backups/openclaw-eng/

# Stop the gateway
docker compose -f ~/openclaw-eng/docker-compose.yml down

# Restore
cd ~
tar xzf ~/backups/openclaw-eng/openclaw-eng-YYYYMMDD-HHMMSS.tar.gz

# Restart
docker compose -f ~/openclaw-eng/docker-compose.yml up -d openclaw-gateway
```

### 7.4 Optional: Git-backed Workspace

For version-controlled workspace (recommended):

```bash
cd ~/.openclaw/workspace
git init
git remote add origin https://github.com/beliefengines/openclaw-eng-workspace.git  # private repo
git add -A && git commit -m "initial workspace"
git push -u origin main

# Add auto-commit to backup script:
cd ~/.openclaw/workspace && git add -A && git commit -m "auto-backup $(date +%Y%m%d)" && git push
```

---

## 8. Security Hardening

### 8.1 API Key Safety

- ✅ API keys in `openclaw.json` env block or `~/.openclaw/.env` — NOT in repos
- ✅ Backups contain credentials — store backup directory with restricted permissions:
  ```bash
  chmod 700 ~/backups/openclaw-eng/
  ```
- ✅ If using git-backed workspace, add `.env` and `credentials/` to `.gitignore`

### 8.2 Docker Isolation

- The agent runs inside a Docker container — it can't access host system outside mounted volumes
- Only mount what the agent needs (project repos, workspace)
- Use `:ro` (read-only) mounts for repos you don't want the agent modifying:
  ```
  OPENCLAW_EXTRA_MOUNTS="$HOME/repos/beliefengines:/home/node/repos:ro"
  ```
- Use `:rw` if the agent should be able to create branches and commit

### 8.3 Network

- Gateway binds to `127.0.0.1:18789` by default — localhost only, not exposed to network
- If you need remote access (e.g., via Tailscale), add to `docker-compose.yml`:
  ```yaml
  ports:
    - "100.x.x.x:18789:18789"  # Tailscale IP only
  ```

### 8.4 Model Access Control

Limit which models the agent can use (control costs):

```json5
{
  "models": {
    "default": "anthropic/claude-sonnet-4-20250514",
    "allowlist": [
      "anthropic/claude-sonnet-4-20250514",
      "anthropic/claude-haiku-3-5-20241022"
    ]
  }
}
```

---

## 9. Maintenance

### 9.1 Update OpenClaw

```bash
cd ~/openclaw-eng
git pull
docker compose build openclaw-gateway
docker compose up -d openclaw-gateway
```

### 9.2 Monitor Logs

```bash
# Live logs
docker compose logs -f openclaw-gateway

# Recent errors
docker compose logs openclaw-gateway --since 1h | grep -i error
```

### 9.3 Check Health

```bash
# From host (if openclaw CLI is installed globally)
openclaw health

# Or via Docker
docker compose run --rm openclaw-cli health
```

### 9.4 Restart if Stuck

```bash
docker compose restart openclaw-gateway
```

---

## 10. Troubleshooting

| Issue | Fix |
|-------|-----|
| "unauthorized" in Control UI | Run `docker compose run --rm openclaw-cli dashboard --no-open` to get fresh token |
| "disconnected (1008): pairing required" | `docker compose run --rm openclaw-cli devices list` then `devices approve <requestId>` |
| Agent can't see repos | Check `OPENCLAW_EXTRA_MOUNTS` path and re-run `docker-setup.sh` |
| High memory usage | Check Docker Desktop settings, limit to 8GB |
| Gateway won't start | Check logs: `docker compose logs openclaw-gateway` — usually missing API key |
| Port 18789 in use | Another OpenClaw instance running. Stop it or change port in config. |

---

## Appendix: Cost

| Item | Cost |
|------|------|
| Docker Desktop | Free (personal) |
| OpenClaw | Free (open source) |
| Anthropic API (Claude) | ~$3-15/day depending on usage |
| Infrastructure | $0 (runs on your Mac) |
| Backups | $0 (local disk) |

**Total infrastructure cost: $0/month** (just API usage)

vs. Fly.io would have been ~$6-11/month for the same thing.

---

## Quick Reference

```bash
# Start
cd ~/openclaw-eng && docker compose up -d

# Stop
docker compose down

# Logs
docker compose logs -f openclaw-gateway

# Restart
docker compose restart openclaw-gateway

# Backup (manual)
~/scripts/backup-openclaw.sh

# Update
git pull && docker compose build && docker compose up -d

# Dashboard token
docker compose run --rm openclaw-cli dashboard --no-open
```

---

**Docs:**
- Setup: https://docs.openclaw.ai/install/docker
- Config: https://docs.openclaw.ai/gateway/configuration
- Env vars: https://docs.openclaw.ai/help/environment
- Full guide: https://docs.openclaw.ai/start/setup
- Security: https://docs.openclaw.ai/gateway/security

---

*Prepared by Max Power ⚡ — Belief Engines*
