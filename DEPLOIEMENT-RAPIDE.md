# 🚀 Guide de Déploiement Rapide - VaultCode

## ⚡ Solution Immédiate pour MacBook M1

### Problème Résolu

- ✅ Crashes mémoire après 40 minutes de build
- ✅ Optimisation spécifique MacBook M1/M2
- ✅ Build cross-platform (Mac/Windows/Linux)
- ✅ Gestion mémoire Node.js optimisée

## 🎯 Scripts Disponibles

### 1. Build Rapide (Test Local)

```bash
./scripts/build-quick-mac.sh
```

- ⏱️ **Durée**: ~10-15 minutes
- 🎯 **Usage**: Tester rapidement tes modifications
- 📦 **Sortie**: VaultCode-Test.app (lien symbolique)

### 2. Build Complet Optimisé

```bash
./scripts/build-optimized-m1.sh
```

- ⏱️ **Durée**: ~45-60 minutes (sans crash!)
- 🎯 **Usage**: Build final pour déploiement
- 📦 **Sortie**: Tous les packages dans `dist/`

### 3. Build Windows Spécifique

```bash
./scripts/build-windows.sh
```

- ⏱️ **Durée**: ~20-30 minutes
- 🎯 **Usage**: Seulement Windows
- 📦 **Sortie**: Setup et portable Windows

## 🔧 Optimisations Appliquées

### Mémoire Node.js

```bash
NODE_OPTIONS="--max-old-space-size=12288 --max-semi-space-size=128"
UV_THREADPOOL_SIZE=16
```

### Build Séquentiel

- ✅ Une plateforme à la fois (évite les pics mémoire)
- ✅ Timeout et retry automatique
- ✅ Nettoyage mémoire entre builds

### Cache Intelligent

- ✅ Suppression sélective des caches
- ✅ Préservation des dépendances
- ✅ Optimisation pour Apple Silicon

## 📦 Fichiers de Sortie

Après un build complet, tu auras dans `dist/`:

```
dist/
├── VaultCode-macOS-arm64.tar.gz      # Mac Apple Silicon
├── VaultCode-macOS-x64.tar.gz        # Mac Intel
├── VaultCode-Windows-x64-Setup.exe   # Windows Installer
├── VaultCode-Windows-x64-Portable.zip # Windows Portable
└── VaultCode-Linux-x64.tar.gz        # Linux 64-bit
```

## 🚀 Déploiement Immédiat

### Option 1: Hébergement Simple

```bash
# Uploader dist/ sur ton serveur web
scp -r dist/ user@serveur.com:/var/www/html/downloads/
```

### Option 2: GitHub Releases

```bash
# Créer une release avec les fichiers dist/
gh release create v1.0.0 dist/* --title "VaultCode v1.0.0"
```

### Option 3: CDN/Cloud Storage

- AWS S3 + CloudFront
- Google Cloud Storage
- Azure Blob Storage

## ⚡ Workflow de Déploiement Express

### 1. Test Rapide (5 min)

```bash
./scripts/build-quick-mac.sh
open VaultCode-Test.app  # Tester localement
```

### 2. Build Final (45 min)

```bash
./scripts/build-optimized-m1.sh
```

### 3. Upload et Distribution (5 min)

```bash
# Upload vers ton serveur
rsync -av dist/ user@serveur.com:/downloads/
```

## 🛠️ Dépannage

### Si le build crash encore:

```bash
# Augmenter encore plus la mémoire
export NODE_OPTIONS="--max-old-space-size=16384"
```

### Si manque d'espace disque:

```bash
# Nettoyer complètement
rm -rf node_modules && npm install
```

### Pour debug:

```bash
# Build avec logs détaillés
DEBUG=* ./scripts/build-optimized-m1.sh
```

## 📊 Performance Attendue

| Script                | Durée     | RAM Utilisée | Plateforme        |
| --------------------- | --------- | ------------ | ----------------- |
| build-quick-mac.sh    | 10-15 min | ~8 GB        | macOS seulement   |
| build-optimized-m1.sh | 45-60 min | ~12 GB       | Toutes            |
| build-windows.sh      | 20-30 min | ~10 GB       | Windows seulement |

## 🎉 C'est Parti !

Pour déployer immédiatement:

1. **Test rapide**: `./scripts/build-quick-mac.sh`
2. **Build complet**: `./scripts/build-optimized-m1.sh`
3. **Upload**: Copier `dist/` vers ton serveur

**Temps total estimé: 1 heure max au lieu de crash après 40 minutes !**
