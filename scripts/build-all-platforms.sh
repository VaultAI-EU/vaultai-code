#!/bin/bash

# VaultCode Build Script - Builds for all platforms
# Usage: ./scripts/build-all-platforms.sh

set -e  # Exit on error

echo "🚀 Starting VaultCode build process for all platforms..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf ../VSCode-* .build/

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

# Wait for build-with-mangling to complete if running
echo "⏳ Waiting for production build to complete..."
wait

# Build production version with mangling
echo "🔧 Building optimized production version..."
npm run gulp compile-build-with-mangling

echo "📱 Building platform packages..."

# macOS builds
echo "🍎 Building macOS packages..."
npm run gulp vscode-darwin-arm64-min
npm run gulp vscode-darwin-x64-min

# Windows builds
echo "🪟 Building Windows packages..."
npm run gulp vscode-win32-x64-min
npm run gulp vscode-win32-arm64-min

# Create Windows installers
echo "💿 Creating Windows installers..."
npm run gulp vscode-win32-x64-system-setup
npm run gulp vscode-win32-x64-user-setup
npm run gulp vscode-win32-arm64-system-setup
npm run gulp vscode-win32-arm64-user-setup

# Linux builds
echo "🐧 Building Linux packages..."
npm run gulp vscode-linux-x64-min
npm run gulp vscode-linux-arm64-min

# Create archives for distribution
echo "📦 Creating distribution archives..."
mkdir -p dist/

# macOS
cd ../VSCode-darwin-arm64/ && tar -czf ../vaultai-code/dist/VaultCode-macOS-arm64.tar.gz VaultCode.app
cd ../VSCode-darwin-x64/ && tar -czf ../vaultai-code/dist/VaultCode-macOS-x64.tar.gz VaultCode.app

# Windows (copy setup files)
cd ../vaultai-code/
cp .build/win32-x64/system-setup/*.exe dist/VaultCode-Windows-x64-Setup.exe 2>/dev/null || echo "Windows x64 setup not found"
cp .build/win32-arm64/system-setup/*.exe dist/VaultCode-Windows-arm64-Setup.exe 2>/dev/null || echo "Windows arm64 setup not found"

# Windows portable
cd ../VSCode-win32-x64/ && zip -r ../vaultai-code/dist/VaultCode-Windows-x64-Portable.zip *
cd ../VSCode-win32-arm64/ && zip -r ../vaultai-code/dist/VaultCode-Windows-arm64-Portable.zip *

# Linux
cd ../VSCode-linux-x64/ && tar -czf ../vaultai-code/dist/VaultCode-Linux-x64.tar.gz *
cd ../VSCode-linux-arm64/ && tar -czf ../vaultai-code/dist/VaultCode-Linux-arm64.tar.gz *

cd ../vaultai-code/

echo "✅ Build complete! Distribution files available in dist/ folder:"
ls -la dist/

echo ""
echo "📋 Next steps:"
echo "1. Test the builds on target platforms"
echo "2. (Optional) Sign the applications for better security"
echo "3. Upload dist/ files to your web server"
echo "4. Create download pages on your website"

echo ""
echo "🌐 Suggested download page structure:"
echo "- VaultCode-macOS-arm64.tar.gz (Apple Silicon Macs)"
echo "- VaultCode-macOS-x64.tar.gz (Intel Macs)"
echo "- VaultCode-Windows-x64-Setup.exe (Windows 64-bit Installer)"
echo "- VaultCode-Windows-x64-Portable.zip (Windows 64-bit Portable)"
echo "- VaultCode-Windows-arm64-Setup.exe (Windows ARM64 Installer)"
echo "- VaultCode-Linux-x64.tar.gz (Linux 64-bit)"
echo "- VaultCode-Linux-arm64.tar.gz (Linux ARM64)"
