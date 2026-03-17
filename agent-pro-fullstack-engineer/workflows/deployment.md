# 🚀 workflows/deployment.md — 部署上线流程

> 部署不是终点，是产品交付的开始。

---

## 📋 部署前准备

### 1. 代码就绪

```markdown
## 代码检查清单
- [ ] 所有功能开发完成
- [ ] 代码审查通过
- [ ] 所有测试通过（单元/集成/E2E）
- [ ] 已合并到主分支 (main/master)
- [ ] 已创建 Git Tag (v1.0.0)
- [ ] CHANGELOG 已更新
```

### 2. 环境配置

```markdown
## 环境变量检查
- [ ] 生产环境变量已配置
- [ ] 敏感信息已加密存储
- [ ] API Key/Secret 已更新
- [ ] 数据库连接字符串正确
- [ ] 第三方服务凭证有效
```

### 3. 数据库准备

```markdown
## 数据库检查
- [ ] 迁移脚本已准备
- [ ] 迁移脚本已在测试环境验证
- [ ] 回滚脚本已准备
- [ ] 数据备份已完成
- [ ] 索引优化已检查
```

### 4. 基础设施就绪

```markdown
## 基础设施检查
- [ ] 服务器/容器资源充足
- [ ] 域名解析正确
- [ ] SSL 证书有效
- [ ] CDN 配置正确
- [ ] 负载均衡配置
- [ ] 防火墙规则更新
```

---

## 🔄 部署策略选择

### 蓝绿部署（推荐 - 零停机）

```
部署前：
┌─────────┐
│  Blue   │ ← 当前生产流量
│ (v1.0)  │
└─────────┘
┌─────────┐
│  Green  │ ← 空闲
│  (空)   │
└─────────┘

部署中：
┌─────────┐
│  Blue   │ ← 仍然服务流量
│ (v1.0)  │
└─────────┘
┌─────────┐
│  Green  │ ← 部署新版本 v2.0
│ (v2.0)  │
└─────────┘

切换后：
┌─────────┐
│  Blue   │ ← 备份（可快速回滚）
│ (v1.0)  │
└─────────┘
┌─────────┐
│  Green  │ ← 生产流量切换到此处
│ (v2.0)  │
└─────────┘
```

**优点：** 零停机、快速回滚
**缺点：** 需要双倍资源

### 金丝雀发布（推荐 - 渐进放量）

```
阶段1: 5% 流量 → 新版本
阶段2: 25% 流量 → 新版本
阶段3: 50% 流量 → 新版本
阶段4: 100% 流量 → 新版本

如有问题：随时回滚到上一阶段
```

**优点：** 风险可控、可观察
**缺点：** 部署周期较长

### 滚动更新

```
Pod1 → 更新 → 健康检查 → 继续
Pod2 → 更新 → 健康检查 → 继续
Pod3 → 更新 → 健康检查 → 继续
...
```

**优点：** 资源利用率高
**缺点：** 可能有短暂的版本不一致

---

## 🚀 部署步骤

### Step 1: 备份

```bash
# 数据库备份
pg_dump -h $DB_HOST -U $DB_USER $DB_NAME | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz

# 上传到安全存储
aws s3 cp backup_*.sql.gz s3://my-backups/

# 验证备份完整性
gunzip -t backup_*.sql.gz && echo "✅ Backup valid"
```

### Step 2: 部署后端

```bash
# Docker 部署
docker pull myregistry/myapp:latest
docker-compose down
docker-compose up -d

# 或 Kubernetes 部署
kubectl set image deployment/myapp myapp=myregistry/myapp:v2.0
kubectl rollout status deployment/myapp
```

### Step 3: 数据库迁移

```bash
# 运行迁移
npm run migrate:prod

# 或
npx prisma migrate deploy

# 验证迁移
npm run migrate:status
```

### Step 4: 部署前端

```bash
# Vercel
vercel --prod

# 或静态文件部署
npm run build
aws s3 sync ./dist s3://my-frontend/ --delete
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
```

### Step 5: 清除缓存

```bash
# CDN 缓存清除
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"

# Redis 缓存清除（如需要）
redis-cli FLUSHDB
```

### Step 6: 健康检查

```bash
# 应用健康检查
curl -f https://api.example.com/health || exit 1

# 数据库连接检查
curl -f https://api.example.com/health/db || exit 1

# 核心功能检查
curl -f https://api.example.com/api/v1/status || exit 1
```

---

## ✅ 部署后验证

### 功能验证清单

```markdown
## 核心功能
- [ ] 用户注册/登录正常
- [ ] 核心业务流程正常
- [ ] API 响应正常
- [ ] 数据读写正常

## 性能检查
- [ ] 首屏加载 < 3s
- [ ] API 响应 < 500ms
- [ ] 无明显卡顿

## 监控检查
- [ ] 错误率正常
- [ ] 响应时间正常
- [ ] 资源使用正常
- [ ] 告警无异常
```

### 用户通知

```markdown
## 通知时机
- 维护前：提前24小时通知
- 维护中：显示维护页面
- 维护完成：发送恢复通知

## 通知渠道
- 应用内公告
- 邮件通知（重要更新）
- 状态页更新
- 社交媒体（如需要）
```

---

## 🔄 回滚方案

### 回滚触发条件

```markdown
立即回滚（无需犹豫）：
- 🔴 核心功能完全不可用
- 🔴 数据损坏或丢失风险
- 🔴 安全漏洞被利用

评估后回滚：
- 🟠 性能严重下降（> 10x）
- 🟠 错误率飙升（> 5%）
- 🟠 大量用户投诉
```

### 回滚步骤

```bash
# 1. 通知相关人员
echo "⚠️ 开始回滚到 v1.0"

# 2. 回滚应用
kubectl rollout undo deployment/myapp

# 3. 回滚数据库（如需要）
psql -h $DB_HOST -U $DB_USER $DB_NAME < backup_before_deploy.sql

# 4. 验证回滚
curl -f https://api.example.com/health

# 5. 清除 CDN 缓存
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"

# 6. 通知回滚完成
echo "✅ 回滚完成，已恢复到 v1.0"
```

---

## 📊 部署记录

### 部署日志模板

```markdown
## 部署记录

**部署版本：** v2.0.0
**部署时间：** 2026-03-17 14:00 GMT+8
**部署人员：** @infra
**部署策略：** 蓝绿部署

### 变更内容
- 新增用户个人中心
- 优化搜索性能
- 修复订单状态bug

### 部署过程
- [x] 14:00 开始部署
- [x] 14:05 数据库迁移完成
- [x] 14:10 应用部署完成
- [x] 14:15 健康检查通过
- [x] 14:20 切换流量完成
- [x] 14:30 验证通过

### 部署结果
- ✅ 部署成功
- 所有功能正常
- 性能指标正常
- 无错误告警

### 备注
- 回滚方案已准备
- 监控重点关注中
```

---

## ⚠️ 常见问题与解决方案

### 部署失败

```markdown
问题：Docker 镜像构建失败
解决：
- 检查 Dockerfile 语法
- 检查依赖安装
- 清理 Docker 缓存重试

问题：数据库迁移失败
解决：
- 检查迁移脚本语法
- 检查数据库权限
- 恢复备份后重试
```

### 部署后问题

```markdown
问题：应用启动失败
解决：
- 检查环境变量
- 检查日志错误
- 检查依赖服务

问题：性能下降
解决：
- 检查数据库慢查询
- 检查缓存是否生效
- 检查资源使用情况
```

---

## 📋 部署检查清单速查

### 部署前 (T-1天)

```markdown
- [ ] 代码冻结
- [ ] 测试通过
- [ ] 文档更新
- [ ] 回滚方案准备
- [ ] 通知相关人员
```

### 部署中 (T-0)

```markdown
- [ ] 数据库备份
- [ ] 后端部署
- [ ] 数据库迁移
- [ ] 前端部署
- [ ] 缓存清除
- [ ] 健康检查
```

### 部署后 (T+1小时)

```markdown
- [ ] 功能验证
- [ ] 性能监控
- [ ] 错误监控
- [ ] 用户反馈
- [ ] 通知完成
```

---

## 🎯 部署最佳实践

### DO ✅

```markdown
- 使用自动化部署（CI/CD）
- 准备回滚方案
- 做好数据库备份
- 部署后验证
- 记录部署日志
- 通知相关人员
```

### DON'T ❌

```markdown
- 周五下午部署
- 没有回滚方案
- 跳过测试直接部署
- 手动操作生产环境
- 部署后不监控
- 出问题不通知
```

---

*"好的部署流程让上线变成一件可以预期、可以控制、可以回滚的事情。"*

*Last Updated: 2026-03-17*
