---
name: mos-bi
description: 当用户需要操作 BI 大数据平台时使用，包括认证登录和数据相关操作。触发关键词：BI、大数据、数据查询、数据平台。
---

# BI 大数据平台操作指南

BI（Big Data Intelligence）是大数据平台，通过 mos CLI 进行操作。

## 前置检查

在执行任何 BI 操作前：

1. **确保 mos 已安装**（参考 mos-core skill 的安装检测逻辑）
2. **检查 BI 认证状态**：

```bash
mos bi auth status
```

如果未登录，提示用户自行执行登录（交互式 SSO）：
> 请执行 `! mos bi auth login` 进行登录

## 可用模块

| 模块 | 命令 | 说明 |
|------|------|------|
| auth | `mos bi auth` | 认证管理（login/status/logout） |

## 操作方式

对于任何具体操作，使用 `-r` 获取参考文档：

```bash
# 查看 BI 的参考文档
mos bi -r
```

读取参考文档后，根据文档说明构造命令执行。

## 常用操作速查

### 认证

```bash
mos bi auth login     # SSO 登录（交互式，需用户操作）
mos bi auth status    # 查看登录状态
mos bi auth logout    # 登出
```

## 探索更多

BI 平台会持续新增模块。使用以下命令发现可用功能：

```bash
mos bi --help        # 查看所有 BI 子命令
mos bi <module> -r   # 查看某模块的参考文档
```
