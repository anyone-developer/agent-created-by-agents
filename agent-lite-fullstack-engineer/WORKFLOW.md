# 🔄 WORKFLOW.md — 工作流程导航

> 详细工作流程模板请查看 `workflows/` 目录

---

## 📚 工作流模板导航

| 流程 | 文件 | 适用场景 |
|------|------|---------|
| 🚀 新项目启动 | [workflows/new-project.md](workflows/new-project.md) | 从零开始创建新项目 |
| ⚡ 功能开发 | [workflows/feature-dev.md](workflows/feature-dev.md) | 为现有项目添加新功能 |
| 🐛 Bug修复 | [workflows/bug-fix.md](workflows/bug-fix.md) | 定位和修复问题 |
| 🚢 部署上线 | [workflows/deployment.md](workflows/deployment.md) | 发布到生产环境 |

---

## 🎯 工作流程总览

```
┌─────────────────────────────────────────────────────────────┐
│                    软件开发生命周期                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐ │
│  │  需求   │───▶│  设计   │───▶│  开发   │───▶│  测试   │ │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘ │
│       │                                               │     │
│       │         ┌─────────┐    ┌─────────┐           │     │
│       │         │  监控   │◀───│  部署   │◀──────────┘     │
│       │         └─────────┘    └─────────┘                 │
│       │              │                                      │
│       │              ▼                                      │
│       │         ┌─────────┐                                 │
│       └────────▶│  迭代   │                                 │
│                 └─────────┘                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 流程选择指南

### 新项目

```
用户需求 
  ↓
workflows/new-project.md
  ├─ 需求理解
  ├─ 技术选型
  ├─ 架构设计
  ├─ 环境搭建
  ├─ 核心开发 → workflows/feature-dev.md (循环)
  ├─ 测试验证
  └─ 部署上线 → workflows/deployment.md
```

### 功能迭代

```
功能需求
  ↓
workflows/feature-dev.md
  ├─ 需求理解
  ├─ 方案设计
  ├─ 任务拆解
  ├─ 编码实现
  ├─ 自测验证
  ├─ Code Review
  ├─ 集成测试
  └─ 部署上线 → workflows/deployment.md
```

### Bug修复

```
Bug报告
  ↓
workflows/bug-fix.md
  ├─ 复现确认
  ├─ 问题定位
  ├─ 原因分析
  ├─ 修复方案
  ├─ 代码修复
  ├─ 验证测试
  ├─ 部署上线 → workflows/deployment.md
  └─ 复盘总结
```

---

## ⏱️ 工作节奏

### 每日流程

```markdown
## 每日开发节奏

### 早上 (Planning)
1. 检查看板/任务列表
2. 确认今日目标
3. 同步阻塞问题

### 开发中 (Execution)
1. 小步提交，频繁推送
2. 写测试，自测功能
3. 遇到问题及时沟通

### 结束前 (Review)
1. 推送代码
2. 更新任务状态
3. 记录问题和进展
```

### Sprint节奏

```markdown
## Sprint (1-2周)

### 开始
- Sprint计划会议
- 任务拆解和估点
- 明确Sprint目标

### 中期
- 每日站会
- 进度跟踪
- 风险识别

### 结束
- Sprint Review
- 回顾会议
- 下一个Sprint准备
```

---

## 🔧 配套工具

| 工具 | 用途 | 参考文件 |
|------|------|---------|
| Prompt模板 | 标准化任务分析 | [PROMPTS.md](PROMPTS.md) |
| 技术选型 | 决策框架 | [DECISIONS.md](DECISIONS.md) |
| 安全准则 | 安全开发 | [SECURITY.md](SECURITY.md) |
| 质量标准 | 代码质量 | [QUALITY.md](QUALITY.md) |
| 故障应急 | 紧急响应 | [EMERGENCY.md](EMERGENCY.md) |

---

*详细流程模板请查看 `workflows/` 目录。*

---

*Last Updated: 2026-03-17*
