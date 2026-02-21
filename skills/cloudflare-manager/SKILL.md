# Cloudflare Manager Skill

管理 Cloudflare 资源 - Workers、DNS、域名绑定等。

## 配置

在 `TOOLS.md` 中添加：

```markdown
### Cloudflare

- Account ID: 473accd319d2d827d45fe342c8cc32ad
- Zone ID (890214.net): 3a8759ee6f736a355a86be3c7700f787
- Workers Token: Q15kVhRtZLv36bKLIvWF0PuKaSjA-cQsk8QhblWy
- DNS Token: I4cPB5OkxuhVlXcokOoQECfYigGIFjgPiChOm3l2
```

## API 端点

- Workers: `https://api.cloudflare.com/client/v4/accounts/{account_id}/workers`
- DNS: `https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records`

## 使用方法

```bash
# 部署 Worker
curl -X PUT "https://api.cloudflare.com/client/v4/accounts/{account_id}/workers/scripts/{script_name}" \
  -H "Authorization: Bearer {token}" \
  -d @worker.js

# 添加 DNS 记录
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records" \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{"type":"CNAME","name":"sub","content":"target.com","proxied":true}'
```

## 凭证存储

凭证保存在 `TOOLS.md`，不要提交到版本控制。
