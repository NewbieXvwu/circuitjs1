# Cloudflare Pages 配置文件说明

本文档详细说明了所有 Cloudflare Pages 配置文件的作用和使用方法。

## 📁 配置文件清单

### 🔧 核心构建文件

#### 1. `build-cloudflare.sh`
**作用**: 自动构建脚本，在 Cloudflare Pages 构建环境中执行

**功能**:
- ✅ 自动下载并安装 Java JDK 11
- ✅ 自动下载并安装 GWT SDK 2.10.0
- ✅ 编译 Java 源代码
- ✅ 运行 GWT 编译器转译为 JavaScript
- ✅ 生成部署文件到 `war/` 目录

**使用方式**:
在 Cloudflare Pages 构建设置中，将构建命令设置为：
```bash
chmod +x build-cloudflare.sh && ./build-cloudflare.sh
```

**特点**:
- 无需本地安装任何工具
- 自动检测系统架构（x86_64/aarch64）
- 依赖缓存加速后续构建
- 使用草稿模式优化构建速度

---

#### 2. `cloudflare-pages.toml`
**作用**: Cloudflare Pages 主配置文件（推荐使用）

**包含配置**:
```toml
[build]
  command = "chmod +x build-cloudflare.sh && ./build-cloudflare.sh"
  publish = "war"

[[redirects]]
  from = "/"
  to = "/circuitjs.html"
  status = 302

[[headers]]
  for = "/circuitjs1/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
```

**优势**:
- ✅ 声明式配置，易于维护
- ✅ 版本控制友好
- ✅ 支持重定向、头部、环境变量等
- ✅ Cloudflare Pages 自动读取

**使用方式**:
将文件放在项目根目录，Cloudflare Pages 会自动应用配置。

---

#### 3. `wrangler.toml`
**作用**: Wrangler CLI 配置文件（可选）

**用途**:
- 用于 `wrangler` 命令行工具
- 支持本地开发和部署
- 可覆盖 Pages 配置

**使用方式**:
```bash
wrangler pages deploy war --project-name=circuitjs1
```

---

### 🌐 部署优化文件

#### 4. `war/_headers`
**作用**: HTTP 响应头配置

**功能**:
- 🚀 缓存优化
- 🔐 安全头设置
- 🌍 CORS 配置

**示例配置**:
```
/circuitjs1/*
  Cache-Control: public, max-age=31536000, immutable
  X-Content-Type-Options: nosniff

/font/*
  Cache-Control: public, max-age=31536000, immutable
  Access-Control-Allow-Origin: *

/*.html
  Cache-Control: public, max-age=3600, must-revalidate
  X-Frame-Options: SAMEORIGIN
  Referrer-Policy: strict-origin-when-cross-origin
```

**效果**:
- GWT 编译的 JS 文件：永久缓存（immutable）
- 字体文件：永久缓存，允许跨域
- HTML 文件：1小时缓存，需重新验证
- 安全头：防止 XSS、点击劫持等攻击

---

#### 5. `war/_redirects`
**作用**: URL 重定向规则

**配置**:
```
/  /circuitjs.html  302
```

**效果**:
访问根路径 `https://你的域名.pages.dev/` 会自动重定向到 `https://你的域名.pages.dev/circuitjs.html`

---

#### 6. `package.json`
**作用**: NPM 包配置（可选）

**功能**:
- 定义项目元数据
- 提供快捷脚本命令
- 方便本地开发

**使用方式**:
```bash
npm run build   # 执行构建脚本
npm run deploy  # 部署到 Cloudflare Pages
```

---

## 🚀 完整部署流程

### 方法 1: 使用 Cloudflare Dashboard（推荐）

1. **连接仓库**
   - 登录 Cloudflare Dashboard
   - Workers & Pages → Create application → Pages → Connect to Git
   - 选择你的 GitHub 仓库

2. **配置构建**
   - **框架预设**: None
   - **构建命令**: `chmod +x build-cloudflare.sh && ./build-cloudflare.sh`
   - **构建输出目录**: `war`
   - **根目录**: `/`

3. **部署**
   - 点击 "Save and Deploy"
   - 等待 5-8 分钟完成构建

4. **自动应用配置**
   Cloudflare Pages 会自动读取：
   - ✅ `cloudflare-pages.toml` - 主配置
   - ✅ `war/_headers` - HTTP 头
   - ✅ `war/_redirects` - 重定向规则

### 方法 2: 使用 Wrangler CLI

```bash
# 1. 安装 Wrangler
npm install -g wrangler

# 2. 登录
wrangler login

# 3. 部署
wrangler pages deploy war --project-name=circuitjs1

# Wrangler 会读取 wrangler.toml 配置
```

---

## 📊 配置文件优先级

当多个配置文件存在时，优先级如下：

1. **Cloudflare Dashboard 设置** - 最高优先级
2. **cloudflare-pages.toml** - 推荐使用
3. **wrangler.toml** - CLI 工具使用
4. **war/_headers** - 自动应用
5. **war/_redirects** - 自动应用

**建议**:
- ✅ 使用 `cloudflare-pages.toml` 作为主配置
- ✅ Dashboard 只用于初始设置
- ✅ 将所有配置都纳入版本控制

---

## 🎯 配置最佳实践

### 1. 构建命令优化

**推荐**:
```bash
chmod +x build-cloudflare.sh && ./build-cloudflare.sh
```

**为什么**:
- `chmod +x` 确保脚本可执行
- `&&` 确保命令按顺序执行
- 单行命令，易于配置

### 2. 缓存策略

**静态资源（不变的文件）**:
```
Cache-Control: public, max-age=31536000, immutable
```
- `max-age=31536000` = 1年
- `immutable` = 文件永不改变

**HTML 文件（可能更新的文件）**:
```
Cache-Control: public, max-age=3600, must-revalidate
```
- `max-age=3600` = 1小时
- `must-revalidate` = 过期后必须重新验证

### 3. 安全头配置

**基础安全头**:
```
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
```

**高级安全头（可选）**:
```
Content-Security-Policy: default-src 'self' 'unsafe-inline' 'unsafe-eval' https:; font-src 'self' https://fonts.gstatic.com;
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

### 4. 重定向规则

**常用重定向**:
```
/              /circuitjs.html    302
/index.html    /circuitjs.html    301
```

**参数说明**:
- `302` = 临时重定向（可以改变）
- `301` = 永久重定向（浏览器会缓存）

---

## 🔧 自定义配置

### 修改构建模式

在 `build-cloudflare.sh` 中修改：

**当前（草稿模式，快速）**:
```bash
-draftCompile \
-optimize 0 \
```

**优化模式（慢但文件小）**:
```bash
-optimize 9 \
```

### 添加环境变量

在 `cloudflare-pages.toml` 中：

```toml
[build.environment]
  NODE_VERSION = "18"
  JAVA_VERSION = "11"
  BUILD_MODE = "production"
```

### 自定义缓存时间

在 `war/_headers` 中修改：

```
/*.js
  Cache-Control: public, max-age=86400  # 改为你想要的秒数
```

---

## 📝 配置文件模板

### 最小配置（只需要这个）

**cloudflare-pages.toml**:
```toml
[build]
  command = "chmod +x build-cloudflare.sh && ./build-cloudflare.sh"
  publish = "war"
```

### 完整配置（推荐）

参考项目中的 `cloudflare-pages.toml` 文件。

---

## 🐛 配置问题排查

### 问题 1: 构建命令未执行

**检查**:
- ✅ 构建命令是否正确
- ✅ 脚本是否有执行权限
- ✅ 路径是否正确

**解决**:
```bash
# 确保包含 chmod +x
chmod +x build-cloudflare.sh && ./build-cloudflare.sh
```

### 问题 2: 配置文件未生效

**检查**:
- ✅ 文件名是否正确（区分大小写）
- ✅ 文件格式是否正确（TOML 语法）
- ✅ 文件位置是否正确（根目录或 war/）

**验证**:
在 Cloudflare Dashboard 查看"Functions"标签，检查配置是否被读取。

### 问题 3: 缓存未生效

**检查**:
- ✅ `_headers` 文件是否在 `war/` 目录
- ✅ 格式是否正确（每个规则独立行）
- ✅ 浏览器是否清除缓存

**测试**:
```bash
curl -I https://你的域名.pages.dev/circuitjs1/xxx.js
# 查看 Cache-Control 响应头
```

---

## 📚 相关资源

### Cloudflare 官方文档
- **Pages 配置**: https://developers.cloudflare.com/pages/platform/build-configuration/
- **Headers 配置**: https://developers.cloudflare.com/pages/platform/headers/
- **Redirects 配置**: https://developers.cloudflare.com/pages/platform/redirects/
- **环境变量**: https://developers.cloudflare.com/pages/platform/build-configuration/#environment-variables

### 工具文档
- **Wrangler CLI**: https://developers.cloudflare.com/workers/wrangler/
- **GWT Compiler**: https://www.gwtproject.org/doc/latest/DevGuideCompilingAndDebugging.html

---

## ✅ 配置检查清单

部署前检查：

- [ ] `build-cloudflare.sh` 存在且可执行
- [ ] `cloudflare-pages.toml` 配置正确
- [ ] `war/_headers` 缓存策略合理
- [ ] `war/_redirects` 重定向规则正确
- [ ] `war/circuitjs.html` 包含 Material You 样式
- [ ] 所有配置文件纳入版本控制

---

## 🎉 总结

使用这些配置文件，你可以实现：

✅ **零配置部署** - 推送代码即自动构建
✅ **性能优化** - 智能缓存和 CDN 加速
✅ **安全加固** - 完善的安全头配置
✅ **用户友好** - 自动重定向和错误处理
✅ **可维护性** - 所有配置版本控制

---

**问题反馈**: 如有配置问题，请查看构建日志或提交 Issue。

**最后更新**: 2024年
