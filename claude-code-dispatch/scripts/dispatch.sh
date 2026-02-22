#!/bin/bash
# dispatch.sh — Dispatch a task to Claude Code with auto-callback (root environment)
#
# Usage:
#   dispatch.sh [OPTIONS] -p "your prompt here"
#
# Options:
#   -p, --prompt TEXT        Task prompt (required)
#   -n, --name NAME          Task name (for tracking)
#   -g, --group ID           Telegram group ID for result delivery
#   -s, --session KEY        Callback session key (AGI session to notify)
#   -w, --workdir DIR        Working directory for Claude Code
#   --model MODEL            Model override

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULT_DIR="/root/.openclaw/data/claude-code-results"
META_FILE="${RESULT_DIR}/task-meta.json"
TASK_OUTPUT="${RESULT_DIR}/task-output.txt"

# Claude Code 路径（显式设置，解决 PTY 环境问题）
export PATH="/root/.nvm/versions/node/v24.13.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
CLAUDE_BIN="/root/.nvm/versions/node/v24.13.1/bin/claude"

# Defaults
PROMPT=""
TASK_NAME="adhoc-$(date +%s)"
TELEGRAM_GROUP=""
CALLBACK_SESSION=""
WORKDIR="/root/.openclaw/workspace"
MODEL=""

# Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--prompt) PROMPT="$2"; shift 2;;
        -n|--name) TASK_NAME="$2"; shift 2;;
        -g|--group) TELEGRAM_GROUP="$2"; shift 2;;
        -s|--session) CALLBACK_SESSION="$2"; shift 2;;
        -w|--workdir) WORKDIR="$2"; shift 2;;
        --model) MODEL="$2"; shift 2;;
        *) echo "Unknown option: $1" >&2; exit 1;;
    esac
done

if [ -z "$PROMPT" ]; then
    echo "Error: --prompt is required" >&2
    exit 1
fi

# ---- 1. Write task metadata ----
mkdir -p "$RESULT_DIR"

cat > "$META_FILE" << EOF
{
  "task_name": "$TASK_NAME",
  "telegram_group": "$TELEGRAM_GROUP",
  "callback_session": "$CALLBACK_SESSION",
  "prompt": "$PROMPT",
  "workdir": "$WORKDIR",
  "started_at": "$(date -Iseconds)",
  "status": "running"
}
EOF

echo "📋 Task metadata written: $META_FILE"
echo "   Task: $TASK_NAME"
echo "   Workdir: $WORKDIR"

# ---- 2. Clear previous output ----
> "$TASK_OUTPUT"

# ---- 3. Set environment ----
export OPENCLAW_GATEWAY_TOKEN="${OPENCLAW_GATEWAY_TOKEN:-477d47934e5f6b02bfb823ba681bb743eae55479b7d260e8}"
export OPENCLAW_GATEWAY="${OPENCLAW_GATEWAY:-http://127.0.0.1:18789}"

# ---- 4. Build Claude Code command ----
CMD=("$CLAUDE_BIN" --print -p "$PROMPT")

if [ -n "$MODEL" ]; then
    CMD+=(--model "$MODEL")
fi

# ---- 5. Run Claude Code ----
echo "🚀 Launching Claude Code..."
echo "   PATH: $PATH"
echo "   Command: $CLAUDE_BIN --print -p \"$PROMPT\""
echo ""

# 使用 script 命令提供 PTY 环境
cd "$WORKDIR"
script -q -c "$CLAUDE_BIN --print -p \"$PROMPT\"" /dev/null 2>&1 | tee "$TASK_OUTPUT"
EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo "✅ Claude Code exited with code: $EXIT_CODE"
echo "   Results: ${RESULT_DIR}/latest.json"

# Update meta with completion
if [ -f "$META_FILE" ]; then
    cat > "$META_FILE" << EOF
{
  "task_name": "$TASK_NAME",
  "telegram_group": "$TELEGRAM_GROUP",
  "callback_session": "$CALLBACK_SESSION",
  "prompt": "$PROMPT",
  "workdir": "$WORKDIR",
  "started_at": "$(date -Iseconds)",
  "completed_at": "$(date -Iseconds)",
  "exit_code": $EXIT_CODE,
  "status": "done"
}
EOF
fi

exit $EXIT_CODE
