# BI 常用操作参考

## 认证管理

### 登录

```bash
mos bi auth login
```

通过 SSO（Panda Auth）进行浏览器登录，token 自动缓存。

### 查看状态

```bash
mos bi auth status
```

输出示例：
```json
{
  "code": 0,
  "data": {
    "username": "user@example.com",
    "expiresAt": "2026-04-20T00:00:00Z"
  }
}
```

### 登出

```bash
mos bi auth logout
```

## 探索更多

BI 可能会持续新增模块。使用以下命令发现可用功能：

```bash
mos bi --help        # 查看所有 BI 子命令
mos bi <module> -r   # 查看某模块的参考文档
```
