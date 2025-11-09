#!/bin/bash
# Test script to verify Tauri setup

set -e

echo "========================================"
echo "Tauri Setup Verification"
echo "========================================"
echo ""

# Check if src-tauri directory exists
if [ -d "src-tauri" ]; then
    echo "✓ src-tauri directory exists"
else
    echo "✗ src-tauri directory not found"
    exit 1
fi

# Check for required Tauri files
REQUIRED_FILES=(
    "src-tauri/Cargo.toml"
    "src-tauri/build.rs"
    "src-tauri/src/main.rs"
    "src-tauri/tauri.conf.json"
    "prepare-tauri.sh"
)

echo ""
echo "Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file not found"
        exit 1
    fi
done

# Check for icon files
echo ""
echo "Checking icon files..."
ICON_FILES=(
    "src-tauri/icons/32x32.png"
    "src-tauri/icons/128x128.png"
    "src-tauri/icons/128x128@2x.png"
    "src-tauri/icons/icon.png"
)

for file in "${ICON_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file not found"
        exit 1
    fi
done

# Check GitHub Actions workflow
echo ""
echo "Checking GitHub Actions workflow..."
if [ -f ".github/workflows/build-tauri-windows.yml" ]; then
    echo "✓ .github/workflows/build-tauri-windows.yml"
else
    echo "✗ GitHub Actions workflow not found"
    exit 1
fi

# Check documentation
echo ""
echo "Checking documentation..."
DOC_FILES=(
    "TAURI_BUILD_README.md"
    "TAURI_QUICKSTART.md"
)

for file in "${DOC_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file not found"
        exit 1
    fi
done

# Verify Cargo.toml dependencies
echo ""
echo "Checking Cargo.toml dependencies..."
if grep -q "tauri.*1.6" src-tauri/Cargo.toml; then
    echo "✓ Tauri dependency found"
else
    echo "✗ Tauri dependency not found"
    exit 1
fi

if grep -q "serde" src-tauri/Cargo.toml; then
    echo "✓ Serde dependency found"
else
    echo "✗ Serde dependency not found"
    exit 1
fi

# Verify tauri.conf.json structure
echo ""
echo "Checking tauri.conf.json structure..."
if grep -q "distDir.*site-tauri" src-tauri/tauri.conf.json; then
    echo "✓ distDir configured correctly"
else
    echo "✗ distDir not configured"
    exit 1
fi

if grep -q "com.lushprojects.circuitjs1" src-tauri/tauri.conf.json; then
    echo "✓ App identifier configured"
else
    echo "✗ App identifier not configured"
    exit 1
fi

echo ""
echo "========================================"
echo "✓ All checks passed!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Run: ./gradlew compileGwt makeSite"
echo "2. Run: ./prepare-tauri.sh"
echo "3. Run: cargo tauri build"
echo ""
echo "Or use GitHub Actions for automated builds:"
echo "Go to Actions > Build Tauri Windows x64 > Run workflow"
echo ""
