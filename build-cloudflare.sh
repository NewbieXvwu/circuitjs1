#!/bin/bash
# Cloudflare Pages 自动构建脚本 for CircuitJS1
# 此脚本会自动安装 Java、GWT 并编译项目

set -e  # 遇到错误立即退出

echo "================================================"
echo "CircuitJS1 - Cloudflare Pages 自动构建"
echo "Material You (MD3) 版本"
echo "================================================"

# 设置构建目录
BUILD_HOME=${CF_PAGES_BUILD_DIR:-$(pwd)}
echo "构建目录: $BUILD_HOME"

# 检测系统架构
ARCH=$(uname -m)
echo "系统架构: $ARCH"
echo ""

# 1. 安装 Java JDK
echo "步骤 1/3: 安装 Java JDK..."
echo "----------------------------------------"

if [ ! -d "$HOME/jdk" ]; then
    mkdir -p $HOME/jdk
    cd $HOME/jdk
    
    if [ "$ARCH" = "x86_64" ]; then
        echo "下载 Amazon Corretto JDK 11 (x86_64)..."
        curl -L -o corretto.tar.gz "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
    elif [ "$ARCH" = "aarch64" ]; then
        echo "下载 Amazon Corretto JDK 11 (aarch64)..."
        curl -L -o corretto.tar.gz "https://corretto.aws/downloads/latest/amazon-corretto-11-aarch64-linux-jdk.tar.gz"
    else
        echo "警告: 不支持的架构 $ARCH，尝试使用 x86_64 版本..."
        curl -L -o corretto.tar.gz "https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz"
    fi
    
    echo "解压 JDK..."
    tar -xzf corretto.tar.gz --strip-components=1
    rm -f corretto.tar.gz
    
    echo "✓ JDK 安装完成"
else
    echo "✓ JDK 已存在，跳过安装"
fi

export JAVA_HOME=$HOME/jdk
export PATH=$JAVA_HOME/bin:$PATH

echo "Java 版本:"
java -version 2>&1 | head -n 1
echo ""

# 2. 下载 GWT SDK
echo "步骤 2/3: 下载 GWT SDK..."
echo "----------------------------------------"

if [ ! -d "$HOME/gwt" ]; then
    mkdir -p $HOME/gwt
    cd $HOME/gwt
    
    GWT_VERSION="2.10.0"
    echo "下载 GWT SDK $GWT_VERSION..."
    curl -fL --retry 3 --retry-delay 2 -o gwt.zip "https://github.com/gwtproject/gwt/releases/download/${GWT_VERSION}/gwt-${GWT_VERSION}.zip"
    
    # 验证下载的文件是否为有效的 ZIP 文件
    if ! file gwt.zip | grep -q "Zip archive"; then
        echo "错误: 下载的 GWT SDK 文件不是有效的 ZIP 压缩包"
        echo "文件类型: $(file gwt.zip)"
        rm -f gwt.zip
        exit 1
    fi
    
    echo "解压 GWT SDK..."
    unzip -q gwt.zip
    GWT_DIR=$(find . -maxdepth 1 -type d -name "gwt-*" | head -n 1)
    if [ -n "$GWT_DIR" ]; then
        mv $GWT_DIR/* ./
        rm -rf $GWT_DIR
    fi
    rm -f gwt.zip
    
    echo "✓ GWT SDK 安装完成"
else
    echo "✓ GWT SDK 已存在，跳过安装"
fi

export GWT_SDK=$HOME/gwt
echo "GWT SDK 路径: $GWT_SDK"
echo ""

# 3. 编译项目
echo "步骤 3/3: 编译 CircuitJS1 项目..."
echo "----------------------------------------"

cd $BUILD_HOME
echo "当前目录: $(pwd)"
echo ""

# 检查必要文件
if [ ! -f "src/com/lushprojects/circuitjs1/circuitjs1.gwt.xml" ]; then
    echo "错误: 未找到 GWT 模块配置文件"
    exit 1
fi

# 创建编译输出目录
mkdir -p war/WEB-INF/classes

# 设置类路径
CLASSPATH="src"
CLASSPATH="$CLASSPATH:$GWT_SDK/gwt-user.jar"
CLASSPATH="$CLASSPATH:$GWT_SDK/gwt-dev.jar"
CLASSPATH="$CLASSPATH:$GWT_SDK/validation-api-1.0.0.GA.jar"
CLASSPATH="$CLASSPATH:$GWT_SDK/validation-api-1.0.0.GA-sources.jar"

echo "编译 Java 源代码..."
find src -name "*.java" -print0 | xargs -0 javac -encoding UTF-8 -d war/WEB-INF/classes -cp "$CLASSPATH"

echo ""
echo "运行 GWT 编译器 (生产模式，优化体积)..."
echo "这可能需要 5-10 分钟，请耐心等待..."
echo ""

# 使用生产编译模式以减小体积
java -Xmx1024M -cp "$CLASSPATH:war/WEB-INF/classes" \
    com.google.gwt.dev.Compiler \
    -war war \
    -style OBF \
    -optimize 9 \
    -localWorkers 2 \
    com.lushprojects.circuitjs1.circuitjs1

COMPILE_EXIT_CODE=$?

if [ $COMPILE_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "✅ 构建成功完成！"
    echo "================================================"
    echo ""
    echo "构建产物位于 war/ 目录:"
    ls -lh war/ | grep -v "^d" | head -n 15
    echo ""
    
    # 检查编译输出
    if [ -d "war/circuitjs1" ]; then
        echo "✓ GWT 编译输出: war/circuitjs1/"
        echo "  文件数量: $(find war/circuitjs1 -type f | wc -l)"
    fi
    
    echo ""
    echo "Material You (MD3) UI 已应用"
    echo "准备部署到 Cloudflare Pages..."
else
    echo ""
    echo "❌ 编译失败，退出代码: $COMPILE_EXIT_CODE"
    echo "请检查上方的错误信息"
    exit $COMPILE_EXIT_CODE
fi
