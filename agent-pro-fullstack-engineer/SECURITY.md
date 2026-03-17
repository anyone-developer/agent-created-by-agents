# 🛡️ SECURITY.md — 安全原则与实践

> "安全不是一个功能，是一种思维方式。"

---

## 🧠 安全第一原则

### 零信任架构思维

```
核心理念：永远不信任任何输入，永远验证一切

不信任的来源：
├── 用户输入（表单、URL 参数、Headers）
├── 第三方 API 响应
├── 数据库读取的数据（可能被篡改）
├── 环境变量（可能被注入）
├── 文件上传
└── WebSocket 消息
```

### 最小权限原则

```
权限设计：
1. 默认拒绝，显式允许
2. 只给完成任务所需的最小权限
3. 定期审查和回收不必要的权限
4. 使用角色而非直接赋权

示例：
❌ 错误：管理员角色可以做任何事
✅ 正确：管理员角色有以下具体权限...（列出清单）
```

### 纵深防御

```
多层安全防护：
┌─────────────────────────────────────┐
│  第1层：网络防护（WAF、防火墙）      │
├─────────────────────────────────────┤
│  第2层：认证授权（JWT、OAuth、RBAC） │
├─────────────────────────────────────┤
│  第3层：输入验证（白名单、类型检查）  │
├─────────────────────────────────────┤
│  第4层：业务逻辑（权限检查、审计）    │
├─────────────────────────────────────┤
│  第5层：数据保护（加密、脱敏）        │
└─────────────────────────────────────┘

任何一层被突破，其他层仍然保护系统。
```

---

## 🔒 OWASP Top 10 防护指南

### A01: Broken Access Control（失效的访问控制）

```markdown
## 防护措施

### 水平越权防护
```javascript
// ❌ 错误：只检查是否登录
app.get('/api/orders/:id', authenticate, (req, res) => {
  const order = await Order.findById(req.params.id);
  res.json(order);
});

// ✅ 正确：检查是否是订单的拥有者
app.get('/api/orders/:id', authenticate, async (req, res) => {
  const order = await Order.findById(req.params.id);
  if (order.userId !== req.user.id) {
    return res.status(403).json({ error: '无权访问此订单' });
  }
  res.json(order);
});
```

### 垂直越权防护
```javascript
// ✅ 使用中间件检查角色
app.delete('/api/users/:id', authenticate, requireRole('admin'), handler);

// ✅ 或在控制器内检查权限
if (!req.user.hasPermission('delete:user')) {
  return res.status(403).json({ error: '权限不足' });
}
```

### 检查清单
- [ ] 所有需要认证的端点都有认证中间件
- [ ] 所有敏感操作都有授权检查
- [ ] 禁用目录列表
- [ ] API 响应不泄露敏感信息
- [ ] CORS 配置正确（不是 `*`）
```

### A02: Cryptographic Failures（加密机制失效）

```markdown
## 密码存储

### ✅ 正确做法
```javascript
const bcrypt = require('bcrypt');

// 注册时
const saltRounds = 12;
const hashedPassword = await bcrypt.hash(password, saltRounds);

// 登录时
const isMatch = await bcrypt.compare(inputPassword, storedHash);
```

### ❌ 错误做法
- 明文存储密码
- 使用 MD5/SHA1 哈希（太快，易暴力破解）
- 自己发明加密算法
- 使用过时的加密库

## 敏感数据加密

### 传输加密
- 强制 HTTPS（HSTS header）
- TLS 1.2+ （禁用 SSLv3, TLS 1.0, 1.1）
- 证书固定（可选，针对高安全场景）

### 存储加密
```javascript
// 敏感字段加密存储
const crypto = require('crypto');

const algorithm = 'aes-256-gcm';
const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');

function encrypt(text) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(algorithm, key, iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  const authTag = cipher.getAuthTag();
  return {
    iv: iv.toString('hex'),
    encrypted,
    authTag: authTag.toString('hex')
  };
}
```

### 检查清单
- [ ] 密码使用 bcrypt/scrypt/argon2
- [ ] 敏感数据传输使用 HTTPS
- [ ] 敏感字段存储加密
- [ ] 日志不含敏感信息
- [ ] 备份加密
```

### A03: Injection（注入攻击）

```markdown
## SQL 注入防护

### ❌ 易受攻击
```javascript
// 字符串拼接 - 极度危险！
const query = `SELECT * FROM users WHERE id = '${userId}'`;
db.query(query);
```

### ✅ 使用参数化查询
```javascript
// 使用参数化查询（预编译语句）
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);

// 或使用 ORM（自动参数化）
const user = await User.findByPk(userId);
```

## XSS（跨站脚本）防护

### 输入净化
```javascript
const DOMPurify = require('dompurify');
const clean = DOMPurify.sanitize(userInput);
```

### 输出编码
```javascript
// React 默认转义
<div>{userContent}</div>  // ✅ 安全

// ❌ 危险：直接设置 HTML
<div dangerouslySetInnerHTML={{__html: userContent}} />
// 如果必须用，先经过 DOMPurify 处理
```

### CSP (Content Security Policy)
```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'
```

## 命令注入防护

### ❌ 危险
```javascript
const { exec } = require('child_process');
exec(`ping ${userInput}`);  // 用户输入: ; rm -rf /
```

### ✅ 安全
```javascript
// 使用 execFile 而不是 exec（不经过 shell）
const { execFile } = require('child_process');
execFile('ping', [userInput]);

// 或严格验证输入
if (!/^[a-zA-Z0-9.-]+$/.test(userInput)) {
  throw new Error('Invalid input');
}
```

### 检查清单
- [ ] 所有数据库查询使用参数化
- [ ] 用户输出经过转义
- [ ] 配置 CSP header
- [ ] 文件路径不直接拼接用户输入
```

### A04: Insecure Design（不安全的设计）

```markdown
## 安全设计原则

### 威胁建模
在设计阶段就考虑安全：

1. **识别资产** — 什么数据需要保护？
2. **识别威胁** — 谁可能攻击？怎么攻击？
3. **评估风险** — 可能性 × 影响
4. **设计对策** — 如何防护？

### 安全需求
功能需求之外，明确安全需求：

```markdown
用户故事：用户注册
功能需求：用户可以通过邮箱注册账号
安全需求：
- 密码强度要求（8字符，含大小写和数字）
- 邮箱验证（防止虚假注册）
- 频率限制（防止批量注册）
- 密码哈希存储（bcrypt）
- 注册日志记录（审计追踪）
```

### Fail-Safe 默认
```javascript
// ✅ 安全的默认值
const config = {
  requireAuth: true,      // 默认需要认证
  allowGuest: false,      // 默认不允许访客
  maxAttempts: 5,         // 默认限制尝试次数
  sessionTimeout: 3600,   // 默认会话超时
};

// ❌ 危险的默认值
const config = {
  requireAuth: false,     // 默认不认证？！
  debug: true,            // 生产环境开着 debug？！
};
```
```

### A05: Security Misconfiguration（安全配置错误）

```markdown
## 配置安全清单

### 生产环境必须
- [ ] 禁用调试模式
- [ ] 移除测试/调试端点
- [ ] 关闭详细错误信息
- [ ] 设置安全 Headers
- [ ] 禁用不必要的功能/端口
- [ ] 默认账户已修改/禁用

### 安全 Headers
```javascript
// Express.js 示例
app.use(helmet());  // 自动设置安全 headers

// 或手动设置
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  next();
});
```

### 环境变量管理
```markdown
✅ 正确：
- 使用环境变量存储敏感配置
- .env 文件不提交到 Git
- 生产环境使用密钥管理服务（Vault、AWS Secrets Manager）

❌ 错误：
- 密码硬编码在代码里
- API Key 提交到 Git
- 所有环境使用同一套密钥
```

### 错误处理
```javascript
// ✅ 生产环境：通用错误信息
app.use((err, req, res, next) => {
  console.error(err);  // 服务端详细日志
  res.status(500).json({
    error: '服务器内部错误'  // 客户端通用信息
  });
});

// ❌ 危险：暴露堆栈信息
app.use((err, req, res, next) => {
  res.status(500).json({
    error: err.message,
    stack: err.stack,  // 泄露实现细节！
    query: req.query,  // 可能含敏感信息！
  });
});
```
```

### A06: Vulnerable and Outdated Components（易受攻击和过时的组件）

```markdown
## 依赖安全管理

### 定期审计
```bash
# Node.js
npm audit
npm audit fix

# Python
pip audit
safety check

# 持续监控
# - GitHub Dependabot
# - Snyk
# - Socket.dev
```

### 依赖选择原则
1. **检查维护状态** — 最后更新时间、issue 响应速度
2. **检查下载量和 star** — 社区认可度
3. **检查已知漏洞** — CVE 数据库
4. **检查依赖树** — 间接依赖也要关注
5. **锁定版本** — package-lock.json / yarn.lock

### 更新策略
```
安全更新：立即应用（自动化）
├── npm audit fix
└── Dependabot PR

次要版本：定期更新（每周）
├── npm update
└── 测试通过后合并

主要版本：谨慎更新（每月规划）
├── 阅读 changelog
├── 评估破坏性变更
└── 充分测试后升级
```
```

### A07: Identification and Authentication Failures（身份识别和认证失败）

```markdown
## 认证安全

### 密码策略
```javascript
const passwordSchema = {
  minLength: 8,
  requireUppercase: true,
  requireLowercase: true,
  requireNumbers: true,
  requireSpecialChars: false,  // 可选，避免用户困扰
  blockCommonPasswords: true,  // 禁用常见弱密码
};
```

### 会话管理
```javascript
// Session 配置
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: true,        // HTTPS only
    httpOnly: true,      // 防止 XSS 读取
    sameSite: 'strict',  // 防止 CSRF
    maxAge: 3600000      // 1小时过期
  }
}));
```

### JWT 最佳实践
```javascript
// ✅ 安全的 JWT 配置
const token = jwt.sign(
  { userId: user.id, role: user.role },
  process.env.JWT_SECRET,
  {
    expiresIn: '1h',           // 短过期时间
    issuer: 'myapp.com',       // 签发者
    audience: 'myapp.com',     // 接收者
    algorithm: 'HS256'         // 明确算法
  }
);

// Refresh Token 策略
// Access Token: 15分钟 - 1小时
// Refresh Token: 7天 - 30天（可撤销）
```

### 多因素认证 (MFA)
```
推荐实现：
1. TOTP (Google Authenticator, Authy)
2. WebAuthn/FIDO2 (硬件密钥)
3. 备用码（安全存储）

强制 MFA 场景：
- 管理员账户
- 敏感操作（修改密码、提现）
- 异常登录（新设备、新地点）
```

### 暴力破解防护
```javascript
// 账户锁定
const loginAttempts = new Map();

async function login(username, password) {
  const attempts = loginAttempts.get(username) || { count: 0, lastAttempt: 0 };
  
  if (attempts.count >= 5 && Date.now() - attempts.lastAttempt < 900000) {
    throw new Error('账户已锁定，请15分钟后重试');
  }
  
  const user = await verifyCredentials(username, password);
  
  if (!user) {
    attempts.count++;
    attempts.lastAttempt = Date.now();
    loginAttempts.set(username, attempts);
    throw new Error('用户名或密码错误');
  }
  
  // 登录成功，重置计数
  loginAttempts.delete(username);
  return user;
}
```
```

### A08: Software and Data Integrity Failures（软件和数据完整性失败）

```markdown
## 完整性保护

### CI/CD 安全
```yaml
# GitHub Actions 安全实践
name: Secure CI
on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      # 固定 Action 版本（不使用 @latest）
      - uses: actions/checkout@v4.1.1
      
      # 依赖审计
      - run: npm audit
      
      # SAST 扫描
      - uses: github/codeql-action/analyze@v2
      
      # 依赖混淆检查
      - uses: SocketDev/action@v1
```

### 防止依赖混淆攻击
```json
// package.json - 使用作用域包
{
  "name": "@mycompany/myapp",
  "publishConfig": {
    "registry": "https://npm.mycompany.com/"
  }
}
```

### 数据完整性
```javascript
// 使用 HMAC 验证数据完整性
const crypto = require('crypto');

function signData(data, secret) {
  return crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(data))
    .digest('hex');
}

function verifyData(data, signature, secret) {
  const expectedSignature = signData(data, secret);
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expectedSignature)
  );
}
```
```

### A09: Security Logging and Monitoring Failures（安全日志和监控失败）

```markdown
## 安全日志

### 必须记录的安全事件
```javascript
const securityEvents = {
  // 认证事件
  AUTH_LOGIN_SUCCESS: '用户登录成功',
  AUTH_LOGIN_FAILED: '用户登录失败',
  AUTH_LOGOUT: '用户登出',
  AUTH_PASSWORD_CHANGED: '密码已修改',
  AUTH_MFA_ENABLED: 'MFA 已启用',
  
  // 授权事件
  AUTHZ_ACCESS_DENIED: '访问被拒绝',
  AUTHZ_PERMISSION_CHANGED: '权限已变更',
  
  // 数据事件
  DATA_SENSITIVE_ACCESSED: '敏感数据被访问',
  DATA_EXPORTED: '数据已导出',
  DATA_DELETED: '数据已删除',
  
  // 系统事件
  SYSTEM_CONFIG_CHANGED: '系统配置已变更',
  SYSTEM_ADMIN_ACTION: '管理员操作',
};

// 日志格式
{
  "timestamp": "2026-03-17T12:00:00Z",
  "event": "AUTH_LOGIN_FAILED",
  "userId": "user123",
  "ip": "192.168.1.1",
  "userAgent": "Mozilla/5.0...",
  "details": {
    "reason": "invalid_password",
    "attemptCount": 3
  }
}
```

### 日志安全
```
✅ 日志应该包含：
- 事件时间（UTC）
- 事件类型
- 相关用户/系统
- IP 地址
- 事件详情

❌ 日志不应该包含：
- 密码
- API Keys
- 信用卡号
- 社保号
- 完整的个人身份信息
```

### 告警规则
```yaml
alerts:
  - name: brute_force_attempt
    condition: failed_login_count > 10 in 5m
    severity: high
    action: block_ip + notify_security
    
  - name: unusual_access_pattern
    condition: sensitive_data_access > 100 in 1h
    severity: medium
    action: notify_admin
    
  - name: admin_action
    condition: event == 'SYSTEM_ADMIN_ACTION'
    severity: low
    action: log_review
```
```

### A10: Server-Side Request Forgery（SSRF）

```markdown
## SSRF 防护

### 危险场景
```javascript
// ❌ 危险：用户控制 URL
app.get('/fetch', async (req, res) => {
  const url = req.query.url;
  const response = await fetch(url);  // 可以访问内部服务！
  res.send(response.data);
});

// 攻击示例：
// /fetch?url=http://169.254.169.254/latest/meta-data/  （AWS 元数据）
// /fetch?url=http://localhost:6379/  （Redis）
```

### 防护措施
```javascript
const { URL } = require('url');
const ip = require('ip');

// 白名单域名
const ALLOWED_DOMAINS = ['api.example.com', 'cdn.example.com'];

// 禁止的 IP 范围
const BLOCKED_RANGES = [
  '127.0.0.0/8',     // 本地
  '10.0.0.0/8',      // 私有网络
  '172.16.0.0/12',   // 私有网络
  '192.168.0.0/16',  // 私有网络
  '169.254.0.0/16',  // 链路本地
];

async function safeFetch(userUrl) {
  const parsed = new URL(userUrl);
  
  // 1. 只允许 HTTP/HTTPS
  if (!['http:', 'https:'].includes(parsed.protocol)) {
    throw new Error('只允许 HTTP/HTTPS 协议');
  }
  
  // 2. 域名白名单
  if (!ALLOWED_DOMAINS.includes(parsed.hostname)) {
    throw new Error('域名不在白名单中');
  }
  
  // 3. 解析 IP 并检查
  const resolvedIp = await dns.resolve(parsed.hostname);
  for (const range of BLOCKED_RANGES) {
    if (ip.cidrSubnet(range).contains(resolvedIp)) {
      throw new Error('禁止访问内部网络');
    }
  }
  
  // 4. 安全请求
  return fetch(userUrl, {
    timeout: 5000,
    redirect: 'manual',  // 不自动跟随重定向
  });
}
```
```

---

## 🔐 敏感数据处理

### 数据分类

```markdown
## 数据敏感度分级

### 🔴 高度敏感（必须加密存储和传输）
- 密码（哈希存储）
- API Keys / Secrets
- 信用卡号
- 社保号 / 身份证号
- 医疗记录
- 生物特征数据

### 🟡 中度敏感（加密传输，考虑加密存储）
- 邮箱地址
- 手机号
- 真实姓名
- 地址
- 出生日期
- IP 地址

### 🟢 低度敏感（基本保护）
- 用户名
- 公开的个人资料
- 使用统计数据

### ⚪ 非敏感
- 公开内容
- 系统配置（不含密钥）
```

### 脱敏规则

```javascript
// 邮箱脱敏
function maskEmail(email) {
  const [name, domain] = email.split('@');
  const masked = name[0] + '***' + name[name.length - 1];
  return `${masked}@${domain}`;
}
// user@example.com → u***r@example.com

// 手机号脱敏
function maskPhone(phone) {
  return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
}
// 13812345678 → 138****5678

// 身份证脱敏
function maskIdCard(id) {
  return id.replace(/(\d{4})\d{10}(\d{4})/, '$1**********$2');
}
// 110101199001011234 → 1101**********1234
```

---

## 🚨 安全事件响应

### 事件分级

```markdown
## 安全事件严重程度

### P0 - 紧急（立即响应）
- 数据泄露（用户数据外泄）
- 系统被入侵
- 支付系统被攻击
- 大规模账户被盗

**响应时间：** 15分钟内
**负责人：** CTO + 安全团队 + 法务

### P1 - 高（4小时内响应）
- 发现严重漏洞（可被利用）
- 单个账户被盗（管理员）
- DDoS 攻击
- 恶意软件检测

**响应时间：** 4小时内
**负责人：** 安全团队 + 相关开发

### P2 - 中（24小时内响应）
- 可疑活动检测
- 非关键漏洞
- 安全配置问题

**响应时间：** 24小时内
**负责人：** 安全团队

### P3 - 低（计划修复）
- 安全改进建议
- 非紧急的安全更新

**响应时间：** 下一个迭代
**负责人：** 相关开发
```

### 响应流程

```
## 安全事件响应步骤

### 1. 检测与报告（0-15分钟）
├── 确认事件真实性
├── 初步评估影响范围
└── 通知安全团队

### 2. 遏制（15分钟 - 2小时）
├── 隔离受影响系统
├── 阻断攻击路径
├── 保存证据（日志、快照）
└── 评估数据泄露范围

### 3. 根除（2 - 24小时）
├── 找到并修复漏洞
├── 清除恶意代码/后门
├── 重置受影响的凭证
└── 验证修复效果

### 4. 恢复（24 - 72小时）
├── 恢复系统服务
├── 监控是否有再次攻击
├── 通知受影响用户（如需要）
└── 更新安全防护措施

### 5. 复盘（事后1周内）
├── 完整的事件时间线
├── 根因分析
├── 改进措施清单
├── 更新安全策略和流程
└── 团队培训（如有必要）
```

---

## ✅ 安全编码速查清单

```markdown
## 日常开发安全检查

### 写代码时
- [ ] 用户输入验证了吗？
- [ ] SQL 查询用参数化了吗？
- [ ] 输出有转义吗？
- [ ] 敏感数据有加密吗？
- [ ] 错误处理不会泄露信息吗？

### 设计 API 时
- [ ] 有认证吗？
- [ ] 有授权吗？
- [ ] 有速率限制吗？
- [ ] CORS 配置正确吗？
- [ ] 有输入验证吗？

### 处理文件时
- [ ] 文件类型验证了吗？
- [ ] 文件大小限制了吗？
- [ ] 存储路径安全吗？
- [ ] 文件名有处理吗？（防止路径遍历）

### 使用第三方时
- [ ] 依赖有已知漏洞吗？
- [ ] API Key 安全存储了吗？
- [ ] 回调/Webhook 有验证吗？

### 部署时
- [ ] 生产配置正确吗？（debug off）
- [ ] 环境变量安全吗？
- [ ] 日志不含敏感信息吗？
- [ ] HTTPS 配置正确吗？
```

---

## 📚 安全资源

### 工具
- **OWASP ZAP** — Web 应用安全扫描
- **Burp Suite** — 渗透测试
- **npm audit / pip audit** — 依赖漏洞扫描
- **Snyk** — 持续安全监控
- **SonarQube** — 代码质量和安全扫描
- **Trivy** — 容器安全扫描

### 学习资源
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [HackerOne Hacker101](https://www.hacker101.com/)

### 合规框架
- **GDPR** — 欧盟数据保护
- **PCI DSS** — 支付卡行业安全
- **SOC 2** — 服务组织控制
- **ISO 27001** — 信息安全管理体系

---

**版本：** 1.0.0
**最后更新：** 2026-03-17
**作者：** 🧠 AI Expert（代 @security_audit 补充）
**状态：** ✅ 完整版
