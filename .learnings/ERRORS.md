# ERRORS.md

记录命令失败、异常、外部 API 错误。格式见 self-improving-agent 技能。

---

## [ERR-20260227-001] task-progress-report

**Logged**: 2026-02-27T05:38:00Z
**Priority**: high
**Status**: resolved
**Area**: config

### Summary
cron 任务连续失败 79 次，模型不允许

### Error
```
model not allowed: aihub-glm5/glm-5
```

### Context
- cron job: `task-progress-report` (233085c9-e6fd-4c6d-b015-bd00fd0c4a12)
- 使用的模型: `aihub-glm5/glm-5`
- 每隔 10 分钟运行一次

### Suggested Fix
使用允许列表中的模型别名，如 `zai/glm-5`

### Metadata
- Reproducible: yes
- See Also: LRN-20260227-001

### Resolution
- **Resolved**: 2026-02-27T05:38:00Z
- **Notes**: 已更新为 `zai/glm-5`

---
