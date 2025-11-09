# Tauri Desktop Application - Changelog

## 2024-11 - Initial Tauri Implementation

### Added

#### Tauri Project Structure
- Created `src-tauri/` directory with complete Tauri project structure
- `src-tauri/Cargo.toml` - Rust dependencies (tauri 1.6, serde, serde_json)
- `src-tauri/build.rs` - Tauri build script
- `src-tauri/src/main.rs` - Rust backend with file dialog and I/O commands
- `src-tauri/tauri.conf.json` - Tauri configuration
- `src-tauri/icons/` - Application icons

#### Build Scripts
- `prepare-tauri.sh` - Script to prepare site-tauri directory and inject Tauri API
- Copies `site/` to `site-tauri/`
- Injects Tauri JavaScript API into `circuitjs.html`

#### GitHub Actions
- `.github/workflows/build-tauri-windows.yml` - Automated Windows x64 build
- Compiles GWT project
- Prepares Tauri build environment
- Generates application icons (ICO and ICNS)
- Builds MSI and NSIS installers
- Uploads artifacts automatically

#### Documentation
- `TAURI_BUILD_README.md` - Comprehensive build guide
- `TAURI_QUICKSTART.md` - Quick start guide
- `TAURI_CHANGELOG.md` - This file
- Updated main `README.md` with Tauri section

#### Testing
- `test-tauri-setup.sh` - Verification script for Tauri setup

### Features

#### Desktop Application Features
- Native file dialogs for opening and saving circuits
- File I/O operations through Rust backend
- All web assets statically bundled
- Command-line argument support for opening files
- Developer tools toggle (dev mode only)

#### API Compatibility
JavaScript API maintains compatibility with existing CircuitJS1 code:
- `window.showSaveDialog()` - Show save file dialog
- `window.saveFile(file, text)` - Save file
- `window.openFile(callback)` - Open file
- `window.toggleDevTools()` - Toggle developer tools

#### Build Outputs
**Windows:**
- MSI installer (~15-25MB)
- NSIS installer (~15-25MB)

**Linux (not yet in CI):**
- DEB package
- AppImage

**macOS (not yet in CI):**
- DMG installer
- .app bundle

### Benefits over Electron

| Metric | Electron | Tauri |
|--------|----------|-------|
| Installer Size | ~100-150MB | ~15-25MB |
| Memory Usage | ~200-300MB | ~50-100MB |
| Startup Time | 2-3 seconds | <1 second |
| Backend | Node.js | Rust |
| Frontend | Chromium | System WebView |

### Configuration

#### Tauri Backend
- Rust commands for file operations
- Async I/O operations
- Error handling with Result types
- File dialog filtering (.txt files)

#### Bundle Configuration
- App identifier: `com.lushprojects.circuitjs1`
- Product name: `CircuitJS1`
- Version: `0.0.1`
- Category: Education
- Window size: 1024x768 (resizable)

### Build Process

1. **GWT Compilation**: `./gradlew compileGwt makeSite`
2. **Tauri Preparation**: `./prepare-tauri.sh`
3. **Tauri Build**: `cargo tauri build`

### CI/CD

GitHub Actions workflow runs on:
- Manual trigger (`workflow_dispatch`)
- Push to `feat-tauri-windows-gh-actions-static-build` branch

Build time: ~10-15 minutes

### Next Steps

Future improvements could include:
- [ ] macOS build in GitHub Actions
- [ ] Linux build in GitHub Actions
- [ ] Code signing for installers
- [ ] Auto-update functionality
- [ ] Custom protocol handler (circuitjs://)
- [ ] Recent files menu
- [ ] Drag-and-drop file opening
- [ ] Multi-window support
- [ ] Custom window controls

### Dependencies

**Runtime:**
- Windows: WebView2 (pre-installed on Windows 10/11)
- Linux: WebKit2GTK
- macOS: WebKit (system)

**Build:**
- Rust 1.70+
- Java 21+ (for GWT)
- Tauri CLI 1.5+
- System build tools (Visual Studio Build Tools on Windows)

### Security

Tauri's security features:
- CSP (Content Security Policy) configurable
- API allowlist (only enabled: dialog, window, shell.open)
- Rust backend with memory safety
- No Node.js runtime in production
- IPC through serialized JSON only

### Known Limitations

1. Icon generation in CI requires ImageMagick (installed via chocolatey)
2. ICNS generation on Windows creates placeholder (macOS-only iconutil)
3. Dev tools only available in debug builds
4. Service Worker registration may not work in Tauri (uses custom protocol)

### Testing

All Tauri setup files verified by `test-tauri-setup.sh`:
- ✓ Project structure
- ✓ Configuration files
- ✓ Icon files
- ✓ GitHub Actions workflow
- ✓ Documentation
- ✓ Cargo dependencies
- ✓ Tauri configuration

---

## Version History

### v0.0.1 (2024-11)
- Initial Tauri implementation
- Windows x64 automated builds
- Complete documentation
- GitHub Actions integration
