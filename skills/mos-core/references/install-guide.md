# mos CLI 安装与配置指南

## 安装

### 前置条件
- Node.js >= 22
- npm（随 Node.js 安装）

### 安装命令

```bash
npm install -g @diezhi/mos-cli --registry=https://npm.papegames.com/
```

### 验证安装

```bash
mos --version
```

## 配置

mos 的配置文件位于 `~/.config/mos/` 目录下。

### 查看配置

```bash
mos config get
```

### 设置配置项

```bash
mos config set <key> <value>
```

JSON 值会自动检测和解析。

## 认证

每个业务平台有独立的认证，基于 SSO（Panda Auth）。

### GOS 登录

```bash
mos gos auth login
```

执行后会打开浏览器进行 SSO 登录，登录成功后 token 自动缓存到本地。

### BI 登录

```bash
mos bi auth login
```

### 查看认证状态

```bash
mos gos auth status
mos bi auth status
```

### 登出

```bash
mos gos auth logout
mos bi auth logout
```

## 故障排查

| 问题 | 解决方案 |
|------|---------|
| `command not found: mos` | 重新安装：`npm install -g @diezhi/mos-cli --registry=https://npm.papegames.com/` |
| 认证过期 | 重新登录：`mos <business> auth login` |
| registry 连不上 | 检查内网连接，确认可以访问 `npm.papegames.com` |
