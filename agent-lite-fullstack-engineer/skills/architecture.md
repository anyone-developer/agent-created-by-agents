# skills/architecture.md — 架构速查

> 别想太多，先用这个。

---

## 🎯 默认方案：Next.js 全栈

```
前端 + 后端 + API = Next.js
数据库 = PostgreSQL
ORM = Prisma
部署 = Vercel
```

**一个人，一个仓库，搞定。**

---

## 📁 项目结构

```
my-app/
├── src/
│   ├── app/           # 页面 + API
│   ├── components/    # 组件
│   └── lib/           # 工具函数
├── prisma/
│   └── schema.prisma  # 数据库模型
└── .env               # 环境变量
```

---

## 🔄 什么时候需要拆分？

| 场景 | 方案 |
|------|------|
| 默认 | Next.js 全栈 |
| 需要独立后端 | + NestJS |
| 需要实时 | + Socket.io |
| 需要后台任务 | + Bull Queue |

---

## ⚠️ 不要做的事

- ❌ 一开始就微服务
- ❌ 过度抽象
- ❌ 追新技术

---

*"最简单的方案往往是最好的。"*

---

*Last Updated: 2026-03-17*
