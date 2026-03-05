# OpenClaw Agent 优化指南

## 核心原则

> **"先把命根子写进硬盘记忆，再允许短期上下文被压缩"**
> 
> 长任务不靠"模型记性好"，而靠"系统先把该留的留住"

---

## 1. Memory Flush 机制

### 问题
- 上下文窗口有限，长对话会被压缩
- 压缩时关键信息可能丢失
- 模型"记性好"不可靠

### 解决方案
在上下文压缩前，主动执行 Memory Flush：
1. 总结关键决策和进展
2. 写入持久化文件（MEMORY.md 或 memory/YYYY-MM-DD.md）
3. 用 `NO_REPLY` 避免打扰用户

### 触发条件
- 用户说"记住这个"
- 做出重要决策
- 学到重要教训
- 长任务的关键节点

---

## 2. 两层持久化

| 文件 | 用途 | 何时读写 |
|------|------|----------|
| `MEMORY.md` | 长期记忆（决策、偏好、教训） | 重要决策时写入 |
| `memory/YYYY-MM-DD.md` | 日常日志 | 每天 append |
| `sessions.json` | 会话元信息 | 系统自动维护 |
| `*.jsonl` | 完整对话历史 | 系统自动维护 |

---

## 3. 树状 Transcript

- 支持分支处理（forkSessionFromParent）
- 支线任务完成后，总结为 `branch_summary` 带回主线
- 主线不被脏活污染

---

## 4. 实践建议

### 写入习惯
```
✅ 正确：立即写入文件
❌ 错误：依赖上下文"记住"
```

### 长任务管理
- 每 5-10 分钟汇报进度
- 关键节点写入文件
- 完成后归档总结

### Memory Flush 模板
```markdown
# YYYY-MM-DD 记忆日志

## 关键决策
- [决策内容]

## 学到的教训
- [教训内容]

## 待办事项
- [ ] [任务]
```

---

## 5. 配置参考

```json
{
  "agents": {
    "defaults": {
      "compaction": {
        "reserveTokensFloor": 20000,
        "memoryFlush": {
          "enabled": true,
          "softThresholdTokens": 4000,
          "systemPrompt": "Session nearing compaction. Store durable memories now.",
          "prompt": "Write any lasting notes to memory/YYYY-MM-DD.md; reply with NO_REPLY if nothing to store."
        }
      }
    }
  }
}
```

---

## 总结

| 之前 | 优化后 |
|------|--------|
| 依赖上下文记忆 | 主动写入文件 |
| 长对话容易丢失信息 | Memory Flush 保护关键信息 |
| 被动等待压缩 | 主动管理记忆 |

**核心理念：文件是真正的记忆，上下文只是临时缓存！**

---

*Generated: 2026-03-04*
