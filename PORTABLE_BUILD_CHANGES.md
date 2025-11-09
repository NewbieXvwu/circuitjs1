# 免安装版本构建更改说明

本次更改为Tauri和Electron版本的GitHub Actions工作流添加了免安装版本（Portable Version）的打包支持。

## 更改摘要

### 1. Tauri版本更改

#### 修改文件：`src-tauri/tauri.conf.json`
- 在 `bundle.windows` 配置中添加了 `nsis` 配置块
- 配置了NSIS安装器选项：
  - `installMode: "both"` - 支持当前用户和所有用户安装
  - `oneClick: false` - 非一键安装，允许用户自定义选项
  - `allowToChangeInstallationDirectory: true` - 允许更改安装目录
  - 创建桌面图标和开始菜单快捷方式

#### 修改文件：`.github/workflows/build-tauri-windows.yml`
- 重命名步骤 "Build Tauri app" 为 "Build Tauri app (Installer)"
- 添加新步骤 "Create Portable Version"：
  - 从release目录复制可执行文件
  - 创建portable目录并重命名为 `CircuitJS1-Portable.exe`
  - 创建标记文件 `portable.txt` 用于标识便携模式
- 更新 "Upload artifacts" 步骤，增加上传portable版本：
  - `src-tauri/target/x86_64-pc-windows-msvc/release/bundle/portable/CircuitJS1-Portable.exe`

### 2. Electron版本更改

#### 修改文件：`app/package.json`
- 在 `build.win.target` 数组中添加了 `portable` 目标
- 添加 `nsis` 配置块：
  - `oneClick: false` - 非一键安装
  - `perMachine: false` - 默认为当前用户安装
  - `allowToChangeInstallationDirectory: true` - 允许更改安装目录
  - 创建桌面图标和开始菜单快捷方式
- 添加 `portable` 配置块：
  - 自定义portable版本的文件名格式：`${productName}-Portable-${version}.${ext}`

#### 修改文件：`.github/workflows/build-electron-windows.yml`
- 更新artifact名称从 `CircuitJS1-Windows-x64` 改为 `CircuitJS1-Electron-Windows-x64`
- electron-builder会自动生成portable版本（.exe文件）
- 工作流会自动上传所有.exe文件（包括NSIS安装器和Portable版本）

## 构建产物

### Tauri版本产物
执行工作流后，会生成以下文件：
1. **MSI安装器**: `CircuitJS1_0.0.1_x64_en-US.msi`
2. **NSIS安装器**: `CircuitJS1_0.0.1_x64-setup.exe`
3. **免安装版本**: `CircuitJS1-Portable.exe`

### Electron版本产物
执行工作流后，会生成以下文件：
1. **NSIS安装器**: `CircuitJS1 Setup 0.0.1.exe`
2. **免安装版本**: `CircuitJS1-Portable-0.0.1.exe`
3. **Blockmap文件**: `*.exe.blockmap`（用于增量更新）

## 使用说明

### 触发构建
两个工作流都配置为手动触发（`workflow_dispatch`）：
1. 进入GitHub仓库的 Actions 页面
2. 选择对应的工作流：
   - `Build Tauri Windows x64`
   - `Build Electron Windows x64`
3. 点击 "Run workflow" 按钮
4. 等待构建完成

### 下载构建产物
1. 构建完成后，在工作流运行页面的 "Artifacts" 部分下载
2. Tauri版本：`CircuitJS1-Tauri-Windows-x64.zip`
3. Electron版本：`CircuitJS1-Electron-Windows-x64.zip`

### 免安装版本使用
免安装版本（Portable）的特点：
- 无需安装，直接运行
- 所有配置和数据保存在程序所在目录
- 可以放在U盘等便携设备上使用
- 不会在系统中留下注册表项或文件

## 技术细节

### Tauri Portable实现
- Tauri本身不直接支持portable模式
- 通过复制编译好的可执行文件来创建便携版
- 添加portable.txt标记文件，方便应用识别是否为便携模式

### Electron Portable实现
- electron-builder内置支持portable目标
- 自动打包为单文件可执行程序
- 自动配置便携模式的数据存储

## 注意事项

1. **版本号**: 当前版本号为 `0.0.1`，需要时请在配置文件中更新
2. **签名**: 当前未配置代码签名，Windows可能会显示安全警告
3. **文件大小**: portable版本包含完整的运行时，文件较大
4. **更新机制**: portable版本不支持自动更新功能

## 兼容性

- **操作系统**: Windows 10/11（x64）
- **架构**: x86_64
- **最低系统版本**: Windows 10 1809或更高

## 后续优化建议

1. 添加代码签名以消除Windows安全警告
2. 添加Linux和macOS平台的portable版本支持
3. 考虑添加版本自动递增机制
4. 优化portable版本的文件大小
