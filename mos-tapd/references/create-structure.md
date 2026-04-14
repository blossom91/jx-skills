# create-structure — 结构化层级创建

## 触发条件
- 用户说 "创建需求和子任务"、"拆分需求"、"按结构创建"、"父需求+子任务"
- 排他：只是单个工单没有子结构 → create-workitem

## 决策树：子级用 story 还是 task？

```
用户要创建子任务
├── 平台中心用户？
│   ├── 是 → 查 workspace-registry，用 story 的 workitem_type_id 创建子级
│   │        （平台中心没有独立 tasks 模块，"任务"是 story 的子类别）
│   └── 否 → 检查项目是否支持 tasks
│        ├── 支持 → 用 --child-entity task
│        └── 不支持 → 用 story 子类别，先查 workspace types 获取类别 ID
```

## 执行流程

1. **确定 workspace_id** — 按前置检查的 workspace 解析策略
2. **确定子级实体类型** — 按上方决策树
3. **提取结构信息** — 父需求标题、子任务列表（各含标题，可选 owner/description）
4. **提取日期和工时** — 起止日期、每日工时
5. **映射自定义字段** — 应用于父需求
6. **执行创建**：
   ```bash
   mos tapd skill create-structure \
     -w <workspace_id> \
     --title "父需求标题" \
     --begin-date "2026-04-13" --end-date "2026-04-16" \
     --effort-per-day 2 --owner "处理人" \
     --child-entity task \
     --children '[{"title":"子任务A"},{"title":"子任务B"}]' \
     --custom-fields '{"key":"value"}'
   ```
7. **展示结果** — 树形结构：父需求 + 子任务列表 + 工时汇总

## 关键命令

| 步骤 | 命令 | 说明 |
|------|------|------|
| 创建 | `mos tapd skill create-structure -w <id> ...` | |
| 查类型 | `mos tapd workspace types -w <id>` | 确认子级实体类型 |

## 参数说明

| 参数 | 必填 | 说明 |
|------|------|------|
| -w | 是 | workspace_id |
| --title | 是 | 父需求标题 |
| --children | 是 | JSON 数组，每项含 title，可选 owner、description |
| --begin-date | 是 | 起始日期 |
| --end-date | 是 | 结束日期 |
| --effort-per-day | 否 | 每个子任务每天预估工时(h) |
| --owner | 否 | 默认处理人 |
| --child-entity | 否 | 子级实体类型，默认 task |
| --custom-fields | 否 | 自定义字段（应用于父需求） |
| --priority | 否 | 优先级 |
| --category | 否 | 类别 ID |
| --iteration-id | 否 | 迭代 ID |

## 输出要求
- 树形展示：父需求 ID/标题/链接 + 子任务列表（ID/标题/处理人/工时）
- 底部汇总：总子任务数、总工时
