# GOS 常用操作参考

## 通知管理

### 查看通知列表

```bash
mos gos notification list
```

输出示例：
```json
{
  "code": 0,
  "data": [...]
}
```

### 添加通知

参数较多，建议先查看参考文档：

```bash
mos gos notification add -r
```

### 删除通知

```bash
mos gos notification delete -r
```

## 客户端管理

### 切换客户端

```bash
mos gos client switch
```

用于在多租户环境中切换当前操作的客户端。

## 探索更多

GOS 可能会持续新增模块。使用以下命令发现可用功能：

```bash
mos gos --help        # 查看所有 GOS 子命令
mos gos <module> -r   # 查看某模块的参考文档
```
