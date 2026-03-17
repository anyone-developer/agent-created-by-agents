# SECURITY.md — 基础安全指南

> 安全是底线，但不需要过度复杂。

---

## 🔐 核心原则

```
1. 所有输入都是不可信的
2. 密码必须哈希存储
3. 敏感数据必须加密传输
4. 最小权限原则
```

---

## 🛡️ 必须做到的安全措施

### 1. 密码安全

```typescript
import bcrypt from 'bcrypt';

// 哈希密码
const hash = await bcrypt.hash(password, 12);

// 验证密码
const isValid = await bcrypt.compare(password, hash);
```

**绝对禁止：**
- ❌ 明文存储密码
- ❌ 使用MD5/SHA1哈希密码

### 2. 输入验证

```typescript
import { z } from 'zod';

// 使用Zod验证输入
const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

const result = schema.safeParse(req.body);
if (!result.success) {
  return res.status(400).json({ error: 'Invalid input' });
}
```

### 3. SQL注入防护

```typescript
// ✅ 使用ORM（自动转义）
const user = await prisma.user.findUnique({
  where: { email }
});

// ✅ 使用参数化查询
const result = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [email]
);

// ❌ 禁止字符串拼接
// const query = `SELECT * FROM users WHERE email = '${email}'`;
```

### 4. XSS防护

```typescript
// React/Next.js 自动转义
<p>{userInput}</p>  // ✅ 安全

// 危险操作
<div dangerouslySetInnerHTML={{__html: content}} />  // ⚠️ 小心使用
```

### 5. HTTPS

- 生产环境必须使用HTTPS
- 推荐：Vercel/Netlify自动配置

### 6. 安全Headers

```typescript
// Next.js 中间件
import { NextResponse } from 'next/server';

export function middleware(request: Request) {
  const response = NextResponse.next();
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  return response;
}
```

---

## 🔑 认证推荐

### NextAuth.js（推荐）

```typescript
// app/api/auth/[...nextauth]/route.ts
import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';

const handler = NextAuth({
  providers: [
    CredentialsProvider({
      async authorize(credentials) {
        // 验证逻辑
      },
    }),
  ],
});

export { handler as GET, handler as POST };
```

---

## 📋 安全检查清单

### 开发时
- [ ] 输入验证（Zod/Joi）
- [ ] 密码哈希（bcrypt）
- [ ] 参数化查询/ORM
- [ ] 敏感信息不硬编码

### 上线前
- [ ] HTTPS配置
- [ ] 环境变量设置
- [ ] 依赖漏洞检查：`npm audit`

---

## 🚨 如果发现安全问题

1. 立即修复
2. 评估影响范围
3. 必要时重置受影响用户的密码
4. 通知受影响用户（如需要）

---

*"安全不需要完美，但底线必须守住。"*

---

*Last Updated: 2026-03-17*
