# CircuitJS1 一键部署到 Cloudflare Pages 指南

本指南提供最简化的部署流程，**无需本地安装任何工具**，一切都在 Cloudflare Pages 的云端构建环境中自动完成。

## 🚀 快速开始（5分钟完成部署）

### 前提条件

你只需要：
- ✅ 一个 GitHub 账户（免费）
- ✅ 一个 Cloudflare 账户（免费）
- ✅ 浏览器

**不需要**：
- ❌ 不需要安装 Java
- ❌ 不需要安装 Ant
- ❌ 不需要安装 GWT
- ❌ 不需要安装 Node.js
- ❌ 不需要本地构建

所有构建过程都在 Cloudflare Pages 的云端环境中自动完成！

---

## 📝 部署步骤

### 步骤 1: Fork 或推送代码到 GitHub

#### 方式 A: Fork 现有仓库（推荐）

1. 访问 CircuitJS1 仓库: https://github.com/pfalstad/circuitjs1
2. 点击右上角的 **"Fork"** 按钮
3. 等待 Fork 完成

#### 方式 B: 推送你的修改版本

如果你已经有了本地修改：

```bash
# 初始化 Git（如果还没有）
git init
git add .
git commit -m "Add Material You UI and Cloudflare Pages config"

# 添加远程仓库并推送
git remote add origin https://github.com/你的用户名/circuitjs1.git
git branch -M main
git push -u origin main
```

### 步骤 2: 连接 Cloudflare Pages

1. **登录 Cloudflare Dashboard**
   - 访问: https://dash.cloudflare.com/
   - 使用你的账户登录

2. **创建 Pages 项目**
   - 在左侧菜单点击 **"Workers & Pages"**
   - 点击 **"Create application"** 按钮
   - 选择 **"Pages"** 标签
   - 点击 **"Connect to Git"**

3. **授权 GitHub 访问**
   - 点击 **"Connect GitHub"**
   - 在弹出的窗口中授权 Cloudflare 访问你的 GitHub
   - 选择 **"All repositories"** 或 **"Only select repositories"**
   - 如果选择特定仓库，请选中 **circuitjs1** 仓库

4. **选择仓库**
   - 在仓库列表中找到 **circuitjs1**
   - 点击 **"Begin setup"**

### 步骤 3: 配置构建设置

在"Setup build and deployments"页面填写以下信息：

#### 基本设置

| 字段 | 值 |
|------|-----|
| **项目名称** | `circuitjs1`（或你喜欢的名称） |
| **生产分支** | `main`（或 `master`，取决于你的默认分支） |

#### 构建设置

| 字段 | 值 |
|------|-----|
| **框架预设** | None（选择"None"） |
| **构建命令** | `chmod +x build-cloudflare.sh && ./build-cloudflare.sh` |
| **构建输出目录** | `war` |
| **根目录** | `/`（保持默认） |

#### 环境变量（可选）

不需要设置任何环境变量！构建脚本会自动处理一切。

### 步骤 4: 开始部署

1. 确认所有设置正确
2. 点击 **"Save and Deploy"** 按钮
3. Cloudflare Pages 开始自动构建和部署

### 步骤 5: 等待构建完成

构建过程大约需要 **5-8 分钟**，包括：

1. **初始化构建环境** (~30秒)
   - 克隆你的 Git 仓库
   - 设置构建容器

2. **安装 Java JDK** (~1-2分钟)
   - 自动下载 Amazon Corretto JDK 11
   - 解压并配置环境

3. **安装 GWT SDK** (~1分钟)
   - 自动下载 GWT 2.10.0
   - 解压并配置

4. **编译项目** (~3-5分钟)
   - 编译 Java 源代码
   - GWT 转译为 JavaScript
   - 优化资源文件

5. **部署** (~30秒)
   - 上传到 Cloudflare 全球 CDN
   - 配置缓存和安全头

你可以在构建日志中实时查看进度。

### 步骤 6: 访问你的应用

构建成功后，你会看到：

```
✅ Success: Your site is live!

https://circuitjs1.pages.dev
```

点击 URL 访问你的 CircuitJS1 应用！

完整访问地址：
```
https://你的项目名.pages.dev/circuitjs.html
```

或者直接访问根路径（会自动重定向）：
```
https://你的项目名.pages.dev/
```

---

## 🎨 Material You (MD3) UI 特性

部署后，你的应用将包含以下 Material Design 3 特性：

- ✨ **现代配色方案** - 紫色主色调，符合 MD3 规范
- 🎯 **圆角设计** - 柔和的圆角按钮和组件
- 🌊 **流畅动画** - 200ms 过渡效果
- 📱 **响应式设计** - 适配各种屏幕尺寸
- 🎭 **多层阴影** - 创建深度感和层次
- 🔤 **Roboto 字体** - Google 的官方 Material 字体
- ♿ **可访问性改进** - 符合 WCAG 2.1 标准

---

## 🔄 自动更新部署

配置完成后，每次你推送代码到 GitHub，Cloudflare Pages 会自动：

1. 检测到代码变化
2. 触发新的构建
3. 自动部署更新

### 如何更新应用

```bash
# 修改代码
# ...

# 提交更改
git add .
git commit -m "更新描述"

# 推送到 GitHub
git push origin main

# Cloudflare Pages 会自动检测并重新部署！
```

你可以在 Cloudflare Dashboard 的项目页面查看：
- 最近的部署
- 构建日志
- 部署历史
- 预览链接（Pull Request）

---

## ⚙️ 高级配置

### 使用配置文件（推荐）

项目已包含 `cloudflare-pages.toml` 配置文件，它定义了：

- ✅ 构建命令和输出目录
- ✅ 缓存策略
- ✅ 安全头
- ✅ 重定向规则

Cloudflare Pages 会自动读取此文件，你无需手动配置。

### 自定义域名

1. 在 Cloudflare Pages 项目中，点击 **"Custom domains"**
2. 点击 **"Set up a custom domain"**
3. 输入你的域名：`circuitjs.yourdomain.com`
4. Cloudflare 会自动：
   - 创建 DNS 记录
   - 生成 SSL 证书
   - 配置 HTTPS

### 环境变量

如果需要配置环境变量（通常不需要）：

1. 进入项目设置
2. 点击 **"Environment variables"**
3. 添加变量：
   - `BUILD_MODE=production` - 生产模式构建
   - `GWT_OPTIMIZE=9` - 最大优化级别

---

## 🛠️ 构建脚本详解

`build-cloudflare.sh` 脚本自动完成以下任务：

### 第一步：安装 Java JDK
```bash
- 检测系统架构（x86_64 或 aarch64）
- 下载 Amazon Corretto JDK 11
- 解压到 $HOME/jdk
- 配置 JAVA_HOME 和 PATH
```

### 第二步：安装 GWT SDK
```bash
- 下载 GWT 2.10.0
- 解压到 $HOME/gwt
- 配置 GWT_SDK 路径
```

### 第三步：编译项目
```bash
- 编译 Java 源代码
- 运行 GWT 编译器（草稿模式）
- 生成 JavaScript 文件到 war/ 目录
```

所有依赖都会被缓存，后续构建会更快（通常 2-3 分钟）。

---

## 📊 构建优化

### 草稿模式 vs 优化模式

**当前使用：草稿模式（Draft Mode）**
- ✅ 构建速度快（3-5分钟）
- ✅ 适合开发和预览
- ⚠️ 文件较大（~5-10MB）

**可选：优化模式（Optimized Mode）**
- ⚠️ 构建速度慢（8-15分钟）
- ✅ 文件更小（~2-3MB）
- ✅ 适合生产环境

要启用优化模式，修改 `build-cloudflare.sh`：

```bash
# 将这行：
-draftCompile \
-optimize 0 \

# 改为：
-optimize 9 \
```

### 构建超时

Cloudflare Pages 免费版构建超时时间为 **20分钟**，足够完成编译。

---

## 🔍 故障排除

### 问题 1: 构建失败 - "command not found"

**原因**: 构建脚本没有执行权限

**解决方案**:
确保构建命令包含 `chmod +x`：
```bash
chmod +x build-cloudflare.sh && ./build-cloudflare.sh
```

### 问题 2: 构建失败 - "Java download failed"

**原因**: 网络问题或下载链接变化

**解决方案**:
1. 重试构建（Cloudflare Dashboard 中点击 "Retry deployment"）
2. 或在构建脚本中使用备用下载源

### 问题 3: GWT 编译失败

**原因**: 代码错误或依赖问题

**解决方案**:
1. 检查构建日志中的详细错误信息
2. 在本地使用 Eclipse 验证代码
3. 确保所有 Java 文件语法正确

### 问题 4: 页面显示空白

**原因**: 路径问题或资源未加载

**解决方案**:
1. 检查浏览器控制台的错误
2. 确认访问的是 `/circuitjs.html` 而不是 `/index.html`
3. 检查 `war/circuitjs1/` 目录是否包含 JS 文件

### 问题 5: 部署后 Material UI 未应用

**原因**: 缓存问题

**解决方案**:
1. 强制刷新浏览器（Ctrl+Shift+R 或 Cmd+Shift+R）
2. 清除浏览器缓存
3. 使用隐私/无痕模式访问

---

## 📈 性能和成本

### Cloudflare Pages 免费套餐包含

- ✅ **无限带宽** - 不限制访问流量
- ✅ **每月 500 次构建** - 足够个人和小团队使用
- ✅ **无限网站** - 可以部署多个项目
- ✅ **全球 CDN** - 自动分发到全球节点
- ✅ **自动 HTTPS** - 免费 SSL 证书
- ✅ **DDoS 防护** - Cloudflare 的防护网络
- ✅ **Git 集成** - 自动部署

### 预估成本

**个人使用：完全免费！**

即使是商业使用，在达到以下限制之前都是免费的：
- 500 次构建/月
- 无限请求
- 无限带宽

---

## 🌍 全球部署

Cloudflare Pages 自动将你的应用部署到全球 275+ 个数据中心，用户会从最近的位置加载应用，确保：

- ⚡ 极快的加载速度
- 🌐 全球可访问性
- 🔒 安全的 HTTPS 连接
- 📊 实时分析数据

---

## 📱 预览部署

### Pull Request 预览

当你创建 Pull Request 时，Cloudflare Pages 会自动：

1. 为 PR 创建独立的预览部署
2. 生成唯一的预览 URL
3. 在 PR 评论中显示链接
4. 每次推送更新时重新构建

预览 URL 格式：
```
https://[commit-hash].circuitjs1.pages.dev
```

这样你可以在合并前预览和测试更改！

---

## 🔐 安全最佳实践

项目已配置以下安全措施：

### HTTP 安全头

```
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), microphone=(), camera=()
```

### 缓存策略

- **静态资源（JS/Fonts）**: 1年缓存（immutable）
- **HTML 文件**: 1小时缓存，需重新验证
- **其他资源**: 24小时缓存

### HTTPS 强制

Cloudflare Pages 自动强制 HTTPS，所有 HTTP 请求都会重定向到 HTTPS。

---

## 📚 相关文档

- **CircuitJS1 官方文档**: https://github.com/pfalstad/circuitjs1
- **Cloudflare Pages 文档**: https://developers.cloudflare.com/pages/
- **GWT 文档**: https://www.gwtproject.org/
- **Material Design 3**: https://m3.material.io/

---

## 🎯 总结

使用 Cloudflare Pages 一键部署 CircuitJS1 的优势：

✅ **零配置** - 无需本地安装任何工具
✅ **自动化** - 推送代码即自动部署
✅ **全球 CDN** - 快速的全球访问
✅ **免费** - 个人和小团队完全免费
✅ **可靠** - Cloudflare 的企业级基础设施
✅ **现代 UI** - Material You (MD3) 设计风格
✅ **安全** - 自动 HTTPS 和安全头

---

## 🆘 获取帮助

如果遇到问题：

1. **查看构建日志** - 在 Cloudflare Dashboard 的部署详情中
2. **检查项目文档** - `MATERIAL_YOU_UI_UPDATES.md`
3. **参考完整教程** - `CLOUDFLARE_PAGES_DEPLOYMENT_GUIDE.md`
4. **访问社区** - Cloudflare Community Forum
5. **查看示例** - CircuitJS1 官方示例

---

**祝你部署顺利！** 🎉

如有任何问题，欢迎提交 Issue！
