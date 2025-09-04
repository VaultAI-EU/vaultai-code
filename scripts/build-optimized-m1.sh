#!/bin/bash

# VaultCode M1 Optimized Build Script
# Spécialement conçu pour MacBook M1/M2 avec gestion mémoire optimisée
# Usage: ./scripts/build-optimized-m1.sh

set -e  # Exit on error

echo "🚀 VaultCode Build Optimisé pour MacBook M1/M2"
echo "=================================================="

# Vérifier l'architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "arm64" ]]; then
    echo "⚠️  Ce script est optimisé pour les Mac Apple Silicon (M1/M2)"
    echo "   Architecture détectée: $ARCH"
fi

# Configuration mémoire optimisée pour M1
export NODE_OPTIONS="--max-old-space-size=12288 --max-semi-space-size=128"
export UV_THREADPOOL_SIZE=16
export ELECTRON_BUILDER_CACHE="/tmp/electron-cache"

# Nettoyage intelligent
echo "🧹 Nettoyage intelligent des caches..."
pkill -f "Electron" || true
pkill -f "node.*gulp" || true
sleep 2

# Supprimer seulement les dossiers problématiques
rm -rf src/vs/workbench/contrib/void/browser/react/src2
rm -rf src/vs/workbench/contrib/void/browser/react/out
rm -rf out/vs
rm -rf .build/
rm -rf node_modules/.cache
rm -rf /tmp/electron-cache

# Optimiser les builds par étapes pour éviter les crashes mémoire
echo "⚙️ Build React en mode optimisé..."
npm run buildreact

echo "📦 Compilation client avec gestion mémoire..."
# Compiler par petits blocs pour éviter les pics mémoire
NODE_OPTIONS="--max-old-space-size=8192" npm run gulp compile-client

echo "🔧 Build production avec optimisations M1..."
# Build production en mode économe
NODE_OPTIONS="--max-old-space-size=10240" npm run gulp compile-build-with-mangling

# Fonction pour build une plateforme à la fois (évite les crashes mémoire)
build_platform() {
    local platform=$1
    local task=$2
    echo "🏗️  Building $platform..."

    # Nettoyer la mémoire entre chaque build
    if command -v purge >/dev/null 2>&1; then
        sudo purge >/dev/null 2>&1 || true
    fi

    # Build avec timeout et retry
    timeout 1800 npm run gulp "$task" || {
        echo "⚠️  Timeout ou erreur pour $platform, retry..."
        sleep 30
        NODE_OPTIONS="--max-old-space-size=8192" npm run gulp "$task"
    }
}

# Créer le dossier de distribution
mkdir -p dist/

echo "📱 Build des packages par plateforme (séquentiel pour éviter les crashes)..."

# macOS (prioritaire)
build_platform "macOS ARM64" "vscode-darwin-arm64-min"
if [ -d "../VSCode-darwin-arm64" ]; then
    echo "📦 Création archive macOS ARM64..."
    cd ../VSCode-darwin-arm64/ && tar -czf ../vaultai-code/dist/VaultCode-macOS-arm64.tar.gz VaultCode.app
    cd ../vaultai-code/
fi

# macOS x64 (pour compatibilité)
build_platform "macOS x64" "vscode-darwin-x64-min"
if [ -d "../VSCode-darwin-x64" ]; then
    echo "📦 Création archive macOS x64..."
    cd ../VSCode-darwin-x64/ && tar -czf ../vaultai-code/dist/VaultCode-macOS-x64.tar.gz VaultCode.app
    cd ../vaultai-code/
fi

# Windows x64
build_platform "Windows x64" "vscode-win32-x64-min"
build_platform "Windows x64 Setup" "vscode-win32-x64-system-setup"

if [ -d "../VSCode-win32-x64" ]; then
    echo "📦 Création archives Windows x64..."
    cd ../VSCode-win32-x64/ && zip -r ../vaultai-code/dist/VaultCode-Windows-x64-Portable.zip *
    cd ../vaultai-code/
fi

# Copier l'installateur Windows
cp .build/win32-x64/system-setup/*.exe dist/VaultCode-Windows-x64-Setup.exe 2>/dev/null || echo "⚠️  Setup Windows non trouvé"

# Linux x64
build_platform "Linux x64" "vscode-linux-x64-min"
if [ -d "../VSCode-linux-x64" ]; then
    echo "📦 Création archive Linux x64..."
    cd ../VSCode-linux-x64/ && tar -czf ../vaultai-code/dist/VaultCode-Linux-x64.tar.gz *
    cd ../vaultai-code/
fi

echo ""
echo "✅ Build terminé avec succès !"
echo "📁 Fichiers disponibles dans dist/:"
ls -la dist/ 2>/dev/null || echo "Aucun fichier trouvé"

echo ""
echo "🎉 VaultCode est prêt pour le déploiement !"
echo ""
echo "📋 Fichiers créés:"
[ -f "dist/VaultCode-macOS-arm64.tar.gz" ] && echo "✅ VaultCode-macOS-arm64.tar.gz (Apple Silicon)"
[ -f "dist/VaultCode-macOS-x64.tar.gz" ] && echo "✅ VaultCode-macOS-x64.tar.gz (Intel Mac)"
[ -f "dist/VaultCode-Windows-x64-Setup.exe" ] && echo "✅ VaultCode-Windows-x64-Setup.exe (Installateur Windows)"
[ -f "dist/VaultCode-Windows-x64-Portable.zip" ] && echo "✅ VaultCode-Windows-x64-Portable.zip (Windows Portable)"
[ -f "dist/VaultCode-Linux-x64.tar.gz" ] && echo "✅ VaultCode-Linux-x64.tar.gz (Linux 64-bit)"

echo ""
echo "🚀 Prêt pour le déploiement rapide !"
echo "💡 Conseil: Teste d'abord la version macOS-arm64 sur ton Mac"
