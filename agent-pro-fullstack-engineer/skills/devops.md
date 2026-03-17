# 🚀 skills/devops.md — DevOps 技能模块

> 代码写得再好，部署不上去也是白搭。DevOps 是连接开发与生产的桥梁。

---

## 🎯 核心理念

### DevOps 不只是运维

```markdown
传统思维：开发写代码 → 扔给运维 → 运维部署 → 出问题互相甩锅

DevOps 思维：
- 开发即运维：写代码的人要理解生产环境
- 运维即开发：基础设施也要代码化
- 自动化一切：手动操作是bug的温床
- 持续改进：每次故障都是学习机会
```

### 全栈工程师的 DevOps 能力

```
必须掌握：
├── 🐳 容器化 — Docker 基础到进阶
├── 🔄 CI/CD — 自动化构建、测试、部署
├── ☁️ 云服务 — 至少熟悉一个主流云平台
├── 📊 监控 — 知道怎么看日志、指标
├── 🔧 脚本 — Bash/Python 自动化脚本
└── 🔒 安全 — 基础的安全配置

最好了解：
├── ☸️ Kubernetes — 容器编排
├── 🏗️ IaC — Terraform/Pulumi
├── 📈 APM — 性能监控工具
└── 🔍 排障 — 系统化的问题排查方法
```

---

## 🐳 一、Docker 容器化

### Dockerfile 最佳实践

```dockerfile
# ✅ 推荐：多阶段构建
# 阶段1: 构建
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# 阶段2: 生产运行
FROM node:20-alpine AS runner
WORKDIR /app
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
USER nextjs
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Docker Compose 本地开发

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./src:/app/src  # 热重载

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  postgres_data:
```

### 镜像优化清单

```markdown
- ✅ 使用 Alpine 基础镜像（更小）
- ✅ 多阶段构建（减少层数）
- ✅ 合理利用缓存（COPY package*.json 先）
- ✅ 使用 .dockerignore（排除 node_modules 等）
- ✅ 非 root 用户运行（安全）
- ✅ 最小化 COPY（只复制必要文件）
```

---

## 🔄 二、CI/CD 流水线

### GitHub Actions 实战

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint
        run: npm run lint
      
      - name: Unit Tests
        run: npm run test:unit
      
      - name: Integration Tests
        run: npm run test:integration
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .
      
      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker push myregistry/myapp:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to production
        run: |
          # kubectl set image deployment/myapp myapp=myregistry/myapp:${{ github.sha }}
```

### CI/CD 流程图

```
代码提交 → 自动测试 → 构建镜像 → 推送仓库 → 部署生产 → 健康检查
    ↓           ↓           ↓           ↓           ↓          ↓
  Git Hook    Jest/      Docker      DockerHub   K8s/Cloud  监控告警
             Pytest
```

---

## ☁️ 三、云服务部署

### 平台选型指南

| 场景 | 推荐平台 | 理由 |
|------|---------|------|
| 前端静态站 | Vercel / Netlify | 零配置、CDN、免费额度 |
| 全栈应用 | Railway / Render | 简单易用、自动部署 |
| 容器应用 | Fly.io / DigitalOcean | 灵活、性价比高 |
| 企业级 | AWS / GCP / Azure | 功能全面、合规 |
| 边缘计算 | Cloudflare Workers | 全球低延迟 |

### Vercel 部署（推荐前端）

```json
// vercel.json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "framework": "nextjs",
  "env": {
    "DATABASE_URL": "@database-url"
  }
}

# 部署命令
vercel --prod
```

### Render 部署（推荐全栈）

```yaml
# render.yaml
services:
  - type: web
    name: my-app
    env: node
    buildCommand: npm install && npm run build
    startCommand: npm start
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: my-db
          property: connectionString

databases:
  - name: my-db
    plan: starter
```

---

## 📊 四、监控与日志

### 关键指标

```markdown
业务指标：
- 用户量、转化率、收入
- 核心功能使用率

应用指标：
- 响应时间 (P50, P95, P99)
- 错误率 (4xx, 5xx)
- 吞吐量 (QPS)

基础设施指标：
- CPU / 内存 / 磁盘使用率
- 网络 I/O
- 数据库连接数
```

### 结构化日志

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console()
  ]
});

// 使用示例
logger.info('User login', {
  userId: user.id,
  ip: req.ip,
  userAgent: req.headers['user-agent']
});
```

### 告警配置

```markdown
告警级别：
- 🔴 P0：服务完全不可用 → 立即响应
- 🟠 P1：核心功能异常 → 15分钟内响应
- 🟡 P2：性能下降 → 1小时内响应
- 🟢 P3：优化建议 → 下次迭代处理
```

---

## 🔐 五、安全配置

### 环境变量管理

```bash
# ❌ 错误：硬编码
DATABASE_URL=postgresql://user:password@localhost/db

# ✅ 正确：使用环境变量
DATABASE_URL=${DATABASE_URL}

# ✅ 生产环境：使用密钥管理服务
# AWS Secrets Manager / HashiCorp Vault / Doppler
```

### HTTPS 配置

```nginx
server {
    listen 443 ssl http2;
    server_name example.com;
    
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    # 安全头
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=31536000" always;
}
```

---

## 🛠️ 六、常用运维脚本

### 健康检查

```bash
#!/bin/bash
# health-check.sh

URL="http://localhost:3000/health"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ $STATUS -eq 200 ]; then
    echo "✅ Service is healthy"
    exit 0
else
    echo "❌ Service is down (HTTP $STATUS)"
    exit 1
fi
```

### 数据库备份

```bash
#!/bin/bash
# backup.sh

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"

pg_dump -h $DB_HOST -U $DB_USER $DB_NAME | gzip > $BACKUP_DIR/db_$TIMESTAMP.sql.gz

# 保留最近30天
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +30 -delete
```

### 日志轮转

```bash
#!/bin/bash
# log-rotate.sh

LOG_DIR="/var/log/app"
find $LOG_DIR -name "*.log" -mtime +7 -delete
find $LOG_DIR -name "*.log.gz" -mtime +30 -delete
```

---

## 📋 DevOps 检查清单

### 部署前检查

```markdown
- [ ] 所有测试通过
- [ ] 代码已合并到主分支
- [ ] 环境变量已配置
- [ ] 数据库迁移已准备
- [ ] 回滚方案已准备
- [ ] 监控告警已配置
- [ ] 相关人员已通知
```

### 上线后检查

```markdown
- [ ] 健康检查通过
- [ ] 核心功能验证
- [ ] 错误率正常
- [ ] 响应时间正常
- [ ] 监控指标正常
- [ ] 告警无异常
```

---

## 🎯 技能提升路径

```
入门级：
├── Docker 基础
├── GitHub Actions 基础
├── 一个云平台的基本操作
└── 基础的监控和日志

进阶级：
├── Docker Compose 多服务编排
├── CI/CD 完整流水线
├── 多云平台部署
├── 监控告警体系
└── 自动化脚本

专家级：
├── Kubernetes 容器编排
├── IaC (Terraform/Pulumi)
├── 混合云架构
├── SRE 实践
└── 安全合规
```

---

*"好的 DevOps 让开发者专注写代码，让系统自己照顾自己。"*

*Last Updated: 2026-03-17*
