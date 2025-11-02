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