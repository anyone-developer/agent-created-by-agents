# workflows/new-project.md — 新项目快速启动

> 10分钟搭建，1小时出原型。

---

## ⚡ 快速启动流程

```
需求确认(5分钟) → 技术选型(2分钟) → 项目初始化(3分钟) → 开始开发
```

---

## 📋 Step 1: 需求确认（5分钟）

```markdown
## 快速需求清单

### 核心功能（最多3个）
1. 
2. 
3. 

### 用户角色
- 谁会用这个产品？
- 他们最需要什么？

### 技术偏好
- 有偏好的技术栈吗？
- 没有 → 我推荐 Next.js全栈
```

---

## 📋 Step 2: 技术选型（2分钟）

### 默认推荐（MVP）

```
前端/后端：Next.js 14 (App Router)
数据库：PostgreSQL + Prisma
认证：NextAuth.js
样式：Tailwind CSS
部署：Vercel
```

### 有特殊需求？

| 需求 | 调整 |
|------|------|
| 需要后台任务 | + Bull Queue + Redis |
| 需要实时功能 | + Socket.io |
| 需要文件存储 | + AWS S3 / Cloudflare R2 |
| 需要搜索 | + Algolia / MeiliSearch |

---

## 📋 Step 3: 项目初始化（3分钟）

```bash
# 1. 创建项目
npx create-next-app@latest my-app --typescript --tailwind --app --src-dir
cd my-app

# 2. 初始化数据库
npx prisma init
# 编辑 .env 添加 DATABASE_URL
npx prisma db push

# 3. 安装常用依赖
npm install next-auth @prisma/client zod
npm install -D prisma

# 4. 启动开发
npm run dev
```

---

## 📁 项目结构

```
my-app/
├── src/
│   ├── app/
│   │   ├── layout.tsx      # 全局布局
│   │   ├── page.tsx        # 首页
│   │   └── api/            # API路由
│   ├── components/         # 组件
│   ├── lib/                # 工具函数
│   └── types/              # 类型定义
├── prisma/
│   └── schema.prisma       # 数据库模型
├── .env                    # 环境变量
└── package.json
```

---

## ✅ 完成检查

- [ ] 项目能启动（npm run dev）
- [ ] 数据库连接正常
- [ ] 首页能访问
- [ ] Git初始化完成

---

*"开始比完美更重要。"*

---

*Last Updated: 2026-03-17*
