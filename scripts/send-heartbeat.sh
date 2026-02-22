#!/bin/bash
# 心跳脚本 - 向 Agent Hub 发送心跳 + 检查消息队列
AGENT_ID="hklxbot"
API_URL="http://chat.890214.net:80/api/heartbeat"
LOG_FILE="/root/.openclaw/heartbeat.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 1. 发送心跳
RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -d "{\"sender\":\"$AGENT_ID\",\"note\":\"在线 - OpenClaw 主节点\"}" 2>/dev/null)

if echo "$RESPONSE" | grep -qi '"ok"\|"status".*"ok"'; then
  log "心跳发送成功: $RESPONSE"
else
  log "心跳发送失败: $RESPONSE"
fi

# 2. 检查 OpenClaw Bus 消息队列
echo "=== 检查消息队列 ==="
cd /root/.openclaw/workspace/skills/openclaw-bus
python3 check_queue.py 2>/dev/null
