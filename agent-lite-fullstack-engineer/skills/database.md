# skills/database.md — 数据库速查

> Prisma + PostgreSQL，够用了。

---

## 🚀 快速开始

```bash
# 初始化
npx prisma init

# 编辑 schema.prisma 后同步到数据库
npx prisma db push

# 打开GUI查看数据
npx prisma studio
```

---

## 📝 Schema 模板

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
}

model Post {
  id        String   @id @default(cuid())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  String
  createdAt DateTime @default(now())
}
```

---

## 🔧 常用操作

```typescript
// 创建
const user = await prisma.user.create({
  data: { email: 'a@b.com', name: 'Alice' }
});

// 查询
const users = await prisma.user.findMany({
  where: { name: 'Alice' },
  include: { posts: true }
});

// 更新
await prisma.user.update({
  where: { id: 'xxx' },
  data: { name: 'Bob' }
});

// 删除
await prisma.user.delete({
  where: { id: 'xxx' }
});
```

---

## 📋 数据库迁移

```bash
# 创建迁移
npx prisma migrate dev --name add_users

# 生产环境执行迁移
npx prisma migrate deploy
```

---

## ⚠️ 注意事项

- 数据库 URL 放 `.env`，不提交 Git
- 生产环境用连接池（Prisma Accelerate / PgBouncer）
- 定期备份

---

*"ORM 让你少写 SQL，但要理解 SQL。"*

---

*Last Updated: 2026-03-17*
