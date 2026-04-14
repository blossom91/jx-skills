# create-workitem — 单个创建/更新

## 触发条件
- 用户说 "创建一个需求/任务/缺陷"、"新建 bug"、"把这个 bug 改成已修复"、"更新状态"
- 排他：涉及"父子结构"、"子任务列表"、"拆分需求" → create-structure

## 执行流程

### 创建

1. **确定 workspace_id** — 按前置检查的 workspace 解析策略
2. **确定 entity 类型** — story / task / bug
   - 平台中心用户：查 workspace-registry 确认是否用 story 子类别代替 task
   - 其他用户：用 `mos tapd workspace types -w <id>` 确认
3. **提取参数** — 从用户话语中提取标题、处理人、优先级、日期等
4. **映射自定义字段** — 见下方"参数提取示例"
5. **执行创建**：
   ```bash
   mos tapd skill create-workitem \
     --action create --entity story -w <workspace_id> \
     --title "标题" --owner "处理人" \
     --custom-fields '{"custom_field_key":"value"}'
   ```
6. **展示结果** — 返回工单 ID 和链接

### 更新

1. **确定目标工单** — 提取 ID 或通过查询定位
2. **执行更新**：
   ```bash
   mos tapd skill create-workitem \
     --action update --entity bug -w <workspace_id> \
     --id 12345 --status "已修复"
   ```
   支持多个 `--id` 参数做批量更新。

## 关键命令

| 步骤 | 命令 | 说明 |
|------|------|------|
| 创建 | `mos tapd skill create-workitem --action create ...` | |
| 更新 | `mos tapd skill create-workitem --action update ...` | 支持多 --id |
| 查字段 | `mos tapd fields custom -w <id>` | 动态获取自定义字段 |

## 参数说明

| 参数 | 必填 | 说明 |
|------|------|------|
| --action | 是 | create 或 update |
| --entity | 是 | story / task / bug |
| -w | 是 | workspace_id |
| --title | 创建时必填 | 标题 |
| --description | 否 | 描述 |
| --owner | 否 | 处理人昵称 |
| --id | 更新时必填 | 工单 ID（可多个） |
| --status | 更新时常用 | 目标状态 |
| --begin-date | 否 | 开始日期 |
| --due-date | 否 | 截止日期 |
| --effort | 否 | 预估工时(h) |
| --priority | 否 | 优先级 |
| --category | 否 | 类别 ID |
| --parent-id | 否 | 父需求 ID |
| --iteration-id | 否 | 迭代 ID |
| --custom-fields | 否 | JSON 格式自定义字段 |

## 参数提取示例

用户说："分摊规则：4，需求来源：平台中心，分摊对象：平台中心"

**平台中心用户** → 查 workspace-registry 确认项目属于 Pattern A：
```bash
--custom-fields '{"custom_field_seven":"规则4：【平台自发需求】100%分摊给单个受益部门","custom_field_eight":"平台中心","custom_field_9":"平台中心"}'
```

**其他用户** → 先用 `mos tapd fields custom -w <id>` 查询字段 key，再映射。

## 自定义字段映射

创建时需要设置自定义字段，按用户类型决定获取方式：
1. **平台中心用户**：查 [workspace-registry](workspace-registry.md)，确定项目属于哪个 Pattern (A/B/C)，找到字段 key
2. **其他用户**：用 `mos tapd fields custom -w <id>` 动态查询

## 输出要求
- 创建成功：返回工单 ID、标题、链接
- 更新成功：返回更新后的工单摘要
- 批量更新：逐条返回结果
