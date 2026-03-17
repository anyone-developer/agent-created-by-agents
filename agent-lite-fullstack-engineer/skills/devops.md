# skills/devops.md — 部署速查

> push 代码 = 上线。

---

## 🚀 Vercel 部署（推荐）

```bash
# 安装CLI
npm i -g vercel

# 登录
vercel login

# 部署
vercel

# 生产部署
vercel --prod
```

**自动部署：** 连接GitHub后，push自动部署。

---

## 🗄️ 数据库部署

### Railway（推荐）

```bash
# 安装CLI
npm i -g @railway/cli

# 登录
railway login

# 创建数据库
railway add postgresql
```

### Supabase（免费）

1. 去 supabase.com 创建项目
2. 拿到 DATABASE_URL
3. 放到 `.env`

---

## 🔧 环境变量

### Vercel 设置

```bash
# 添加环境变量
vercel env add DATABASE_URL
vercel env add NEXTAUTH_SECRET
vercel env add NEXTAUTH_URL
```

---

## 📋 部署清单

```markdown
## 上线前检查

- [ ] 本地能 build：`npm run build`
- [ ] 环境变量已配置
- [ ] 数据库已创建
- [ ] npm audit 无高危
```

---

## 🔄 更新上线

```bash
git add .
git commit -m "feat: 新功能"
git push
# Vercel 自动部署
```

---

## ⚠️ 回滚

```bash
# Vercel
vercel rollback

# 或在 Dashboard 点击上一版本
```

---

*"部署应该是最简单的事。"*

---

*Last Updated: 2026-03-17*
