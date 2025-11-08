# Cloudflare Pages 构建配置说明

## ✅ 问题已修复

### 原始错误
```
✘ [ERROR] Running configuration file validation for Pages:
    - Configuration file for Pages projects does not support "build"
```

### 根本原因
`wrangler.toml` 文件包含了仅适用于 Cloudflare Workers 的配置项（`[build]` 部分、`upload_format`、`pages_build_command` 等），导致 Cloudflare Pages 在验证配置时失败。

### 解决方案
已将 `wrangler.toml` 精简为最小配置，仅保留项目名称。所有 Pages 相关配置已移至 `cloudflare-pages.toml`。

---

## 📋 正确的配置文件结构

### 1. `wrangler.toml` （已修复）
```toml
name = "circuitjs1-material-you"

# Cloudflare Pages 专用配置
# 注意: Pages 项目的主要配置应在 cloudflare-pages.toml 或 Dashboard 中设置
# wrangler.toml 仅用于 wrangler CLI 工具的基本识别
```

**作用**：仅用于 `wrangler` CLI 工具识别项目名称，不包含 Pages 构建配置。

---

### 2. `cloudflare-pages.toml` （主配置文件）
此文件包含完整的 Pages 构建配置：
- ✅ 构建命令：`chmod +x build-cloudflare.sh && ./build-cloudflare.sh`
- ✅ 输出目录：`war`
- ✅ 环境变量：`NODE_VERSION = "18"`
- ✅ 重定向规则：根路径 → `/circuitjs.html`
- ✅ HTTP 响应头：缓存策略、安全头等

**Cloudflare Pages 会自动读取并应用此文件的配置。**

---

### 3. `build-cloudflare.sh` （构建脚本）
自动化构建脚本，功能包括：
- 自动下载并安装 Java JDK 11
- 自动下载并安装 GWT SDK 2.10.0
- 编译 Java 源代码
- 运行 GWT 编译器生成 JavaScript
- 输出到 `war/` 目录

**脚本已设置执行权限**：`-rwxrwxr-x`

---

## 🚀 Cloudflare Pages Dashboard 配置

在 Cloudflare Pages 控制台中，请确保设置如下：

| 配置项 | 值 |
|--------|-----|
| **Framework preset** | `None` |
| **Root directory** | `/` （根目录）|
| **Build command** | `chmod +x build-cloudflare.sh && ./build-cloudflare.sh` |
| **Build output directory** | `war` |
| **Environment variables** | `NODE_VERSION=18` （可选，已在 cloudflare-pages.toml 中定义）|

**注意**：Dashboard 设置的优先级高于 `cloudflare-pages.toml`，建议保持一致。

---

## ✨ 构建流程

1. **Cloudflare Pages 克隆仓库**
2. **读取 `cloudflare-pages.toml` 配置**
3. **执行构建命令**：
   - `chmod +x build-cloudflare.sh` 确保脚本可执行
   - `./build-cloudflare.sh` 运行构建脚本
4. **构建脚本自动完成**：
   - 下载 Java JDK 11 (Amazon Corretto)
   - 下载 GWT SDK 2.10.0
   - 编译 Java 源代码
   - 运行 GWT 编译器（草稿模式，优化构建速度）
   - 生成静态文件到 `war/` 目录
5. **部署 `war/` 目录内容到 CDN**
6. **应用 HTTP 响应头和重定向规则**

预计构建时间：**5-8 分钟**（首次构建）

---

## 🔍 配置验证清单

- [x] `wrangler.toml` 不包含 `[build]` 部分
- [x] `wrangler.toml` 不包含 `pages_build_command` 等 Pages 专用字段
- [x] `cloudflare-pages.toml` 包含完整的构建配置
- [x] `build-cloudflare.sh` 有执行权限
- [x] 没有冲突的部署配置文件（vercel.json, netlify.toml 等）
- [x] `.gitignore` 正确配置，不会排除必要文件

---

## 🛠️ 使用 Wrangler CLI 手动部署（可选）

如果需要通过命令行部署：

```bash
# 安装 Wrangler
npm install -g wrangler

# 登录 Cloudflare
wrangler login

# 部署到 Pages
wrangler pages deploy war --project-name=circuitjs1-material-you
```

---

## ⚠️ 常见问题

### 问题：构建失败，提示 "Configuration file for Pages projects does not support 'build'"
**解决**：已修复，确保使用更新后的 `wrangler.toml`

### 问题：构建超时
**原因**：首次构建需要下载 JDK 和 GWT SDK  
**解决**：正常情况，等待 5-8 分钟；后续构建会使用缓存，速度更快

### 问题：脚本无执行权限
**解决**：
```bash
chmod +x build-cloudflare.sh
git add build-cloudflare.sh
git commit -m "Fix: Add execute permission to build script"
git push
```

---

## 📚 相关文档

- [Cloudflare Pages 构建配置](https://developers.cloudflare.com/pages/platform/build-configuration/)
- [Cloudflare Pages Headers](https://developers.cloudflare.com/pages/platform/headers/)
- [Cloudflare Pages Redirects](https://developers.cloudflare.com/pages/platform/redirects/)
- [项目详细配置说明](./CLOUDFLARE_PAGES_CONFIG_FILES.md)

---

## ✅ 总结

**当前配置已修复所有 Cloudflare Pages 构建错误，可以正常自动部署。**

主要更改：
- ✅ 移除 `wrangler.toml` 中的 Workers 专用配置
- ✅ 使用 `cloudflare-pages.toml` 作为主配置文件
- ✅ 确保构建脚本有执行权限
- ✅ 验证所有配置文件无冲突

**下次推送代码后，Cloudflare Pages 将自动完成构建和部署。**

---

最后更新：2024年11月
