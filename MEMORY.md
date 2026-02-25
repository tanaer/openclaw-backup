# MEMORY.md - 长期记忆

## 用户偏好

### 进度报告
- **频率**: 每10分钟向用户报告一次任务进度
- **触发条件**: 任务执行时
- **记录时间**: 2026-02-23

### ⚠️ 任务质量要求 (重要！)
- **记录时间**: 2026-02-24
- **三次检查规则**: 每个任务完成后必须做3次定时检查，从不同角度彻底检查系统
- **工作态度**: 必须认真工作，不允许敷衍
- **品牌名称**: 所有界面上的 AxonHub 必须改成 MuskAPI
- **语言包**: 确保中英文语言包完整，不能在中文界面显示英文
- **长任务汇报**: 每 5-10 分钟汇报一次进展（2026-02-24 新增）
- **项目区分**: 开源项目和开发项目要用不同域名
  - 开源项目：直接部署 GitHub 代码
  - 开发项目：自定义开发版本
- **多 Agent 协作**: 2026-02-25 新增
  - **双人制衡模式**：每个任务必须有 2 个 Agent
    - **执行者 (Executor)**: 负责完成任务
    - **审查者 (Reviewer)**: 专门挑刺、质疑、挑战执行结果
  - **审查者职责**:
    - 对执行结果提出挑战和质疑
    - 检查是否完全满足任务要求
    - 督促执行者改进迭代
    - 不满意不放行
  - **循环迭代**: 审查者发现问题 → 执行者修复 → 审查者再检查 → 直到完全达标
  - 使用 CCCC 或 sessions_spawn 实现

## 项目概览

### OpenClaw Config GUI
- **路径**: `/root/.openclaw/workspace/openclaw-config-gui/`
- **端口**: 8091
- **访问**: `http://122.10.119.154:8091`
- **配置文件**: `/root/.openclaw/openclaw.json`
- **备份目录**: `/root/.openclaw/config-backups/`
- **远程 Agent**: 端口 18790, Token: `ur6e04hw07sl0l5jz4z2mobd0wjohaem`

### AxonHub / Muskapi.com
- **路径**: `/root/axonhub/`
- **前端**: React 19 + Vite + TypeScript + Tailwind CSS + Framer Motion
- **后端**: Go + GraphQL
- **认证服务**: Better Auth (Node.js, 端口 3001)
- **前端访问**: `http://122.10.119.154:5173`
- **Landing Page**: `http://122.10.119.154:5173/landing`
- **新域名**: Muskapi.com
- **统计**: 20+ AI 服务商, 100+ 支持模型

## 关键技术决策

### 配置文件安全
- **原子写入**: 写入 `.tmp` 文件后 `fs.renameSync()` 防止损坏
- **服务端验证**: 所有配置变更前验证 JSON schema
- **备份保留**: 保持最后 20 个备份

### 认证架构 (方案3)
- Better Auth 作为独立 Node.js 服务
- 与 Go 后端共享 JWT Secret (存储在 system 表)
- OAuth 流程: 分离 GET 端点 → 回调 → 重定向带 JWT

### Claude Code 环境
- 必须使用 `bash -lc` 或显式设置 PATH
- 使用 `--permission-mode acceptEdits` (非 `--dangerously-skip-permissions`)
- 需要 PTY 环境

### 前端部署
- Vite 必须使用 `--host 0.0.0.0` 允许外部访问
- Provider logos 使用内嵌 SVG (非外部 CDN)

## 待办事项

### Muskapi.com 品牌重塑
- [x] 更新 Hero 组件品牌信息
- [x] 创建定价计划页面
- [x] 集成用户管理系统
- [x] 创建默认管理员用户
- [ ] 集成 Stripe 支付
- [ ] 集成 EPUSDT 支付
- [ ] 配置 Cloudflare DNS (claudeai.best)
- [x] 速率限制与套餐/用户挂钩（三级：用户 > 套餐 > 默认）

### muskapi-v2 项目 (已完成 2026-02-24)
- [x] Logo 更换
- [x] 社交登录集成（Google/GitHub）
- [x] 首页改造（Landing Page）
- [x] 修复 v0.9.8 编译问题（muskapi.graphql）

## Cloudflare 凭证
- **Account ID**: `473accd319d2d827d45fe342c8cc32ad`
- **Zone ID (890214.net)**: `3a8759ee6f736a355a86be3c7700f787`
- **API Token**: `bb0X3bhRY-1u_b0hquAZHngWNvGzffwQ6K9-kgn-`
- **Zone ID (claudeai.best)**: `d101681d241d500769781583c0bc7ffe`
- **API Token (DNS edit)**: `DSKwH7fBq7KsRLEXgMe4-f7MzawUYw2OfFtXscRe`

## CCCC 多智能体协作系统
- **路径**: `/root/.openclaw/workspace/cccc/`
- **虚拟环境**: `/root/.openclaw/workspace/cccc/.venv/`
- **运行时目录**: `~/.cccc/`
- **Web UI**: `http://122.10.119.154:8848`
- **Token**: `cccc2026`
- **版本**: v0.4.0
- **可用运行时**: Claude Code, Codex CLI
- **启动命令**: `. .venv/bin/activate && CCCC_WEB_HOST=0.0.0.0 CCCC_WEB_TOKEN=cccc2026 cccc`
- **协作组**: g_c9581a21c73a (AxonHub 项目)
  - architect (foreman, claude) — 架构设计、任务拆分
  - coder (peer, codex) — 代码实现

## GitHub 凭证
- **Email**: `tanaer@qq.com`
- **PAT**: `【已移除】`
