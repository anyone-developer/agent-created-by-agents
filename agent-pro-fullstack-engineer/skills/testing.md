# 🧪 TESTING.md — 测试能力完全指南

> "没有测试的代码是负债，不是资产。"

---

## 🧠 测试思维核心理念

### 1. "测试即设计"
- 好的代码天然可测，不可测的代码往往设计有问题
- 先想"怎么测"，再想"怎么写"
- **口头禅：** "如果这段代码很难写测试，说明它做得太多了"

### 2. "测试不是保险，是规范"
- 测试不保证没有 bug，但保证行为符合预期
- 测试是代码的"活文档"，比注释更可靠
- **心态：** 测试不是事后补救，而是开发的一部分

### 3. "恰到好处的测试"
- 100% 覆盖率不是目标，有意义的覆盖才是
- 测试收益递减：边际效益 > 边际成本时才值得写
- **口头禅：** "测核心逻辑，别测框架行为"

---

## 📐 测试金字塔深度解析

### 经典模型

```
              /\
             /  \        E2E 测试 (10%)
            /----\       验证核心用户流程
           /      \      
          /--------\     集成测试 (20%)
         /          \    验证模块间交互
        /____________\   
       /              \  单元测试 (70%)
      /                \ 验证函数逻辑
     /__________________\
```

### 各层职责

| 层级 | 目标 | 速度 | 成本 | 数量 |
|------|------|------|------|------|
| **单元测试** | 验证函数/方法逻辑 | 极快 (<10ms) | 低 | 大量 |
| **集成测试** | 验证模块/服务交互 | 中等 (100ms-1s) | 中 | 适量 |
| **E2E 测试** | 验证完整用户流程 | 慢 (1s-10s) | 高 | 少量 |

### 现代调整（测试奖杯）

```
          /\
         /E2E\         少量，验证核心流程
        /------\
       /  集成  \      适量，验证模块交互
      /----------\
     /   单元测试  \    大量，验证函数逻辑
    /--------------\
   /     Static     \  ESLint/TypeScript
  /__________________\
```

**关键洞察：** 现代观点认为集成测试的 ROI 最高，应该多写。

---

## 🧪 单元测试（Unit Tests）

### 测试什么

✅ **应该测：**
- 业务逻辑（计算、转换、验证）
- 边界条件（空值、极值、特殊字符）
- 错误处理（异常、错误码）
- 状态转换（状态机）

❌ **不应该测：**
- 第三方库的内部行为
- 框架代码
- Getter/Setter（除非有逻辑）
- 纯粹的 HTML/CSS

### 测试命名规范

```typescript
// 推荐模式：should [预期行为] when [条件]
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user successfully when email is valid', () => {});
    it('should throw ConflictException when email already exists', () => {});
    it('should trim whitespace from username', () => {});
  });
});
```

### 测试结构（AAA 模式）

```typescript
it('should calculate discount correctly for VIP users', () => {
  // Arrange - 准备测试数据
  const user = { id: 1, role: 'vip' };
  const order = { total: 1000, items: [...] };
  
  // Act - 执行被测代码
  const result = calculateDiscount(user, order);
  
  // Assert - 验证结果
  expect(result.discount).toBe(150);  // VIP 15% 折扣
  expect(result.finalTotal).toBe(850);
});
```

### 多语言示例

#### TypeScript (Vitest/Jest)

```typescript
import { describe, it, expect, vi } from 'vitest';
import { UserService } from './user.service';
import { UserRepository } from './user.repository';

describe('UserService', () => {
  let userService: UserService;
  let mockUserRepo: ReturnType<typeof vi.fn>;

  beforeEach(() => {
    mockUserRepo = {
      findByEmail: vi.fn(),
      create: vi.fn(),
      findById: vi.fn(),
    };
    userService = new UserService(mockUserRepo);
  });

  describe('createUser', () => {
    it('should create user when email is new', async () => {
      // Arrange
      const dto = { email: 'test@example.com', name: 'Test' };
      mockUserRepo.findByEmail.mockResolvedValue(null);
      mockUserRepo.create.mockResolvedValue({ id: 1, ...dto });

      // Act
      const result = await userService.createUser(dto);

      // Assert
      expect(result.id).toBe(1);
      expect(mockUserRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({ email: dto.email })
      );
    });

    it('should throw ConflictException when email exists', async () => {
      // Arrange
      mockUserRepo.findByEmail.mockResolvedValue({ id: 1 });

      // Act & Assert
      await expect(
        userService.createUser({ email: 'exists@example.com', name: 'Test' })
      ).rejects.toThrow('该邮箱已注册');
    });

    it('should normalize email to lowercase', async () => {
      // Arrange
      const dto = { email: 'Test@Example.COM', name: 'Test' };
      mockUserRepo.findByEmail.mockResolvedValue(null);
      mockUserRepo.create.mockResolvedValue({ id: 1, ...dto });

      // Act
      await userService.createUser(dto);

      // Assert
      expect(mockUserRepo.create).toHaveBeenCalledWith(
        expect.objectContaining({ email: 'test@example.com' })
      );
    });
  });
});
```

#### Python (pytest)

```python
import pytest
from unittest.mock import AsyncMock, MagicMock
from datetime import datetime
from user_service import UserService
from exceptions import ConflictException

@pytest.fixture
def mock_user_repo():
    repo = AsyncMock()
    repo.find_by_email = AsyncMock(return_value=None)
    repo.create = AsyncMock(return_value={"id": 1})
    return repo

@pytest.fixture
def user_service(mock_user_repo):
    return UserService(user_repo=mock_user_repo)

class TestUserService:
    @pytest.mark.asyncio
    async def test_create_user_success(self, user_service, mock_user_repo):
        """应该成功创建用户"""
        # Arrange
        dto = {"email": "test@example.com", "name": "Test"}
        
        # Act
        result = await user_service.create_user(dto)
        
        # Assert
        assert result["id"] == 1
        mock_user_repo.create.assert_called_once()

    @pytest.mark.asyncio
    async def test_create_user_duplicate_email(self, user_service, mock_user_repo):
        """邮箱已存在时应该抛出异常"""
        # Arrange
        mock_user_repo.find_by_email.return_value = {"id": 1}
        
        # Act & Assert
        with pytest.raises(ConflictException) as exc_info:
            await user_service.create_user(
                {"email": "exists@example.com", "name": "Test"}
            )
        assert "已注册" in str(exc_info.value)

    @pytest.mark.asyncio
    async def test_create_user_normalizes_email(self, user_service, mock_user_repo):
        """邮箱应该规范化为小写"""
        # Arrange
        dto = {"email": "Test@Example.COM", "name": "Test"}
        
        # Act
        await user_service.create_user(dto)
        
        # Assert
        call_args = mock_user_repo.create.call_args[0][0]
        assert call_args["email"] == "test@example.com"

    @pytest.mark.parametrize("email,expected_valid", [
        ("test@example.com", True),
        ("invalid", False),
        ("@example.com", False),
        ("test@", False),
        ("", False),
    ])
    def test_email_validation(self, user_service, email, expected_valid):
        """邮箱验证边界测试"""
        assert user_service.validate_email(email) == expected_valid
```

#### Go (testing + testify)

```go
package userservice_test

import (
    "context"
    "testing"

    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
    "github.com/stretchr/testify/require"
)

// Mock UserRepo
type MockUserRepo struct {
    mock.Mock
}

func (m *MockUserRepo) FindByEmail(ctx context.Context, email string) (*User, error) {
    args := m.Called(ctx, email)
    if args.Get(0) == nil {
        return nil, args.Error(1)
    }
    return args.Get(0).(*User), args.Error(1)
}

func (m *MockUserRepo) Create(ctx context.Context, user *User) (*User, error) {
    args := m.Called(ctx, user)
    return args.Get(0).(*User), args.Error(1)
}

func TestUserService_CreateUser(t *testing.T) {
    ctx := context.Background()

    t.Run("should create user when email is new", func(t *testing.T) {
        // Arrange
        repo := new(MockUserRepo)
        service := NewUserService(repo)
        
        dto := CreateUserDTO{Email: "test@example.com", Name: "Test"}
        repo.On("FindByEmail", ctx, "test@example.com").Return(nil, nil)
        repo.On("Create", ctx, mock.AnythingOfType("*User")).Return(&User{ID: 1}, nil)
        
        // Act
        result, err := service.CreateUser(ctx, dto)
        
        // Assert
        require.NoError(t, err)
        assert.Equal(t, int64(1), result.ID)
        repo.AssertExpectations(t)
    })

    t.Run("should return error when email exists", func(t *testing.T) {
        // Arrange
        repo := new(MockUserRepo)
        service := NewUserService(repo)
        
        repo.On("FindByEmail", ctx, "exists@example.com").Return(&User{ID: 1}, nil)
        
        // Act
        _, err := service.CreateUser(ctx, CreateUserDTO{
            Email: "exists@example.com",
            Name:  "Test",
        })
        
        // Assert
        require.Error(t, err)
        assert.Contains(t, err.Error(), "已注册")
    })
}
```

---

## 🔗 集成测试（Integration Tests）

### 测试范围

```
集成测试关注模块之间的"合约"：
┌─────────────┐     ┌─────────────┐
│   模块 A    │────▶│   模块 B    │
└─────────────┘     └─────────────┘
       │                   │
       └───── 集成测试 ─────┘
       验证：数据传递正确、接口调用无误、错误处理完善
```

### API 集成测试

```typescript
// tests/integration/users.api.test.ts
import request from 'supertest';
import { app } from '../../src/app';
import { prisma } from '../../src/db';

describe('POST /api/users', () => {
  beforeEach(async () => {
    // 清理测试数据
    await prisma.user.deleteMany();
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  it('should return 201 and user data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'new@example.com',
        name: 'New User',
        password: 'SecurePass123!',
      });

    expect(response.status).toBe(201);
    expect(response.body).toMatchObject({
      id: expect.any(Number),
      email: 'new@example.com',
      name: 'New User',
    });
    // 密码不应该返回
    expect(response.body.password).toBeUndefined();
    expect(response.body.hashedPassword).toBeUndefined();
  });

  it('should return 409 when email already exists', async () => {
    // Arrange: 先创建一个用户
    await prisma.user.create({
      data: {
        email: 'exists@example.com',
        name: 'Existing',
        hashedPassword: 'hash123',
      },
    });

    // Act
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'exists@example.com',
        name: 'Duplicate',
        password: 'SecurePass123!',
      });

    // Assert
    expect(response.status).toBe(409);
    expect(response.body.message).toContain('已注册');
  });

  it('should return 400 for invalid input', async () => {
    const testCases = [
      { body: {}, expected: 'email is required' },
      { body: { email: 'invalid' }, expected: 'invalid email' },
      { body: { email: 'test@example.com' }, expected: 'name is required' },
      { body: { email: 'test@example.com', name: 'T' }, expected: 'name too short' },
    ];

    for (const { body, expected } of testCases) {
      const response = await request(app)
        .post('/api/users')
        .send(body);

      expect(response.status).toBe(400);
      expect(response.body.message).toContain(expected);
    }
  });
});
```

### 数据库集成测试

```typescript
// tests/integration/user.repository.test.ts
import { PrismaClient } from '@prisma/client';
import { UserRepository } from '../../src/repositories/user.repository';

describe('UserRepository', () => {
  let prisma: PrismaClient;
  let repo: UserRepository;

  beforeAll(() => {
    prisma = new PrismaClient();
    repo = new UserRepository(prisma);
  });

  beforeEach(async () => {
    await prisma.user.deleteMany();
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  describe('findByEmail', () => {
    it('should return user when email exists', async () => {
      // Arrange
      await prisma.user.create({
        data: { email: 'test@example.com', name: 'Test', hashedPassword: 'hash' },
      });

      // Act
      const user = await repo.findByEmail('test@example.com');

      // Assert
      expect(user).not.toBeNull();
      expect(user!.email).toBe('test@example.com');
    });

    it('should return null when email does not exist', async () => {
      const user = await repo.findByEmail('notexist@example.com');
      expect(user).toBeNull();
    });

    it('should be case-insensitive', async () => {
      await prisma.user.create({
        data: { email: 'test@example.com', name: 'Test', hashedPassword: 'hash' },
      });

      const user = await repo.findByEmail('TEST@EXAMPLE.COM');
      expect(user).not.toBeNull();
    });
  });

  describe('pagination', () => {
    beforeEach(async () => {
      // 创建测试数据
      const users = Array.from({ length: 25 }, (_, i) => ({
        email: `user${i}@example.com`,
        name: `User ${i}`,
        hashedPassword: 'hash',
      }));
      await prisma.user.createMany({ data: users });
    });

    it('should return correct page', async () => {
      const page1 = await repo.findMany({ page: 1, pageSize: 10 });
      expect(page1.items).toHaveLength(10);
      expect(page1.total).toBe(25);
      expect(page1.hasNext).toBe(true);

      const page3 = await repo.findMany({ page: 3, pageSize: 10 });
      expect(page3.items).toHaveLength(5);
      expect(page3.hasNext).toBe(false);
    });
  });
});
```

---

## 🎭 E2E 测试（End-to-End Tests）

### Playwright 示例

```typescript
// e2e/user-registration.spec.ts
import { test, expect } from '@playwright/test';

test.describe('用户注册流程', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/register');
  });

  test('should register successfully with valid data', async ({ page }) => {
    // 填写表单
    await page.fill('[data-testid="email"]', 'newuser@example.com');
    await page.fill('[data-testid="name"]', 'New User');
    await page.fill('[data-testid="password"]', 'SecurePass123!');
    await page.fill('[data-testid="confirmPassword"]', 'SecurePass123!');
    
    // 提交
    await page.click('[data-testid="submit"]');
    
    // 验证跳转
    await expect(page).toHaveURL('/dashboard');
    
    // 验证欢迎消息
    await expect(page.locator('[data-testid="welcome"]')).toContainText('New User');
  });

  test('should show error for duplicate email', async ({ page }) => {
    // 使用已存在的邮箱
    await page.fill('[data-testid="email"]', 'existing@example.com');
    await page.fill('[data-testid="name']