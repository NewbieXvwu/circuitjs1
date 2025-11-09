# GitHub Actions 缓存问题修复

## 问题描述

GitHub Actions 构建日志显示缓存无法找到：
```
Cache not found for input keys: Windows-cargo-, Windows-cargo-
Cache not found for input keys: Windows-tauri-cli-1.5.11
```

## 根本原因

1. **Cargo.lock 文件缺失**
   - 原来的缓存配置使用 `hashFiles('**/Cargo.lock')` 作为 key
   - 但仓库中没有 Cargo.lock 文件
   - 导致 hash 为空，缓存 key 变成 `Windows-cargo-`（末尾没有 hash 值）

2. **缓存 key 不稳定**
   - 没有 Cargo.lock 时，缓存 key 每次都相同但无法有效标识依赖版本
   - 这会导致即使依赖更新了，也可能使用旧的缓存

## 修复方案

### 1. 生成 Cargo.lock 文件

在缓存步骤之前添加一个步骤来生成 Cargo.lock：

```yaml
- name: Generate Cargo.lock
  run: |
    cd src-tauri
    cargo generate-lockfile
  shell: pwsh
```

**优点：**
- 确保 Cargo.lock 文件存在
- 可以为缓存 key 生成稳定的 hash 值
- 符合 Rust 应用程序的最佳实践

### 2. 改进 Rust 依赖缓存

```yaml
- name: Cache Rust dependencies
  uses: actions/cache@v4
  with:
    path: |
      ~/.cargo/registry/index/
      ~/.cargo/registry/cache/
      ~/.cargo/git/db/
      src-tauri/target/
    key: ${{ runner.os }}-cargo-${{ hashFiles('src-tauri/Cargo.lock') }}
    restore-keys: |
      ${{ runner.os }}-cargo-
```

**改进：**
- 使用 Cargo.lock 的 hash 作为精确的缓存 key
- 保留 restore-keys 作为降级方案
- 使用标准的 Unix 风格路径（GitHub Actions 会自动处理）

### 3. 改进 Tauri CLI 缓存

```yaml
- name: Cache Tauri CLI
  id: cache-tauri-cli
  uses: actions/cache@v4
  with:
    path: ~/.cargo/bin/cargo-tauri.exe
    key: ${{ runner.os }}-tauri-cli-1.5.11
    restore-keys: |
      ${{ runner.os }}-tauri-cli-
```

**改进：**
- 指定完整的可执行文件路径（Windows 上是 .exe）
- 添加 restore-keys 以支持版本升级时的降级缓存
- 使用固定版本号作为 key 的一部分

## 缓存工作流程

1. **首次构建：**
   - 生成 Cargo.lock
   - 缓存未命中（"Cache not found" 是正常的）
   - 下载并编译所有依赖
   - 构建结束时保存缓存

2. **后续构建（依赖未变）：**
   - 生成 Cargo.lock（内容相同）
   - 缓存命中（hash 匹配）
   - 跳过下载和编译
   - 构建速度大幅提升

3. **后续构建（依赖更新）：**
   - 生成新的 Cargo.lock（内容不同）
   - 缓存未命中（hash 不匹配）
   - 但会尝试使用 restore-keys 恢复部分缓存
   - 只重新编译变化的部分

## 预期效果

### 首次构建
- ❌ 缓存未命中（正常）
- ⏱️ 完整编译时间：~10-15 分钟

### 后续构建（无更改）
- ✅ 缓存命中
- ⏱️ 构建时间：~2-3 分钟（节省 70-80%）

### 后续构建（依赖更新）
- ⚠️ 部分缓存命中（通过 restore-keys）
- ⏱️ 构建时间：~5-7 分钟（节省 40-50%）

## 额外优化建议

### 1. 提交 Cargo.lock 到仓库

对于应用程序项目（非库），应该将 Cargo.lock 提交到 Git：

**优点：**
- 确保所有构建使用相同的依赖版本
- 缓存 key 在不同运行之间保持稳定
- 避免每次都要生成 Cargo.lock
- 符合 Rust 最佳实践

**操作：**
```bash
cd src-tauri
cargo generate-lockfile
git add Cargo.lock
git commit -m "Add Cargo.lock for reproducible builds"
```

### 2. 使用 Swatinem/rust-cache action（可选）

可以考虑使用专门的 Rust 缓存 action：

```yaml
- uses: Swatinem/rust-cache@v2
  with:
    workspaces: src-tauri
```

这个 action 会自动处理：
- 智能的缓存键生成
- 增量缓存（只缓存必要的内容）
- 自动清理旧缓存

## 验证方法

查看 GitHub Actions 日志中的缓存步骤：

**成功的缓存保存：**
```
Post job cleanup.
Post Cache Rust dependencies
Cache saved with key: Windows-cargo-abc123...
```

**成功的缓存恢复：**
```
Run actions/cache@v4
Cache restored from key: Windows-cargo-abc123...
```

## 注意事项

1. **第一次运行看到 "Cache not found" 是正常的**
   - 这只是表示还没有缓存可用
   - 不是错误，而是信息性消息

2. **缓存大小限制**
   - GitHub Actions 单个缓存最大 10 GB
   - Rust 编译缓存通常在 1-3 GB
   - 应该不会超过限制

3. **缓存过期**
   - 7 天未使用的缓存会被自动删除
   - 确保定期运行构建以保持缓存有效
