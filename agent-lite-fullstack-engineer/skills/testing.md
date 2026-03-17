# skills/testing.md — 测试速查

> 核心功能要测，其他的上线后再说。

---

## 🎯 测试策略

```
优先级：
1. 核心业务逻辑 → 必须测
2. API 接口 → 建议测
3. UI 组件 → 有空再测
```

---

## 🧪 Jest 快速开始

```bash
# 安装
npm install -D jest @types/jest ts-jest

# 运行测试
npm test
```

---

## 📝 测试模板

```typescript
// lib/utils.test.ts

import { calculateTotal } from './utils';

describe('calculateTotal', () => {
  it('应该正确计算总价', () => {
    expect(calculateTotal(100, 0.1)).toBe(110);
  });

  it('应该处理零值', () => {
    expect(calculateTotal(0, 0.1)).toBe(0);
  });
});
```

---

## 🔧 API 测试

```typescript
// 使用 supertest
import request from 'supertest';
import { app } from '../app';

describe('GET /api/users', () => {
  it('应该返回用户列表', async () => {
    const res = await request(app).get('/api/users');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});
```

---

## 📋 测试清单

```markdown
## 上线前自测

- [ ] 核心流程能跑通
- [ ] 边界情况处理了
- [ ] 错误提示正常
- [ ] 没有明显 bug
```

---

## ⚠️ 底线

- 核心功能必须有测试
- 不追求 100% 覆盖率
- 测试应该是快速的

---

*"测试是信心的来源，不是负担。"*

---

*Last Updated: 2026-03-17*
