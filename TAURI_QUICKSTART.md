# Tauri快速入门指南

## 使用GitHub Actions自动构建（推荐）

### 方法1: 手动触发工作流

1. 访问GitHub仓库页面
2. 点击 "Actions" 标签
3. 在左侧选择 "Build Tauri Windows x64" 工作流
4. 点击 "Run workflow" 按钮
5. 等待构建完成（约10-15分钟）
6. 下载构建产物：
   - 点击完成的工作流运行
   - 在 "Artifacts" 部分下载 `CircuitJS1-Tauri-Windows-x64`

### 方法2: 通过推送代码触发

```bash
git push origin feat-tauri-windows-gh-actions-static-build
```

推送到该分支会自动触发构建。

## 本地构建

### 前提条件

**Windows用户：**
```powershell
# 1. 安装Rust
winget install Rustlang.Rustup

# 2. 安装Java (如果还没有)
winget install EclipseAdoptium.Temurin.21.JDK

# 3. 安装Visual Studio Build Tools
# 下载并安装: https://visualstudio.microsoft.com/downloads/
# 选择 "Desktop development with C++"
```

**Linux用户：**
```bash
# 安装依赖
sudo apt update
sudo apt install -y \
    libwebkit2gtk-4.0-dev \
    build-essential \
    curl \
    wget \
    file \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev

# 安装Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 构建步骤

```bash
# 1. 克隆仓库（如果还没有）
git clone <仓库URL>
cd circuitjs1

# 2. 切换到Tauri分支
git checkout feat-tauri-windows-gh-actions-static-build

# 3. 编译GWT项目
./gradlew compileGwt
./gradlew makeSite

# 4. 准备Tauri构建
./prepare-tauri.sh

# 5. 安装Tauri CLI
cargo install tauri-cli

# 6. 构建应用
cargo tauri build
```

### 构建产物位置

构建完成后，在以下位置找到安装包：

**Windows:**
- MSI安装包: `src-tauri/target/release/bundle/msi/CircuitJS1_0.0.1_x64_en-US.msi`
- NSIS安装包: `src-tauri/target/release/bundle/nsis/CircuitJS1_0.0.1_x64-setup.exe`

**Linux:**
- DEB包: `src-tauri/target/release/bundle/deb/circuitjs1_0.0.1_amd64.deb`
- AppImage: `src-tauri/target/release/bundle/appimage/circuitjs1_0.0.1_amd64.AppImage`

**macOS:**
- DMG: `src-tauri/target/release/bundle/dmg/CircuitJS1_0.0.1_x64.dmg`
- App: `src-tauri/target/release/bundle/macos/CircuitJS1.app`

## 开发模式

如果你想修改代码并实时预览：

```bash
# 1. 确保已编译GWT和准备Tauri
./gradlew compileGwt makeSite
./prepare-tauri.sh

# 2. 启动开发模式
cargo tauri dev
```

这会打开一个带有热重载的开发窗口。

## 常见问题

### Windows上提示"WebView2 not found"

安装WebView2运行时：
```powershell
winget install Microsoft.EdgeWebView2Runtime
```

或从官网下载：https://developer.microsoft.com/microsoft-edge/webview2/

### Linux上提示找不到webkit2gtk

```bash
sudo apt install libwebkit2gtk-4.0-dev
```

### 构建时内存不足

编辑 `src-tauri/Cargo.toml`，添加：
```toml
[profile.release]
opt-level = "z"  # 优化体积
lto = true       # 链接时优化
```

### 如何修改应用信息？

编辑 `src-tauri/tauri.conf.json`:
- `package.productName`: 应用名称
- `package.version`: 版本号
- `tauri.bundle.identifier`: 应用标识符
- `tauri.windows[0].title`: 窗口标题

## 与Electron版本的区别

| 特性 | Electron | Tauri |
|------|----------|-------|
| 安装包大小 | ~100-150MB | ~10-20MB |
| 内存占用 | 高 | 低 |
| 启动速度 | 较慢 | 快 |
| 技术栈 | Node.js + Chromium | Rust + WebView |
| 安全性 | 中等 | 高 |

## 下一步

- 阅读详细文档：[TAURI_BUILD_README.md](./TAURI_BUILD_README.md)
- 了解Tauri API：https://tauri.app/v1/api/js/
- 自定义应用图标：替换 `src-tauri/icons/` 目录中的图标文件

## 技术支持

如有问题，请在GitHub仓库创建Issue。
