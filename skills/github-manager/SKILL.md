# GitHub Manager Skill

管理 GitHub 仓库 - 创建、推送、配置私有仓库等。

## 配置

在 `TOOLS.md` 中添加：

```markdown
## GitHub

- **Email:** `your-email@example.com`
- **Personal Access Token:** `ghp_xxx`
- **用途:** 管理私有仓库
```

## API 端点

- REST API: `https://api.github.com`
- Git HTTPS: `https://github.com/username/repo.git`

## 使用方法

### 创建私有仓库

```bash
curl -X POST "https://api.github.com/user/repos" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{"name":"repo-name","private":true}'
```

### 推送代码

```bash
git remote add origin https://$GITHUB_TOKEN@github.com/username/repo.git
git push -u origin main
```

## 凭证存储

凭证保存在 `TOOLS.md`，不要提交到版本控制。

## Git 配置

```bash
git config --global user.email "your-email@example.com"
git config --global user.name "OpenClaw"
git config --global credential.helper store
```
