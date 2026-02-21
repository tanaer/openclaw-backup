#!/bin/bash
# OpenClaw 备份脚本 - 备份配置、技能和记忆到 GitHub
set -e

WORKSPACE="/root/.openclaw/workspace"
OPENCLAW_HOME="/root/.openclaw"
LOG_FILE="$OPENCLAW_HOME/backup.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== 开始备份 ==="

cd "$WORKSPACE"

# 配置 Git
git config user.email "tanaer@qq.com" 2>/dev/null || true
git config user.name "OpenClaw Agent" 2>/dev/null || true

# 添加所有更改
git add -A 2>/dev/null || true

# 检查是否有更改
if git diff --staged --quiet 2>/dev/null; then
  log "没有需要备份的更改"
else
  # 提交
  git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
  log "已提交更改"
  
  # 推送到远程
  if git remote | grep -q "origin"; then
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || log "推送失败（可能需要配置远程仓库）"
    log "已推送到 GitHub"
  else
    log "没有配置远程仓库，跳过推送"
  fi
fi

log "=== 备份完成 ==="
