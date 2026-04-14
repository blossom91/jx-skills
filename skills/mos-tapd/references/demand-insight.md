# demand-insight — 需求维度分析

## 触发条件
- 用户说 "需求都有哪些"、"谁在负责这些需求"、"需求工时分布"、"这批需求的人力投入"
- 排他：问的是"某个人的全部产出" → member-summary

## 与 member-summary 的区分决策

| 判断依据 | demand-insight | member-summary |
|---------|---------------|----------------|
| 核心维度 | 以**需求**为中心 | 以**人**为中心 |
| 典型问题 | "这些需求谁在跟" | "这个人做了什么" |
| 输出重点 | 每条需求的负责人和工时 | 某人的全部产出 |
| 适用场景 | 了解一批需求的人力分布 | 生成个人周报/月报 |

## 执行流程

1. **确定 workspace_id** — 按前置检查的 workspace 解析策略
2. **提取筛选条件** — 需求来源、时间范围
3. **解析时间范围** — 同 member-summary 的时间范围解析逻辑
4. **执行查询**：
   ```bash
   mos tapd skill demand-insight \
     -w <workspace_id> \
     --source "运营中心" \
     --period custom \
     --start-date "YYYY-MM-DD" --end-date "YYYY-MM-DD"
   ```
5. **展示结果** — 需求总览 + 明细表 + 工时按人汇总

## 关键命令

| 步骤 | 命令 | 说明 |
|------|------|------|
| 查询 | `mos tapd skill demand-insight -w <id> --period month` | |

## 参数说明

| 参数 | 必填 | 说明 |
|------|------|------|
| -w | 是 | workspace_id |
| --source | 否 | 需求来源筛选 |
| --period | 是 | week / month / custom |
| --start-date | custom 时必填 | 起始日期 |
| --end-date | custom 时必填 | 截止日期 |

## 输出要求
- 需求总览（状态分布：已完成/进行中/待规划）
- 需求明细表（ID、标题、状态、负责人、各人工时、总工时）
- 工时按人汇总（成员、总工时，降序排列）
