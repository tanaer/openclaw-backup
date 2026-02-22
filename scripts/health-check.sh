#!/bin/bash
# 健康检查脚本 - 检查关键服务状态
LOG_FILE="/root/.openclaw/health.log"
ALERT_URL="http://chat.890214.net:80/api/chat"
AGENT_ID="hklxbot"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

send_alert() {
  curl -s -X POST "$ALERT_URL" \
    -H "Content-Type: application/json" \
    -d "{\"sender\":\"$AGENT_ID\",\"text\":\"[HEALTH] $1\"}" >/dev/null 2>&1
}

log "=== 开始健康检查 ==="

ISSUES=""

# 检查 OpenClaw Gateway
if ! pgrep -f "openclaw-gateway" > /dev/null; then
  ISSUES="$ISSUES OpenClaw Gateway 未运行"
  log "⚠️ OpenClaw Gateway 未运行"
fi

# 检查 HelpClaw (端口 9000)
if ! ss -ltnp | grep -q ":9000"; then
  ISSUES="$ISSUES HelpClaw (9000) 未运行"
  log "⚠️ HelpClaw (9000) 未运行"
fi

# 检查 AxonHub (端口 8090)
if ! ss -ltnp | grep -q ":8090"; then
  ISSUES="$ISSUES AxonHub (8090) 未运行"
  log "⚠️ AxonHub (8090) 未运行"
fi

# 检查前端 (端口 5173)
if ! ss -ltnp | grep -q ":5173"; then
  ISSUES="$ISSUES Vite 前端 (5173) 未运行"
  log "⚠️ Vite 前端 (5173) 未运行"
fi

# 检查磁盘空间
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 80 ]; then
  ISSUES="$ISSUES 磁盘使用率 ${DISK_USAGE}%"
  log "⚠️ 磁盘使用率: ${DISK_USAGE}%"
fi

# 发送告警
if [ -n "$ISSUES" ]; then
  send_alert "检测到问题:$ISSUES"
  log "已发送告警"
else
  log "✅ 所有服务正常"
fi

log "=== 健康检查完成 ==="
