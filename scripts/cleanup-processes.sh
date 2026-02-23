#!/bin/bash
# 定期清理无用或卡住的进程

echo "=== 进程清理报告 $(date) ==="

# 1. 检查僵尸进程
zombie_count=$(ps aux | awk '$8 ~ /Z/ {count++} END {print count+0}')
if [ "$zombie_count" -gt 0 ]; then
    echo "⚠️ 发现 $zombie_count 个僵尸进程"
    ps aux | awk '$8 ~ /Z/ {print $2, $11}'
else
    echo "✅ 无僵尸进程"
fi

# 2. 清理长时间卡住的 claude 进程（超过 24 小时）
claude_pids=$(ps aux | grep "claude" | grep -v grep | awk '{print $2}')
for pid in $claude_pids; do
    runtime=$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ -n "$runtime" ] && [ "$runtime" -gt 86400 ]; then
        echo "🧹 终止长时间运行的 claude 进程 (PID: $pid, 运行时间: $((runtime/3600))小时)"
        kill "$pid" 2>/dev/null
    fi
done

# 3. 清理孤立的 node 进程（没有父进程）
orphan_nodes=$(ps aux | awk '$11 ~ /node/ && $8 ~ /S/ {print $2}')
for pid in $orphan_nodes; do
    ppid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ "$ppid" = "1" ] || [ -z "$ppid" ]; then
        # 检查是否是重要服务
        cmd=$(ps -o cmd= -p "$pid" 2>/dev/null)
        if [[ "$cmd" != *"vite"* ]] && [[ "$cmd" != *"axonhub"* ]] && [[ "$cmd" != *"tsx"* ]]; then
            echo "🧹 发现孤立 node 进程 (PID: $pid)"
        fi
    fi
done

# 4. 报告高内存进程（超过 10%）
echo ""
echo "📊 高内存进程 (>10%):"
ps aux --sort=-%mem | head -5 | awk 'NR>1 {printf "  %-12s %5s %5s %s\n", $1, $4"%", $6/1024"M", $11}'

# 5. 报告高 CPU 进程（超过 50%）
echo ""
echo "📊 高 CPU 进程 (>50%):"
ps aux --sort=-%cpu | awk 'NR>1 && $3>50 {printf "  %-12s %5s %s\n", $1, $3"%", $11}'

echo ""
echo "✅ 清理完成"
