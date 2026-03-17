# workflows/bug-fix.md — Bug修复快速流程

> 快速定位，快速修复。

---

## ⚡ 修复流程

```
复现问题 → 定位原因 → 修复 → 验证 → 上线
```

---

## 📋 Step 1: 复现问题

```markdown
## 复现信息

- 什么操作会触发？
- 每次都出现还是偶发？
- 错误信息是什么？
- 哪个页面/功能？
```

---

## 📋 Step 2: 定位原因

### 常见Bug类型

| 类型 | 检查位置 |
|------|---------|
| 前端显示异常 | 浏览器Console、Network |
| API报错 | 服务器日志 |
| 数据问题 | 数据库、Prisma Studio |

### 快速定位

```bash
# 查看日志
npm run dev  # 开发环境日志
pm2 logs     # 生产环境日志

# 查看数据库
npx prisma studio
```

---

## 📋 Step 3: 修复

```markdown
## 修复原则

1. **最小改动** — 只改必要的
2. **不要借机重构** — 先修bug，重构另说
3. **添加测试** — 防止回归（可选）
```

---

## 📋 Step 4: 验证

```markdown
## 验证清单

- [ ] 原bug不再复现
- [ ] 相关功能正常
- [ ] 没有引入新bug
```

---

## 📋 Step 5: 上线

```bash
git add .
git commit -m "fix: 修复xxx问题"
git push
```

---

## ⚠️ 紧急情况

### 需要立即回滚

```bash
# 回滚到上一版本
git revert HEAD
git push

# Vercel回滚
vercel rollback
```

### 数据问题

```bash
# 先备份
pg_dump $DATABASE_URL > backup.sql

# 再操作
```

---

*"Bug是学习的机会，但不要重复犯同一个。"*

---

*Last Updated: 2026-03-17*
