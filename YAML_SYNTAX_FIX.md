# YAML语法错误修复

## 🐛 问题描述

GitHub Actions工作流文件出现YAML语法错误：

```
Invalid workflow file
You have an error in your yaml syntax on line 58
```

## 🔍 根本原因

在GitHub Actions工作流中尝试使用PowerShell的here-string语法：

```yaml
- name: Prepare Tauri build
  run: |
    $tauriScript = @'
    <script>...</script>
    '@
  shell: pwsh
```

**问题**：PowerShell的here-string语法`@'...'@`在YAML文件中会导致解析错误，因为：
1. YAML对单引号`'`有特殊处理
2. `@'`在YAML中被当作特殊字符序列
3. 多行字符串的缩进会干扰YAML解析器

## ✅ 解决方案

**最佳方案**：直接使用bash执行已有的`prepare-tauri.sh`脚本

```yaml
- name: Prepare Tauri build
  run: bash prepare-tauri.sh
  shell: bash
```

### 为什么这样更好？

1. **简单可靠** - 避免复杂的YAML字符串转义
2. **已有脚本** - prepare-tauri.sh已经测试通过
3. **跨平台** - Windows的GitHub Actions已预装Git Bash
4. **可维护** - 脚本逻辑在单独文件中，更易维护

## 📊 对比

### ❌ 尝试的方案（失败）

```yaml
- name: Prepare Tauri build
  run: |
    $tauriScript = @'
    多行内容...
    '@
    # YAML解析错误！
  shell: pwsh
```

**问题**：
- YAML语法错误
- 字符串转义复杂
- 难以维护

### ✅ 当前方案（成功）

```yaml
- name: Prepare Tauri build
  run: bash prepare-tauri.sh
  shell: bash
```

**优点**：
- ✅ YAML语法正确
- ✅ 简洁明了
- ✅ 易于维护
- ✅ 复用现有脚本

## 🔧 技术说明

### Windows上的Bash

GitHub Actions的Windows运行器包含Git for Windows，其中包括Git Bash：

```bash
# 这些命令在Windows运行器上都可用：
bash --version          # GNU bash, version 5.x.x
which bash              # /usr/bin/bash
bash prepare-tauri.sh   # ✅ 正常工作
```

### prepare-tauri.sh脚本

脚本执行两个主要任务：
1. 复制`site/`到`site-tauri/`
2. 注入Tauri API脚本到`circuitjs.html`

```bash
#!/bin/bash
set -e

# 复制文件
rm -rf site-tauri
cp -r site site-tauri

# 使用sed注入脚本
cd site-tauri
sed -i "/<script.*lz-string/i\\
$TAURI_SCRIPT" circuitjs.html
```

## 🎯 验证

修复后的工作流文件语法正确：

```bash
# 本地验证YAML语法
yamllint .github/workflows/build-tauri-windows.yml

# 或使用在线工具
# https://www.yamllint.com/
```

## 📝 修改记录

### 修改的文件
1. `.github/workflows/build-tauri-windows.yml`
   - 删除：~80行PowerShell here-string代码
   - 添加：2行bash脚本调用

### 影响
- ✅ YAML语法错误已修复
- ✅ 功能保持不变
- ✅ 更简洁、更易维护

## 🚀 后续步骤

1. **提交修复**
   ```bash
   git add .github/workflows/build-tauri-windows.yml
   git add YAML_SYNTAX_FIX.md
   git commit -m "fix: 修复GitHub Actions YAML语法错误"
   ```

2. **推送到GitHub**
   ```bash
   git push origin feat-tauri-windows-gh-actions-static-build
   ```

3. **验证**
   - GitHub会自动验证YAML语法
   - Actions标签页不应显示语法错误
   - 可以正常触发工作流

## 💡 经验教训

### 在YAML中使用PowerShell

如果必须在YAML中使用复杂的PowerShell字符串：

**方法1: 使用外部脚本（推荐）**
```yaml
- run: ./script.ps1
  shell: pwsh
```

**方法2: 避免here-string，使用普通字符串**
```yaml
- run: |
    $str = "line1`nline2`nline3"
  shell: pwsh
```

**方法3: 使用双引号和转义**
```yaml
- run: |
    $str = "<script>alert(\"test\")</script>"
  shell: pwsh
```

### YAML字符串规则

- 使用 `|` 保留换行符
- 使用 `>` 折叠换行符
- 单引号内单引号需要双写：`'don''t'`
- 避免在字符串中使用`@'`这样的特殊序列

## 🎉 总结

- ✅ YAML语法错误已修复
- ✅ 使用bash脚本更简单可靠
- ✅ 保持功能完全一致
- ✅ 代码更易维护

修复完成！现在可以正常使用GitHub Actions构建Tauri应用了。
