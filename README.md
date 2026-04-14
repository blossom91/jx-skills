# mos

面向 AI Agent 的中后台操作 CLI，覆盖 GOS 游戏运营、BI 大数据、TAPD 项目管理等内部系统。

---

## 安装

**环境要求：** Node.js >= 22，公司内网环境

```bash
npm install -g @diezhi/mos-cli --registry=https://npm.papegames.com/
```

验证：

```bash
mos --version
```

## 安装 Skills

```bash
npx skills add blossom91/jx-skills -y -g
```

## 使用

### 查看可用能力

```bash
mos -r                              # 全局指引
mos gos -r                          # GOS 业务概览
mos bi -r                           # BI 业务概览
mos tapd -r                         # TAPD 业务概览
mos <业务> <模块> <操作> -r         # 操作参数与示例
```

### 认证

按需认证 — 遇到认证错误（code 100-199）时再登录：

```bash
mos gos auth login                              # GOS — 交互式 SSO
mos bi auth login                               # BI — 交互式 SSO
mos tapd auth login --token <access-token>      # TAPD — token 登录
```

TAPD token 获取地址：https://www.tapd.cn/personal_settings/index?tab=personal_token

### 命令结构

```
mos <业务> <模块> <操作> [参数]
```

| 业务 | 命令前缀 | 说明 |
|------|----------|------|
| GOS | `mos gos` | 游戏运营 — 推送通知、客户端切换 |
| BI | `mos bi` | 大数据 — 数据查询 |
| TAPD | `mos tapd` | 项目管理 — 需求/缺陷/迭代/用例/Wiki/工时 |

### 输出格式

stdout 为 JSON envelope：

```json
// 成功
{ "code": 0, "data": { ... } }

// 失败
{ "code": 300, "error": { "message": "..." } }
```

| 错误码范围 | 含义 | 处理方式 |
|-----------|------|---------|
| 100-199 | 认证错误 | 执行 `mos <业务> auth login` 后重试 |
| 200-299 | Panda-auth 错误 | 提示用户检查 SSO 状态 |
| 300-399 | API 错误 | 检查参数，带 `--verbose` 重试 |

`-r` 模式输出 markdown 纯文本，不走 JSON envelope。

## Agent Skills

| Skill | 说明 |
|-------|------|
| `mos-core` | 安装检测、reference 机制教学、通用操作模式 |
| `mos-tapd` | TAPD 项目管理 — 全模块管理 + 高级工作流技能 |

### TAPD 高级工作流

| 技能 | 说明 |
|------|------|
| create-workitem | 创建/更新需求、任务、缺陷 |
| create-structure | 层级创建（父需求 + 子任务 + 工时） |
| bug-analysis | 缺陷查询 + 分组展示 |
| member-summary | 成员工作汇总（月报/周报） |
| demand-insight | 需求分析（负责人 + 工时） |
| my-todo | 个人今日待办 |
| project-tracker | 项目进度追踪 |
