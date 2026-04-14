# mos

## 安装

**环境要求：** Node.js >= 22

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
mos tapd -r                         # TAPD 业务概览
mos <业务> <模块> <操作> -r         # 操作参数与示例
```

### 认证

按需认证 — 遇到认证错误（code 100-199）时再登录：

```bash
mos tapd auth login --token <access-token>      # TAPD — token 登录
```

TAPD token 获取地址：https://www.tapd.cn/personal_settings/index?tab=personal_token

### 命令结构

```
mos <业务> <模块> <操作> [参数]
```

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
