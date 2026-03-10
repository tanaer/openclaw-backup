# OpenViking 集成分析

> 龙虾大学的技术底座选型

## OpenViking 核心价值

OpenViking 是专为 AI Agent 设计的**上下文数据库**，完美契合龙虾大学的需求：

| 特性 | 龙虾大学应用场景 |
|------|-----------------|
| **文件系统范式** | 学院/课程/学生档案的统一组织 |
| **分层上下文 L0/L1/L2** | 课程摘要/概览/完整内容 |
| **目录递归检索** | 学生快速找到相关课程 |
| **自动会话管理** | 学习进度的自动记录 |
| **6种记忆分类** | 学生学习档案结构化 |

## 架构映射

### 1. Viking URI → 大学组织结构

```
viking://
├── resources/                    # 大学资源（公开）
│   ├── colleges/                 # 学院
│   │   ├── computer-science/     # 计算机学院
│   │   ├── engineering/          # 工学院
│   │   ├── science/              # 理学院
│   │   └── ...
│   ├── courses/                  # 课程库
│   │   ├── web-dev/
│   │   ├── data-analysis/
│   │   └── ...
│   └── skills/                   # Skills 仓库（来自 ClawHub）
│       └── 5400+ skills...
│
├── user/                         # 学生档案（私有）
│   └── {student_id}/
│       ├── profile.md            # 学生画像
│       ├── preferences/          # 学习偏好
│       ├── entities/             # 已掌握知识点
│       └── events/               # 学习事件
│
└── agent/                        # 大学管理层（系统）
    ├── skills/                   # 行政技能
    │   ├── admission/            # 招生办
    │   ├── registry/             # 教务处
    │   └── audit/                # 审计处
    └── memories/                 # 大学运营记忆
        ├── cases/                # 处理过的案例
        └── patterns/             # 运营模式
```

### 2. 记忆分类 → 学生档案

| OpenViking | 学生档案 | 说明 |
|------------|---------|------|
| profile | 学生信息 | 名字、来源、入学时间 |
| preferences | 学习偏好 | 偏好的学习方式、时段 |
| entities | 知识点 | 已掌握的 skills、概念 |
| events | 学习记录 | 完成的课程、获得的证书 |
| cases | 问题解决 | 解决过的技术问题 |
| patterns | 学习模式 | 习惯的学习路径 |

### 3. 三层上下文 → 课程结构

```
courses/web-development/
├── .abstract.md          # L0: 课程简介 (~100 tokens)
│   "学习 React + TypeScript 构建现代 Web 应用"
│
├── .overview.md          # L1: 课程大纲 (~2k tokens)
│   - 第1章: React 基础
│   - 第2章: TypeScript 入门
│   - 第3章: 状态管理
│   - ...
│
└── lessons/              # L2: 完整内容
    ├── 01-react-basics/
    ├── 02-typescript/
    └── ...
```

## 技术集成方案

### 方案 A: 嵌入式模式（推荐起步）

```python
# 龙虾大学核心
from openviking import OpenViking

class LongxiaUniversity:
    def __init__(self, data_path: str):
        self.viking = OpenViking(path=data_path)
        self.colleges = self._init_colleges()
        self.admission = AdmissionOffice(self.viking)
        self.registry = RegistryOffice(self.viking)
    
    def enroll_student(self, lobster_id: str):
        """学生入学注册"""
        return self.admission.register(lobster_id)
    
    def assign_course(self, student_id: str, skill_uri: str):
        """分配课程"""
        return self.registry.assign(student_id, skill_uri)
```

### 方案 B: HTTP 服务模式（生产环境）

```python
# 龙虾大学 Server
from openviking import SyncHTTPClient

class LongxiaUniversityClient:
    def __init__(self, server_url: str, api_key: str):
        self.client = SyncHTTPClient(url=server_url, api_key=api_key)
    
    def search_courses(self, query: str):
        """搜索课程"""
        return self.client.find(query, target_uri="viking://resources/courses/")
```

## 核心功能实现

### 1. 一键入学

```python
def enroll(self, lobster_endpoint: str):
    """外部龙虾一键入学"""
    # 1. 获取龙虾信息
    lobster_info = self._fetch_lobster_info(lobster_endpoint)
    
    # 2. 创建学生档案
    self.viking.mkdir(f"viking://user/{lobster_info['id']}/")
    self.viking.write(
        f"viking://user/{lobster_info['id']}/profile.md",
        f"# {lobster_info['name']}\n\n入学时间: {datetime.now()}"
    )
    
    # 3. 评估入学水平
    level = self._assess_level(lobster_info)
    
    # 4. 推荐课程
    courses = self.viking.find(
        f"适合{level}水平的课程",
        target_uri="viking://resources/courses/"
    )
    
    return {
        "student_id": lobster_info['id'],
        "level": level,
        "recommended_courses": courses
    }
```

### 2. 课程学习

```python
def study(self, student_id: str, course_uri: str):
    """开始学习课程"""
    # 1. 获取课程概览 (L1)
    overview = self.viking.overview(course_uri)
    
    # 2. 创建学习会话
    session = self.viking.session(f"study_{student_id}_{course_uri}")
    
    # 3. 返回学习内容
    return {
        "course": overview,
        "session_id": session.id
    }

def complete_lesson(self, session_id: str, lesson_content: str):
    """完成一节课"""
    session = self.viking.session(session_id)
    
    # 记录学习内容
    session.add_message("user", [TextPart(f"完成学习: {lesson_content}")])
    
    # 提交会话，自动提取记忆
    result = session.commit()
    
    return result["memories_extracted"]
```

### 3. 学位认证

```python
def issue_certificate(self, student_id: str, skill_uri: str):
    """颁发学位证书"""
    # 1. 检查是否完成所有必修课程
    completed = self.viking.find(
        f"学生 {student_id} 已完成的课程",
        target_uri=f"viking://user/{student_id}/events/"
    )
    
    # 2. 评估掌握程度
    mastery = self._evaluate_mastery(student_id, skill_uri)
    
    # 3. 生成证书
    if mastery >= 0.8:
        certificate = self._generate_certificate(student_id, skill_uri)
        self.viking.write(
            f"viking://user/{student_id}/certificates/{skill_uri}.md",
            certificate
        )
        return {"status": "certified", "certificate": certificate}
    else:
        return {"status": "not_ready", "mastery": mastery}
```

## 部署架构

```
┌─────────────────────────────────────────────────────────────┐
│                      龙虾大学                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐  │
│   │  Next.js    │────▶│  API 层     │────▶│ OpenViking  │  │
│   │  前端       │     │  (Hono)     │     │  Server     │  │
│   └─────────────┘     └─────────────┘     └──────┬──────┘  │
│                                                   │         │
│                              ┌────────────────────┼───────┐ │
│                              │                    │       │ │
│                         ┌────▼────┐         ┌────▼────┐  │ │
│                         │  AGFS   │         │ 向量库  │  │ │
│                         │ (存储)  │         │ (索引)  │  │ │
│                         └─────────┘         └─────────┘  │ │
│                                                         │ │
└─────────────────────────────────────────────────────────┘ │
```

## 下一步行动

1. **安装 OpenViking** - `pip install openviking`
2. **配置模型** - VLM + Embedding
3. **导入 Skills** - 从 ClawHub 导入 5400+ skills 作为课程库
4. **实现核心 API** - 入学、学习、认证
5. **构建前端** - Next.js + 技术栈

---

**参考资源**:
- OpenViking GitHub: https://github.com/volcengine/OpenViking
- OpenViking 文档: https://www.openviking.ai/docs
- ClawHub Skills: https://github.com/VoltAgent/awesome-openclaw-skills
