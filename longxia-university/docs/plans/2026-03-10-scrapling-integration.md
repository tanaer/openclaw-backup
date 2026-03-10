# 教材扩充系统 - Scrapling 集成

> 使用 Scrapling 自动抓取和扩充课程资源

## 为什么选择 Scrapling

| 特性 | 优势 |
|------|------|
| **自适应抓取** | 网站改版后自动重新定位，无需维护选择器 |
| **反爬虫绕过** | 内置 Cloudflare Turnstile 绕过 |
| **MCP Server** | AI 友好，可直接集成 OpenClaw |
| **Spider 框架** | Scrapy-like API，支持大规模爬取 |
| **官方 Skill** | 已有 OpenClaw Skill 支持 |

## 教材来源

| 来源类型 | 示例 | 抓取策略 |
|---------|------|---------|
| **官方文档** | React Docs, TypeScript Handbook | StealthyFetcher |
| **技术博客** | Medium, Dev.to, 个人博客 | DynamicFetcher |
| **GitHub** | README, Wiki, Discussions | Fetcher + API |
| **教程网站** | 教程网站 | Spider 框架 |
| **视频字幕** | YouTube 字幕 | API 抓取 |

## 工作流程

```
1. 发现资源 (自动化)
   ├─ 监控 GitHub Trending
   ├─ RSS 订阅技术博客
   ├─ 监控 HN/Reddit 热门
   └─ 用户提交 URL

2. 抓取内容 (Scrapling)
   ├─ 绕过反爬虫
   ├─ 提取核心内容
   └─ 清理格式

3. 处理内容 (LLM)
   ├─ 生成 L0 摘要 (~100 tokens)
   ├─ 生成 L1 概览 (~2k tokens)
   ├─ 结构化元数据
   └─ 关联知识图谱

4. 存储发布 (OpenViking)
   ├─ 写入课程库
   ├─ 向量化索引
   ├─ 关联推荐
   └─ CDN 分发
```

## 代码示例

### 单页面抓取

```python
from scrapling import StealthyFetcher

async def fetch_course_content(url: str) -> dict:
    """抓取单个课程页面"""
    page = StealthyFetcher.fetch(
        url,
        headless=True,
        network_idle=True,
        adaptive=True
    )
    
    return {
        "title": page.css('h1::text').get(),
        "content": page.css('article').get_text(),
        "code_blocks": [block.get_text() for block in page.css('pre code')],
        "links": [link.get('href') for link in page.css('a')],
    }
```

### 大规模爬取

```python
from scrapling import Spider, Response

class TutorialSpider(Spider):
    name = "tutorial_spider"
    start_urls = ["https://example.com/tutorials/"]
    concurrency = 5  # 并发数
    
    async def parse(self, response: Response):
        for tutorial in response.css('.tutorial-item'):
            yield response.follow(
                tutorial.css('a::attr(href)').get(),
                self.parse_tutorial
            )
    
    async def parse_tutorial(self, response: Response):
        yield {
            "url": response.url,
            "title": response.css('h1::text').get(),
            "content": response.css('article').get_text(),
        }
```

### 集成 OpenViking

```python
class CourseExpander:
    """课程扩充器"""
    
    async def expand(self, topic: str):
        # 1. 搜索相关资源
        sources = await self.search_sources(topic)
        
        # 2. 抓取并处理
        for source in sources:
            content = await self.fetch(source.url)
            processed = await self.process(content)
            
            # 3. 存入 OpenViking
            await self.viking.write(
                f"viking://resources/courses/{topic}/{source.id}/content.md",
                processed.content
            )
            
            # 4. 生成分层摘要
            await self.viking.generate_abstracts(
                f"viking://resources/courses/{topic}/{source.id}/"
            )
```

## 监控与维护

```python
class CourseMonitor:
    """课程监控器"""
    
    async def check_updates(self):
        """检查课程更新"""
        courses = await self.viking.ls("viking://resources/courses/")
        
        for course in courses:
            # 重新抓取源 URL
            current = await self.fetch(course.source_url)
            
            # 比较内容 hash
            if current.hash != course.stored_hash:
                await self.update_course(course, current)
    
    async def check_quality(self):
        """检查课程质量"""
        courses = await self.viking.find(
            "质量检查",
            target_uri="viking://resources/courses/"
        )
        
        for course in courses:
            # 检查 L0/L1 是否存在
            if not await self.viking.exists(course.abstract_path):
                await self.viking.generate_abstracts(course.uri)
```

## 配置

```yaml
# config.yaml
course_expansion:
  # 抓取配置
  scraping:
    concurrency: 5
    delay: 1.0  # 秒
    timeout: 30
    retry: 3
    
  # 来源配置
  sources:
    github:
      enabled: true
      topics: ["openclaw", "ai-agent", "web-scraping"]
    blogs:
      enabled: true
      feeds:
        - "https://blog.example.com/rss"
        
  # 处理配置
  processing:
    llm_model: "gpt-4o-mini"
    generate_l0: true
    generate_l1: true
    
  # 存储配置
  storage:
    viking_base: "viking://resources/courses/"
    cdn_enabled: true
```

## 安装

```bash
# Python 包
pip install scrapling

# OpenClaw Skill
clawhub install scrapling-official
```

## 参考资源

- Scrapling GitHub: https://github.com/D4Vinci/Scrapling
- Scrapling 文档: https://scrapling.readthedocs.io
- ClawHub Skill: https://clawhub.ai/D4Vinci/scrapling-official
