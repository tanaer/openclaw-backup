# LEARNINGS.md

记录纠正、知识差距、最佳实践。格式见 self-improving-agent 技能。

---

## [LRN-20260227-001] correction

**Logged**: 2026-02-27T05:38:00Z
**Priority**: high
**Status**: resolved
**Area**: config

### Summary
cron 任务 model 配置必须使用允许列表中的模型别名

### Details
`task-progress-report` cron 任务使用了 `aihub-glm5/glm-5` 模型，导致连续失败 79 次。
错误信息：`model not allowed: aihub-glm5/glm-5`
修复：改为 `zai/glm-5`

### Metadata
- Source: error
- Related Files: cron job `233085c9-e6fd-4c6d-b015-bd00fd0c4a12`
- Tags: cron, model, config

### Resolution
- **Resolved**: 2026-02-27T05:38:00Z
- **Notes**: 更新 cron 任务的 model 字段为允许的模型别名

---

## [LRN-20260227-002] best_practice

**Logged**: 2026-02-27T05:40:00Z
**Priority**: medium
**Status**: promoted
**Area**: config

### Summary
设置每日自动更新 cron 任务保持技能最新

### Details
安装了 auto-updater 技能，并配置了每日凌晨 5 点自动运行 `clawhub update --all` 更新所有已安装技能，确保始终使用最新版本。

### Metadata
- Source: user_feedback
- Tags: cron, skills, auto-update
- Pattern-Key: maintenance.auto_update

### Resolution
- **Resolved**: 2026-02-27T05:40:00Z
- **Promoted**: cron job `3fcc322d-f75e-4fcd-8324-1f3a0e6f63e1`

---
