# Tauri快速参考卡片

## 🚀 最快开始方式

### GitHub Actions自动构建（推荐）
```
1. 访问 GitHub → Actions
2. 选择 "Build Tauri Windows x64"
3. 点击 "Run workflow"
4. 等待 10-15分钟
5. 下载产物
```

### 本地构建
```bash
./gradlew compileGwt makeSite
./prepare-tauri.sh
cargo tauri build
```

## 📁 关键文件位置

| 文件/目录 | 用途 |
|-----------|------|
| `src-tauri/` | Tauri项目根目录 |
| `src-tauri/src/main.rs` | Rust后端代码 |
| `src-tauri/tauri.conf.json` | Tauri配置 |
| `prepare-tauri.sh` | 构建准备脚本 |
| `site-tauri/` | 构建输入目录（自动生成）|
| `src-tauri/target/release/bundle/` | 构建输出 |

## 🔧 常用命令

| 命令 | 说明 |
|------|------|
| `cargo tauri dev` | 开发模式（热重载）|
| `cargo tauri build` | 生产构建 |
| `cargo tauri info` | 查看环境信息 |
| `./test-tauri-setup.sh` | 验证设置 |
| `./prepare-tauri.sh` | 准备构建目录 |

## 📦 构建产物

### Windows
- `*.msi` - MSI安装包 (~15-25MB)
- `*.exe` - NSIS安装包 (~15-25MB)

### 位置
```
src-tauri/target/release/bundle/
├── msi/
│   └── CircuitJS1_0.0.1_x64_en-US.msi
└── nsis/
    └── CircuitJS1_0.0.1_x64-setup.exe
```

## 🛠️ 系统要求

### Windows
- Windows 10/11
- WebView2（预装）
- Visual Studio Build Tools（仅构建时）

### Linux
```bash
sudo apt install libwebkit2gtk-4.0-dev build-essential
```

### macOS
```bash
xcode-select --install
```

## 📝 配置文件

### tauri.conf.json
```json
{
  "package": {
    "productName": "CircuitJS1",
    "version": "0.0.1"
  },
  "tauri": {
    "bundle": {
      "identifier": "com.lushprojects.circuitjs1"
    }
  }
}
```

### Cargo.toml
```toml
[dependencies]
tauri = { version = "1.6", features = [...] }
serde = { version = "1.0", features = ["derive"] }
```

## 🔌 JavaScript API

```javascript
// 保存对话框
const result = await window.showSaveDialog();

// 保存文件
await window.saveFile(filePath, content);

// 打开文件
window.openFile((content, fileName) => {
  console.log('File opened:', fileName);
});

// 切换开发者工具
window.toggleDevTools();
```

## 🐛 故障排查

| 问题 | 解决方案 |
|------|----------|
| WebView2 not found | 安装: `winget install Microsoft.EdgeWebView2Runtime` |
| Rust not found | 安装: `winget install Rustlang.Rustup` |
| site-tauri不存在 | 运行: `./prepare-tauri.sh` |
| Java错误 | 确保Java 21+: `java -version` |

## 📚 文档链接

- [详细文档](./TAURI_BUILD_README.md)
- [快速入门](./TAURI_QUICKSTART.md)
- [变更日志](./TAURI_CHANGELOG.md)
- [实现总结](./TAURI_IMPLEMENTATION_SUMMARY.md)

## ⚡ 性能对比

| 指标 | Electron | Tauri |
|------|----------|-------|
| 安装包 | ~100MB | ~20MB |
| 内存 | ~250MB | ~75MB |
| 启动 | 2-3s | <1s |

## 🎯 最佳实践

1. **构建前清理**: `rm -rf site-tauri src-tauri/target`
2. **使用缓存**: GitHub Actions自动缓存Cargo
3. **开发模式**: 使用`cargo tauri dev`快速测试
4. **验证设置**: 构建前运行`./test-tauri-setup.sh`

## 🔐 安全特性

- ✅ API白名单
- ✅ Rust内存安全
- ✅ 无Node.js暴露
- ✅ IPC序列化
- ✅ CSP可配置

## 📞 支持

遇到问题？
1. 查看[故障排查](./TAURI_BUILD_README.md#常见问题)
2. 运行`cargo tauri info`检查环境
3. 在GitHub创建Issue

---

**提示**: 把这个页面加入书签，构建时随时参考！
