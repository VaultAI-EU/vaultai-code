#!/bin/bash

# VaultCode Windows Build Script
# Usage: ./scripts/build-windows.sh

set -e  # Exit on error

echo "🪟 Starting VaultCode build process for Windows..."

# Clean previous builds
echo "🧹 Cleaning previous Windows builds..."
rm -rf ../VSCode-win32-* .build/win32-*

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

echo "🪟 Building Windows packages..."

# Windows builds (x64 is most common)
echo "📱 Building Windows x64 package..."
npm run gulp vscode-win32-x64-min

# Create Windows installer
echo "💿 Creating Windows x64 installer..."
npm run gulp vscode-win32-x64-system-setup

# Create distribution folder
echo "📦 Creating distribution files..."
mkdir -p dist/

# Copy Windows setup file
cp .build/win32-x64/system-setup/*.exe dist/VaultCode-Windows-x64-Setup.exe 2>/dev/null || echo "⚠️  Windows x64 setup not found"

# Create Windows portable zip
echo "📦 Creating Windows portable version..."
if [ -d "../VSCode-win32-x64" ]; then
    cd ../VSCode-win32-x64/ && zip -r ../vaultai-code/dist/VaultCode-Windows-x64-Portable.zip *
    cd ../vaultai-code/
else
    echo "⚠️  Windows portable build not found"
fi

echo "✅ Windows build complete!"
echo ""
echo "📋 Files créés pour Windows :"
if [ -f "dist/VaultCode-Windows-x64-Setup.exe" ]; then
    echo "✅ dist/VaultCode-Windows-x64-Setup.exe (Installateur Windows)"
fi
if [ -f "dist/VaultCode-Windows-x64-Portable.zip" ]; then
    echo "✅ dist/VaultCode-Windows-x64-Portable.zip (Version portable)"
fi

echo ""
echo "🚀 Pour ton collègue :"
echo "1. Envoie-lui le fichier VaultCode-Windows-x64-Setup.exe pour une installation normale"
echo "2. Ou envoie-lui le fichier .zip s'il préfère une version portable"
echo ""

ls -la dist/ 2>/dev/null || echo "Aucun fichier dans dist/"
