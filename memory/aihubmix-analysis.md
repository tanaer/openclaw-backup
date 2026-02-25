# AIHubMix 功能分析报告

## 一、AIHubMix 用户系统功能

### 账户系统
- 用户名/邮箱/密码
- 多种社交登录（Google、GitHub、微信、飞书、OIDC、Clerk）
- 账户余额（quota）
- 已使用额度（used_quota）
- 账户分组（group）
- 邀请码系统（aff_code、inviter_id）
- 余额提醒（notify、quota_remind_threshold）

### API 能力
| 功能 | AIHubMix | AxonHub |
|------|----------|---------|
| Chat Completions | ✅ | ✅ |
| Embeddings | ✅ | ✅ |
| Rerank | ✅ | ✅ |
| 图片生成 | ✅ | ✅ |
| 图片编辑 | ✅ | ✅ |
| 视频生成 | ✅ | ❌ |
| TTS 文本转语音 | ✅ | ❌ |
| STT 语音转文本 | ✅ | ❌ |
| 内容审查 | ✅ | ❌ |
| FIM 补全 | ✅ | ❌ |
| 联网搜索 | ✅ | ❌ |
| Responses API | ✅ | ❌ |

### 管理功能
- KEY 管理 API（创建、删除、更新、列表）
- 获取用户信息与余额
- 获取可用模型列表
- APP-Code 应用标识码（10% 优惠）
- Claude 提示词缓存
- 模型后缀能力

## 二、需要开发的功能

### 优先级 1：核心用户系统
1. **账户余额系统**
   - quota 字段（余额）
   - used_quota 字段（已用额度）
   - 充值功能
   
2. **套餐/订阅系统**
   - 套餐定义
   - 套餐购买
   - 套餐额度

3. **用户等级/分组**
   - group 字段
   - 不同等级的费率

### 优先级 2：社交功能
1. **邀请返利系统**
   - aff_code 邀请码
   - inviter_id 邀请人
   - 返利规则

### 优先级 3：API 能力扩展
1. **视频生成** - 需要 channel 支持
2. **TTS/STT** - 需要 channel 支持
3. **内容审查** - 需要 channel 支持
4. **联网搜索** - 需要 channel 支持

## 三、AxonHub 现有架构分析

### 用户模型 (internal/ent/schema/user.go)
```go
- email
- status (activated/deactivated)
- prefer_language
- password
- first_name
- last_name
- avatar
- is_owner
- scopes
- projects (通过 project_users)
- roles (通过 user_roles)
- api_keys
```

### 需要添加的字段
```go
- quota (int64) // 账户余额
- used_quota (int64) // 已使用额度
- group (string) // 用户分组/等级
- aff_code (string) // 邀请码
- inviter_id (int) // 邀请人ID
```

## 四、开发计划

### Phase 1: 用户余额系统（不修改原有逻辑）
1. 创建独立的 quota 模块
2. 前端用户中心集成余额显示
3. 充值界面（对接 Stripe/EPUSDT）

### Phase 2: 套餐系统
1. 创建 package 模型
2. 套餐列表页面
3. 套餐购买流程

### Phase 3: 邀请返利
1. 生成邀请码
2. 邀请注册逻辑
3. 返利计算

## 五、参考资源
- AIHubMix 文档: https://docs.aihubmix.com/cn
- AIHubMix 模型列表: https://aihubmix.com/models
