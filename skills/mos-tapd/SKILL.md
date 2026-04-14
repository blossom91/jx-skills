---
name: mos-tapd
description: 当用户需要查询、创建、修改 TAPD 项目中需求、缺陷、任务、迭代等信息时使用。 覆盖场景：创建/更新工单、层级创建、缺陷分析、成员汇总、需求分析、个人待办、项目追踪。 触发场景参考：(1) 查询/创建/更新 TAPD 工单 (2) 分析成员工作产出或需求工时 (3) 批量创建需求和子任务 (4) 查看个人待办 (5) 项目进度和风险
---
## 重要

`mos tapd` 封装了 tapd 所有功能的原子化接口调用，可以通过组装实现各种业务场景，尽可能的帮助用户解决问题

## 前置检查

在执行任何 tapd 操作前，按顺序完成以下检查：

### 1. 确保 mos 已安装

参考 mos-core skill 的安装检测逻辑。

### 2. 认证检查

```
mos tapd auth whoami
```

- **已登录**（返回 user_nick）→ 记录 `department` 字段值，跳到步骤 3
- **未登录**（返回错误）→ 进入认证流程：
  1. 告知用户当前未登录 TAPD，请求提供 access token
  2. **暂停当前任务，等待用户回复**（不要猜测 token、不要跳过）
  3. 用户提供 token 后，执行：`mos tapd auth login --token <用户提供的token>`
  4. 验证登录结果，成功后**自动恢复并继续执行用户的原始任务**（用户不需要再重复一遍请求）

### 3. Workspace 解析

根据 whoami 返回的 `department` 字段决定项目解析策略：

**a) 平台中心用户**（department = "平台中心"）
→ 参考 [workspace-registry](references/workspace-registry.md) 获取 workspace_id 和字段映射。registry 包含预配置的自定义字段、状态工作流和项目列表
规范遵循 [tapd-conventions](references/tapd-conventions.md) 中的字段要求


**b) 其他用户**（department 为空或其他值）
→ 无法使用注册表，但可以：
1. 用 `mos tapd workspace projects` 列出用户参与的项目
2. 根据用户描述中的项目名称进行模糊匹配
3. 匹配到项目后，用 `mos tapd fields custom -w <workspace_id>` 动态获取自定义字段配置
4. 无法匹配时再询问用户具体项目

> **重要**：部分项目（如平台中心）的"任务"是需求（story）的子类别，不是独立的 tasks 实体。创建前务必查阅 registry（平台中心用户）或用 `mos tapd workspace types -w <id>` 查询实体类型（其他用户）。

## 意图路由

### 第一步：判断意图大类

| 用户想要... | 大类 | 跳转 |
|------------|------|------|
| 创建、新建、添加、建一个、拉一个 | 创建类 | → 第二步-创建 |
| 更新、修改、改成、改为、批量改 | 创建类 | → 第二步-创建 |
| 查看、拉取、列出、筛选、分析、统计、汇总、有哪些 | 查询分析类 | → 第二步-查询 |
| 我的待办、今天做什么、工作安排、需要处理 | 工作管理类 | → 第二步-管理 |
| 项目进度、风险、情况怎么样、阻塞 | 工作管理类 | → 第二步-管理 |

### 第二步-创建：精确匹配

#### create-workitem — 单个创建/更新
- **意图**：创建或更新单个需求、任务、缺陷
- **示例话术**：
  - "帮我创建一个任务，起止时间为 xxx，处理人云长"
  - "把这个 bug 状态改成已修复"
  - "新建一个需求，标题是 xxx"
  - "把这3个 bug 都改成已关闭"
- **排他**：涉及"父子结构"、"子任务列表"、"拆分需求" → 走 create-structure
- **参考文档**: [create-workitem](references/create-workitem.md)

#### create-structure — 结构化层级创建
- **意图**：创建带层级关系的需求+子任务，可含工时预分配
- **示例话术**：
  - "根据以下结构创建需求和任务"
  - "帮我拆分这个需求，下面有3个子任务"
  - "创建需求并按天分配每个子任务工时"
  - "按这个结构建需求：父需求 xxx，子任务有 A、B、C"
- **排他**：只是单个工单没有子结构 → 走 create-workitem
- **参考文档**: [create-structure](references/create-structure.md)

### 第二步-查询：精确匹配

#### bug-analysis — 缺陷条件查询+分组展示
- **意图**：按条件筛选缺陷并分组展示
- **示例话术**：
  - "拉取 SDK 项目创建于 xxx 之后的缺陷，按严重程度分开展示"
  - "帮我看看这个项目的 bug 情况，按状态分组"
  - "筛选缺陷类型是用户反馈的 bug"
  - "标签是 2.5 迭代的缺陷有哪些"
- **排他**：创建/更新 bug → create-workitem；项目整体健康含缺陷 → project-tracker
- **参考文档**: [bug-analysis](references/bug-analysis.md)

#### member-summary — 成员工作汇总
- **意图**：查看某个人在一段时间内的工作产出，用于月报/周报
- **示例话术**：
  - "深红上个月都有哪些工作，帮我生成月报"
  - "我这周的工作汇总"
  - "帮我看看 xxx 最近的产出"
  - "xxx 上个月做了什么，让我了解他的工作事项和产出"
- **排他**：问的是"需求维度的分析"而非"人维度的汇总" → demand-insight
- **参考文档**: [member-summary](references/member-summary.md)

#### demand-insight — 需求维度分析
- **意图**：按需求维度分析负责人和工时投入
- **示例话术**：
  - "上个月运营中心都有哪些需求，谁在负责，投入多少工时"
  - "这个项目的需求都是谁在跟"
  - "帮我分析下这批需求的工时分布"
  - "xxx 来源的需求有哪些，各自花了多少人力"
- **排他**：问的是"某个人的全部产出" → member-summary
- **参考文档**: [demand-insight](references/demand-insight.md)

### 第二步-管理：精确匹配

#### my-todo — 个人今日待办
- **意图**：梳理个人当日/近期待办（需求+任务+缺陷）
- **示例话术**：
  - "我今天有哪些需求、任务、缺陷需要处理"
  - "帮我看看今天的工作安排"
  - "我的待办有哪些"
  - "梳理一下我手头的事情"
- **排他**：问的是"项目整体进度" → project-tracker
- **参考文档**: [my-todo](references/my-todo.md)

#### project-tracker — 项目进度追踪
- **意图**：了解项目整体进度、风险和阻塞
- **示例话术**：
  - "xxx 项目现在情况怎么样了，进度如何"
  - "项目有没有风险，阻塞是什么"
  - "帮我看看这个迭代的完成率"
  - "这个项目是否有风险，如果有让我知道"
- **排他**：只是看"个人待办" → my-todo
- **参考文档**: [project-tracker](references/project-tracker.md)

## 参数提取指引

匹配到 skill 后，从用户话语中提取以下信息：

### 通用参数
- **项目名称** → 查 workspace-registry 得到 workspace_id
- **时间范围** → 解析为具体日期（"上个月" → 上月1日~末日，"本周" → 周一~周日）
- **人名/昵称** → 直接传入 owner/member 参数（"本人" → 当前登录用户）

### 自定义字段（创建类）
- **需求来源** → 查 workspace-registry 得到对应 custom_field_key
- **分摊对象** → 同上
- **分摊规则** → 数字映射，查 workspace-registry
- 处理规则：用户说"分摊规则：4"→ 查 registry 得到 custom_field_key=custom_field_seven, value="4"

### 缺什么必须追问
- **创建类**：entity 类型、标题 必须有
- **查询类**：workspace_id 必须有（至少知道项目名）
- **member-summary**：member 和 period 必须有
- **demand-insight**：period 必须有

## 基础命令

对于不在上述场景中的简单 TAPD 查询/操作，直接使用基础命令：

```
mos tapd story list -w <workspace_id> [--me] [--status <status>]
mos tapd bug list -w <workspace_id> [--me]
mos tapd iteration list -w <workspace_id>
mos tapd todo -w <workspace_id>
mos tapd workspace projects
```

## 全局参数

- `-w, --workspace` — 项目 ID（大部分命令必填）
- `-o, --output` — 输出格式：table | json | markdown（默认 table）
- `--verbose` — 详细日志
