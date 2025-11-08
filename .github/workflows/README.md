# GitHub Actions Workflows

此目录包含用于自动化构建和部署的 GitHub Actions 工作流。

## Build Electron Windows x64

**文件**: `build-electron-windows.yml`

**触发方式**: 手动触发（workflow_dispatch）

**功能**: 自动编译 CircuitJS1 项目并打包为 Windows x64 版本的 Electron 应用程序。

**使用方法**:
1. 在 GitHub 仓库中，点击顶部的 "Actions" 标签
2. 在左侧工作流列表中选择 "Build Electron Windows x64"
3. 点击右侧的 "Run workflow" 按钮
4. 选择要运行的分支（默认为主分支）
5. 点击绿色的 "Run workflow" 按钮确认
6. 等待工作流完成（大约需要 10-20 分钟）
7. 完成后，在工作流运行详情页面的 "Artifacts" 部分下载编译产物

**构建产物**:
- Windows 安装程序 (`.exe` 文件)
- 安装程序的校验文件 (`.exe.blockmap`)

**技术细节**:
- 使用 Java 11 (Amazon Corretto)
- 使用 Gradle 编译 GWT 项目
- 使用 Node.js 20 和 electron-builder 打包
- 目标平台: Windows x64
- 安装程序格式: NSIS

**配置**:
Electron 应用的配置位于 `app/package.json` 的 `build` 字段中。
