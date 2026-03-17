# workflows/feature-dev.md — 功能开发快速流程

> 快速实现，快速上线。

---

## ⚡ 开发流程

```
需求理解(5分钟) → 方案设计(5分钟) → 编码实现 → 自测 → 上线
```

---

## 📋 Step 1: 需求理解（5分钟）

```markdown
## 快速需求确认

- 这个功能解决什么问题？
- 用户怎么使用？
- 成功的标准是什么？
- 有什么不确定的地方？
```

---

## 📋 Step 2: 方案设计（5分钟）

```markdown
## 快速方案

### 涉及的部分
- [ ] 前端页面/组件
- [ ] API接口
- [ ] 数据库变动

### 技术方案
用什么技术实现？（保持简单）

### 时间估算
大概需要多久？
```

---

## 📋 Step 3: 编码实现

### 开发顺序

```
1. 数据库模型（Prisma Schema）
2. API接口（Next.js API Routes）
3. 前端页面（React Components）
4. 联调测试
```

### 代码规范

```typescript
// 命名清晰
async function getUserById(id: string) { }

// 错误处理
try {
  const user = await prisma.user.findUnique({ where: { id } });
  if (!user) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 });
  }
  return NextResponse.json(user);
} catch (error) {
  return NextResponse.json({ error: 'Server error' }, { status: 500 });
}
```

---

## 📋 Step 4: 自测

```markdown
## 快速自测清单

- [ ] 正常流程能跑通
- [ ] 边界情况处理了（空值、不存在）
- [ ] 没有明显bug
- [ ] 移动端基本可用
```

---

## 📋 Step 5: 上线

```bash
# 提交代码
git add .
git commit -m "feat: 添加xxx功能"
git push

# Vercel自动部署
# 或手动部署
vercel --prod
```

---

## 🔧 Git提交规范

```bash
feat: 新功能
fix: 修复bug
docs: 文档
style: 格式
refactor: 重构
test: 测试
chore: 杂项
```

---

## ⚠️ 遇到问题？

1. **卡住超过15分钟** → 换个思路或先跳过
2. **不确定方案** → 选最简单的那个
3. **需要确认** → 直接问，不要猜

---

*"能跑就行，先上线再优化。"*

---

*Last Updated: 2026-03-17*
