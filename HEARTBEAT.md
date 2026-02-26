# HEARTBEAT.md

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

## 🔍 开发后必检清单 (双人制衡)
每次开发完成后必须检查：
- [ ] 前端已构建: `cd frontend && pnpm build`
- [ ] 已部署静态文件: `cp -r dist/* ../internal/server/static/dist/`
- [ ] 服务已重启: `systemctl restart axonhub-dev`
- [ ] 外部访问测试: `curl https://dev.claudeai.best/新路由`
- [ ] API 功能测试: 实际调用 API 验证

## 技术研发组监督
检查技术研发组状态：
- 运行: python3 /root/.openclaw/workspace/skills/team-tasks/scripts/task_manager.py list
- 如果有进行中的项目，检查进度
- 如果任务停滞，重新激活或向老板汇报

## 当前项目状态
- axonhub-features (支付集成): ✅ 已完成
- axonhub (项目检查): ✅ 已完成
- muskapi-auth (认证重构): ✅ 已完成 (3/3)
- muskapi-v2 (v2.0 升级): ✅ 已完成
