# GitHub Actions Workflows

本目录包含CircuitJS1项目的自动化工作流。

## 可用工作流

### 1. Build Tauri Windows x64
**文件**: `build-tauri-windows.yml`

**用途**: 自动构建Windows x64桌面应用（使用Tauri）

**触发方式**:
- 手动触发（workflow_dispatch）
- 推送到`feat-tauri-windows-gh-actions-static-build`分支

**构建步骤**:
1. 检出代码
2. 设置Java 21（用于GWT编译）
3. 编译GWT项目
4. 准备Tauri构建环境
5. 设置Rust工具链
6. 生成应用图标
7. 构建Tauri应用
8. 上传构建产物

**产物**:
- MSI安装包 (~15-25MB)
- NSIS安装包 (~15-25MB)

**构建时间**: 约10-15分钟

**查看文档**: [TAURI_QUICKSTART.md](../TAURI_QUICKSTART.md)

### 2. Build Electron Windows (Legacy)
**文件**: `build-electron-windows.yml`

**用途**: 构建Windows x64桌面应用（使用Electron，旧版本）

**触发方式**: 手动触发

**产物**: 
- NSIS安装包 (~100-150MB)

**注意**: Electron版本已被Tauri取代，建议使用Tauri版本。

## 如何使用

### 方法1: GitHub网页界面

1. 访问仓库的GitHub页面
2. 点击顶部的 **Actions** 标签
3. 在左侧选择要运行的工作流
4. 点击 **Run workflow** 按钮
5. 选择分支（通常是主分支或功能分支）
6. 点击绿色的 **Run workflow** 按钮确认
7. 等待工作流完成
8. 在完成的工作流页面下载 **Artifacts**

### 方法2: 推送代码触发

对于配置了push触发器的工作流（如Tauri），推送到指定分支会自动触发：

```bash
git push origin feat-tauri-windows-gh-actions-static-build
```

## 查看构建状态

### 实时查看
1. 在Actions标签中点击正在运行的工作流
2. 点击构建任务（如"build"）
3. 展开各个步骤查看实时日志

### 构建徽章
可以在README中添加状态徽章：

```markdown
![Build Status](https://github.com/your-username/circuitjs1/workflows/Build%20Tauri%20Windows%20x64/badge.svg)
```

## 下载构建产物

### 从GitHub Actions下载
1. 访问完成的工作流运行
2. 滚动到页面底部的 **Artifacts** 部分
3. 点击产物名称（如 `CircuitJS1-Tauri-Windows-x64`）下载
4. 解压ZIP文件获取安装包

### 产物保留期
GitHub Actions产物默认保留90天。

## 本地测试工作流

使用[act](https://github.com/nektos/act)可以在本地测试GitHub Actions：

```bash
# 安装act
# Windows: choco install act-cli
# macOS: brew install act
# Linux: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# 运行工作流
act workflow_dispatch -W .github/workflows/build-tauri-windows.yml
```

**注意**: Windows工作流在非Windows主机上可能无法完全运行。

## 工作流配置

### 运行环境
- **Tauri**: `runs-on: windows-latest`
- **Electron**: `runs-on: windows-latest`

### 缓存
Tauri工作流使用缓存加速构建：
- Cargo registry
- Cargo git
- 构建目标目录

### 密钥和环境变量
当前工作流不需要特殊的密钥或环境变量。

如需代码签名，可添加：
```yaml
env:
  SIGNING_CERTIFICATE: ${{ secrets.WINDOWS_SIGNING_CERT }}
  SIGNING_PASSWORD: ${{ secrets.WINDOWS_SIGNING_PASSWORD }}
```

## 故障排查

### 常见问题

**1. GWT编译失败**
- 检查Java版本是否为21
- 检查Gradle配置
- 查看完整日志

**2. Tauri构建失败**
- 检查Rust工具链是否正确安装
- 检查site-tauri目录是否正确生成
- 验证tauri.conf.json配置

**3. 图标生成失败**
- 检查ImageMagick是否正确安装
- 验证源图标文件是否存在

**4. 产物上传失败**
- 检查构建产物路径是否正确
- 确认文件确实被生成

### 查看详细日志

在工作流YAML中添加调试输出：
```yaml
- name: Debug step
  run: |
    echo "Current directory: $(pwd)"
    ls -la
    echo "Environment variables:"
    env | sort
```

## 自定义工作流

### 添加新目标平台

要添加Linux构建：
```yaml
build-linux:
  runs-on: ubuntu-latest
  steps:
    # ... 类似步骤，但使用Linux特定命令
```

要添加macOS构建：
```yaml
build-macos:
  runs-on: macos-latest
  steps:
    # ... 类似步骤，但使用macOS特定命令
```

### 添加代码签名

在构建步骤前添加：
```yaml
- name: Import certificate
  run: |
    # 导入代码签名证书
    # Windows: signtool
    # macOS: codesign
```

### 添加自动发布

在上传产物后添加：
```yaml
- name: Create Release
  uses: softprops/action-gh-release@v1
  if: startsWith(github.ref, 'refs/tags/')
  with:
    files: |
      src-tauri/target/release/bundle/msi/*.msi
      src-tauri/target/release/bundle/nsis/*.exe
```

## 相关文档

- [GitHub Actions文档](https://docs.github.com/en/actions)
- [Tauri CI配置](https://tauri.app/v1/guides/building/cross-platform)
- [CircuitJS1 Tauri指南](../TAURI_BUILD_README.md)

## 贡献

改进工作流的建议欢迎通过Pull Request提交。

---

最后更新: 2024-11
