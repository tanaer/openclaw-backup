#!/bin/bash
# 心跳脚本 - 向 Agent Hub 发送心跳
AGENT_ID="hklxbot"
API_URL="https://chat.890214.net/api/heartbeat"
LOG_FILE="/root/.openclaw/heartbeat.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -d "{\"sender\":\"$AGENT_ID\",\"note\":\"在线 - OpenClaw 主节点\"}" 2>/dev/null)

if echo "$RESPONSE" | grep -q "success"; then
  log "心跳发送成功"
else
  log "心跳发送失败: $RESPONSE"
fi
