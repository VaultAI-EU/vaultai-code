#!/bin/bash

# VaultCode Quick Mac Build - Pour tester rapidement
# Usage: ./scripts/build-quick-mac.sh

set -e

echo "⚡ VaultCode Quick Build pour Mac (test rapide)"
echo "=============================================="

# Configuration mémoire légère pour test rapide
export NODE_OPTIONS="--max-old-space-size=8192"

# Nettoyage minimal
echo "🧹 Nettoyage rapide..."
pkill -f "Electron" || true

# Supprimer seulement les caches React
rm -rf src/vs/workbench/contrib/void/browser/react/src2
rm -rf src/vs/workbench/contrib/void/browser/react/out

echo "⚙️ Build React..."
npm run buildreact

echo "📦 Compilation client..."
npm run gulp compile-client

echo "🍎 Build macOS ARM64 seulement..."
npm run gulp vscode-darwin-arm64-min

# Créer un lien symbolique pour test local
if [ -d "../VSCode-darwin-arm64" ]; then
    echo "🔗 Création du lien pour test..."
    rm -f VaultCode-Test.app
    ln -sf ../VSCode-darwin-arm64/VaultCode.app VaultCode-Test.app
    echo "✅ Test app créée: VaultCode-Test.app"
    echo "💡 Lance avec: open VaultCode-Test.app"
else
    echo "❌ Build échoué"
fi

echo ""
echo "⚡ Build rapide terminé en $(date)"
