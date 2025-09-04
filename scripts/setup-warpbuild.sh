#!/bin/bash

# Script de configuration WarpBuild pour VaultCode
# Usage: ./scripts/setup-warpbuild.sh

set -e

echo "🚀 Configuration WarpBuild pour VaultCode"
echo "========================================"

# Vérifier que nous sommes dans le bon repo
if [[ ! -f "package.json" ]] || ! grep -q "code-oss-dev" package.json; then
    echo "❌ Erreur: Ce script doit être exécuté depuis la racine du projet VaultCode"
    exit 1
fi

# Vérifier que les workflows existent
if [[ ! -f ".github/workflows/build-vaultcode-warpbuild.yml" ]]; then
    echo "❌ Erreur: Workflow WarpBuild principal non trouvé"
    echo "💡 Assure-toi que les workflows ont été créés correctement"
    exit 1
fi

echo "✅ Workflows WarpBuild détectés"
echo ""

# Afficher les workflows disponibles
echo "📋 Workflows WarpBuild configurés:"
ls -la .github/workflows/*warp*.yml | while read -r file; do
    filename=$(basename "$file")
    echo "  ✅ $filename"
done
echo ""

# Vérifier le statut Git
echo "🔍 Vérification du statut Git..."
if git diff --quiet && git diff --staged --quiet; then
    echo "✅ Aucun changement en attente"
else
    echo "📝 Changements détectés, préparation du commit..."

    # Ajouter les workflows
    git add .github/workflows/
    git add WARPBUILD-SETUP.md
    git add DEPLOIEMENT-RAPIDE.md
    git add scripts/

    echo "📦 Fichiers ajoutés au commit:"
    git diff --staged --name-only | sed 's/^/  ✅ /'
    echo ""
fi

# Options pour l'utilisateur
echo "🎯 Que veux-tu faire maintenant ?"
echo ""
echo "1. 🚀 Commit et push vers GitHub (recommandé)"
echo "2. 📋 Afficher le diff des changements"
echo "3. 🔧 Commit seulement (sans push)"
echo "4. ❌ Annuler"
echo ""

read -p "Choix (1-4): " choice

case $choice in
    1)
        echo "🚀 Commit et push vers GitHub..."

        # Commit avec message descriptif
        git commit -m "🚀 Add WarpBuild workflows for VaultCode

- Add complete build workflow for all platforms (Mac/Windows/Linux)
- Add quick test build workflow for development
- Optimize memory settings for VS Code fork builds
- Add comprehensive deployment guides
- Fix MacBook M1 build crashes with cloud builders

Estimated build time: 20-30 min instead of 40+ min crashes
Platforms: macOS (ARM64/x64), Windows x64, Linux x64"

        # Push vers origin
        echo "📤 Push vers GitHub..."
        git push origin $(git branch --show-current)

        echo ""
        echo "✅ Configuration WarpBuild pushée vers GitHub !"
        echo ""
        echo "🎯 Prochaines étapes:"
        echo "1. 🌐 Va sur https://app.warpbuild.com/"
        echo "2. 🔗 Connecte ton repo GitHub"
        echo "3. 📊 Surveille l'onglet 'Actions' de ton repo"
        echo "4. ⏱️ Premier build: ~25 minutes au lieu de crash !"
        echo ""
        echo "📚 Guides disponibles:"
        echo "  • WARPBUILD-SETUP.md - Configuration détaillée"
        echo "  • DEPLOIEMENT-RAPIDE.md - Solutions locales de backup"
        ;;

    2)
        echo "📋 Différences à commiter:"
        echo ""
        git diff --staged
        echo ""
        echo "💡 Relance le script pour commiter ces changements"
        ;;

    3)
        echo "🔧 Commit local seulement..."
        git commit -m "Add WarpBuild workflows and deployment guides"
        echo "✅ Commit créé. Utilise 'git push' quand tu es prêt."
        ;;

    4)
        echo "❌ Configuration annulée"
        echo "💡 Tes fichiers sont prêts, tu peux les commiter manuellement"
        ;;

    *)
        echo "❌ Choix invalide"
        exit 1
        ;;
esac

echo ""
echo "🎉 Configuration WarpBuild terminée !"
echo "📖 Consulte WARPBUILD-SETUP.md pour les détails"
