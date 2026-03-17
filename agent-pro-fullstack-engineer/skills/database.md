# 🗄️ 数据库设计与开发能力

> 这个文件定义了全栈工程师 Agent 在数据库领域的核心知识体系，涵盖关系型、NoSQL、缓存、搜索等全栈数据存储方案。

---

## 🧠 数据库思维核心理念

### 1. "数据模型是地基"
- 数据模型一旦确定，后续改动成本极高
- 好的数据模型让业务逻辑自然流畅，坏的数据模型到处打补丁
- **口头禅：** "先画 ER 图，再写代码"

### 2. "读写模式决定选型"
- 读多写少？→ 缓存 + 读写分离
- 写多读少？→ 批量写入 + 异步处理
- 复杂查询？→ 关系型 + 索引优化
- 灵活 Schema？→ NoSQL

### 3. "没有完美的数据库，只有合适的取舍"
- ACID vs BASE
- 强一致性 vs 最终一致性
- 规范化 vs 反规范化
- **心态：** "每个选择都有代价，想清楚再选"

---

## 🐘 PostgreSQL 深度精通

### 为什么 PostgreSQL 是我的首选

```
选择 PostgreSQL 的理由：
├── 功能最全面 — 关系型 + JSON + 全文搜索 + 向量
├── 标准兼容性最好 — SQL 标准遵循度最高
├── 扩展生态最强 — PostGIS, TimescaleDB, pgvector
├── 开源且免费 — 无厂商锁定
├── 社区活跃 — 问题容易找到解决方案
└── 企业级可靠性 — 久经考验
```

### Schema 设计最佳实践

```sql
-- ============================================
-- 用户系统 Schema 示例
-- ============================================

-- 启用必要扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID 生成
CREATE EXTENSION IF NOT EXISTS "pgcrypto";        -- 加密函数
CREATE EXTENSION IF NOT EXISTS "citext";          -- 大小写不敏感文本

-- 用户表
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID NOT NULL DEFAULT uuid_generate_v4() UNIQUE,
    email CITEXT NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100),
    password_hash TEXT NOT NULL,
    avatar_url TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin', 'moderator')),
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'deleted')),
    email_verified_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- 约束
    CONSTRAINT users_email_check CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT users_username_check CHECK (username ~* '^[a-zA-Z0-9_]{3,50}$')
);

-- 索引策略
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_created_at ON users(created_at DESC);
CREATE INDEX idx_users_status ON users(status) WHERE status != 'active'; -- 部分索引

-- 自动更新 updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 文章系统 Schema 示例
-- ============================================

CREATE TABLE posts (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID NOT NULL DEFAULT uuid_generate_v4() UNIQUE,
    author_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(250) NOT NULL UNIQUE,
    content TEXT NOT NULL,
    excerpt VARCHAR(500),
    featured_image_url TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    published_at TIMESTAMPTZ,
    view_count INTEGER NOT NULL DEFAULT 0,
    like_count INTEGER NOT NULL DEFAULT 0,
    comment_count INTEGER NOT NULL DEFAULT 0,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- 约束
    CONSTRAINT posts_title_length CHECK (length(title) >= 1),
    CONSTRAINT posts_published_check CHECK (
        (status = 'published' AND published_at IS NOT NULL) OR 
        (status != 'published')
    )
);

-- 索引
CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_slug ON posts(slug);
CREATE INDEX idx_posts_status_published ON posts(status, published_at DESC) WHERE status = 'published';
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_posts_metadata ON posts USING GIN(metadata); -- JSONB 索引

-- 全文搜索索引
ALTER TABLE posts ADD COLUMN search_vector tsvector;

CREATE OR REPLACE FUNCTION posts_search_vector_update()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector :=
        setweight(to_tsvector('chinese', COALESCE(NEW.title, '')), 'A') ||
        setweight(to_tsvector('chinese', COALESCE(NEW.excerpt, '')), 'B') ||
        setweight(to_tsvector('chinese', COALESCE(NEW.content, '')), 'C');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_posts_search_vector
    BEFORE INSERT OR UPDATE OF title, excerpt, content ON posts
    FOR EACH ROW
    EXECUTE FUNCTION posts_search_vector_update();

CREATE INDEX idx_posts_search ON posts USING GIN(search_vector);

-- ============================================
-- 标签系统（多对多关系）
-- ============================================

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    post_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE post_tags (
    post_id BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    tag_id INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY (post_id, tag_id)
);

CREATE INDEX idx_post_tags_tag ON post_tags(tag_id);

-- ============================================
-- 评论系统（嵌套结构）
-- ============================================

CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    post_id BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    author_id BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    parent_id BIGINT REFERENCES comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'published' CHECK (status IN ('pending', 'published', 'spam', 'deleted')),
    like_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_comments_post ON comments(post_id, created_at);
CREATE INDEX idx_comments_author ON comments(author_id);
CREATE INDEX idx_comments_parent ON comments(parent_id) WHERE parent_id IS NOT NULL;
```

### 查询优化实战

```sql
-- ============================================
-- 常见查询模式与优化
-- ============================================

-- 1. 分页查询 — 游标分页优于 OFFSET
-- ❌ 慢：OFFSET 越大越慢
SELECT * FROM posts 
WHERE status = 'published'
ORDER BY created_at DESC
LIMIT 20 OFFSET 10000;

-- ✅ 快：游标分页
SELECT * FROM posts 
WHERE status = 'published'
  AND created_at < '2024-03-17T12:00:00Z'  -- 上一页最后一条的时间
ORDER BY created_at DESC
LIMIT 20;

-- 2. 统计查询 — 使用物化视图
-- ❌ 慢：每次实时计算
SELECT 
    u.id,
    u.username,
    COUNT(p.id) as post_count,
    COUNT(DISTINCT c.id) as comment_count
FROM users u
LEFT JOIN posts p ON p.author_id = u.id
LEFT JOIN comments c ON c.author_id = u.id
GROUP BY u.id;

-- ✅ 快：物化视图 + 定时刷新
CREATE MATERIALIZED VIEW user_stats AS
SELECT 
    u.id,
    u.username,
    COUNT(DISTINCT p.id) as post_count,
    COUNT(DISTINCT c.id) as comment_count,
    NOW() as refreshed_at
FROM users u
LEFT JOIN posts p ON p.author_id = u.id
LEFT JOIN comments c ON c.author_id = u.id
GROUP BY u.id;

CREATE UNIQUE INDEX idx_user_stats_id ON user_stats(id);

-- 定时刷新（通过 cron job）
REFRESH MATERIALIZED VIEW CONCURRENTLY user_stats;

-- 3. 全文搜索查询
SELECT 
    id,
    title,
    ts_rank(search_vector, query) as rank,
    ts_headline('chinese', content, query) as headline
FROM posts,
     to_tsquery('chinese', '数据库 & 优化') query
WHERE search_vector @@ query
  AND status = 'published'
ORDER BY rank DESC
LIMIT 20;

-- 4. 窗口函数 — 排行榜
SELECT 
    id,
    title,
    view_count,
    ROW_NUMBER() OVER (ORDER BY view_count DESC) as rank,
    PERCENT_RANK() OVER (ORDER BY view_count DESC) as percentile
FROM posts
WHERE status = 'published'
  AND published_at > NOW() - INTERVAL '30 days'
LIMIT 100;

-- 5. CTE — 复杂业务逻辑
WITH active_users AS (
    SELECT id, username
    FROM users
    WHERE status = 'active'
      AND last_login_at > NOW() - INTERVAL '30 days'
),
user_post_counts AS (
    SELECT 
        author_id,
        COUNT(*) as post_count
    FROM posts
    WHERE status = 'published'
    GROUP BY author_id
)
SELECT 
    u.id,
    u.username,
    COALESCE(upc.post_count, 0) as post_count
FROM active_users u
LEFT JOIN user_post_counts upc ON upc.author_id = u.id
ORDER BY post_count DESC;
```

---

## 🍃 MongoDB 实战

### 文档模型设计

```javascript
// 用户文档
{
  _id: ObjectId("..."),
  email: "user@example.com",
  username: "johndoe",
  profile: {
    displayName: "John Doe",
    avatar: "https://...",
    bio: "Full-stack developer",
    location: "Beijing",
    website: "https://johndoe.dev"
  },
  settings: {
    theme: "dark",
    language: "zh-CN",
    notifications: {
      email: true,
      push: false
    }
  },
  stats: {
    postCount: 42,
    followerCount: 128,
    followingCount: 56
  },
  createdAt: ISODate("2024-01-01T00:00:00Z"),
  updatedAt: ISODate("2024-03-17T12:00:00Z")
}

// 文档设计原则：
// 1. 嵌入频繁一起访问的数据（profile, settings, stats）
// 2. 引用独立性强、更新频繁的数据（评论、点赞）
// 3. 预计算统计数据（stats.postCount）
// 4. 使用数组存储一对多关系（tags）

// 帖子文档
{
  _id: ObjectId("..."),
  authorId: ObjectId("..."),  // 引用用户
  title: "MongoDB 最佳实践",
  slug: "mongodb-best-practices",
  content: "...",
  tags: ["mongodb", "database", "nosql"],  // 嵌入标签
  media: [
    { type: "image", url: "https://...", caption: "..." }
  ],
  stats: {
    views: 1024,
    likes: 128,
    comments: 32
  },
  status: "published",
  publishedAt: ISODate("..."),
  createdAt: ISODate("..."),
  updatedAt: ISODate("...")
}
```

### MongoDB 索引策略

```javascript
// 复合索引 — 支持常见查询
db.posts.createIndex({ 
  status: 1, 
  publishedAt: -1 
});

// 文本索引 — 全文搜索
db.posts.createIndex(
  { title: "text", content: "text" },
  { 
    weights: { title: 10, content: 1 },
    name: "posts_text_index",
    default_language: "none"  // 支持中文
  }
);

// TTL 索引 — 自动过期（如 session）
db.sessions.createIndex(
  { createdAt: 1 },
  { expireAfterSeconds: 86400 }  // 24小时后自动删除
);

// 部分索引 — 只索引活跃数据
db.posts.createIndex(
  { authorId: 1, createdAt: -1 },
  { partialFilterExpression: { status: "published" } }
);
```

---

## ⚡ Redis 深度应用

### 数据结构与场景

```python
# 1. String — 缓存、计数器、分布式锁
async def cache_example():
    # 缓存用户信息
    await redis.setex(
        "user:123",
        3600,  # 1小时过期
        json.dumps({"id": 123, "name": "John"})
    )
    
    # 原子计数器
    views = await redis.incr("article:456:views")
    
    # 分布式锁
    lock_key = "lock:order:789"
    acquired = await redis.set(lock_key, "1", nx=True, ex=10)
    if acquired:
        try:
            # 处理订单
            pass
        finally:
            await redis.delete(lock_key)

# 2. Hash — 对象存储、购物车
async def hash_example():
    # 存储用户会话
    await redis.hset("session:abc", mapping={
        "user_id": "123",
        "ip": "192.168.1.1",
        "user_agent": "Mozilla/5.0",
        "created_at": "2024-03-17T12:00:00Z"
    })
    
    # 购物车
    await redis.hincrby("cart:user:123", "product:456", 1)  # 添加商品
    await redis.hincrby("cart:user:123", "product:456", -1) # 减少
    cart = await redis.hgetall("cart:user:123")

# 3. List — 消息队列、时间线
async def list_example():
    # 简单消息队列
    await redis.lpush("queue:emails", json.dumps({"to": "user@example.com", "subject": "..."}))
    message = await redis.brpop("queue:emails", timeout=5)
    
    # 最近访问记录
    await redis.lpush("recent:views:user:123", "article:456")
    await redis.ltrim("recent:views:user:123", 0, 99)  # 只保留最近100条

# 4. Set — 标签、好友关系、去重
async def set_example():
    # 文章标签
    await redis.sadd("tags:article:456", "python", "backend", "api")
    tags = await redis.smembers("tags:article:456")
    
    # 共同好友
    mutual = await redis.sinter("friends:user:1", "friends:user:2")
    
    # 在线用户
    await redis.sadd("online_users", "user:123")
    await redis.srem("online_users", "user:123")  # 下线

# 5. Sorted Set — 排行榜、延迟队列
async def zset_example():
    # 热门文章排行榜
    await redis.zadd("hot:articles", {"article:1": 1000, "article:2": 850})
    await redis.zincrby("hot:articles", 1, "article:1")  # 增加阅读量
    
    # 获取 Top 10
    top10 = await redis.zrevrange("hot:articles", 0, 9, withscores=True)
    
    # 延迟任务队列
    import time
    execute_at = time.time() + 300  # 5分钟后执行
    await redis.zadd("delayed:tasks", {"task:123": execute_at})
    
    # 检查到期任务
    now = time.time()
    tasks = await redis.zrangebyscore("delayed:tasks", 0, now)

# 6. Stream — 消息流（类似 Kafka）
async def stream_example():
    # 生产者
    await redis.xadd("events:user", {
        "action": "login",
        "user_id": "123",
        "ip": "192.168.1.1"
    })
    
    # 消费者组
    await redis.xgroup_create("events:user", "analytics", id="0")
    
    # 消费消息
    messages = await redis.xreadgroup(
        "analytics",
        "consumer-1",
        {"events:user": ">"},
        count=10,
        block=5000
    )
```

### 缓存策略模式

```python
# 1. Cache-Aside（旁路缓存）— 最常用
async def get_user(user_id: int) -> dict | None:
    cache_key = f"user:{user_id}"
    
    # 1. 先查缓存
    cached = await redis.get(cache_key)
    if cached:
        return json.loads(cached)
    
    # 2. 缓存没有，查数据库
    user = await db.get_user(user_id)
    if user:
        # 3. 写入缓存
        await redis.setex(cache_key, 3600, json.dumps(user))
    
    return user

# 2. Write-Through（写穿透）— 写操作同步更新缓存
async def update_user(user_id: int, data: dict):
    # 1. 更新数据库
    await db.update_user(user_id, data)
    
    # 2. 同步更新缓存
    cache_key = f"user:{user_id}"
    user = await db.get_user(user_id)
    await redis.setex(cache_key, 3600, json.dumps(user))
    
    # 或者直接删除缓存（下次读取时自动更新）
    await redis.delete(cache_key)

# 3. 缓存击穿防护 — 热点 key 过期时的互斥锁
async def get_hot_article(article_id: int):
    cache_key = f"article:{article_id}"
    
    # 1. 查缓存
    cached = await redis.get(cache_key)
    if cached:
        return json.loads(cached)
    
    # 2. 获取互斥锁
    lock_key = f"lock:{cache_key}"
    lock = await redis.set(lock_key, "1", nx=True, ex=10)
    
    if lock:
        try:
            # 3. 查数据库并写缓存
            article = await db.get_article(article_id)
            if article:
                await redis.setex(cache_key, 3600, json.dumps(article))
            return article
        finally:
            await redis.delete(lock_key)
    else:
        # 4. 等待其他线程完成
        await asyncio.sleep(0.1)
        return await get_hot_article(article_id)  # 重试

# 4. 缓存穿透防护 — 布隆过滤器或缓存空值
async def get_product(product_id: int):
    cache_key = f"product:{product_id}"
    
    cached = await redis.get(cache_key)
    if cached:
        if cached == "NULL":
            return None  # 缓存的空值
        return json.loads(cached)
    
    product = await db.get_product(product_id)
    
    if product:
        await redis.setex(cache_key, 3600, json.dumps(product))
    else:
        # 缓存空值，短 TTL 防穿透
        await redis.setex(cache_key, 60, "NULL")
    
    return product
```

---

## 🔍 Elasticsearch 全文搜索

### 索引设计

```json
// 文章索引映射
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "analyzer": "ik_max_word",
        "search_analyzer": "ik_smart",
        "fields": {
          "keyword": { "type": "keyword" }
        }
      },
      "content": {
        "type": "text",
        "analyzer": "ik_max_word",
        "search_analyzer": "ik_smart"
      },
      "author_id": { "type": "keyword" },
      "tags": { "type": "keyword" },
      "status": { "type": "keyword" },
      "view_count": { "type": "integer" },
      "published_at": { "type": "date" },
      "created_at": { "type": "date" }
    }
  },
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 1,
    "analysis": {
      "analyzer": {
        "ik_max_word": { "type": "ik_max_word" },
        "ik_smart": { "type": "ik_smart" }
      }
    }
  }
}
```

### 搜索查询示例

```python
# 综合搜索：关键词 + 过滤 + 排序 + 分页
async def search_articles(
    query: str,
    tags: list[str] = None,
    author_id: str = None,
    sort_by: str = "relevance",
    page: int = 1,
    page_size: int = 20
):
    must = []
    filter_conditions = []
    
    # 关键词搜索
    if query:
        must.append({
            "multi_match": {
                "query": query,
                "fields": ["title^3", "content"],  # title 权重更高
                "type": "best_fields",
                "fuzziness": "AUTO"  # 模糊匹配
            }
        })
    
    # 过滤条件
    filter_conditions.append({"term": {"status": "published"}})
    
    if tags:
        filter_conditions.append({"terms": {"tags": tags}})
    
    if author_id:
        filter_conditions.append({"term": {"author_id": author_id}})
    
    # 排序
    sort = []
    if sort_by == "relevance" and query:
        sort = ["_score", {"published_at": "desc"}]
    elif sort_by == "date":
        sort = [{"published_at": "desc"}]
    elif sort_by == "views":
        sort = [{"view_count": "desc"}]
    
    # 执行搜索
    result = await es.search(
        index="articles",
        body={
            "query": {
                "bool": {
                    "must": must,
                    "filter": filter_conditions
                }
            },
            "sort": sort,
            "from": (page - 1) * page_size,
            "size": page_size,
            "highlight": {
                "fields": {
                    "title": {"number_of_fragments": 1},
                    "content": {"fragment_size": 150, "number_of_fragments": 3}
                }
            },
            "aggs": {
                "tags": {"terms": {"field": "tags", "size": 20}},
                "date_histogram": {
                    "date_histogram": {
                        "field": "published_at",
                        "calendar_interval": "month"
                    }
                }
            }
        }
    )
    
    return {
        "total": result["hits"]["total"]["value"],
        "items": [hit["_source"] for hit in result["hits"]["hits"]],
        "aggregations": result["aggregations"]
    }
```

---

## 🔄 数据库迁移策略

### 版本化迁移（Flyway / Prisma Migrate）

```sql
-- V1__create_users_table.sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- V2__add_username_to_users.sql
ALTER TABLE users ADD COLUMN username VARCHAR(50) UNIQUE;

-- V3__create_posts_table.sql
CREATE TABLE posts (
    id BIGS
