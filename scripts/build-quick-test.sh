#!/bin/bash

# VaultCode Quick Test Build - Build only for current platform (macOS ARM64)
# Usage: ./scripts/build-quick-test.sh

set -e  # Exit on error

echo "🚀 Starting VaultCode quick test build for macOS ARM64..."

# Kill any running Electron processes
echo "⚡ Stopping Electron processes..."
pkill -f "Electron" || true

# Clean caches according to VaultCode procedure
echo "🗑️ Cleaning React and build caches..."
rm -rf src/vs/workbench/contrib/void/browser/react/src2
rm -rf src/vs/workbench/contrib/void/browser/react/out
rm -rf out/vs

# Build React components
echo "⚙️ Building React components..."
npm run buildreact

# Compile client
echo "📦 Compiling client..."
npm run gulp compile-client

# Build production version with mangling
echo "🔧 Building optimized production version..."
npm run gulp compile-build-with-mangling

# Build for current platform (macOS ARM64)
echo "🍎 Building macOS ARM64 package..."
npm run gulp vscode-darwin-arm64-min

# Create archive for testing
echo "📦 Creating test archive..."
mkdir -p dist-test/
cd ../VSCode-darwin-arm64/ && tar -czf ../vaultai-code/dist-test/VaultCode-macOS-arm64-test.tar.gz VaultCode.app
cd ../vaultai-code/

echo "✅ Quick test build complete!"
echo "📁 Test build available at: dist-test/VaultCode-macOS-arm64-test.tar.gz"
echo ""
echo "🧪 To test:"
echo "1. cd dist-test/"
echo "2. tar -xzf VaultCode-macOS-arm64-test.tar.gz"
echo "3. open VaultCode.app"
