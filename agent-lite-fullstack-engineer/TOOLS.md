# TOOLS.md — 必备工具链

> 用最少的工具，做最多的事。

---

## 🛠️ 核心工具

### 开发环境

```bash
# 必须安装
node --version    # >= 18
npm --version     # >= 9
git --version

# 推荐
pnpm install -g pnpm  # 更快的包管理
```

### 编辑器

**VS Code** + 以下插件：
- ESLint
- Prettier
- GitLens
- Tailwind CSS IntelliSense

---

## ⚡ 快速启动命令

### Next.js 全栈项目（推荐）

```bash
# 创建项目
npx create-next-app@latest my-app --typescript --tailwind --app --src-dir

# 添加数据库
cd my-app
npx prisma init
npx prisma db push

# 启动开发
npm run dev
```

### NestJS 后端

```bash
# 创建项目
npx @nestjs/cli new my-api

# 启动开发
cd my-api
npm run start:dev
```

---

## 📦 常用依赖

### 前端

```bash
# UI组件
npm install @radix-ui/react-*  # 无样式原语
npx shadcn-ui@latest init      # shadcn/ui（推荐）

# 状态管理
npm install zustand             # 简单好用

# 数据请求
npm install axios               # HTTP客户端
```

### 后端

```bash
# ORM
npm install prisma @prisma/client

# 认证
npm install next-auth           # Next.js认证

# 验证
npm install zod                 # Schema验证
```

---

## 🚀 部署

### Vercel（推荐）

```bash
# 安装CLI
npm i -g vercel

# 部署
vercel

# 或连接GitHub自动部署
```

### Railway

```bash
# 安装CLI
npm i -g @railway/cli

# 部署
railway login
railway init
railway up
```

---

## 🔧 常用命令速查

```bash
# 开发
npm run dev          # 启动开发服务器
npm run build        # 构建生产版本
npm run start        # 启动生产服务器

# 数据库
npx prisma studio    # 打开数据库GUI
npx prisma db push   # 同步Schema到数据库
npx prisma migrate dev  # 创建迁移

# 代码质量
npm run lint         # ESLint检查
npm run format       # Prettier格式化

# Git
git add .
git commit -m "feat: xxx"
git push
```

---

*"工具够用就行，关键是用好。"*

---

*Last Updated: 2026-03-17*
