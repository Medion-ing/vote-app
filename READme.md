🗳️ Vote App - Phase 1: Containerisation
📋 Description

Application de vote en temps réel containerisée avec architecture microservices.
🏗️ Architecture

    Frontend : React (Port 3000)

    Backend : FastAPI (Port 8000)

    Base de données : Redis (Port 6379)

🚀 Installation
bash

# Cloner le repository
git clone <repository-url>
cd vote-app

# Démarrer l'application
docker compose up --build

# Arrêter l'application
docker compose down

# Voir les logs
docker compose logs -f

# Nettoyer Docker
docker system prune

🌐 Accès

    Application : http://localhost:3000
    API Docs : http://localhost:8000/docs
    Health Check : http://localhost:8000/health
    

# 🚀 Vote App - Phase 2: CI/CD avec GitHub Actions

## 📋 Objectif Accompli
Mise en place d'un pipeline d'intégration et déploiement continus automatisé.

## 🏗️ Architecture CI/CD
```
Code Local → git push → GitHub Actions → Docker Hub
     ↑           ↑           ↑              ↑
Développement  Déclencheur  Usine de     Registry d'
                Pipeline     Build        Images
```

## 🔧 Configuration

### Secrets GitHub (Settings → Secrets → Actions)
- `DOCKERHUB_USERNAME` : Ton utilisateur Docker Hub
- `DOCKERHUB_TOKEN` : Token avec permissions Read/Write/Delete

### Workflow Automatisé
À chaque `git push` sur la branche `main` :
1. ✅ **Déclenchement automatique** du pipeline
2. ✅ **Build des images** Docker frontend et backend
3. ✅ **Push des images** sur Docker Hub
4. ✅ **Notification** du statut build

## 🌐 URLs des Images Docker
- **Frontend** : `https://hub.docker.com/r/ciscko/vote-frontend`
- **Backend** : `https://hub.docker.com/r/ciscko/vote-backend`

## 🚀 Utilisation des Images
```bash
# Tester l'application n'importe où
docker run -p 3000:3000 ciscko/vote-frontend:latest
docker run -p 8000:8000 ciscko/vote-backend:latest
```
