---
name: mos-gos
description: 当用户需要操作 GOS 游戏运营平台时使用，包括认证登录、通知管理、客户端切换等。触发关键词：GOS、游戏运营、通知管理、游戏通知、客户端切换。
---

# GOS 游戏运营平台操作指南

GOS（Game Operations）是游戏运营平台，通过 mos CLI 进行操作。

## 前置检查

在执行任何 GOS 操作前：

1. **确保 mos 已安装**（参考 mos-core skill 的安装检测逻辑）
2. **检查 GOS 认证状态**：

```bash
mos gos auth status
```

如果未登录，提示用户自行执行登录（交互式 SSO）：
> 请执行 `! mos gos auth login` 进行登录

## 可用模块

| 模块 | 命令 | 说明 |
|------|------|------|
| auth | `mos gos auth` | 认证管理（login/status/logout） |
| client | `mos gos client` | 客户端/租户切换 |
| notification | `mos gos notification` | 通知管理（add/list/delete） |

## 操作方式

对于任何具体操作，使用 `-r` 获取参考文档：

```bash
# 查看 notification 模块的参考文档
mos gos notification -r

# 查看 notification add 的详细参考
mos gos notification add -r
```

读取参考文档后，根据文档说明构造命令执行。

## 常用操作速查

### 认证

```bash
mos gos auth login     # SSO 登录（交互式，需用户操作）
mos gos auth status    # 查看登录状态
mos gos auth logout    # 登出
```

### 客户端切换

```bash
mos gos client switch  # 切换租户/客户端
```

### 通知管理

```bash
mos gos notification list              # 查看通知列表
mos gos notification add -r            # 查看添加通知的参考文档
mos gos notification delete -r         # 查看删除通知的参考文档
```

**注意**：notification add/delete 的参数较多，务必先用 `-r` 查看参考文档再操作。
