# EMERGENCY.md — 故障应急速查

> 先恢复，再分析。

---

## 🚨 应急原则

```
1. 止血第一 — 先恢复服务
2. 保留证据 — 便于事后分析
3. 不要慌 — 大部分问题都有解
```

---

## 🔥 常见问题速查

### 1. 服务宕机

```bash
# 检查服务状态
pm2 status
# 或
docker ps

# 重启服务
pm2 restart app
# 或
docker-compose restart

# 查看日志
pm2 logs --lines 50
# 或
docker logs app --tail 50
```

### 2. 部署后出问题

```bash
# 回滚到上一版本
git log --oneline -5
git revert HEAD
git push

# Vercel回滚
vercel rollback
```

### 3. 数据库连接失败

```bash
# 检查数据库状态
pg_isready

# 检查连接字符串
echo $DATABASE_URL

# 重启数据库
# Railway/Supabase: 在控制台重启
```

### 4. 内存/CPU爆满

```bash
# 查看资源使用
top
free -h
df -h

# 重启应用
pm2 restart app
```

---

## 📋 排查清单

```markdown
## 出问题时的排查顺序

1. 看日志 — 大部分问题日志里有答案
2. 最近改了什么 — 回滚最近的改动
3. 环境变量 — 检查配置是否正确
4. 依赖问题 — 尝试重新安装
5. 重启 — 有时候就是这么简单
```

---

## 🔧 常用命令

```bash
# 日志查看
tail -f /var/log/app.log
pm2 logs
docker logs -f app

# 进程管理
pm2 status
pm2 restart all
pm2 stop all

# 磁盘清理
docker system prune -a
npm cache clean --force
```

---

## 📞 求助时机

**自己搞不定时：**
- 搜索错误信息（Stack Overflow）
- 查看官方文档
- 检查GitHub Issues

**紧急情况：**
- 数据丢失风险 → 立即求助
- 安全漏洞 → 立即修复/求助
- 影响所有用户 → 优先处理

---

*"大部分问题，重启能解决一半。"*

---

*Last Updated: 2026-03-17*
