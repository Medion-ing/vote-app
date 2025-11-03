# Vote App : Projet DevOps Fil Rouge

## Présentation

Application de vote en temps réel, full stack, orchestrée type microservices :  
- Frontend : React (Vite)
- Backend : FastAPI (Python, Socket.IO)
- Base de données : Redis  
- Déploiement : Kubernetes (MicroK8s), provisioning IaC

---

## Arborescence (architecture globale)

```

vote-app/
├── backend/          \# Application Python FastAPI
├── frontend/         \# Application React/Vite
├── infra/
│   ├── terraform/    \# Provisionnement VMs (Proxmox)
│   └── ansible/      \# Config \& déploiement MicroK8s, apps, monitoring
└── .github/workflows \# CI/CD GitHub Actions

```

---

## Objectif du projet

- Couvrir toute la chaîne DevOps automatisée, avec sécurité, supervision, reproductibilité et documentation, depuis l’édition du code jusqu’au monitoring de production.
- Montrer la **continuité logique** du DevOps moderne à travers un fil rouge cohérent.

---

## Choix techniques et justification

- **Docker** : standard de la containerisation, facilite CI/CD, portabilité et tests locaux
- **GitHub Actions** : pipeline CI, validation automatique, publication DockerHub
- **Terraform** : Infrastructure as Code, reproductibilité du cluster, support cloud/public/privé
- **Ansible** : configuration automatique, installation Docker/MicroK8s, sécurité
- **MicroK8s** : K8s local, parfait pour lab ou cluster privé, facile à intégrer dans IaC, supporte add-ons (RBAC, HPA…)
- **Prometheus & Grafana** : monitoring/alerting standard, visualisation temps réel des métriques du cluster

---

## Fonctionnement du Pipeline CI/CD

### CI (GitHub Actions)

- Linting Node.js & Python, tests unitaires auto
- Build & push images Docker frontend/backend sur DockerHub sur chaque push `main`

### CD (Script local)

- Déploiement ansible & scripts bash exécutés sur le réseau local pour garantir sécurité (accès sudo, pas d’exposition réseau des VM)

---

## Étapes d’utilisation

### 1. Provisionnement des VMs (Terraform)

- Modifier les variables d’accès Proxmox/cloud.
- Lancer : 
```

terraform init
terraform apply

```

### 2. Configuration des serveurs (Ansible)

- Exécuter les playbooks principaux :
  - `01-docker.yml` : installe Docker sur chaque VM
  - `03-microk8s-setup-fixed.yml` : configure MicroK8s (install, user, addons, tokens…)
  - `04-deploy-vote-app-complete.yml` : déploie Redis, backend, frontend, expose services Nodeport
  - `05-hpa-backend.yml` : active l’autoscaling backend
  - `07-supervision.yml` : déploie Prometheus/Grafana, dashboard cluster, alertes

### 3. Déploiement manuel (secure CD)

- Accéder à la VM maître (LAN)
- Lancer
  ```
  cd vote-app
  ./deploy.sh <dockerhub_username>
  # (mot de passe sudo demandé)
  ```

---

## Supervision & Monitoring

- Metrics collectées : CPU, RAM, pods, nodes, restarts, erreurs (Prometheus)
- Dashboards Grafana prêts à l'emploi : accès sur `http://<master_ip>:31000` (admin/admin)
- Alerting customisable via Grafana ou Prometheus rules

---

## Sécurité

- Aucun accès SSH ou API exposé sur Internet (local LAN uniquement)
- Sudo obligatoire pour toute action système critique (jamais de mot de passe stocké dans les scripts)
- Runner GitHub Action non autorisé sur cluster prod (par design)

---

## Limites & pistes d’amélioration

- Déployer un runner GitHub Actions auto-hébergé pour activer le CD complet automatique
- Déplacer le cluster sur le cloud pour ouverture sécurisée du CD
- Ajouter plus de scans sécurité (Trivy, SonarQube, Kube-bench)
- Automatiser la gestion des secrets (Vault, SealedSecrets…)

---

## Exemples de commandes pour la stack locale

```

docker compose up --build
docker compose down
docker system prune

```
- Frontend : http://localhost:3000
- Backend API : http://localhost:8000/docs, http://localhost:8000/health
