# 🚀 CircuitJS1 - Material You 版本 - 快速部署指南

> **一键部署到 Cloudflare Pages，无需本地安装任何工具！**

## ✨ 新特性

### Material You (MD3) 设计
- 🎨 现代紫色配色方案
- 🔘 圆角按钮和组件
- 🌊 流畅的动画效果
- 📱 响应式设计
- 🎭 多层阴影效果

### 自动化部署
- ⚡ 推送代码即自动部署
- 🌍 全球 CDN 加速
- 🔒 自动 HTTPS
- 💯 完全免费

---

## 📋 部署方式

### 方式一：通过 Cloudflare Pages Dashboard（推荐）

**5分钟完成部署：**

1. Fork 此仓库到你的 GitHub
2. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)
3. 进入 **Workers & Pages** → **Create application** → **Pages** → **Connect to Git**
4. 选择你的仓库，配置构建设置：
   - **构建命令**: `chmod +x build-cloudflare.sh && ./build-cloudflare.sh`
   - **构建输出目录**: `war`
5. 点击 **Save and Deploy**
6. 等待 5-8 分钟，完成！

**详细教程**: 查看 [`CLOUDFLARE_ONE_CLICK_DEPLOY.md`](./CLOUDFLARE_ONE_CLICK_DEPLOY.md)

### 方式二：通过 Wrangler CLI

```bash
# 安装 Wrangler
npm install -g wrangler

# 登录 Cloudflare
wrangler login

# 创建 Pages 项目
wrangler pages project create circuitjs1

# 本地构建（可选）
bash build-cloudflare.sh

# 部署
wrangler pages deploy war --project-name=circuitjs1
```

### 方式三：一键部署按钮

点击下方按钮直接部署到 Cloudflare Pages：

[![Deploy to Cloudflare Pages](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/你的用户名/circuitjs1)

---

## 🏗️ 构建配置文件

项目包含完整的自动化配置：

### 📄 `build-cloudflare.sh`
自动构建脚本，负责：
- ✅ 安装 Java JDK 11
- ✅ 下载 GWT SDK 2.10.0
- ✅ 编译 Java 源代码
- ✅ GWT 转译为 JavaScript
- ✅ 生成部署文件

### 📄 `cloudflare-pages.toml`
Cloudflare Pages 配置：
- 构建命令和输出目录
- 缓存策略
- 安全头配置
- 重定向规则

### 📄 `wrangler.toml`
Wrangler CLI 配置：
- 项目名称
- 构建环境
- 部署设置

### 📄 `war/_headers`
HTTP 头配置：
- 缓存控制
- 安全策略
- CORS 设置

### 📄 `war/_redirects`
路由重定向：
- 根路径 → circuitjs.html

---

## 🎯 快速访问

部署完成后，你的应用将可通过以下地址访问：

```
https://你的项目名.pages.dev/circuitjs.html
```

或直接访问根路径（自动重定向）：

```
https://你的项目名.pages.dev/
```

---

## 🔄 自动更新

配置完成后，每次推送代码到 GitHub，Cloudflare Pages 会自动重新构建和部署：

```bash
git add .
git commit -m "你的更新说明"
git push origin main
```

---

## 📖 详细文档

- **[一键部署完整教程](./CLOUDFLARE_ONE_CLICK_DEPLOY.md)** - 详细的分步指南
- **[Material You UI 说明](./MATERIAL_YOU_UI_UPDATES.md)** - 设计系统详解
- **[完整部署指南](./CLOUDFLARE_PAGES_DEPLOYMENT_GUIDE.md)** - 包含故障排除

---

## 🛠️ 本地开发（可选）

如果你想在本地测试：

### 方法 1: 使用简单 HTTP 服务器

```bash
# Python 3
cd war
python -m http.server 8080

# 访问 http://localhost:8080/circuitjs.html
```

### 方法 2: 使用 Wrangler 预览

```bash
cd war
wrangler pages dev .
```

---

## 🎨 自定义配色

Material You 配色使用 CSS 变量，易于自定义。

编辑 `war/circuitjs.html` 中的颜色变量：

```css
:root {
  --md-sys-color-primary: #6750A4;  /* 改为你喜欢的颜色 */
  --md-sys-color-secondary: #625B71;
  /* ... 其他颜色 */
}
```

**推荐工具**: [Material Theme Builder](https://m3.material.io/theme-builder)

---

## 📊 性能

### 构建时间
- **首次构建**: ~5-8 分钟
- **后续构建**: ~2-3 分钟（依赖已缓存）

### 文件大小
- **草稿模式（当前）**: ~5-10 MB
- **优化模式（可选）**: ~2-3 MB

### 加载速度
- **全球 CDN**: 就近访问
- **Brotli 压缩**: 自动启用
- **缓存策略**: 智能缓存

---

## 🔐 安全特性

- ✅ 强制 HTTPS
- ✅ 安全响应头（X-Frame-Options, CSP, 等）
- ✅ DDoS 防护（Cloudflare 网络）
- ✅ 自动 SSL 证书

---

## 💰 成本

**完全免费！**

Cloudflare Pages 免费套餐包括：
- ✅ 无限带宽
- ✅ 每月 500 次构建
- ✅ 无限网站
- ✅ 全球 CDN
- ✅ 自动 HTTPS

---

## 🐛 故障排除

### 构建失败

1. 检查构建日志中的错误信息
2. 确认构建命令正确：`chmod +x build-cloudflare.sh && ./build-cloudflare.sh`
3. 确认构建输出目录为：`war`

### 页面空白

1. 强制刷新浏览器（Ctrl+Shift+R）
2. 检查浏览器控制台错误
3. 确认访问 `/circuitjs.html` 而不是 `/index.html`

### Material UI 未显示

1. 清除浏览器缓存
2. 使用隐私/无痕模式测试
3. 检查 `circuitjs.html` 文件是否包含 Material 样式

---

## 🆘 获取帮助

- **查看详细教程**: `CLOUDFLARE_ONE_CLICK_DEPLOY.md`
- **检查构建日志**: Cloudflare Dashboard → 你的项目 → Deployments
- **社区支持**: [Cloudflare Community](https://community.cloudflare.com/)
- **提交 Issue**: [GitHub Issues](https://github.com/pfalstad/circuitjs1/issues)

---

## 📝 更新日志

### v2.0 - Material You 版本
- ✨ 应用 Material Design 3 (Material You) 设计系统
- 🚀 添加 Cloudflare Pages 自动部署配置
- 📦 创建自动构建脚本（无需本地工具）
- 📚 完善部署文档和教程
- 🔐 添加安全头和缓存优化

---

## 📄 许可证

GNU General Public License v2.0 或更高版本

查看 [COPYING.txt](./COPYING.txt) 了解详情。

---

## 🙏 致谢

- **Paul Falstad** - CircuitJS1 原作者
- **Iain Sharp** - GWT 移植
- **Material Design Team** - Material You 设计系统
- **Cloudflare** - Pages 托管平台

---

**开始部署你的 CircuitJS1 应用吧！** 🎉

有问题？查看 [`CLOUDFLARE_ONE_CLICK_DEPLOY.md`](./CLOUDFLARE_ONE_CLICK_DEPLOY.md) 获取详细帮助。
