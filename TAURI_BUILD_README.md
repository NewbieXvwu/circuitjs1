# Tauri Desktop Application Build Guide

这个文档说明如何构建和开发基于Tauri的CircuitJS1桌面应用程序。

## 概述

CircuitJS1现在支持使用Tauri框架构建跨平台桌面应用。Tauri使用Rust后端和Web前端，相比Electron更轻量且安全。

## 先决条件

### 系统要求

1. **Rust** (1.70+)
   - 安装: https://rustup.rs/
   - Windows: `winget install Rustlang.Rustup`

2. **Java** (21+)
   - 用于编译GWT项目

3. **Node.js** (可选)
   - 仅在需要使用npm命令时

4. **系统依赖**
   
   **Windows:**
   - Microsoft Visual Studio C++ Build Tools
   - WebView2 (通常已预装在Windows 10/11)
   
   **Linux:**
   ```bash
   sudo apt update
   sudo apt install libwebkit2gtk-4.0-dev \
       build-essential \
       curl \
       wget \
       file \
       libssl-dev \
       libgtk-3-dev \
       libayatana-appindicator3-dev \
       librsvg2-dev
   ```
   
   **macOS:**
   - Xcode Command Line Tools: `xcode-select --install`

## 构建步骤

### 1. 编译GWT项目

首先需要编译GWT项目生成Web资源：

```bash
./gradlew compileGwt
./gradlew makeSite
```

这将在`site/`目录中生成编译后的Web应用。

### 2. 准备Tauri构建

运行准备脚本来注入Tauri API：

```bash
./prepare-tauri.sh
```

这将创建`site-tauri/`目录，其中包含修改后的HTML文件，集成了Tauri API。

### 3. 安装Tauri CLI

```bash
cargo install tauri-cli
```

### 4. 构建应用

**开发模式：**
```bash
cargo tauri dev
```

**生产构建：**
```bash
cargo tauri build
```

构建产物位置：
- Windows: `src-tauri/target/release/bundle/msi/` 和 `src-tauri/target/release/bundle/nsis/`
- Linux: `src-tauri/target/release/bundle/deb/` 和 `src-tauri/target/release/bundle/appimage/`
- macOS: `src-tauri/target/release/bundle/dmg/` 和 `src-tauri/target/release/bundle/macos/`

## GitHub Actions 自动构建

项目配置了GitHub Actions来自动构建Windows x64版本。

### 触发构建

1. **手动触发：**
   - 进入GitHub仓库的 Actions 标签
   - 选择 "Build Tauri Windows x64" 工作流
   - 点击 "Run workflow"

2. **自动触发：**
   - 推送到 `feat-tauri-windows-gh-actions-static-build` 分支

### 下载构建产物

构建完成后，在GitHub Actions页面的工作流运行详情中下载 `CircuitJS1-Tauri-Windows-x64` 产物。

产物包含：
- `.msi` 安装包 (Windows Installer)
- `.exe` 安装包 (NSIS Installer)

## 项目结构

```
/home/engine/project/
├── src-tauri/              # Tauri Rust项目
│   ├── src/
│   │   └── main.rs         # Rust主程序
│   ├── icons/              # 应用图标
│   ├── Cargo.toml          # Rust依赖
│   ├── tauri.conf.json     # Tauri配置
│   └── build.rs            # 构建脚本
├── site/                   # GWT编译输出 (原始)
├── site-tauri/             # Tauri构建输入 (注入API)
├── prepare-tauri.sh        # Tauri准备脚本
└── .github/workflows/
    └── build-tauri-windows.yml  # Windows自动构建
```

## API适配

Tauri应用通过JavaScript API与Rust后端通信。以下是关键API的映射：

### 文件操作

**保存对话框：**
```javascript
const result = await window.showSaveDialog();
if (result) {
    const filePath = result.filePath;
}
```

**保存文件：**
```javascript
await window.saveFile(filePath, content);
```

**打开文件：**
```javascript
window.openFile((content, fileName) => {
    // 处理文件内容
});
```

### 开发者工具

```javascript
window.toggleDevTools();
```

## Tauri配置

主要配置在 `src-tauri/tauri.conf.json`:

- `distDir`: 指向 `../site-tauri` (包含Web资源)
- `identifier`: `com.lushprojects.circuitjs1`
- `windows[0].url`: `circuitjs.html` (入口HTML)

## 常见问题

### Q: 构建失败，提示找不到WebView2

**A:** Windows需要WebView2运行时。通常已预装在Windows 10/11。如果没有：
- 下载: https://developer.microsoft.com/microsoft-edge/webview2/

### Q: 如何调试Tauri应用？

**A:** 
1. 使用 `cargo tauri dev` 启动开发模式
2. 开发模式下，按 Ctrl+Shift+I (Windows/Linux) 或 Cmd+Option+I (macOS) 打开开发者工具

### Q: 如何修改窗口大小或标题？

**A:** 编辑 `src-tauri/tauri.conf.json` 中的 `windows` 数组配置。

### Q: 构建的应用很大？

**A:** Tauri应用通常比Electron小得多。如需进一步减小：
- 确保使用 `--release` 模式构建
- 考虑使用 `strip` 工具移除调试符号

## 更多资源

- [Tauri官方文档](https://tauri.app/)
- [Tauri API参考](https://tauri.app/v1/api/js/)
- [Rust编程语言](https://www.rust-lang.org/)

## 许可证

本项目遵循原CircuitJS1项目的GPL-2.0-or-later许可证。
