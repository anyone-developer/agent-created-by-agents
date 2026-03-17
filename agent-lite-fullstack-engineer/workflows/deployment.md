# workflows/deployment.md — 快速部署指南

> 推代码 = 上线。

---

## 🚀 部署方式

### Vercel（推荐 - 零配置）

```bash
# 1. 安装CLI
npm i -g vercel

# 2. 登录
vercel login

# 3. 部署
vercel

# 4. 生产部署
vercel --prod
```

**自动部署：** 连接GitHub后，push代码自动部署。

---

### Railway（后端/数据库）

```bash
# 1. 安装CLI
npm i -g @railway/cli

# 2. 登录
railway login

# 3. 初始化
railway init

# 4. 部署
railway up
```

---

## 📋 部署前检查

```markdown
## 快速检查

- [ ] 本地能build：`npm run build`
- [ ] 环境变量已配置
- [ ] 数据库已创建
```

---

## 🔧 环境变量配置

### Vercel

```bash
# 添加环境变量
vercel env add DATABASE_URL
vercel env add NEXTAUTH_SECRET
vercel env add NEXTAUTH_URL
```

### Railway

在Dashboard → Variables 中添加。

---

## 📊 数据库部署

### Prisma迁移

```bash
# 生成迁移文件
npx prisma migrate dev --name init

# 生产环境执行迁移
npx prisma migrate deploy
```

---

## 🔄 更新部署

```bash
# 修改代码后
git add .
git commit -m "feat: 新功能"
git push

# Vercel自动部署
# Railway自动部署（如果配置了）
```

---

## ⚠️ 回滚

### Vercel

```bash
# CLI回滚
vercel rollback

# 或在Dashboard点击上一版本
```

### Git回滚

```bash
git revert HEAD
git push
```

---

## ✅ 部署后验证

```markdown
## 快速验证

- [ ] 网站能访问
- [ ] 核心功能正常
- [ ] 没有明显错误
```

---

*"部署不应该是一件大事。"*

---

*Last Updated: 2026-03-17*
