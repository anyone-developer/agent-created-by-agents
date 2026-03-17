# 🖼️ 前端开发能力指南 — Frontend Development Skills

> FullStackPro 的前端能力体系：从技术栈到工程化，从设计系统到性能优化

---

## 一、核心理念

### 前端不只是写页面

优秀的前端工程师需要具备：

| 维度 | 要求 |
|------|------|
| **技术深度** | 理解浏览器原理、JavaScript 引擎、渲染机制 |
| **工程思维** | 组件化、模块化、可维护、可测试 |
| **用户体验** | 响应速度、交互反馈、无障碍、跨设备兼容 |
| **审美能力** | 对像素级细节有执念，不允许丑陋的 UI 存在 |
| **性能意识** | 首屏加载、交互流畅度、内存管理 |

### 工作原则

1. **用户第一** — 写代码时永远思考"用户会怎么用"
2. **80% 完美即可上线** — 先 ship 再迭代，不要陷入完美主义
3. **代码即文档** — 清晰的命名 > 复杂的注释
4. **组件化思维** — 一切皆可复用，一切皆可组合
5. **渐进增强** — 基础功能优先，高级特性锦上添花

---

## 二、技术栈能力矩阵

### 2.1 核心语言

#### HTML5
- 语义化标签（`<article>`, `<section>`, `<nav>`, `<aside>`）
- 表单验证与新 input 类型
- Web Components 基础（Custom Elements, Shadow DOM）
- SVG 内联与动画
- Canvas 2D 绘图

#### CSS3
- Flexbox 布局（精通）
- Grid 布局（精通）
- 响应式设计（媒体查询、流式布局、断点策略）
- CSS 变量（Custom Properties）
- CSS Modules / Scoped CSS
- 动画与过渡（@keyframes, transition, animation）
- 伪类与伪元素
- 选择器优先级与性能
- CSS 架构方法论（BEM, OOCSS, SMACSS, ITCSS）

#### JavaScript (ES6+)
- 原型链与继承机制
- 闭包、作用域、执行上下文
- Promise / async-await
- 事件循环（Event Loop）机制
- Map, Set, WeakMap, WeakSet
- 解构、展开运算符、剩余参数
- 代理（Proxy）与反射（Reflect）
- 模块系统（ES Modules, CommonJS）
- 迭代器与生成器

#### TypeScript
- 类型系统基础（基本类型、联合类型、交叉类型）
- 泛型（Generics）
- 类型守卫（Type Guards）
- 条件类型（Conditional Types）
- 映射类型（Mapped Types）
- 工具类型（Partial, Required, Pick, Omit, Record）
- 声明文件（.d.ts）编写
- 严格模式下的最佳实践

---

### 2.2 框架与库

#### React 生态（首选）

```
├── React 18+
│   ├── Hooks（useState, useEffect, useReducer, useMemo, useCallback, useRef）
│   ├── Context API
│   ├── Suspense + lazy
│   ├── Server Components (RSC)
│   └── Concurrent Mode
│
├── 状态管理
│   ├── Zustand（轻量首选）
│   ├── Jotai / Recoil（原子化状态）
│   ├── Redux Toolkit（大型项目）
│   └── React Query / SWR（服务端状态）
│
├── 路由
│   ├── React Router v6
│   └── TanStack Router
│
└── UI 框架
    ├── Tailwind CSS + Headless UI
    ├── shadcn/ui（组件即代码）
    ├── Radix UI（无样式原语）
    └── Ant Design / Material UI（快速原型）
```

#### Vue 生态

```
├── Vue 3 + Composition API
├── Pinia（状态管理）
├── Vue Router
├── Nuxt 3（元框架）
└── Vuetify / Element Plus
```

#### Svelte 生态

```
├── Svelte 4 / Svelte 5 (Runes)
├── SvelteKit
└── 状态管理（$state, $derived, $effect）
```

---

### 2.3 元框架与渲染策略

#### Next.js（首选）
- App Router 架构
- 服务端组件（RSC）
- 路由与布局系统
- 中间件（Middleware）
- API Routes / Route Handlers
- 数据获取策略（SSR, SSG, ISR, CSR）
- 图片优化（next/image）
- 字体优化（next/font）
- 国际化（i18n）

#### Nuxt 3
- 自动导入
- 组合式函数（Composables）
- 服务端路由
- Nitro 引擎

#### 渲染策略决策

| 策略 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| **CSR** | 仪表盘、后台管理 | 开发简单、交互丰富 | SEO 差、首屏慢 |
| **SSR** | 动态内容、SEO 关键页面 | SEO 好、首屏快 | 服务器压力大 |
| **SSG** | 博客、文档、营销页 | 极致性能、CDN 友好 | 不适合动态内容 |
| **ISR** | 电商、新闻 | 平衡动态与性能 | 配置复杂 |
| **Streaming SSR** | 大页面、慢数据源 | TTFB 快 | 浏览器兼容 |

---

### 2.4 构建工具

#### Vite（首选）
- 基于 ESM 的极速开发体验
- HMR 毫秒级热更新
- Rollup 生产构建
- 插件系统

#### Webpack（遗留项目）
- Loader / Plugin 机制
- 代码分割策略
- Tree Shaking
- Module Federation

#### 其他
- Turbopack（Next.js 默认）
- esbuild（极速打包）
- Rollup（库开发）
- tsup（TypeScript 库打包）

---

## 三、组件化设计方法论

### 3.1 原子设计（Atomic Design）

```
Atoms（原子）
  ↓ 组合
Molecules（分子）
  ↓ 组合
Organisms（有机体）
  ↓ 组成
Templates（模板）
  ↓ 填充
Pages（页面）
```

### 3.2 组件设计原则

#### 单一职责
每个组件只做一件事，做透做好。

#### 组合优于继承
```tsx
// ✅ 好：通过组合实现复用
<Card>
  <CardHeader>
    <CardTitle>标题</CardTitle>
  </CardHeader>
  <CardContent>内容</CardContent>
  <CardFooter>底部</CardFooter>
</Card>

// ❌ 差：通过 props 控制一切
<Card 
  title="标题" 
  content="内容" 
  footer="底部"
  showHeader={true}
  showFooter={true}
/>
```

#### Props 设计

```tsx
// ✅ 好：清晰、类型安全的 Props
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'ghost'
  size: 'sm' | 'md' | 'lg'
  loading?: boolean
  disabled?: boolean
  children: React.ReactNode
  onClick?: () => void
}

// ❌ 差：过于灵活、难以维护
interface ButtonProps {
  style?: any
  [key: string]: any
}
```

#### 受控 vs 非受控

| 类型 | 适用场景 | 示例 |
|------|---------|------|
| **受控** | 需要即时验证、联动 | 表单输入、搜索框 |
| **非受控** | 简单表单、性能敏感 | 文件上传、大文本 |

### 3.3 组件分类

| 类型 | 职责 | 示例 |
|------|------|------|
| **展示组件** | 纯 UI，无业务逻辑 | Button, Card, Badge |
| **容器组件** | 状态管理、数据获取 | UserList, ProductGrid |
| **布局组件** | 页面结构 | Header, Sidebar, Grid |
| **复合组件** | 复杂交互组件 | DatePicker, RichEditor |
| **Hook 组件** | 逻辑封装 | useAuth, useDebounce |

---

## 四、状态管理策略

### 4.1 状态分类

```
本地状态（Local State）
  │
  ├── UI 状态（模态框开关、Tab 选中）
  │   → useState / useReducer
  │
  └── 表单状态
      → React Hook Form / Formik

全局状态（Global State）
  │
  ├── 客户端状态（用户偏好、主题、购物车）
  │   → Zustand / Jotai
  │
  └── 服务端状态（API 数据缓存）
      → React Query / SWR / Apollo Client
```

### 4.2 状态管理选型

| 场景 | 推荐方案 | 理由 |
|------|---------|------|
| 简单状态 | useState | 最简单，无需额外依赖 |
| 复杂表单 | React Hook Form | 性能好、验证方便 |
| 小型全局状态 | Zustand | 轻量、API 简洁 |
| 原子化状态 | Jotai / Recoil | 细粒度更新、避免重渲染 |
| 大型应用 | Redux Toolkit | DevTools 强大、生态成熟 |
| 服务端数据 | React Query | 缓存、重试、乐观更新 |

---

## 五、性能优化体系

### 5.1 Core Web Vitals

| 指标 | 含义 | 目标 |
|------|------|------|
| **LCP** (Largest Contentful Paint) | 最大内容渲染时间 | < 2.5s |
| **FID** (First Input Delay) | 首次输入延迟 | < 100ms |
| **CLS** (Cumulative Layout Shift) | 累积布局偏移 | < 0.1 |
| **INP** (Interaction to Next Paint) | 交互到下一次绘制 | < 200ms |

### 5.2 优化策略

#### 加载优化
- 代码分割（Route-based, Component-based）
- 动态导入（Dynamic Import）
- Tree Shaking
- 懒加载图片（Intersection Observer）
- 预加载关键资源（`<link rel="preload">`）
- 预连接关键域名（`<link rel="preconnect">`）
- 字体优化（font-display: swap, 子集化）

#### 渲染优化
- React.memo / useMemo / useCallback（适度使用）
- 虚拟列表（react-window / react-virtualized）
- 分批渲染（requestIdleCallback）
- 避免布局抖动
- GPU 加速（transform, opacity）

#### 网络优化
- HTTP/2 / HTTP/3
- 资源压缩（gzip / brotli）
- CDN 分发
- Service Worker 缓存
- API 响应缓存策略

#### 运行时优化
- 避免内存泄漏（清理事件监听器、定时器）
- Web Workers 处理重计算
- Debounce / Throttle 高频事件
- RAF（requestAnimationFrame）动画

### 5.3 性能监测工具

| 工具 | 用途 |
|------|------|
| Chrome DevTools Performance | 运行时性能分析 |
| Lighthouse | 综合性能评分 |
| Web Vitals Extension | 实时 CWV 监测 |
| bundlephobia | 包体积分析 |
| webpack-bundle-analyzer | 构建产物分析 |
| React DevTools Profiler | 组件渲染分析 |

---

## 六、设计系统与 Design Token

### 6.1 Design Token 层级

```css
/* 全局 Token */
:root {
  /* 颜色 */
  --color-primary-50: #eff6ff;
  --color-primary-500: #3b82f6;
  --color-primary-900: #1e3a8a;
  
  /* 间距 */
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-4: 1rem;
  
  /* 字体 */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'Fira Code', monospace;
  
  /* 圆角 */
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 1rem;
  
  /* 阴影 */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* 语义 Token */
:root {
  --background-primary: var(--color-white);
  --text-primary: var(--color-gray-900);
  --border-default: var(--color-gray-200);
  --interactive-primary: var(--color-primary-500);
  --interactive-primary-hover: var(--color-primary-600);
}

/* 暗色主题 */
[data-theme="dark"] {
  --background-primary: var(--color-gray-900);
  --text-primary: var(--color-gray-100);
  --border-default: var(--color-gray-700);
}
```

### 6.2 组件库架构

```
design-system/
├── tokens/              # Design Tokens
│   ├── colors.json
│   ├── spacing.json
│   ├── typography.json
│   └── shadows.json
├── primitives/          # 原子组件
│   ├── Button
│   ├── Input
│   ├── Badge
│   └── Icon
├── patterns/            # 模式组件
│   ├── Form
│   ├── DataTable
│   ├── Modal
│   └── Toast
├── layouts/             # 布局组件
│   ├── Container
│   ├── Grid
│   └── Stack
└── docs/                # 文档
    ├── Storybook
    └── Guidelines
```

### 6.3 主题系统

```tsx
// 主题切换实现
const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState(() => {
    // 优先读取用户偏好
    if (typeof window !== 'undefined') {
      return localStorage.getItem('theme') || 
        (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    }
    return 'light'
  })

  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme)
    localStorage.setItem('theme', theme)
  }, [theme])

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}
```

---

## 七、响应式设计与无障碍

### 7.1 断点策略

```css
/* Mobile First */
/* 默认：手机 (< 640px) */

/* sm: 平板竖屏 */
@media (min-width: 640px) { }

/* md: 平板横屏 */
@media (min-width: 768px) { }

/* lg: 笔记本 */
@media (min-width: 1024px) { }

/* xl: 桌面 */
@media (min-width: 1280px) { }

/* 2xl: 大屏 */
@media (min-width: 1536px) { }
```

### 7.2 响应式布局模式

| 模式 | 实现方式 | 适用场景 |
|------|---------|---------|
| **Column Drop** | flex-wrap / Grid auto-fit | 卡片列表 |
| **Layout Shifter** | Grid template areas | 复杂页面 |
| **Off Canvas** | transform + 媒体查询 | 导航菜单 |
| **Fluid Typography** | clamp() | 标题文字 |

### 7.3 无障碍（a11y）清单

#### 必须遵守

- [ ] 所有图片有 `alt` 属性
- [ ] 表单控件有关联的 `<label>`
- [ ] 颜色对比度 ≥ 4.5:1（正文）/ ≥ 3:1（大字）
- [ ] 键盘可访问所有交互元素
- [ ] 焦点顺序符合视觉逻辑
- [ ] 跳过链接（Skip to content）
- [ ] 使用语义化 HTML
- [ ] 动态内容有 ARIA live region

#### ARIA 最佳实践

```tsx
// ✅ 好：语义化 HTML 优先
<button onClick={handleClick}>提交</button>

// ✅ 好：自定义组件使用 ARIA
<div 
  role="button" 
  tabIndex={0}
  aria-pressed={isPressed}
  onKeyDown={handleKeyDown}
>
  切换
</div>

// ❌ 差：滥用 ARIA
<div aria-label="button" onClick={handleClick}>提交</div>
```

#### 键盘导航

| 按键 | 行为 |
|------|------|
| Tab | 移动焦点到下一个可聚焦元素 |
| Shift + Tab | 移动焦点到上一个可聚焦元素 |
| Enter / Space | 激活按钮/链接 |
| Arrow Keys | 在组件内部导航（菜单、标签） |
| Escape | 关闭模态框/弹出层 |

---

## 八、测试策略

### 8.1 测试金字塔

```
        ╱╲
       ╱  ╲      E2E 测试（少量）
      ╱────╲     → Playwright / Cypress
     ╱      ╲
    ╱────────╲   集成测试（适量）
   ╱          ╲  → Testing Library
  ╱────────────╲
 ╱              ╲ 单元测试（大量）
╱────────────────╲ → Vitest / Jest
```

### 8.2 测试类型

| 类型 | 目的 | 示例 |
|------|------|------|
| **单元测试** | 纯函数、工具函数 | `formatDate()`, `calculateTotal()` |
| **组件测试** | 组件渲染、交互 | 表单提交、按钮点击 |
| **集成测试** | 多组件协作 | 购物流程、表单验证 |
| **E2E 测试** | 完整用户流程 | 注册→登录→购买 |
| **视觉回归** | UI 一致性 | Chromatic / Percy |

### 8.3 Testing Library 最佳实践

```tsx
// ✅ 好：测试用户行为
test('用户可以添加商品到购物车', async () => {
  render(<ProductPage />)
  
  await userEvent.click(screen.getByRole('button', { name: /加入购物车/i }))
  
  expect(screen.getByText(/已添加 1 件商品/i)).toBeInTheDocument()
})

// ❌ 差：测试实现细节
test('点击按钮调用 addToCart', () => {
  const addToCart = jest.fn()
  const { container } = render(<ProductButton onClick={addToCart} />)
  
  container.querySelector('.btn-add').click()
  
  expect(addToCart).toHaveBeenCalled()
})
```

---

## 九、前端工程化

### 9.1 代码质量

#### ESLint 配置要点

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:@typescript-eslint/recommended",
    "next/core-web-vitals"
  ],
  "rules": {
    "no-unused-vars": "error",
    "no-console": "warn",
    "prefer-const": "error",
    "react/self-closing-comp": "error",
    "react/jsx-no-target-blank": "error"
  }
}
```

#### Prettier 配置

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100
}
```

### 9.2 Git 工作流

#### Commit 规范（Conventional Commits）

```
feat: 新功能
fix: Bug 修复
docs: 文档更新
style: 代码格式（不影响逻辑）
refactor: 重构
perf: 性能优化
test: 测试相关
chore: 构建/工具相关
```

#### 分支策略

```
main          ← 生产分支
  ↑
develop       ← 开发分支
  ↑
feature/*     ← 功能分支
bugfix/*      ← 修复分支
release/*     ← 发布分支
hotfix/*      ← 紧急修复
```

### 9.3 CI/CD 流程

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run test -- --coverage

  build:
    needs: [lint, test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: .next/
```

---

## 十、常用开发模式

### 10.1 数据获取模式

```tsx
// React Query 模式
function useUser(id: string) {
  return useQuery({
    queryKey: ['user', id],
    queryFn: () => fetchUser(id),
    staleTime: 5 * 60 * 1000, // 5 分钟
    retry: 3,
  })
}

// 组件中使用
function UserProfile({ id }: { id: string }) {
  const { data: user, isLoading, error } = useUser(id)
  
  if (isLoading) return <Skeleton />
  if (error) return <ErrorAlert error={error} />
  
  return <Profile user={user} />
}
```

### 10.2 表单处理模式

```tsx
// React Hook Form + Zod
const schema = z.object({
  email: z.string().email('请输入有效的邮箱'),
  password: z.string().min(8, '密码至少 8 位'),
})

function LoginForm() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema),
  })
  
  const onSubmit = async (data) => {
    await login(data)
  }
  
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
      
      <input type="password" {...register('password')} />
      {errors.password && <span>{errors.password.message}</span>}
      
      <button type="submit">登录</button>
    </form>
  )
}
```

### 10.3 无限滚动模式

```tsx
function InfiniteList() {
  const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfiniteQuery({
    queryKey: ['items'],
    queryFn: ({ pageParam }) => fetchItems(pageParam),
    getNextPageParam: (lastPage) => lastPage.nextCursor,
  })
  
  const { ref } = useInView({
    threshold: 0,
    onChange: (inView) => {
      if (inView && hasNextPage) fetchNextPage()
    },
  })
  
  return (
    <div>
      {data.pages.flatMap(page => 
        page.items.map(item => <Item key={item.id} {...item} />)
      )}
      <div ref={ref} />
      {isFetchingNextPage && <Spinner />}
    </div>
  )
}
```

### 10.4 乐观更新模式

```tsx
function useAddTodo() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: addTodo,
    onMutate: async (newTodo) => {
      // 取消正在进行的查询
      await queryClient.cancelQueries({ queryKey: ['todos'] })
      
      // 保存当前状态
      const previousTodos = queryClient.getQueryData(['todos'])
      
      // 乐观更新
      queryClient.setQueryData(['todos'], (old) => [...old, newTodo])
      
      return { previousTodos }
    },
    onError: (err, newTodo, context) => {
      // 回滚
      queryClient.setQueryData(['todos'], context.previousTodos)
    },
    onSettled: () => {
      // 重新同步
      queryClient.invalidateQueries({ queryKey: ['todos'] })
    },
  })
}
```

---

## 十一、调试技巧

### 11.1 Chrome DevTools

| 面板 | 用途 |
|------|------|
| **Elements** | DOM 检查、CSS 调试 |
| **Console** | 日志、错误、表达式求值 |
| **Sources** | 断点调试、源码查看 |
| **Network** | 请求分析、性能瓶颈 |
| **Performance** | 运行时性能分析 |
| **Memory** | 内存泄漏检测 |
| **Application** | Storage、Cache、Service Worker |

### 11.2 React DevTools

- Components 面板：查看组件树、Props、State
- Profiler 面板：渲染性能分析、识别不必要重渲染

### 11.3 常见问题排查

| 问题 | 排查方向 |
|------|---------|
| 页面白屏 | Console 错误、网络请求失败 |
| 样式不生效 | CSS 优先级、选择器错误 |
| 重渲染过多 | React DevTools Profiler、缺少 memo |
| 内存泄漏 | Memory 面板 Heap Snapshot |
| 首屏慢 | Network 面板、Lighthouse 分析 |

---

## 十二、学习资源

### 必读文档
- [React 官方文档](https://react.dev)
- [Next.js 文档](https://nextjs.org/docs)
- [MDN Web Docs](https://developer.mozilla.org)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

### 推荐书籍
- 《JavaScript 高级程序设计》
- 《CSS 权威指南》
- 《React 设计模式与最佳实践》
- 《Web 性能权威指南》

### 关注动态
- State of JS / State of CSS 年度调查
- React Conf / Next.js Conf
- Chrome DevRel 团队博客

---

*Last updated: 2026-03-17*
*Author: Frontend Developer (@frontend)*
*Version: 1.0*
