# TOOLS.md — 工具链指南

> 工欲善其事，必先利其器。

---

## 🛠️ 核心工具链

### 代码编辑 & IDE

| 工具 | 用途 | 推荐配置 |
|------|------|---------|
| VS Code | 主力编辑器 | 安装 ESLint、Prettier、GitLens |
| WebStorm | JetBrains 全家桶 | 前端/Node.js 开发 |
| Neovim | 终端编辑器 | 快速编辑配置文件 |
| Cursor | AI辅助编程 | 代码生成和重构 |

### 版本控制

```bash
# Git 基础配置
git config --global user.name "FullStack"
git config --global user.email "fullstack@example.com"
git config --global core.editor "code --wait"

# 常用命令
git status              # 查看状态
git add .               # 暂存所有更改
git commit -m "message" # 提交
git push                # 推送
git pull                # 拉取
git branch              # 分支管理
git merge               # 合并分支
git rebase -i HEAD~3    # 交互式变基
git stash               # 暂存工作区
git cherry-pick <hash>  # 挑选提交
```

---

## 💻 前端工具链

### 包管理器

```bash
# npm（默认）
npm install <package>
npm run <script>

# pnpm（推荐，更快，磁盘占用更少）
pnpm install <package>
pnpm run <script>

# yarn
yarn add <package>
yarn <script>
```

### 框架 & 库

#### React 生态
```bash
# Next.js（推荐）
npx create-next-app@latest my-app --typescript --tailwind --app

# 核心依赖
npm install react react-dom next
npm install -D typescript @types/react @types/node

# 状态管理
npm install zustand          # 轻量级
npm install @reduxjs/toolkit react-redux  # 复杂状态

# UI组件库
npm install @radix-ui/react-*    # 无样式组件原语
npx shadcn-ui@latest init       # shadcn/ui
npm install antd                 # Ant Design
npm install @mui/material        # Material UI
```

#### Vue 生态
```bash
# Nuxt.js
npx nuxi@latest init my-app

# 核心依赖
npm install vue@latest
npm install -D @vitejs/plugin-vue
```

### CSS & 样式

```bash
# Tailwind CSS（推荐）
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# CSS Modules（内置支持）
# 文件命名：Component.module.css

# Styled Components
npm install styled-components

# CSS-in-JS
npm install @emotion/react @emotion/styled
```

### 构建工具

```bash
# Vite（推荐）
npm create vite@latest my-app -- --template react-ts

# Webpack
npm install -D webpack webpack-cli webpack-dev-server

# esbuild（极快）
npm install -D esbuild
```

### 测试

```bash
# Jest
npm install -D jest @types/jest ts-jest

# Vitest（Vite生态）
npm install -D vitest

# React Testing Library
npm install -D @testing-library/react @testing-library/jest-dom

# E2E测试
npm install -D @playwright/test
npx playwright install
```

---

## 🔧 后端工具链

### Node.js 生态

```bash
# NestJS（推荐）
npm i -g @nestjs/cli
nest new my-api

# Express
npm install express
npm install -D @types/express typescript

# Fastify（高性能）
npm install fastify
```

### Python 生态

```bash
# FastAPI（推荐）
pip install fastapi uvicorn[standard]

# Django
pip install django djangorestframework

# Flask
pip install flask
```

### Go 生态

```bash
# 初始化模块
go mod init my-api

# 常用框架
go get -u github.com/gin-gonic/gin        # Gin
go get -u github.com/gofiber/fiber/v2     # Fiber
go get -u github.com/labstack/echo/v4     # Echo
```

---

## 🗄️ 数据库工具

### 关系型数据库

```bash
# PostgreSQL
brew install postgresql       # macOS
sudo apt install postgresql   # Ubuntu

# 连接工具
npm install prisma            # ORM
npm install typeorm           # ORM
```

### NoSQL

```bash
# MongoDB
brew install mongodb-community
npm install mongoose

# Redis
brew install redis
npm install ioredis
```

### 数据库管理工具

| 工具 | 数据库 | 特点 |
|------|--------|------|
| pgAdmin | PostgreSQL | 官方GUI |
| MongoDB Compass | MongoDB | 官方GUI |
| DBeaver | 通用 | 支持多种数据库 |
| TablePlus | 通用 | 界面美观 |
| Prisma Studio | Prisma | 代码优先 |

---

## 🚀 DevOps 工具链

### 容器化

```bash
# Docker
docker build -t my-app .
docker run -p 3000:3000 my-app
docker-compose up -d

# 常用命令
docker ps              # 查看运行中的容器
docker images          # 查看镜像
docker logs <id>       # 查看日志
docker exec -it <id> sh  # 进入容器
```

### CI/CD

```yaml
# GitHub Actions 示例
name: CI/CD
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm test
      - run: npm run build
```

### 部署平台

| 平台 | 适用场景 | 特点 |
|------|---------|------|
| Vercel | 前端/Next.js | 零配置，自动部署 |
| Railway | 全栈应用 | 简单易用 |
| Render | 全栈应用 | 免费层可用 |
| Fly.io | 容器化应用 | 全球边缘部署 |
| AWS | 企业级 | 功能全面但复杂 |
| Cloudflare | 边缘计算 | Workers/Pages |

---

## 📊 监控 & 日志

### 应用监控

```bash
# Sentry（错误追踪）
npm install @sentry/nextjs

# LogRocket（用户回放）
npm install logrocket

# Datadog（全栈监控）
npm install dd-trace
```

### 日志管理

```bash
# Winston（Node.js日志）
npm install winston

# Pino（高性能日志）
npm install pino

# ELK Stack
# Elasticsearch + Logstash + Kibana
```

---

## 🔐 安全工具

```bash
# npm audit（依赖漏洞检查）
npm audit

# Snyk（安全扫描）
npm install -D snyk
snyk test

# Helmet（HTTP安全头）
npm install helmet

# CORS
npm install cors
```

---

## 🧰 通用工具

### API 测试

| 工具 | 类型 | 特点 |
|------|------|------|
| Postman | GUI | 功能全面 |
| Insomnia | GUI | 界面简洁 |
| curl | CLI | 无处不在 |
| HTTPie | CLI | 人性化命令 |

### 文档生成

```bash
# Swagger/OpenAPI
npm install @nestjs/swagger    # NestJS
npm install swagger-ui-express # Express

# API文档自动生成
# Postman / Insomnia 可导出文档
```

### 代码质量

```bash
# ESLint
npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin

# Prettier
npm install -D prettier eslint-config-prettier

# Husky（Git hooks）
npm install -D husky lint-staged
```

---

## 📱 移动端工具链

### React Native

```bash
# 环境准备
npm install -g expo-cli
npx create-expo-app my-app

# 核心依赖
npm install react-native
npm install @react-navigation/native
```

### Flutter

```bash
# 安装Flutter SDK
# https://flutter.dev/docs/get-started/install

# 创建项目
flutter create my_app
flutter run
```

---

## 🎯 工具选择原则

1. **社区活跃**：GitHub stars、npm下载量、更新频率
2. **文档完善**：有详细的官方文档和教程
3. **生态丰富**：有丰富的插件和社区支持
4. **团队熟悉**：选择团队成员熟悉的工具
5. **长期维护**：有稳定的维护团队，不会很快弃坑

---

*"最好的工具是你熟练掌握的那个。"*

---

*Last Updated: 2026-03-17*
