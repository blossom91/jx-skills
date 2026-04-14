# mos

mos 是一个 AI-friendly 的 CLI 工具，用于管理 TAPD 项目（需求/缺陷/迭代/用例/Wiki/工时）。所有输出为结构化 JSON，支持 `-r` 参考文档机制。

## 自动化安装流程

Agent 按以下步骤依次执行，每步验证通过后再进入下一步。

### Step 1: 检测环境

```bash
node --version   # 要求 >= 22，失败则提示用户先安装 Node.js
```

### Step 2: 安装 mos CLI

```bash
# 检测是否已安装
which mos && mos --version
```

如果上述命令失败（未安装或版本异常），执行安装：

```bash
npm install -g @diezhi/mos-cli --registry=https://npm.papegames.com/
```

安装后再次验证：

```bash
mos --version   # 预期输出版本号，失败则检查 npm.papegames.com 内网可达性
```

### Step 3: 安装 Skills

```bash
npx skills add blossom91/jx-skills -y -g
```

### Step 4: 认证（按需）

TAPD 使用 access token 认证，在遇到认证错误（JSON 输出 code 100-199）时执行：

```bash
mos tapd auth login --token <access-token>
```

- token 获取地址：https://www.tapd.cn/personal_settings/index?tab=personal_token
- 验证认证：`mos tapd auth whoami`

> **注意**：GOS/BI 的 `auth login` 是交互式 SSO 登录（会打开浏览器），agent 不能直接执行，需提示用户手动运行。

## 使用

### 命令结构

```
mos <业务> <模块> <操作> [参数]
```

### 参考文档机制

对任何不确定的命令，优先用 `-r` 获取用法说明，而非猜测参数：

```bash
mos -r                              # 全局指引
mos tapd -r                         # TAPD 业务概览
mos <业务> <模块> <操作> -r         # 操作参数与示例
```

### 输出格式

所有命令输出为 JSON envelope，判断逻辑：`code === 0` 为成功，否则读取 `error.message`。

### 可用业务

| 业务 | 命令前缀 | 说明 |
|------|----------|------|
| TAPD | `mos tapd` | 项目管理 — 需求/缺陷/迭代/用例/Wiki/工时 |

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
