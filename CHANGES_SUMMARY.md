# 优化总结

本次更改完成了以下两个任务：

## 1. 优化Tauri启动速度（解决白屏问题）

### 问题
Tauri应用在启动时会显示白屏，用户体验不佳。

### 解决方案
实现了一个优雅的加载流程：

#### 修改的文件：
- **src-tauri/tauri.conf.json**
  - 将窗口初始状态设置为不可见（`visible: false`）
  - 窗口将在内容加载完成后才显示

- **src-tauri/src/main.rs**
  - 添加了新的Tauri命令 `show_main_window`
  - 该命令用于在页面加载完成后显示并聚焦主窗口

- **prepare-tauri.sh**
  - 添加了漂亮的加载动画界面（紫色渐变背景，旋转加载指示器）
  - 注入JavaScript代码监听DOM加载事件
  - 在DOM内容加载完成后自动调用 `show_main_window` 显示窗口
  - 加载动画会平滑淡出（0.3秒过渡效果）

### 效果
- 应用启动时不再显示白屏
- 用户会看到一个专业的加载动画
- 页面加载完成后平滑过渡到主界面
- 整体启动体验更加流畅专业

## 2. 添加免安装版本（Portable）

### Tauri版本

#### 修改的文件：
- **.github/workflows/build-tauri-windows.yml**
  - 添加了 "Create portable version" 步骤
  - 该步骤会：
    1. 创建便携版目录
    2. 复制可执行文件（CircuitJS1.exe）
    3. 创建README说明文件
    4. 打包成ZIP文件（CircuitJS1-Tauri-Windows-x64-Portable.zip）
  - 更新了artifact上传，包含便携版ZIP文件

#### 输出产物：
- 原有的MSI安装包
- 原有的NSIS安装程序
- **新增：免安装便携版ZIP包**

### Electron版本

#### 修改的文件：
- **app/package.json**
  - 在 `build.win.target` 中添加了 `portable` 目标
  - electron-builder会自动生成便携版可执行文件

- **.github/workflows/build-electron-windows.yml**
  - 将artifact名称改为 `CircuitJS1-Electron-Windows-x64` 以区分
  - 保持原有的上传配置，electron-builder会自动生成portable版本

#### 输出产物：
- 原有的NSIS安装程序
- **新增：electron-builder生成的便携版EXE**

## 使用说明

### 构建Tauri应用（本地）
```bash
# 1. 构建GWT项目
./gradlew compileGwt makeSite

# 2. 准备Tauri（会注入加载动画和API）
./prepare-tauri.sh

# 3. 构建Tauri应用
cd src-tauri
cargo tauri build
```

### 构建Electron应用（本地）
```bash
# 1. 构建GWT项目
./gradlew compileGwt makeSite

# 2. 准备Electron
cd app
rm -rf war
cp -r ../site war

# 3. 安装依赖并构建
npm install
npm run build:win
```

### GitHub Actions自动构建
- 在GitHub仓库中触发对应的workflow
- Tauri: "Build Tauri Windows x64"
- Electron: "Build Electron Windows x64"
- 构建完成后从Artifacts下载所有版本（安装版和便携版）

## 技术细节

### Tauri加载优化原理
1. 窗口初始化时设置为隐藏状态
2. HTML页面注入加载动画（固定定位，全屏覆盖，高z-index）
3. JavaScript监听多个加载事件：
   - `DOMContentLoaded`：DOM解析完成
   - `load`：所有资源加载完成
4. 加载完成后：
   - 淡出加载动画（CSS过渡）
   - 调用Rust后端命令显示窗口
   - 移除加载动画DOM元素

### Portable版本优势
- **无需安装**：解压即用，适合U盘携带或临时使用
- **无管理员权限要求**：不修改系统注册表
- **独立运行**：每个实例独立，便于测试不同版本
- **快速部署**：适合企业批量部署或教育环境

## 兼容性
- 所有更改向后兼容
- 不影响现有的安装版本功能
- 用户可以根据需求选择安装版或便携版
