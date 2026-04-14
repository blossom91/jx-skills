# member-summary — 成员工作汇总

## 触发条件
- 用户说 "xxx的工作汇总"、"帮我生成月报"、"我这周做了什么"、"某人最近的产出"
- 排他：问的是"需求维度的分析"而非"人维度的汇总" → demand-insight

## 执行流程

1. **确定 workspace_id** — 按前置检查的 workspace 解析策略
2. **提取 member** — "我"/"本人" → 当前登录用户；其他 → 直接用昵称
3. **解析时间范围** — 见下方"时间范围解析"
4. **执行查询**：
   ```bash
   mos tapd skill member-summary \
     -w <workspace_id> \
     --member "昵称" \
     --period <week|month|custom> \
     --start-date "YYYY-MM-DD" --end-date "YYYY-MM-DD"
   ```
5. **展示结果** — 工作概览 + 需求/缺陷明细 + 工时分布

## 关键命令

| 步骤 | 命令 | 说明 |
|------|------|------|
| 查询 | `mos tapd skill member-summary -w <id> --member "x" --period month` | |

## 参数说明

| 参数 | 必填 | 说明 |
|------|------|------|
| -w | 是 | workspace_id |
| --member | 是 | 成员昵称 |
| --period | 是 | week / month / custom |
| --start-date | custom 时必填 | 起始日期 |
| --end-date | custom 时必填 | 截止日期 |

## 时间范围解析

| 用户说法 | period | start-date | end-date |
|---------|--------|------------|----------|
| "这周" / "本周" | week | 本周一 | 本周日 |
| "上周" | custom | 上周一 | 上周日 |
| "这个月" / "本月" | custom | 本月1日 | 今天 |
| "上个月" | month | 上月1日 | 上月末日 |
| "最近两周" | custom | 14天前 | 今天 |
| "3月" / "三月份" | custom | 3月1日 | 3月31日 |
| "Q1" / "第一季度" | custom | 1月1日 | 3月31日 |

## 输出要求
- 工作概览（需求已完成/进行中、缺陷已修复/处理中、总工时）
- 需求明细（ID、标题、状态、优先级）
- 缺陷明细（ID、标题、状态、严重程度）
- 工时按日分布
