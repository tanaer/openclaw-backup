# MEMORY.md - 长期记忆

## ⚠️⚠️⚠️ 最高优先级规则 ⚠️⚠️⚠️

### 🔴🔴 长期任务进度汇报 (排第二重要！)
- **记录时间**: 2026-02-26
- **规则**: 长期任务执行时，每 5-10 分钟必须向用户汇报一次进度
- **汇报内容**: 已完成、进行中、下一步、预计完成时间
- **重要性**: 排第二，仅次於双人制衡模式

### 🔴 双人制衡模式 (绝对不可违反！)
- **记录时间**: 2026-02-25
- **违反后果**: 导致功能未部署、404错误等严重问题
- **规则**: 每个开发任务必须有 2 个角色参与
  - **执行者 (Executor)**: 负责完成任务 (当前模型)
  - **审查者 (Reviewer)**: 专门挑刺、质疑、挑战执行结果
- **审查者模型**: `qwen3-max-2026-01-23`
- **审查者职责**:
  - 对执行结果提出挑战和质疑
  - 检查是否完全满足任务要求
  - 督促执行者改进迭代
  - **不满意不放行**
- **开发后必检清单**:
  - [ ] 前端已构建: `cd frontend && pnpm build`
  - [ ] 已部署静态文件: `cp -r dist/* ../internal/server/static/dist/`
  - [ ] 服务已重启: `systemctl restart axonhub-dev`
  - [ ] 外部访问测试: `curl https://dev.claudeai.best/新路由`
  - [ ] API 功能测试: 实际调用 API 验证
- **循环迭代**: 审查者发现问题 → 执行者修复 → 审查者再检查 → 直到完全达标
- **审查触发方式**: 使用 sessions_spawn 调用 reviewer-agent (qwen3-max 模型)
- **代码模型**: code-agent 使用 `zai/glm-5` (GLM-5)

---

## 工作方法论

### 💾 Memory Flush - 先写再压缩 (重要！)
- **记录时间**: 2026-03-04
- **核心原则**: "先把命根子写进硬盘记忆，再允许短期上下文被压缩"
- **规则**: 
  - 长任务不靠"模型记性好"，而靠"系统先把该留的留住"
  - 关键决策、重要信息必须立即写入文件
  - 不要依赖上下文"记住"事情
- **触发条件**:
  - 用户说"记住这个"
  - 做出重要决策
  - 学到重要教训
  - 长任务的关键节点
- **操作**: 写入 MEMORY.md 或 memory/YYYY-MM-DD.md，然后用 NO_REPLY

---

## 用户偏好

### 代码开发优先使用 Codex
- **记录时间**: 2026-02-27
- **规则**: 代码开发任务优先让 Codex 执行，而不是自己写代码
- **原因**: 用户认为 Codex 编程能力更强

### 静默模式
- **记录时间**: 2026-02-28
- **规则**: 决定静默时直接不发消息，不要发送"静默"这个词
- **操作**: 使用 NO_REPLY 而不是发送文字

### 进度报告
- **频率**: 每10分钟向用户报告一次任务进度
- **触发条件**: 任务执行时
- **记录时间**: 2026-02-23

### 🔴🔴🔴 前端测试规则 (非常重要！)
- **记录时间**: 2026-03-04
- **规则**: **不要用 HTTP code 或 curl 判断前端功能是否正常！**
- **原因**: HTTP 200 只代表服务器返回了页面，不代表前端 JS 逻辑正确
- **正确做法**: 用浏览器实际打开测试，验证 UI 交互和路由跳转
- **例子**: Landing Page 部署后，curl 返回正确内容，但浏览器访问仍跳转到登录页
- **教训**: 前端是 JS 驱动的，必须用浏览器测试真实行为

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

## 2026-02-25 开发进度

### ✅ 已完成
1. **用户认证系统**
   - 注册 API: `/admin/auth/signup`
   - 登录 API: `/admin/auth/signin`
   - 忘记密码 API: `/admin/auth/forgot-password`
   - OAuth 回调修复 (重定向到 `/auth/callback`)

2. **用户余额系统**
   - Schema: UserQuota, QuotaTransaction, SubscriptionPlan, UserSubscription
   - Service: UserQuotaService (余额管理、充值、消费)
   - API: `/admin/quota/me`, `/admin/quota/transactions`, `/admin/quota/recharge`

3. **前端 UI**
   - 统一登录/注册/忘记密码页面布局 (TwoColumnAuth)
   - 用户中心框架 (账户/模型/API Keys/套餐/充值/推荐)
   - Landing Page 用户信息显示

4. **安全**
   - fail2ban 已启用，已封禁 14+ 攻击 IP

5. **ClawRAG 评估**
   - 已分析 https://github.com/2dogsandanerd/ClawRag
   - 结论: 与 OpenClaw 功能重叠，价值有限
   - 建议: 单独使用 Docling 做文档处理
