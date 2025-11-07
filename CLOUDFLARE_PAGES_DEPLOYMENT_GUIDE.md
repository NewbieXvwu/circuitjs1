# CircuitJS1 部署到 Cloudflare Pages 完整教程

本教程将详细指导你如何将 CircuitJS1 电路模拟器部署到 Cloudflare Pages，使其可以通过互联网访问。

## 📋 目录

1. [前置要求](#前置要求)
2. [准备工作](#准备工作)
3. [构建项目](#构建项目)
4. [部署到 Cloudflare Pages](#部署到-cloudflare-pages)
5. [配置自定义域名](#配置自定义域名可选)
6. [故障排除](#故障排除)
7. [更新部署](#更新部署)

---

## 🔧 前置要求

在开始之前，请确保你已经准备好以下内容：

### 1. 必需工具
- **Git** - 版本控制工具
  - 下载地址: https://git-scm.com/downloads
  - 安装后在命令行运行 `git --version` 验证

- **Java JDK 8 或更高版本** - 编译 GWT 项目
  - 下载地址: https://www.oracle.com/java/technologies/downloads/
  - 或使用 OpenJDK: https://adoptium.net/
  - 运行 `java -version` 验证安装

- **Apache Ant** - 构建工具
  - 下载地址: https://ant.apache.org/bindownload.cgi
  - 运行 `ant -version` 验证安装

### 2. 账户准备
- **Cloudflare 账户** (免费)
  - 注册地址: https://dash.cloudflare.com/sign-up
  - Cloudflare Pages 免费套餐提供：
    - 无限带宽
    - 每月 500 次构建
    - 无限网站
    - 自动 HTTPS

- **GitHub 账户** (推荐) 或 GitLab 账户
  - GitHub: https://github.com/signup
  - GitLab: https://gitlab.com/users/sign_up

---

## 📦 准备工作

### 步骤 1: Fork 或克隆项目

#### 方式一：通过 GitHub Fork (推荐)

1. 访问 CircuitJS1 GitHub 仓库：
   ```
   https://github.com/pfalstad/circuitjs1
   ```

2. 点击右上角的 "Fork" 按钮，将项目 Fork 到你的 GitHub 账户

3. 克隆你 Fork 的仓库到本地：
   ```bash
   git clone https://github.com/你的用户名/circuitjs1.git
   cd circuitjs1
   ```

#### 方式二：直接克隆原始仓库

```bash
git clone https://github.com/pfalstad/circuitjs1.git
cd circuitjs1
```

### 步骤 2: 应用 Material You (MD3) 设计更新

如果你想使用更新后的 Material Design 3 界面，circuitjs.html 已经包含了所有必要的样式更新。

---

## 🔨 构建项目

### 步骤 1: 设置环境变量 (Windows)

在 Windows 上，你需要设置 JAVA_HOME 环境变量：

```cmd
# 查找 Java 安装路径
where java

# 设置 JAVA_HOME (临时)
set JAVA_HOME=C:\Program Files\Java\jdk-17

# 添加到 PATH
set PATH=%JAVA_HOME%\bin;%PATH%
```

### 步骤 2: 设置环境变量 (macOS/Linux)

```bash
# 查找 Java 安装路径
which java

# 编辑 ~/.bashrc 或 ~/.zshrc
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# 重新加载配置
source ~/.bashrc  # 或 source ~/.zshrc
```

### 步骤 3: 下载 GWT SDK

1. 访问 GWT 下载页面: https://www.gwtproject.org/download.html

2. 下载 GWT SDK (建议版本 2.8.2 或更高)

3. 解压到项目目录：
   ```bash
   # 示例路径
   unzip gwt-2.8.2.zip
   ```

4. 编辑项目根目录的 `build.xml` 文件，更新 GWT SDK 路径：
   ```xml
   <property name="gwt.sdk" location="path/to/gwt-2.8.2" />
   ```

### 步骤 4: 编译项目

在项目根目录运行：

```bash
# 清理之前的构建
ant clean

# 编译 GWT 项目 (这可能需要几分钟)
ant

# 或者使用草稿模式编译 (更快但文件更大)
ant draft
```

编译成功后，你会看到类似输出：
```
BUILD SUCCESSFUL
Total time: X minutes Y seconds
```

编译结果位于 `war` 目录中。

### 步骤 5: 验证构建结果

检查 `war` 目录结构：
```
war/
├── circuitjs.html          # 主页面 (已更新为 MD3 风格)
├── circuitjs1/             # GWT 编译输出
│   ├── circuitjs1.nocache.js
│   └── ...
├── lz-string.min.js
├── font/                   # 图标字体
└── ...
```

### 步骤 6: 本地测试 (可选但推荐)

使用简单的 HTTP 服务器测试：

**Python 3:**
```bash
cd war
python -m http.server 8080
```

**Python 2:**
```bash
cd war
python -m SimpleHTTPServer 8080
```

**Node.js (http-server):**
```bash
npm install -g http-server
cd war
http-server -p 8080
```

访问 `http://localhost:8080/circuitjs.html` 测试应用。

---

## 🚀 部署到 Cloudflare Pages

### 方法一：通过 Git 集成部署 (推荐)

这是最简单的方法，支持自动部署。

#### 步骤 1: 推送代码到 GitHub

```bash
# 添加所有更改
git add .

# 提交更改
git commit -m "Update UI to Material You (MD3) design"

# 推送到 GitHub
git push origin main  # 或 master，取决于你的默认分支名
```

#### 步骤 2: 连接 Cloudflare Pages

1. 登录 Cloudflare Dashboard: https://dash.cloudflare.com/

2. 在左侧菜单选择 **"Workers & Pages"**

3. 点击 **"Create application"** 

4. 选择 **"Pages"** 标签

5. 点击 **"Connect to Git"**

6. 授权 Cloudflare 访问你的 GitHub/GitLab 账户

7. 选择 **circuitjs1** 仓库

#### 步骤 3: 配置构建设置

在配置页面填写以下信息：

- **项目名称**: `circuitjs1` (或自定义名称)
- **生产分支**: `main` (或 `master`)
- **构建命令**: 
  ```bash
  ant
  ```
- **构建输出目录**: 
  ```
  war
  ```
- **根目录**: `/` (保持默认)

**环境变量** (点击 "Add variable" 添加):
```
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ANT_HOME=/usr/share/ant
```

#### 步骤 4: 开始部署

1. 点击 **"Save and Deploy"**

2. Cloudflare Pages 会自动：
   - 克隆你的仓库
   - 运行构建命令
   - 部署生成的文件
   - 分配一个 `.pages.dev` 域名

3. 等待构建完成（通常需要 5-10 分钟）

4. 部署成功后，你会看到一个类似这样的 URL：
   ```
   https://circuitjs1.pages.dev
   ```

5. 访问你的 CircuitJS1 应用：
   ```
   https://circuitjs1.pages.dev/circuitjs.html
   ```

### 方法二：通过 Wrangler CLI 部署

Wrangler 是 Cloudflare 的命令行工具。

#### 步骤 1: 安装 Wrangler

```bash
npm install -g wrangler

# 或使用 yarn
yarn global add wrangler
```

#### 步骤 2: 登录 Cloudflare

```bash
wrangler login
```

这会打开浏览器窗口，请求你授权。

#### 步骤 3: 初始化 Pages 项目

在项目根目录：

```bash
# 创建 Pages 项目配置
wrangler pages project create circuitjs1
```

#### 步骤 4: 部署

```bash
# 先构建项目
ant

# 部署到 Cloudflare Pages
wrangler pages deploy war --project-name=circuitjs1
```

### 方法三：手动上传部署

如果你不想使用 Git 或 CLI，可以手动上传。

#### 步骤 1: 准备部署包

```bash
# 构建项目
ant

# 进入 war 目录
cd war

# 创建 zip 文件（可选，用于上传）
zip -r ../circuitjs1-deploy.zip .
```

#### 步骤 2: 使用 Cloudflare Dashboard

1. 登录 Cloudflare Dashboard

2. 进入 **Workers & Pages**

3. 点击 **"Create application"** > **"Pages"** > **"Upload assets"**

4. 输入项目名称: `circuitjs1`

5. 拖拽 `war` 目录中的所有文件到上传区域

6. 点击 **"Deploy site"**

7. 等待上传和部署完成

---

## 🌐 配置自定义域名（可选）

如果你有自己的域名，可以将其绑定到 Cloudflare Pages。

### 步骤 1: 添加自定义域名

1. 在 Cloudflare Pages 项目设置中，选择 **"Custom domains"**

2. 点击 **"Set up a custom domain"**

3. 输入你的域名，例如：
   ```
   circuitjs.yourdomain.com
   ```

4. 点击 **"Continue"**

### 步骤 2: 配置 DNS

Cloudflare 会自动为你创建 DNS 记录：

- **CNAME 记录**: `circuitjs` → `circuitjs1.pages.dev`

如果你的域名已经在 Cloudflare 上，这会自动完成。
如果不在，你需要：

1. 将域名的 Nameservers 更改为 Cloudflare 的 NS
2. 或者在你的 DNS 提供商处手动添加 CNAME 记录

### 步骤 3: 等待 SSL 证书

Cloudflare 会自动为你的自定义域名生成免费 SSL 证书（通常需要几分钟）。

### 步骤 4: 访问你的站点

```
https://circuitjs.yourdomain.com/circuitjs.html
```

---

## 🐛 故障排除

### 问题 1: 构建失败 - "Could not find or load main class"

**原因**: JAVA_HOME 未正确设置

**解决方案**:
```bash
# 查找 Java 安装位置
which java  # Linux/Mac
where java  # Windows

# 设置 JAVA_HOME
export JAVA_HOME=/path/to/jdk  # Linux/Mac
set JAVA_HOME=C:\path\to\jdk   # Windows
```

### 问题 2: 构建失败 - "GWT SDK not found"

**原因**: GWT SDK 路径不正确

**解决方案**:
1. 下载 GWT SDK
2. 编辑 `build.xml`，设置正确的 `gwt.sdk` 路径：
   ```xml
   <property name="gwt.sdk" location="/absolute/path/to/gwt-2.8.2" />
   ```

### 问题 3: 页面加载但显示空白

**原因**: 可能是路径问题或编译不完整

**解决方案**:
1. 检查浏览器控制台的错误信息
2. 确认 `war/circuitjs1/` 目录包含编译后的 JS 文件
3. 尝试清理并重新构建：
   ```bash
   ant clean
   ant
   ```

### 问题 4: Cloudflare Pages 构建超时

**原因**: 完整构建需要较长时间

**解决方案**:
1. 在本地预先构建，只上传 `war` 目录
2. 或者将构建命令改为 `ant draft` (更快但生成文件更大)

### 问题 5: 样式显示不正常

**原因**: CSS 缓存或浏览器兼容性

**解决方案**:
1. 清除浏览器缓存并强制刷新 (Ctrl+Shift+R / Cmd+Shift+R)
2. 检查是否使用的是现代浏览器（Chrome, Firefox, Safari, Edge 最新版）
3. 查看浏览器开发者工具的控制台错误

### 问题 6: 字体图标不显示

**原因**: 字体文件路径问题

**解决方案**:
1. 确认 `war/font/` 目录包含所有字体文件
2. 检查浏览器开发者工具的 Network 标签，看字体文件是否成功加载
3. 确认 circuitjs.html 中的字体路径正确

---

## 🔄 更新部署

### Git 集成方式（自动部署）

如果你使用 Git 集成，更新非常简单：

```bash
# 1. 修改代码
# 2. 提交更改
git add .
git commit -m "Update description"

# 3. 推送到 GitHub
git push origin main

# Cloudflare Pages 会自动检测并重新部署
```

你可以在 Cloudflare Dashboard 的项目页面查看部署进度。

### Wrangler CLI 方式

```bash
# 1. 重新构建
ant clean
ant

# 2. 部署
wrangler pages deploy war --project-name=circuitjs1
```

### 手动上传方式

1. 重新构建项目
2. 在 Cloudflare Dashboard 中创建新的部署
3. 上传更新后的文件

---

## 📊 部署后的优化建议

### 1. 启用缓存优化

Cloudflare Pages 自动启用了智能缓存，但你可以进一步优化：

在项目根目录创建 `_headers` 文件（放在 `war` 目录中）：

```
/circuitjs1/*
  Cache-Control: public, max-age=31536000, immutable

/font/*
  Cache-Control: public, max-age=31536000, immutable

/circuitjs.html
  Cache-Control: public, max-age=3600

/*.js
  Cache-Control: public, max-age=86400
```

### 2. 启用 Brotli 压缩

Cloudflare 自动为所有响应启用 Brotli 压缩，无需额外配置。

### 3. 配置重定向

如果你想让用户访问根路径时自动跳转到 circuitjs.html，创建 `_redirects` 文件（放在 `war` 目录中）：

```
/  /circuitjs.html  302
```

### 4. 添加安全头

创建 `_headers` 文件或在 Cloudflare 设置中添加：

```
/*
  X-Frame-Options: SAMEORIGIN
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: geolocation=(), microphone=(), camera=()
```

### 5. 监控和分析

在 Cloudflare Dashboard 中：
- 查看 **Analytics** 获取访问统计
- 查看 **Web Analytics** 获取详细的用户行为分析
- 设置告警以监控站点可用性

---

## 🎉 完成！

恭喜！你已经成功将 CircuitJS1 部署到 Cloudflare Pages，并应用了 Material You (MD3) 设计风格。

### 你的站点 URL:
```
https://你的项目名.pages.dev/circuitjs.html
```

### 下一步建议:

1. **分享你的站点**: 将 URL 分享给朋友和同事
2. **自定义域名**: 绑定你自己的域名
3. **继续定制**: 修改颜色方案、添加功能
4. **监控性能**: 使用 Cloudflare Analytics 跟踪使用情况
5. **备份数据**: 定期备份你的电路设计

---

## 📚 参考资源

- **CircuitJS1 官方文档**: https://github.com/pfalstad/circuitjs1
- **Cloudflare Pages 文档**: https://developers.cloudflare.com/pages/
- **GWT 文档**: https://www.gwtproject.org/
- **Material Design 3**: https://m3.material.io/
- **Wrangler 文档**: https://developers.cloudflare.com/workers/wrangler/

---

## ❓ 获取帮助

如果遇到问题：

1. **查看错误日志**: Cloudflare Pages 构建日志提供详细的错误信息
2. **搜索问题**: 在 GitHub Issues 中搜索类似问题
3. **社区支持**: 访问 Cloudflare Community 论坛
4. **官方支持**: Cloudflare 文档和支持页面

---

**最后更新**: 2024年
**版本**: 1.0

祝你部署顺利！🚀
