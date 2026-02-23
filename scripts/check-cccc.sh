#!/bin/bash
# CCCC 协作监督脚本
# 每4小时运行一次，检查协作组状态

LEDGER="/root/.cccc/groups/g_c9581a21c73a/ledger.jsonl"
NOW=$(date +%s)

# 获取最后一条非系统消息
LAST_ACT=$(grep -v '"system"' "$LEDGER" | tail -1)
LAST_TS=$(echo "$LAST_ACT" | python3 -c "import sys,json; d=json.loads(sys.stdin.read()); print(d.get('ts',''))" 2>/dev/null)

if [ -z "$LAST_TS" ]; then
    echo "⚠️ 无法获取最后活动时间"
    exit 1
fi

# 计算空闲时间（秒）
LAST_EPOCH=$(date -d "${LAST_TS}" +%s 2>/dev/null || echo $NOW)
IDLE_SECONDS=$((NOW - LAST_EPOCH))
IDLE_MINUTES=$((IDLE_SECONDS / 60))

echo "CCCC 协作组状态:"
echo "  最后活动: $LAST_TS"
echo "  空闲时间: ${IDLE_MINUTES} 分钟"

# 检查 coder 是否卡住
CODER_IDLE=$(grep "coder has been quiet" "$LEDGER" | tail -1 | grep -oP 'quiet for \K[0-9]+')

if [ -n "$CODER_IDLE" ] && [ "$CODER_IDLE" -gt 1800 ]; then
    echo "🚨 警告: coder 已空闲 ${CODER_IDLE} 秒 (超过30分钟)"
    echo "需要: architect 分配具体任务"
fi

# 输出最近5条重要事件
echo ""
echo "最近事件:"
tail -5 "$LEDGER" | python3 -c "
import sys, json
for line in sys.stdin:
    d = json.loads(line.strip())
    ts = d.get('ts','')[:19]
    kind = d.get('kind','')
    print(f'  {ts} | {kind}')
"
