---
id: 4
title: EPUSDT 回调签名验证
priority: P1
labels: security, payment
status: closed
assignee: unassigned
created_at: 2026-02-25T20:18:31.950689
updated_at: 2026-02-25T20:18:31.950689
---

实现 EPUSDT 支付回调的签名验证，确保支付安全


## 解决方案

已实现 EPUSDT 回调签名验证：支持 MD5 和 HMAC-SHA256 两种签名方式，自动检测订单类型（充值/套餐购买）

关闭时间: 2026-02-25T20:51:30.704658
