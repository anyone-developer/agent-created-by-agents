# 🛡️ Security Audit Skill — 安全审计专项能力

> **从攻击者视角审视系统，找出每一个可能被利用的弱点。**

---

## 🎯 审计范围

### 审计类型

| 类型 | 频率 | 范围 | 深度 |
|------|------|------|------|
| **代码审计** | 每次 PR | 变更代码 | 深入 |
| **配置审计** | 每次部署 | 配置文件 | 中等 |
| **架构审计** | 季度 | 系统设计 | 全面 |
| **渗透测试** | 半年 | 全系统 | 深入 |
| **合规审计** | 年度 | 全系统 | 全面 |

---

## 🔍 代码安全审计流程

### Phase 1: 准备

```markdown
## 审计前准备

### 信息收集
- [ ] 项目技术栈
- [ ] 架构图/数据流图
- [ ] 之前的审计报告
- [ ] 已知的安全事件
- [ ] 敏感数据清单

### 工具准备
- [ ] SAST 工具配置
- [ ] IDE 安全插件
- [ ] 漏洞数据库更新
- [ ] 审计检查清单
```

### Phase 2: 静态分析

```markdown
## 代码静态分析

### 自动化扫描
```bash
# SonarQube
sonar-scanner -Dsonar.projectKey=myproject

# Semgrep（OWASP 规则）
semgrep --config=p/owasp-top-ten

# ESLint Security
eslint --ext .js,.ts --config security src/
```

### 手动代码审查重点

#### 1. 认证与会话
```javascript
// 🔴 检查点
- 密码是否哈希存储？
- Session 是否安全配置？
- Token 是否正确验证？
- 是否有会话固定漏洞？
- 是否有注销功能？
```

#### 2. 输入验证
```javascript
// 🔴 检查点
- 所有用户输入是否验证？
- 是否使用白名单？
- 文件上传是否限制类型/大小？
- URL 参数是否验证？
- 请求体大小是否限制？
```

#### 3. 输出编码
```javascript
// 🔴 检查点
- HTML 输出是否转义？
- JavaScript 上下文是否安全？
- SQL 查询是否参数化？
- 命令执行是否安全？
- 日志是否避免敏感信息？
```

#### 4. 加密与密钥
```javascript
// 🔴 检查点
- 加密算法是否现代？
- 密钥是否硬编码？
- 随机数生成器是否安全？
- HTTPS 是否强制？
- 证书验证是否完整？
```

#### 5. 访问控制
```javascript
// 🔴 检查点
- 每个端点是否验证权限？
- 水平越权是否防护？
- 垂直越权是否防护？
- API 是否有速率限制？
- 敏感操作是否有日志？
```

### Phase 3: 配置审计

```markdown
## 安全配置审计

### 服务器配置
```bash
# 检查 TLS 配置
nmap --script ssl-enum-ciphers -p 443 example.com

# 检查 HTTP 头
curl -I https://example.com

# 检查开放端口
nmap -sV -p- example.com
```

### 数据库配置
- [ ] 是否只监听本地？
- [ ] 是否使用强密码？
- [ ] 是否禁用远程 root？
- [ ] 是否启用审计日志？
- [ ] 是否定期备份？

### 云服务配置
- [ ] 安全组是否最小化？
- [ ] S3/GCS 是否公开？
- [ ] IAM 角色是否最小权限？
- [ ] 日志是否启用？
- [ ] 密钥是否定期轮换？
```

### Phase 4: 渗透测试

```markdown
## 渗透测试方法论

### OWASP Testing Guide
1. 信息收集
2. 配置管理测试
3. 身份认证测试
4. 授权测试
5. 会话管理测试
6. 输入验证测试
7. 错误处理测试
8. 加密测试
9. 业务逻辑测试
10. 客户端测试

### 常用工具
| 工具 | 用途 |
|------|------|
| Burp Suite | Web 应用测试 |
| OWASP ZAP | 自动化扫描 |
| sqlmap | SQL 注入测试 |
| nikto | Web 服务器扫描 |
| dirb/gobuster | 目录枚举 |
| nmap | 端口扫描 |
| Metasploit | 漏洞利用框架 |
| wfuzz | 模糊测试 |
```

---

## 📝 审计报告模板

```markdown
# 安全审计报告

## 基本信息
- 项目名称：
- 审计日期：
- 审计人员：
- 审计范围：
- 审计版本：

## 执行摘要
[高层概述，给管理层看]

## 风险概览
| 严重程度 | 数量 | 已修复 | 修复中 | 未修复 |
|----------|------|--------|--------|--------|
| 严重 (Critical) | 0 | 0 | 0 | 0 |
| 高危 (High) | 0 | 0 | 0 | 0 |
| 中危 (Medium) | 0 | 0 | 0 | 0 |
| 低危 (Low) | 0 | 0 | 0 | 0 |
| 信息 (Info) | 0 | 0 | 0 | 0 |

## 详细发现

### SEC-001: [漏洞名称]
**严重程度：** 高危
**CWE：** CWE-XXX
**CVSS：** 7.5

**描述：**
[详细描述漏洞]

**影响：**
[成功利用的后果]

**复现步骤：**
1. [步骤1]
2. [步骤2]
3. [步骤3]

**证据：**
[截图、代码片段、请求/响应]

**修复建议：**
[具体的修复方案]

**参考链接：**
- [OWASP 相关页面]
- [CVE 链接]

---

[更多发现...]

## 建议总结
[优先级排序的改进建议]

## 附录
- 工具版本
- 测试环境
- 范围外系统
```

---

## 🛠️ 安全审计工具箱

### 自动化工具配置

```yaml
# .semgrep.yml - Semgrep 自定义规则
rules:
  - id: hardcoded-password
    pattern: |
      password = "..."
    message: 发现硬编码密码
    severity: ERROR
    languages: [python, javascript]

  - id: sql-injection
    pattern: |
      $QUERY = "..." + $INPUT
    message: 潜在 SQL 注入风险
    severity: ERROR
    languages: [python, javascript]
```

```javascript
// eslint-security.config.js
module.exports = {
  plugins: ['security'],
  rules: {
    'security/detect-sql-injection': 'error',
    'security/detect-xss': 'error',
    'security/detect-eval-with-expression': 'error',
    'security/detect-no-csrf-before-method-override': 'error',
  },
};
```

### 手动检查脚本

```bash
#!/bin/bash
# security-checklist.sh

echo "=== 安全配置检查 ==="

echo "1. 检查硬编码密钥..."
grep -r "password\s*=" --include="*.{js,ts,py}" . | grep -v test | grep -v example

echo "2. 检查 console.log（可能泄露敏感信息）..."
grep -r "console.log" --include="*.{js,ts}" . | grep -v test

echo "3. 检查 eval 使用..."
grep -r "eval(" --include="*.{js,ts}" .

echo "4. 检查 HTTP URL（应使用 HTTPS）..."
grep -r "http://" --include="*.{js,ts}" . | grep -v localhost

echo "5. 检查 TODO/FIXME/HACK..."
grep -r "TODO\|FIXME\|HACK\|XXX" --include="*.{js,ts,py}" .

echo "=== 检查完成 ==="
```

---

## 🎓 常见漏洞快速参考

### OWASP Top 10 (2021)

| # | 漏洞 | 快速检查 | 修复方向 |
|---|------|----------|----------|
| A01 | 访问控制失效 | API 端点权限检查？ | RBAC/ABAC 实现 |
| A02 | 加密机制失效 | 密码存储？传输加密？ | 现代加密算法 |
| A03 | 注入 | SQL/NoSQL/OS 命令注入？ | 参数化查询 |
| A04 | 不安全设计 | 威胁建模做了吗？ | 安全设计评审 |
| A05 | 安全配置错误 | 默认配置？调试模式？ | 安全基线配置 |
| A06 | 易受攻击组件 | 依赖有 CVE 吗？ | 定期更新扫描 |
| A07 | 认证失效 | 暴力破解防护？MFA？ | 强认证机制 |
| A08 | 软件/数据完整性 | CI/CD 安全？签名验证？ | 完整性校验 |
| A09 | 日志/监控不足 | 异常能检测到吗？ | 完善监控告警 |
| A10 | SSRF | 用户可控 URL？ | 白名单/网络隔离 |

---

## ✅ 审计完成标准

```markdown
## 审计完成检查清单

### 覆盖范围
- [ ] 所有认证/授权逻辑已审计
- [ ] 所有用户输入点已审计
- [ ] 所有数据输出点已审计
- [ ] 所有 API 端点已测试
- [ ] 所有配置文件已审查

### 工具扫描
- [ ] SAST 扫描完成
- [ ] 依赖漏洞扫描完成
- [ ] 安全头检查完成
- [ ] TLS 配置检查完成

### 文档
- [ ] 审计报告已编写
- [ ] 发现已按优先级排序
- [ ] 修复建议已提供
- [ ] 复测计划已制定

### 沟通
- [ ] 高危漏洞已即时通报
- [ ] 报告已发送给相关方
- [ ] 修复计划已讨论
```

---

*审计的目的是找出问题，更重要的是帮助解决问题。*
*好的审计报告 = 清晰的发现 + 可操作的建议 + 负责任的披露*

*Last Updated: 2026-03-17*
*Author: 🛡️ Security Auditor*
