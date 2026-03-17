# EMERGENCY.md — 故障应急手册

> 故障不可避免，快速恢复才是关键。

---

## 🚨 应急响应原则

### 黄金法则

```
1. 止血第一 — 先恢复服务，再查根因
2. 信息同步 — 保持团队信息透明
3. 保留证据 — 操作前备份，方便事后分析
4. 分级响应 — 根据严重程度启动不同流程
5. 事后复盘 — 每次故障都是学习机会
```

### 响应时效要求

| 级别 | 定义 | 响应时间 | 恢复时间目标 |
|------|------|---------|-------------|
| **P0** | 全站不可用、数据丢失 | 5分钟 | 30分钟 |
| **P1** | 核心功能不可用 | 15分钟 | 1小时 |
| **P2** | 部分功能异常 | 30分钟 | 4小时 |
| **P3** | 非核心功能异常 | 2小时 | 24小时 |

---

## 📞 升级路径与联系人

### 升级路径

```
一线值班 → 技术负责人 → 技术总监 → CTO
   ↓           ↓           ↓
 15分钟      30分钟      1小时
```

### 联系人模板

```markdown
## 紧急联系人

| 角色 | 姓名 | 电话 | 备注 |
|------|------|------|------|
| 一线值班 | | | 7x24 |
| 后端负责人 | | | |
| 前端负责人 | | | |
| DBA | | | |
| 运维负责人 | | | |
| 技术总监 | | | |
| 产品负责人 | | | |
```

---

## 🔥 P0级故障响应

### 立即响应（0-5分钟）

```markdown
## P0故障响应清单

### Step 1: 确认故障（1分钟）
- [ ] 确认故障现象
- [ ] 确认影响范围
- [ ] 确认开始时间

### Step 2: 拉起响应群（2分钟）
- [ ] 创建临时群聊/会议
- [ ] 拉入相关人员
- [ ] 指定故障指挥官

### Step 3: 初步止血（5分钟）
- [ ] 检查最近变更
- [ ] 考虑回滚
- [ ] 临时降级方案
```

### 故障指挥官职责

```markdown
## 故障指挥官（Incident Commander）

### 职责
- 协调各方资源
- 决策应急方案
- 对外沟通
- 记录时间线

### 权限
- 可以直接操作生产环境
- 可以调动任何资源
- 可以决定回滚/降级

### 注意
- 不要亲自排查问题
- 专注于协调和决策
- 保持冷静
```

### 信息同步模板

```markdown
## 故障通报模板

### 初始通报
**时间：** HH:MM
**影响：** [描述影响范围]
**当前状态：** 正在排查
**负责人：** xxx

### 进展通报（每15分钟）
**时间：** HH:MM
**进展：** [描述最新进展]
**下一步：** [描述下一步计划]
**预计恢复：** [预估时间]

### 恢复通报
**时间：** HH:MM
**影响：** [描述影响范围]
**根因：** [简述根因]
**恢复措施：** [描述恢复措施]
**后续：** [后续计划]
```

---

## 🔄 常见故障场景与处理

### 场景1: 服务完全不可用

```markdown
## 服务宕机

### 症状
- 无法访问网站/API
- 502/504错误
- 连接超时

### 排查步骤
1. 检查服务器状态
   ```bash
   # 检查服务是否运行
   systemctl status app
   docker ps
   
   # 检查端口
   netstat -tlnp | grep 3000
   
   # 检查日志
   journalctl -u app -f
   docker logs app --tail 100
   ```

2. 检查资源使用
   ```bash
   # CPU/内存
   top
   free -h
   
   # 磁盘
   df -h
   
   # 网络
   ping google.com
   ```

3. 检查最近变更
   ```bash
   # 最近部署
   git log --oneline -10
   
   # 最近配置变更
   ```

### 止血方案
- 方案A：重启服务
- 方案B：回滚到上一版本
- 方案C：切换到备用服务器
```

### 场景2: 数据库故障

```markdown
## 数据库问题

### 症状
- 查询超时
- 连接池耗尽
- 数据不一致

### 排查步骤
1. 检查数据库状态
   ```sql
   -- 检查连接数
   SELECT count(*) FROM pg_stat_activity;
   
   -- 检查慢查询
   SELECT * FROM pg_stat_activity 
   WHERE state = 'active' 
   AND now() - query_start > interval '5 seconds';
   
   -- 检查锁
   SELECT * FROM pg_locks WHERE NOT granted;
   ```

2. 检查资源
   ```bash
   # 磁盘空间
   df -h
   
   # 内存使用
   free -h
   ```

### 止血方案
- 方案A：终止慢查询
- 方案B：重启数据库连接池
- 方案C：切换到从库
- 方案D：从备份恢复
```

### 场景3: 内存泄漏

```markdown
## 内存泄漏

### 症状
- 服务内存持续增长
- 最终OOM被杀死
- 性能逐渐下降

### 排查步骤
1. 确认内存泄漏
   ```bash
   # 监控内存趋势
   top -p <pid>
   
   # 或使用监控工具
   ```

2. 分析内存使用
   ```bash
   # Node.js
   node --inspect app.js
   # 然后用Chrome DevTools Memory面板
   
   # 或生成heap dump
   kill -USR2 <pid>
   ```

### 止血方案
- 方案A：定期重启（临时）
- 方案B：限制最大内存
- 方案C：找到并修复泄漏点
```

### 场景4: 流量突增

```markdown
## 流量突增

### 症状
- 响应时间变长
- 5xx错误增多
- 服务器负载高

### 排查步骤
1. 确认流量来源
   ```bash
   # 分析访问日志
   awk '{print $1}' access.log | sort | uniq -c | sort -rn | head
   
   # 检查是否正常流量
   ```

2. 检查系统资源
   ```bash
   # CPU
   top
   
   # 连接数
   netstat -an | wc -l
   ```

### 止血方案
- 方案A：开启CDN缓存
- 方案B：限流（Rate Limiting）
- 方案C：扩容
- 方案D：降级非核心功能
```

### 场景5: 配置错误

```markdown
## 配置错误

### 症状
- 部署后服务异常
- 功能表现不符合预期
- 连接外部服务失败

### 排查步骤
1. 检查最近变更
   ```bash
   # 配置文件变更
   git diff HEAD~1 .env
   
   # 环境变量
   env | grep APP_
   ```

2. 对比环境差异
   ```bash
   # 对比生产和测试环境配置
   diff .env.production .env.staging
   ```

### 止血方案
- 方案A：恢复正确配置
- 方案B：回滚到上一版本
```

---

## 🛠️ 应急工具箱

### 快速检查命令

```markdown
## 一键检查脚本

```bash
#!/bin/bash
# health-check.sh

echo "=== 系统状态 ==="
uptime
free -h
df -h

echo "=== 服务状态 ==="
systemctl status app --no-pager
docker ps

echo "=== 网络状态 ==="
netstat -tlnp | grep -E ':(80|443|3000|3001)'

echo "=== 最近日志 ==="
journalctl -u app --since "10 minutes ago" --no-pager | tail -20

echo "=== 数据库连接 ==="
psql -c "SELECT count(*) FROM pg_stat_activity;"
```
```

### 回滚脚本

```markdown
## 快速回滚

### Docker部署回滚
```bash
# 查看历史版本
docker images app

# 回滚到指定版本
docker-compose down
docker-compose up -d app:previous-tag
```

### Git部署回滚
```bash
# 回滚到上一提交
git log --oneline -5
git revert HEAD --no-edit
git push

# 或回滚到指定版本
git reset --hard <commit-hash>
git push --force
```

### 数据库回滚
```bash
# 运行down migration
npx prisma migrate reset

# 或手动恢复备份
psql -f backup.sql
```
```

### 监控检查

```markdown
## 监控平台快速检查

### 关键指标
1. **服务可用性** — Uptime监控
2. **响应时间** — P50/P95/P99
3. **错误率** — 5xx错误比例
4. **资源使用** — CPU/Memory/Disk
5. **业务指标** — 订单量/支付成功率

### 告警检查
- 检查当前活跃告警
- 检查告警历史
- 确认告警是否已处理
```

---

## 📋 故障复盘模板

### 复盘会议

```markdown
## 故障复盘

### 基本信息
- **故障标题：** 
- **故障时间：** YYYY-MM-DD HH:MM ~ HH:MM
- **影响时长：** X分钟
- **严重程度：** P0/P1/P2/P3
- **影响范围：** 
- **复盘日期：** 

### 时间线
| 时间 | 事件 | 操作人 |
|------|------|--------|
| HH:MM | 故障开始 | - |
| HH:MM | 发现故障 | xxx |
| HH:MM | 开始响应 | xxx |
| HH:MM | 初步止血 | xxx |
| HH:MM | 完全恢复 | xxx |

### 根因分析
#### 直接原因
[描述直接导致故障的原因]

#### 根本原因
[描述为什么会出现这个问题]

#### 5 Whys分析
1. 为什么故障？→ ...
2. 为什么...？→ ...
3. 为什么...？→ ...
4. 为什么...？→ ...
5. 为什么...？→ ...（根本原因）

### 影响评估
- **用户影响：** 
- **业务影响：** 
- **数据影响：** 

### 做得好的
- [保持/发扬的优点]

### 需要改进的
| 问题 | 改进措施 | 负责人 | 完成时间 |
|------|---------|--------|---------|
| | | | |

### Action Items
- [ ] 改进项1 — 负责人 — 截止日期
- [ ] 改进项2 — 负责人 — 截止日期
- [ ] 改进项3 — 负责人 — 截止日期
```

---

## 📚 应急预案库

### 预案1: 机房故障

```markdown
## 机房故障预案

### 触发条件
- 整个机房不可用
- 网络完全中断

### 响应流程
1. 确认故障范围
2. 启动灾备切换
3. DNS切换到备用机房
4. 通知相关人员
5. 监控恢复情况

### 切换步骤
```bash
# DNS切换（示例）
# 将主域名指向备用IP
```

### 恢复后
- 数据同步回主站
- 切换回主站
- 验证数据完整性
```

### 预案2: 数据泄露

```markdown
## 数据泄露预案

### 触发条件
- 确认敏感数据泄露
- 收到安全告警

### 响应流程
1. 立即隔离受影响系统
2. 评估泄露范围
3. 通知安全团队
4. 修复漏洞
5. 通知受影响用户（如需要）
6. 报告监管机构（如需要）

### 注意事项
- 保留所有证据
- 不要自行删除日志
- 配合安全团队调查
```

### 预案3: DDoS攻击

```markdown
## DDoS攻击预案

### 触发条件
- 异常流量激增
- 服务响应变慢
- 收到CDN/云服务商告警

### 响应流程
1. 确认是否为DDoS
2. 联系CDN/云服务商
3. 开启防护模式
4. 配置IP黑名单
5. 启用限流策略
6. 必要时切换高防IP

### 防护配置
```nginx
# Nginx限流配置
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;

location / {
    limit_req zone=burst=20;
}
```
```

---

## 🔧 应急工具清单

### 监控工具

| 工具 | 用途 | 访问方式 |
|------|------|---------|
| Grafana | 指标监控 | URL |
| Sentry | 错误追踪 | URL |
| UptimeRobot | 可用性监控 | URL |
| PagerDuty | 告警管理 | URL |

### 运维工具

| 工具 | 用途 | 命令 |
|------|------|------|
| SSH | 服务器访问 | `ssh user@host` |
| Docker | 容器管理 | `docker ps/logs/restart` |
| kubectl | K8s管理 | `kubectl get pods/logs` |
| psql | 数据库访问 | `psql -h host -U user` |

### 日志查看

```markdown
## 日志位置

### 应用日志
- Docker: `docker logs <container>`
- Systemd: `journalctl -u app`
- 文件: `/var/log/app/`

### 系统日志
- `/var/log/syslog`
- `/var/log/messages`

### Nginx日志
- 访问日志: `/var/log/nginx/access.log`
- 错误日志: `/var/log/nginx/error.log`

### 数据库日志
- PostgreSQL: `/var/log/postgresql/`
```

---

## 📊 应急演练

### 演练计划

```markdown
## 应急演练

### 频率
- 季度演练：全流程演练
- 月度演练：单场景演练

### 演练场景
1. 服务宕机恢复
2. 数据库故障切换
3. 流量突增应对
4. 数据泄露响应

### 演练评估
- 响应时间
- 恢复时间
- 沟通效率
- 改进点
```

---

*"好的应急响应不是不出故障，而是快速恢复。"*

---

*Last Updated: 2026-03-17*
