#!/bin/bash
# Nightly backup of Max Power's workspace to GitHub
set -e

WORKSPACE="$HOME/.openclaw/workspace"
BACKUP_REPO="$WORKSPACE/repos/be-MaxPower"
TIMESTAMP=$(date +%Y-%m-%d_%H%M)

# Copy memory files
mkdir -p "$BACKUP_REPO/workspace-backup/memory"
cp -f "$WORKSPACE/MEMORY.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -f "$WORKSPACE/SOUL.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -f "$WORKSPACE/AGENTS.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -f "$WORKSPACE/IDENTITY.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -f "$WORKSPACE/USER.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -f "$WORKSPACE/TOOLS.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -f "$WORKSPACE/HEARTBEAT.md" "$BACKUP_REPO/workspace-backup/" 2>/dev/null || true
cp -rf "$WORKSPACE/memory/"* "$BACKUP_REPO/workspace-backup/memory/" 2>/dev/null || true

# NOTE: Session transcripts excluded from GitHub backup (contain API keys/secrets)
# Sessions backed up via Time Machine + Backblaze only

# Commit and push
cd "$BACKUP_REPO"
git add -A
git diff --cached --quiet || git commit -m "backup: workspace $TIMESTAMP"
git push origin main 2>/dev/null || true

echo "Backup complete: $TIMESTAMP"
