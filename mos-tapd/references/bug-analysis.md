# bug-analysis — 缺陷条件查询+分组展示

## 触发条件
- 用户说 "拉取缺陷"、"bug 情况"、"缺陷分析"、"按严重程度看 bug"、"筛选缺陷"
- 排他：创建/更新 bug → create-workitem；项目整体健康含缺陷 → project-tracker

## 执行流程

1. **确定 workspace_id** — 按前置检查的 workspace 解析策略
2. **提取筛选条件** — 从用户话语中提取：时间范围、严重程度、状态、缺陷类型、标签
3. **执行查询**：
   ```bash
   mos tapd skill bug-analysis \
     -w <workspace_id> \
     --created-after "YYYYMMDD" \
     --created-before "YYYYMMDD" \
     --severity <severity> \
     --status <status> \
     --bug-type "<类型>" \
     --tag "<标签>" \
     --group-by <维度>
   ```
4. **展示结果** — 按分组维度展示 Markdown 表格

## 关键命令

| 步骤 | 命令 | 说明 |
|------|------|------|
| 查询 | `mos tapd skill bug-analysis -w <id> [filters]` | 多条件可叠加（取交集） |
| 补充查询 | `mos tapd bug list -w <id> --me` | 简单查自己的 bug |

## 参数说明

| 参数 | 必填 | 说明 |
|------|------|------|
| -w | 是 | workspace_id |
| --created-after | 否 | 创建起始日期（YYYYMMDD） |
| --created-before | 否 | 创建截止日期 |
| --severity | 否 | 严重程度：fatal/serious/normal/prompt/advice |
| --status | 否 | 状态筛选 |
| --bug-type | 否 | 缺陷类型筛选 |
| --tag | 否 | 标签筛选 |
| --group-by | 否 | 分组维度：severity(默认) / status / owner |

## 分组维度决策

| 用户关注点 | 推荐 group-by |
|-----------|---------------|
| "按严重程度看" / "哪些是致命的" | severity（默认） |
| "按状态分组" / "还有多少没修" | status |
| "每个人有多少 bug" / "谁的 bug 最多" | owner |
| 未明确说明 | severity（默认） |

## 输出要求
- 按分组维度展示，每组一个 Markdown 表格
- 每条 bug 显示：ID、标题、状态、严重程度、处理人、创建时间
- 底部汇总表：各组数量统计
