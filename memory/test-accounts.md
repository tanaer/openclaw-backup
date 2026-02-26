# 测试账号

## MuskAPI 测试账号

| 邮箱 | 密码 | 用途 | 创建时间 |
|------|------|------|----------|
| `healthcheck@test.com` | `HealthCheck2026!` | 功能测试、API 测试 | 2026-02-26 |
| `test@example.com` | `Test1234!` | 数据库预设 | - |
| `demo@example.com` | `Demo1234!` | 数据库预设 | - |
| `quota-test@example.com` | 未知 | 数据库预设 | - |

## 管理员账号

| 邮箱 | 角色 | 备注 |
|------|------|------|
| `wtcoder89@gmail.com` | owner (is_owner=1) | 密码未知，需要找回 |

## 测试说明

- 登录 API: `POST https://dev.claudeai.best/admin/auth/signin`
- 注册 API: `POST https://dev.claudeai.best/admin/auth/signup`
- 余额 API: `GET https://dev.claudeai.best/admin/quota/me` (需 Bearer Token)
- 充值 API: `POST https://dev.claudeai.best/admin/quota/recharge` (需 paymentMethod)

## 速率限制

- 登录/注册接口有速率限制
- 触发后需等待约 60-90 秒
