---
name: mos-core
description: 当用户需要使用 mos CLI 进行任何操作时使用。提供安装检测、reference 机制教学和通用操作模式。当其他 mos 相关 skill（mos-gos、mos-bi）被触发时，本 skill 的安装检测和通用模式也应被参考。
---

# mos CLI 核心操作指南

mos 是一个 AI-friendly 的 CLI，用于管理 GOS（游戏运营）和 BI（大数据）平台。所有输出为结构化 JSON，支持 `-r` 参考文档机制。

## 安装检测

在首次执行任何 mos 命令前，必须检测 mos 是否已安装：

```bash
which mos
```

**如果未安装**，引导用户确认后执行：

```bash
npm install -g @diezhi/mos-cli --registry=https://npm.papegames.com/
```

安装完成后验证：

```bash
mos --version
```

## Reference 机制（核心）

mos 内置了 `-r/--reference` 参考文档机制。对于任何不熟悉的命令，**优先使用 `-r` 获取参考文档**，而不是猜测参数：

```bash
# 获取某个业务模块的参考文档
mos gos notification -r

# 获取特定操作的参考文档
mos gos notification add -r

# 获取整体参考（不带参数）
mos -r
```

`-r` 输出的是 markdown 格式的操作指南，包含参数说明、示例和注意事项。

## 通用操作模式

对于任何 mos 操作，遵循以下流程：

1. **检查认证**：`mos <business> auth status`
2. **获取参考文档**：`mos <business> <module> -r`（如果不确定用法）
3. **执行操作**：`mos <business> <module> <action> [params]`
4. **解析输出**：所有输出为 JSON envelope

## 输出格式

所有 mos 命令输出遵循统一的 JSON envelope：

**成功：**
```json
{
  "code": 0,
  "data": { ... }
}
```

**失败：**
```json
{
  "code": <非零错误码>,
  "error": {
    "message": "错误描述",
    "details": { ... }
  }
}
```

错误码范围：
- 1-99：通用错误
- 100-199：认证错误
- 300-399：HTTP 错误
- 400-499：配置错误

**判断逻辑**：`code === 0` 为成功，否则读取 `error.message`。

## 认证流程

每个业务都有独立的认证：

```bash
# 检查认证状态
mos <business> auth status

# 登录（交互式，需要用户在浏览器中操作）
mos <business> auth login

# 登出
mos <business> auth logout
```

**重要**：`auth login` 是交互式操作，会打开浏览器进行 SSO 登录。必须提示用户自行执行此命令（使用 `! mos <business> auth login`），不要直接在 Bash 中执行。

### TAPD 认证

TAPD 使用 access token 认证（非 SSO），流程：

1. 用户提供 access token
2. 执行 `mos tapd auth login --token <token>`
3. 验证：`mos tapd auth whoami`

> 注意：TAPD 不像 GOS/BI 需要 SSO 浏览器登录，可以直接通过 token 认证。

## 配置管理

```bash
mos config get [key]    # 查看配置
mos config set <key> <val>  # 设置配置
```

## 可用业务

| 业务 | 命令前缀 | 说明 |
|------|---------|------|
| GOS | `mos gos` | 游戏运营平台 |
| BI | `mos bi` | 大数据平台 |
| TAPD | `mos tapd` | TAPD 项目管理（需求/缺陷/迭代/Wiki/工时） |

如需了解具体业务操作，参考 mos-gos、mos-bi 或 mos-tapd skill。
